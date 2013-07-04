class Task < ActiveRecord::Base
  belongs_to :list
  attr_accessible :description,:completed
  validates :description, presence: true
  validates :list, presence: true
  scope :completed ,where(completed:true)
  scope :incomplete, where(completed: false)
end
