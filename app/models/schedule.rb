class Schedule < ActiveRecord::Base
  belongs_to :user

  before_create :generate_token

  protected

  def generate_token
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless Schedule.exists?(token: random_token)
    end
  end
end
