import consumer from "./consumer"

consumer.subscriptions.create("TypingChannel", {
  connected() {
    const input = document.getElementById("chat-text")
    const connection_id = input.getAttribute("connection_id");
    const user = input.getAttribute("user");
    input.addEventListener("keyup", (e) => {
      console.log(connection_id);
      if (e.target.value.length > 0) {
        this.isTyping({
          is_typing: true,
          connection_id,
          user
        })
      } else {
        this.isTyping({
          is_typing: false,
          connection_id,
          user
        })
      }
    });
  },

  isTyping: function (is_typing) {
    this.perform("isTyping", is_typing)
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
  }
});
