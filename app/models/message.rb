class Message < ApplicationRecord
  include Cubism::Presence
  belongs_to :user
  belongs_to :room
  before_create :confirm_participant
  after_create_commit { broadcast_append_to room }

  def self.check(message)
    p message
    p "aayush"
    broadcast_append_to room
    # broadcasts_to message.room
  end

  private
  def confirm_participant
    return unless room.is_private
        is_participant = Participant.where(user_id: user.id, room_id: room.id).first
        throw :abort unless is_participant
  end
end
