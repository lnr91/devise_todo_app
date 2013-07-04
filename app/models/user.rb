class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email,:nick_name, :password, :password_confirmation, :remember_me
  validates :nick_name, presence: true    # the other fields already validated by devise
  has_many :lists , dependent: :destroy


end
