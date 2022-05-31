module MessagesHelper
  def message_owner(user, c_user)
    user.id == c_user.id ? [" my_msg_cont", " my_msg"] : ""
  end

  def message_date(date)
    yesterday = DateTime.now - 1.day
    if date == DateTime.now.to_date
      return "Today"
    elsif date == yesterday.to_date
      return "Yesterday"
    else
      return date.strftime("%d %b %Y")
    end
  end

  def other_user(participants)
    other_user = nil
    participants.each do |user|
      other_user = user if user.user_id != current_user.id
    end
    "#{[other_user.user_id, current_user.id].join("_")}"
  end
end
