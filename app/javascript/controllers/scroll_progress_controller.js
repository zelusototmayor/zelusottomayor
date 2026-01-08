import { Controller } from "@hotwired/stimulus"

// Scroll progress bar and navigation shrink controller
export default class extends Controller {
  static targets = ["bar"]

  connect() {
    this.updateProgress = this.updateProgress.bind(this)
    this.shrinkNav = this.shrinkNav.bind(this)

    window.addEventListener('scroll', this.updateProgress)
    window.addEventListener('scroll', this.shrinkNav)

    // Initial update
    this.updateProgress()
    this.shrinkNav()
  }

  disconnect() {
    window.removeEventListener('scroll', this.updateProgress)
    window.removeEventListener('scroll', this.shrinkNav)
  }

  updateProgress() {
    const windowHeight = document.documentElement.scrollHeight - document.documentElement.clientHeight
    const scrolled = (window.scrollY / windowHeight) * 100

    if (this.hasBarTarget) {
      this.barTarget.style.width = `${scrolled}%`
    }
  }

  shrinkNav() {
    const nav = this.element
    const scrolled = window.scrollY

    if (scrolled > 100) {
      nav.classList.add('scrolled')
    } else {
      nav.classList.remove('scrolled')
    }
  }
}
