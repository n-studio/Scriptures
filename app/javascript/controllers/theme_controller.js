import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["icon", "label"]

  connect() {
    const stored = localStorage.getItem("theme")
    if (stored === "dark" || (!stored && window.matchMedia("(prefers-color-scheme: dark)").matches)) {
      document.documentElement.classList.add("dark")
    }
    this.updateUI()
  }

  toggle() {
    document.documentElement.classList.toggle("dark")
    const isDark = document.documentElement.classList.contains("dark")
    localStorage.setItem("theme", isDark ? "dark" : "light")
    this.updateUI()
  }

  updateUI() {
    const isDark = document.documentElement.classList.contains("dark")
    if (this.hasIconTarget) {
      this.iconTarget.innerHTML = isDark ? this.sunSVG : this.moonSVG
    }
    if (this.hasLabelTarget) {
      this.labelTarget.textContent = isDark ? "Light Mode" : "Dark Mode"
    }
  }

  get sunSVG() {
    return `<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="4"/><path d="M12 2v2"/><path d="M12 20v2"/><path d="m4.93 4.93 1.41 1.41"/><path d="m17.66 17.66 1.41 1.41"/><path d="M2 12h2"/><path d="M20 12h2"/><path d="m6.34 17.66-1.41 1.41"/><path d="m19.07 4.93-1.41 1.41"/></svg>`
  }

  get moonSVG() {
    return `<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 3a6 6 0 0 0 9 9 9 9 0 1 1-9-9Z"/></svg>`
  }
}
