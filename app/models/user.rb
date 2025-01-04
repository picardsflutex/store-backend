class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  enum :role, user: "user", admin: "admin"
  
  def admin?
    role == 'admin'
  end

  has_many :orders
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self
end
