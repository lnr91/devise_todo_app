class List < ActiveRecord::Base
  belongs_to :user
  has_many :tasks
  attr_accessible :description, :name
  validates :name, presence: true
  validates :user, presence: true        # can also write it as validates :user_id, presence: true
  default_scope order: 'lists.created_at DESC'
end
