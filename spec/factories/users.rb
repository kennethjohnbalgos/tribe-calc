FactoryBot.define do

  factory(:user) do
    email { "john.doe@email.com" }
    password { "correctpassword" }

    trait :guest do
      role {0}
    end

    trait :admin do
      role {1}
    end
  end
end
