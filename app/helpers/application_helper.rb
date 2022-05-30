module ApplicationHelper
  include Pagy::Frontend
  def users_chatted_with(current_user)
    temp = []
    Room.joins(:participants).where("participants.user_id = #{current_user.id}").each do |room|
      room.participants.each do |participant|
        temp.append(participant.user) if participant.user.id != current_user.id
      end
    end
    User.all_except(current_user) - temp
  end

  def rooms_of_user(current_user)
    Room.public_rooms - Room.public_rooms.joins(:messages).where("messages.user_id = #{current_user.id}").distinct
  end
end
