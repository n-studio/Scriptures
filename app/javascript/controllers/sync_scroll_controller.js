import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["pane"]

  #syncing = false

  scroll(event) {
    if (this.#syncing) return
    this.#syncing = true

    const source = event.target
    const scrollRatio = source.scrollTop / (source.scrollHeight - source.clientHeight || 1)

    this.paneTargets.forEach(pane => {
      if (pane !== source) {
        pane.scrollTop = scrollRatio * (pane.scrollHeight - pane.clientHeight)
      }
    })

    requestAnimationFrame(() => { this.#syncing = false })
  }
}
