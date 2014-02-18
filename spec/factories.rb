FactoryGirl.define do
  factory :user do
    username "tester"
    email "tester@test.com"
    password "secret"
    password_confirmation "secret"
    salt "asdasdastr4325234324sdfds"
    crypted_password Sorcery::CryptoProviders::BCrypt.encrypt("secret","asdasdastr4325234324sdfds")
  end

  factory :admin, class: User do
    username "tester_admin"
    email "tester_admin@test.com"
    password "secret_admin"
    password_confirmation "secret_admin"
    salt "asdasdastr4325234324sdfds"
    admin true
    crypted_password Sorcery::CryptoProviders::BCrypt.encrypt("secret_admin","asdasdastr4325234324sdfds")
  end

  factory :entry do
    minutes 60
    sequence(:description) { |n| "test description #{n}" }
    date Date.today.strftime("%d/%m/%Y")
  end

  factory :project do
    sequence(:name) { |n| "test project #{n}" }
  end

  factory :ProjectUser do
  end
end
