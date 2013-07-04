# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :list do
    sequence(:name) {|n| "List Item #{n}"}
    sequence(:description) {|n| "List Description #{n}"}
    user
  end
end
