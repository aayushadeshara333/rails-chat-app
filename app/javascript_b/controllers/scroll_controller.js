import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const messages = document.getElementById("single_room");
    messages.addEventListener("DOMNodeInserted", this.resetScroll);
    this.resetScroll(messages);
    messages.classList.add("smooth")
  }

  disconnect() {
  }

  resetScroll() {
    const messages = document.getElementById("single_room");
    messages.scrollTop = messages.scrollHeight - messages.clientHeight;
  }
}