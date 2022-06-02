class Message < ApplicationRecord
  include Cubism::Presence
  belongs_to :user
  belongs_to :room
  before_create :confirm_participant
  after_create_commit { broadcast_append_to room }
  has_many_attached :attachments, dependent: :destroy

  def self.check(message)
    p message
    p "aayush"
    broadcast_append_to room
    # broadcasts_to message.room
  end
  
    
  def chat_attachments(index)
    target = attachments[index]
    return unless attachments.attached?

    if target.image?
      target.variant(resize: "100x100").processed
    elsif target.video?
      target.variant(resize: "100x100").processed
    end
  end

  private
  def confirm_participant
    return unless room.is_private
        is_participant = Participant.where(user_id: user.id, room_id: room.id).first
        throw :abort unless is_participant
  end
end
