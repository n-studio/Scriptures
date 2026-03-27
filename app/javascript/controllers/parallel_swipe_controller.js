import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container", "indicator"]

  #currentIndex = 0
  #touchStartX = 0
  #touchDeltaX = 0
  #columnCount = 0

  connect() {
    this.#columnCount = this.containerTarget.children.length
    this.#updateIndicators()
  }

  touchstart(event) {
    this.#touchStartX = event.touches[0].clientX
    this.#touchDeltaX = 0
  }

  touchmove(event) {
    this.#touchDeltaX = event.touches[0].clientX - this.#touchStartX
  }

  touchend() {
    const threshold = 50
    if (this.#touchDeltaX > threshold && this.#currentIndex > 0) {
      this.#currentIndex--
    } else if (this.#touchDeltaX < -threshold && this.#currentIndex < this.#columnCount - 1) {
      this.#currentIndex++
    }
    this.#scrollToIndex()
  }

  goTo(event) {
    this.#currentIndex = parseInt(event.params.index, 10)
    this.#scrollToIndex()
  }

  #scrollToIndex() {
    const child = this.containerTarget.children[this.#currentIndex]
    if (child) {
      this.containerTarget.scrollTo({ left: child.offsetLeft, behavior: "smooth" })
    }
    this.#updateIndicators()
  }

  #updateIndicators() {
    this.indicatorTargets.forEach((el, i) => {
      el.classList.toggle("bg-stone-900", i === this.#currentIndex)
      el.classList.toggle("dark:bg-stone-100", i === this.#currentIndex)
      el.classList.toggle("bg-stone-300", i !== this.#currentIndex)
      el.classList.toggle("dark:bg-stone-700", i !== this.#currentIndex)
    })
  }
}
