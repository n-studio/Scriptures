import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]

  toggle(event) {
    event.stopPropagation()

    if (this.#menu.classList.contains("hidden")) {
      document.body.appendChild(this.#menu)
      const rect = this.element.getBoundingClientRect()
      this.#menu.style.top = `${rect.bottom + 4}px`
      this.#menu.style.right = `${window.innerWidth - rect.right}px`
      this.#menu.classList.remove("hidden")
    } else {
      this.#menu.classList.add("hidden")
    }
  }

  close(event) {
    if (!this.element.contains(event.target) && !this.#menu.contains(event.target)) {
      this.#menu.classList.add("hidden")
    }
  }

  connect() {
    this.#menu = this.menuTarget
    this.#boundClose = this.close.bind(this)
    document.addEventListener("click", this.#boundClose)
  }

  disconnect() {
    document.removeEventListener("click", this.#boundClose)
    this.#menu.remove()
  }

  #menu
  #boundClose
}
