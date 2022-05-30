class MessageTypingChannel < ApplicationCable::Channel
  def subscribed
    current_user.messages.find_each do |conversation|
      stream_from "message_typing:#{conversation.id}"
    end     
  end

  def unsubscribed
    stop_all_streams
  end

  def broadcast_typing_status(data)
    ActionCable.server.broadcast "message_typing:#{data['conversation_id']}", {
      is_typing: data["is_typing"],
      conversation_id: data["conversation_id"],
      current_user_id: current_user.id,
      other_user_id: data['other_user_id']
    } 
  end
end
