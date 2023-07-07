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

  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }
  PASSWORD_FORMAT = /\A
    (?=.{8,})          # Must contain 8 or more characters
    (?=.*\d)           # Must contain a digit
    (?=.*[a-z])        # Must contain a lower case character
    (?=.*[A-Z])        # Must contain an upper case character
    (?=.*[[:^alnum:]]) # Must contain a symbol
  /x

  validates :password,
    presence: true,
    length: { in: Devise.password_length },
    format: { with: PASSWORD_FORMAT },
    confirmation: true,
    on: :create

  scope :managers, -> { where(role_id: 1) }
end