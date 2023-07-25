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



# actual and expected  income / expense -> 2 set actual and projected income 
# income_type -> actual and projected
# actual->{  logic
# # } the user can get the salary any day in one month from (1 to 30/31) so we have to update the moth accordingly 
# once user is adding the salary monthly suppose on 12 july he got his salary added the income in actual income 
# now user is getting the salary again on 12th august it should show the same just it will be update month 