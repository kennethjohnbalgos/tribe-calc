class Format < ApplicationRecord
  validates :name, :code, presence: true
  validates :code, uniqueness: true

  has_many :format_bundles
  accepts_nested_attributes_for :format_bundles, allow_destroy: true

  def self.process(input)
    requests = collect_values(input)
    results = {}
    requests.each do |code, value|
      results[code] = {}
      results[code][:value] = value
      results[code][:output] = calculate(code, value)
      prices = results[code][:output].collect{|x| (x[:price] * x[:quantity]) if x.is_a?(Hash)}
      results[code][:total] = prices.compact.sum
    end
    return results
  end

  def self.calculate(code, input)
    bundles = Format.find_by(code: code).format_bundles.sort_quantity_reverse
    bundles_array = bundles.collect{|x| [x.quantity, x.price.to_f]}
    results = []
    
    (1..bundles_array.count).each do
      value = input
      results = []
      index = 0

      while index < bundles_array.count do
        bundle_qty = bundles_array[index][0]
        bundle_price = bundles_array[index][1]
        break if value == 0
          
        remainder = value % bundle_qty
        results[index] = {
          bundle: bundle_qty,
          price: bundle_price,
          value: value,
          remainder: remainder
        }
        if value == remainder
          results[index][:quantity] = 0

          if index == (bundles_array.count - 1)
            (1..bundles_array.count).each do |offset|
              last_index = index-offset
              if results[last_index].present?
                value = results[last_index][:value]
                results[last_index][:remainder] = value
                results[last_index][:quantity] = 0
                results[index][:value] = value
                next if (value % bundle_qty) > 0
                index -= 1
                break
              end
            end
          end
        else
          results[index][:quantity] = (value - remainder) / bundle_qty
          value = remainder
        end
        index += 1
      end
      
      if value > 0
        results << "Invalid #{code} value, remainder is #{value}."
        bundles_array = bundles_array.drop(1)
      else
        return results
      end
    end

    return results
  end

  def self.load_default
    seed_file = Rails.root.join('db', 'seeds', 'default_format.yml')
    data = YAML::load_file(seed_file)

    data.each do |f|
      format = Format.where(code: f["code"]).first_or_create
      format.update_attribute(:name, f["name"])
      f["bundles"].each do |b|
        bundle = format.format_bundles.where(quantity: b["quantity"]).first_or_create
        bundle.update_attribute(:price, b["price"])
      end
    
      quantities = f["bundles"].collect{|x| x["quantity"]}
      format.format_bundles.where.not(quantity: quantities).destroy_all
    end
  end

  def self.collect_values(input)
    return nil unless input.present?
    requests = {}
    Format.pluck(:code).each do |code|
      if (index = input.split.index(code)).present?
        requests[code] = input.split[index-1].to_i
      end
    end
    return requests
  end
end
