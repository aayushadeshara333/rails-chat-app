class UsersController < ApplicationController
  before_action :authenticate_user!
  def show
    @user = User.find(params[:id])
    # @users = User.all_except(current_user)
    temp = []
    Room.joins(:participants).where("participants.user_id = #{current_user.id}").each do |room|
      room.participants.each do |participant|
        temp.append(participant.user) if participant.user.id != current_user.id
      end
    end
    @users = temp
    @room = Room.new
    # @rooms = Room.public_rooms
    @rooms = Room.public_rooms.joins(:messages).where("messages.user_id = #{current_user.id}").distinct
    @room_name = get_name(@user, current_user)
    @single_room = Room.where(name: @room_name).first || Room.create_private_room([@user, current_user], @room_name)
    @message = Message.new
    # @messages = @single_room.messages.order(created_at: :asc)
    pagy_messages = @single_room.messages.order(created_at: :desc)
    @pagy, @messages = pagy(pagy_messages, items: 13)
    @messages = @messages.reverse
    if params[:page]
      render "users/scrollable_list"
    else
      render "rooms/index"
    end
  end

  private
  def get_name (user1, user2)
     user = [user1, user2].sort
     "private_#{user[0].id}_#{user[1].id}"
  end
end
