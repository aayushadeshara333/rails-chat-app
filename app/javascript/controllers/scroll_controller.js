import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  /** On start */
  connect() {
    console.log("Connected");
    const messages = document.getElementById("single_room");
    messages.addEventListener("DOMNodeInserted", this.resetScroll);
    this.resetScroll(messages);
    messages.classList.add("smooth")
  }
  /** On stop */
  disconnect() {
    console.log("Disconnected");
  }
  /** Custom function */
  resetScroll() {
    const messages = document.getElementById("single_room");
    messages.scrollTop = messages.scrollHeight - messages.clientHeight;
  }
}
