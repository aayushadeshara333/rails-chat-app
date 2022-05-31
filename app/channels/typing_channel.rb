class TypingChannel < ApplicationCable::Channel
  def subscribed
    stream_from "typing_channel"
  end

  def unsubscribed
    stop_stream_from "typing_channel"
  end

  def isTyping(data)
    # broadcast_to "typing_channel", partial: "users/status", user: self
    typingUser = User.find(data["user"].to_i)
    if data["is_typing"]
      ActionCable.server.broadcast "typing_channel", "<turbo-stream action=\"replace\" target=\"typing_#{data["connection_id"]}_#{data["user"]}\"><template><turbo-frame id=\"typing_channel\"></turbo-frame>\n<div id=\"typing_#{data["connection_id"]}_#{data["user"]}\"><div class=\"message-box\">
      <div class=\"name dark-color font-message-author\"><b>#{typingUser.email}</b></div>
      <div class=\"loader\"><span></span>
      <span></span><span></span></div>
  </div></div>\n</template></turbo-stream>"
    else
      ActionCable.server.broadcast "typing_channel", "<turbo-stream action=\"replace\" target=\"typing_#{data["connection_id"]}_#{data["user"]}\"><template><turbo-frame id=\"typing_channel\"></turbo-frame>\n<div id=\"typing_#{data["connection_id"]}_#{data["user"]}\"></div>\n</template></turbo-stream>"
    end
  end

  def receive(data)
    ActionCable.server.broadcast('typing_channel', data)
  end
end