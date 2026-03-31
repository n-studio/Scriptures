import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { url: String }

  navigate() {
    const provider = this.element.value
    const url = new URL(this.urlValue, window.location.origin)
    url.searchParams.set("provider", provider)
    Turbo.visit(url.toString())
  }
}
