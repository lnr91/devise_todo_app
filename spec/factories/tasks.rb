# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :task do
    sequence(:description) {|n| "Task Description #{n}"}
    list
  end
end
