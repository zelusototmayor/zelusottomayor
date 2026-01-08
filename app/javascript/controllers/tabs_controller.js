import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="tabs"
export default class extends Controller {
  static targets = ["button", "panel"]

  connect() {
    this.showAll()
  }

  show(event) {
    const category = event.currentTarget.dataset.category

    // Update active button
    this.buttonTargets.forEach(button => {
      button.classList.remove("active")
    })
    event.currentTarget.classList.add("active")

    // Filter cards
    if (category === "all") {
      this.showAll()
    } else {
      this.filterByCategory(category)
    }
  }

  showAll() {
    const cards = document.querySelectorAll(".case-study-card")
    cards.forEach(card => {
      card.style.display = "block"
    })
  }

  filterByCategory(category) {
    const cards = document.querySelectorAll(".case-study-card")
    cards.forEach(card => {
      if (card.dataset.category === category) {
        card.style.display = "block"
      } else {
        card.style.display = "none"
      }
    })
  }
}
