FactoryGirl.define do
  factory :user do
    username "tester"
    email "tester@test.com"
    password "secret"
    salt "asdasdastr4325234324sdfds"
    crypted_password Sorcery::CryptoProviders::BCrypt.encrypt("secret","asdasdastr4325234324sdfds")
  end

  factory :entry do
    minutes 60
    sequence(:description) { |n| "test description #{n}" }
    date Date.today.strftime("%d/%m/%Y")
    project_id 1
    user_id 1
  end

  factory :project do
    name "test project"
  end

  factory :ProjectUser do
    user_id 1
    project_id 1
  end
end
