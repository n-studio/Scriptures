import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  #el = null

  connect() {
    this.#el = document.createElement("div")
    this.#el.id = "tooltip"
    document.body.appendChild(this.#el)

    this.element.addEventListener("mouseover", this.#show)
    this.element.addEventListener("mouseout", this.#hide)
  }

  disconnect() {
    this.element.removeEventListener("mouseover", this.#show)
    this.element.removeEventListener("mouseout", this.#hide)
    this.#el?.remove()
  }

  #show = (e) => {
    const target = e.target.closest("[data-tooltip]")
    if (!target) return

    this.#el.textContent = target.dataset.tooltip
    this.#el.style.opacity = "1"

    const rect = target.getBoundingClientRect()
    const tipRect = this.#el.getBoundingClientRect()

    let left = rect.left + rect.width / 2 - tipRect.width / 2
    let top = rect.top - tipRect.height - 6

    // Keep within viewport
    if (left < 4) left = 4
    if (left + tipRect.width > window.innerWidth - 4) left = window.innerWidth - tipRect.width - 4
    if (top < 4) {
      top = rect.bottom + 6
    }

    this.#el.style.left = `${left}px`
    this.#el.style.top = `${top}px`
  }

  #hide = () => {
    this.#el.style.opacity = "0"
  }
}
