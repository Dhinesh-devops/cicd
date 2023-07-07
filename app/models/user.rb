class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
         :registerable,
         :recoverable, 
         :lockable, 
         :validatable, 
         :trackable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

  belongs_to :role

  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }, uniqueness: true

  scope :managers, -> { where(role_id: 1) }
end