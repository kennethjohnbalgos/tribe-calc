class Format < ApplicationRecord
  validates :name, :code, presence: true
  validates :code, uniqueness: true

  has_many :format_bundles
  accepts_nested_attributes_for :format_bundles, allow_destroy: true

  def self.process(input)
    # Get formatted input values
    requests = collect_values(input)
    # Initialize results Hash
    results = {}

    # Loop for each format request
    requests.each do |code, value|
      # Intialize result for the format code
      results[code] = {}
      # Set the input value
      results[code][:value] = value
      # Set the calculated bundle quantity combination Hash as output
      results[code][:output] = calculate(code, value)
      # Set the total price based on the calculated output
      prices = results[code][:output].collect{|x| (x[:price] * x[:quantity]) if x.is_a?(Hash)}
      results[code][:total] = prices.compact.sum
    end

    return results
  end

  def self.load_default
    # Load the default data file
    seed_file = Rails.root.join('db', 'seeds', 'default_format.yml')
    data = YAML::load_file(seed_file)

    # Loop for each default format
    data.each do |f|
      # Set a new or user an existing the format object
      format = Format.where(code: f["code"]).first_or_create
      # Update the format name
      format.update_attribute(:name, f["name"])
      # Loop for each default format bundle
      f["bundles"].each do |b|
        # Set a new or user an existing the format bundle object
        bundle = format.format_bundles.where(quantity: b["quantity"]).first_or_create
        # Update the format bundle price
        bundle.update_attribute(:price, b["price"])
      end
      # Delete all existing bundle which are not specified in the default data file
      quantities = f["bundles"].collect{|x| x["quantity"]}
      format.format_bundles.where.not(quantity: quantities).destroy_all
    end
  end

  private

  def self.collect_values(input)
    return nil unless input.present?
    requests = {}
    Format.pluck(:code).each do |code|
      if (index = input.split.index(code)).present?
        requests[code] = input.split[index-1].to_i
      end
    end
    # Sample hash result: {"IMG"=>1, "FLAC"=>2, "VID"=>3}
    return requests
  end

  def self.calculate(code, input)
    # Collect format bundles array of quantity and price in reverse order
    bundles = Format.find_by(code: code).format_bundles.sort_quantity_reverse.pluck(:quantity, :price)
    results = []
    
    # Loop for excluding the highest the bundle quantity (outer loop)
    (1..bundles.count).each do

      # Variable for the computed user input (integer)
      value = input
      # Variable for storing results
      results = []
      # Variable for loop index
      index = 0

      # Loop for each bundle quantity (main loop)
      while index < bundles.count do
        # Variable for bundle quantity
        bundle_qty = bundles[index][0]
        # Stop if user input is 0
        break if value == 0
        
        # Get the remainder
        remainder = value % bundle_qty
        # Set the default result hash
        results[index] = {
          bundle: bundle_qty,
          price: bundles[index][1].to_f,
          value: value,
          remainder: remainder
        }

        # If the user input cannot be divided into the bundle quantity
        if value == remainder
          # Set the result quantity to zero (if the current value cannot be divided into the bundle quantity)
          results[index][:quantity] = 0

          # If it is the minimum bundle quantity loop
          if index == (bundles.count - 1)

            # Loop to previous bundle quantity inheritance checker
            (1..bundles.count).each do |offset|

              # Variable for the index of the previous bundle quantity
              last_index = index - offset

              # If the previous bundle quantity has a result
              if results[last_index].present?
                # Update the current value using the value of the previous bundle quantity result
                value = results[last_index][:value]
                # Update the previous bundle quantity remainder using its value
                results[last_index][:remainder] = value
                # Update the previous bundle quantity quantity to zero
                results[last_index][:quantity] = 0
                # Update the current bundle quantity
                results[index][:value] = value
                # Repeat the process if there's still a remainder
                next if (value % bundle_qty) > 0
                # If there's no more remainder, repeat the loop for the same bundle quantity 
                index -= 1
                # Stop the loop for previous bundle quantity inheritance checker
                break
              end
            end
          end
        else
          # Set the result quantity to the multiplicand (if the current value can be divided into the bundle quantity)
          results[index][:quantity] = (value - remainder) / bundle_qty
          # Set the remainder as the new value (for the next loop)
          value = remainder
        end
        # Increase the main loop index for the next bundle quantity
        index += 1
      end
      
      # If there's still a remaining value after the main loop
      if value > 0
        # Notify that the input has a remainder in any bundle quantity combination
        results << "Invalid #{code} value, remainder is #{value}."
        # Remove the highest quantity for the next outer loop
        bundles = bundles.drop(1)
      else
        # If the remaining value is zero, return the collected results
        return results
      end
    end
    # If all combination has a remainder, return the collected results with notice
    return results
  end
end
