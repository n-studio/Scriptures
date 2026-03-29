import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { passageId: Number }

  #startTime = null
  #reported = false

  connect() {
    this.#startTime = Date.now()

    document.addEventListener("visibilitychange", this.#onVisibilityChange)
  }

  disconnect() {
    this.#report()
    document.removeEventListener("visibilitychange", this.#onVisibilityChange)
  }

  #onVisibilityChange = () => {
    if (document.hidden) this.#report()
    else this.#startTime = Date.now()
  }

  #report() {
    if (this.#reported || !this.#startTime || !this.passageIdValue) return

    const seconds = Math.round((Date.now() - this.#startTime) / 1000)
    if (seconds < 2) return

    const token = document.querySelector('meta[name="csrf-token"]')?.content
    navigator.sendBeacon("/reading_progresses/time", new URLSearchParams({
      passage_id: this.passageIdValue,
      seconds: seconds,
      authenticity_token: token
    }))

    this.#startTime = Date.now()
  }
}
