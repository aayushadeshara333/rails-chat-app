import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  reset() {
    const element = document.getElementById("single_room");
    // element.scrollTo(0, element.scrollHeight)
    this.element.reset()
  }
}