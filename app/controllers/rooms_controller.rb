class RoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_status
  def index
    @room = Room.new
    # @rooms = Room.public_rooms
    @rooms = Room.public_rooms.joins(:messages).where("messages.user_id = #{current_user.id}").distinct
    # @users = User.all_except(current_user)
    temp = []
    Room.joins(:participants).where("participants.user_id = #{current_user.id}").each do |room|
      room.participants.each do |participant|
        temp.append(participant.user) if participant.user.id != current_user.id
      end
    end
    @users = temp
    p @users
    render "index"
  end

  def show
    @room = Room.new
    # @rooms = Room.public_rooms
    @rooms = Room.public_rooms.joins(:messages).where("messages.user_id = #{current_user.id}").distinct
    @single_room = Room.find(params[:id])
    @message = Message.new
    pagy_messages = @single_room.messages.order(created_at: :desc)
    @pagy, @messages = pagy(pagy_messages, items: 13)
    temp = []
    Room.joins(:participants).where("participants.user_id = #{current_user.id}").each do |room|
      room.participants.each do |participant|
        temp.append(participant.user) if participant.user.id != current_user.id
      end
    end
    @users = temp
    @messages = @messages.reverse
    if params[:page]
      render "users/scrollable_list"
    else
      render "rooms/index"
    end
    # @users = User.all_except(current_user)
  end

  def create
    @room = Room.create(name: params["room"]["name"])
  end

  private
  def set_status
    current_user.update!(status: User.statuses[:online]) if current_user
  end
end
