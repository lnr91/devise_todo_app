# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence(:nick_name) {|n| "nick_name#{n}"}
    sequence(:email) {|n| "nick_name#{n}@example.com"}
    password "password"
    password_confirmation "password"
  end
end
