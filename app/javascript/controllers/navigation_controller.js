import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="navigation"
export default class extends Controller {
  static targets = ["menu"]

  connect() {
    this.lastScrollY = window.scrollY
    this.ticking = false
    this.scrollThreshold = 10 // Minimum scroll before hiding

    this.handleScroll = this.handleScroll.bind(this)
    window.addEventListener('scroll', this.handleScroll, { passive: true })

    // Initial state check
    this.updateNavState()
  }

  disconnect() {
    window.removeEventListener('scroll', this.handleScroll)
  }

  handleScroll() {
    if (!this.ticking) {
      requestAnimationFrame(() => {
        this.updateNavState()
        this.ticking = false
      })
      this.ticking = true
    }
  }

  updateNavState() {
    const currentScrollY = window.scrollY
    const scrollDelta = currentScrollY - this.lastScrollY

    // Add/remove scrolled class for styling
    if (currentScrollY > 50) {
      this.element.classList.add('scrolled')
    } else {
      this.element.classList.remove('scrolled')
    }

    // Hide on scroll down, show on scroll up
    if (currentScrollY > 100) {
      if (scrollDelta > this.scrollThreshold) {
        // Scrolling down - hide nav
        this.element.classList.add('nav-hidden')
      } else if (scrollDelta < -this.scrollThreshold) {
        // Scrolling up - show nav
        this.element.classList.remove('nav-hidden')
      }
    } else {
      // Near top - always show
      this.element.classList.remove('nav-hidden')
    }

    this.lastScrollY = currentScrollY
  }

  toggleMenu() {
    this.menuTarget.classList.toggle("active")
  }
}
