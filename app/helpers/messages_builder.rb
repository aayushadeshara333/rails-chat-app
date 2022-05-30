class MessagesBuilder
  def initialize(room)
    @room_messages_hash = {}
    room.messages.each do |message|
      @room_messages_hash[message.created_at.to_date].append(message) unless @room_messages_hash[message.created_at.to_date].nil?
      @room_messages_hash[message.created_at.to_date] = [message] if @room_messages_hash[message.created_at.to_date].nil?
    end
  end

  def add_message(message)
    @room_messages_hash[message.created_at.to_date] = [message] if @room_messages_hash[message.created_at.to_date].nil? 
  end

  def getMessages()
    @room_messages_hash
  end
end