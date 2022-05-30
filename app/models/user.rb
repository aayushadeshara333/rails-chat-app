class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  include Cubism::User
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  scope :all_except, -> (user) { where.not(id: user) }
  has_many :messages
  after_create_commit { broadcast_append_to "users" }
  after_update_commit { broadcast_update }


  enum status: %i[offline away online]
  def self.connected_users
    User.joins(:rooms).where("users.")
  end

  def status_to_css
    case status
    when "offline"
      "bg-dark"
    when "away"
      "bg-warning"
    when "online"
      "bg-success"
    else
      "bg-dark"
    end
  end

  def broadcast_update
    broadcast_replace_to "user_status", partial: "users/status", user: self
  end
end
