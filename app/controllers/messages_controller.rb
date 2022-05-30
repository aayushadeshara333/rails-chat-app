class MessagesController < ApplicationController
  def create
    p msg_params
    p "adeshara"
    @message = current_user.messages.create(body: msg_params[:body], room_id: params[:room_id])
  end

  private
  def msg_params
    params.require(:message).permit(:body)
  end
end
