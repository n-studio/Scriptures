import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["panel"]

  connect() {
    if (window.innerWidth < 768) {
      this.panelTarget.style.display = "none"
    }
  }

  toggle() {
    var panel = this.panelTarget
    if (panel.style.display === "none") {
      panel.style.display = "flex"
    } else {
      panel.style.display = "none"
    }
  }
}
