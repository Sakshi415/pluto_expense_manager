class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :registerable, :recoverable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

  #attr_accessor :reset_password_token, :reset_password_sent_at
  has_many :incomes, dependent: :destroy

  
  def generate_password_token!
    self.reset_password_sent_at = Time.now.utc
    self.reset_password_token = generate_token
    
  end
   
  def password_token_valid?
    (self.reset_password_sent_at + 4.hours) > Time.now.utc
  end
   
  def reset_password!(password)
    self.reset_password_token = nil
    self.password = password
    save!
  end
   
  private
   
  def generate_token
    SecureRandom.hex(10)
  end
end
