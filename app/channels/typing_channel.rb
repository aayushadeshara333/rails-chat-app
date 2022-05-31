class TypingChannel < ApplicationCable::Channel
  def subscribed
    stream_from "typing_channel"
  end

  def unsubscribed
    stop_stream_from "typing_channel"
  end

  def isTyping(data)
    # broadcast_to "typing_channel", partial: "users/status", user: self
    if data["is_typing"]
      ActionCable.server.broadcast "typing_channel", "<turbo-stream action=\"replace\" target=\"typing_#{data["connection_id"]}\"><template><turbo-frame id=\"typing_channel\"></turbo-frame>\n<div id=\"typing_#{data["connection_id"]}\" user=\"#{data["user"]}\"><div class=\"loader\"><span></span>
      <span></span><span></span></div></div>\n</template></turbo-stream>"
    else
      ActionCable.server.broadcast "typing_channel", "<turbo-stream action=\"replace\" target=\"typing_#{data["connection_id"]}\"><template><turbo-frame id=\"typing_channel\"></turbo-frame>\n<div id=\"typing_#{data["connection_id"]}\"user=\"#{data["user"]}\ ></div>\n</template></turbo-stream>"
    end
  end

  def receive(data)
    ActionCable.server.broadcast('typing_channel', data)
  end
end
