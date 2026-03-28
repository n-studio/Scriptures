import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["item", "handle"]
  static values = { url: String }

  #dragItem = null
  #placeholder = null

  connect() {
    this.itemTargets.forEach(item => {
      item.setAttribute("draggable", "true")
      item.addEventListener("dragstart", this.#onDragStart)
      item.addEventListener("dragover", this.#onDragOver)
      item.addEventListener("dragend", this.#onDragEnd)
    })
  }

  #onDragStart = (e) => {
    this.#dragItem = e.currentTarget
    e.currentTarget.style.opacity = "0.4"
    e.dataTransfer.effectAllowed = "move"
  }

  #onDragOver = (e) => {
    e.preventDefault()
    e.dataTransfer.dropEffect = "move"

    const target = e.currentTarget
    if (target === this.#dragItem) return

    const rect = target.getBoundingClientRect()
    const midY = rect.top + rect.height / 2

    if (e.clientY < midY) {
      target.parentNode.insertBefore(this.#dragItem, target)
    } else {
      target.parentNode.insertBefore(this.#dragItem, target.nextSibling)
    }
  }

  #onDragEnd = () => {
    this.#dragItem.style.opacity = "1"
    this.#dragItem = null
    this.#persist()
  }

  #persist() {
    const itemIds = this.itemTargets.map(el => el.dataset.itemId)
    const token = document.querySelector('meta[name="csrf-token"]')?.content

    fetch(this.urlValue, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": token,
        "Accept": "application/json"
      },
      body: JSON.stringify({ item_ids: itemIds })
    })
  }
}
