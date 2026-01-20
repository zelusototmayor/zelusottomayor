import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "step",
    "panel",
    "selectedDate",
    "timeSlotsContainer",
    "startsAt",
    "timezone",
    "summaryDate",
    "summaryTime",
    "form"
  ]

  connect() {
    this.currentStep = 1
    this.selectedDate = null
    this.selectedSlot = null

    // Set timezone
    this.userTimezone = Intl.DateTimeFormat().resolvedOptions().timeZone
    if (this.hasTimezoneTarget) {
      this.timezoneTarget.value = this.userTimezone
    }

    this.updateStepDisplay()
  }

  goToStep(event) {
    const step = parseInt(event.currentTarget.dataset.step)
    this.showStep(step)
  }

  showStep(step) {
    this.currentStep = step
    this.updateStepDisplay()
  }

  updateStepDisplay() {
    // Update step indicators
    this.stepTargets.forEach((stepEl) => {
      const stepNum = parseInt(stepEl.dataset.step)
      stepEl.classList.remove("is-active", "is-completed")

      if (stepNum === this.currentStep) {
        stepEl.classList.add("is-active")
      } else if (stepNum < this.currentStep) {
        stepEl.classList.add("is-completed")
      }
    })

    // Update panels
    this.panelTargets.forEach((panel) => {
      const panelNum = parseInt(panel.dataset.panel)
      panel.style.display = panelNum === this.currentStep ? "block" : "none"
    })
  }

  // Called from calendar_controller when a date is selected
  dateSelected(event) {
    this.handleDateSelection(event.detail.date, event.detail.displayDate)
  }

  // Direct method call from calendar controller
  handleDateSelection(date, displayDate) {
    this.selectedDate = date

    // Update the selected date display
    if (this.hasSelectedDateTarget) {
      this.selectedDateTarget.textContent = displayDate
    }

    // Load available time slots
    this.loadTimeSlots(this.selectedDate)

    // Go to step 2
    this.showStep(2)
  }

  async loadTimeSlots(date) {
    if (this.hasTimeSlotsContainerTarget) {
      this.timeSlotsContainerTarget.innerHTML = '<div class="loading-slots">Loading available times...</div>'
    }

    try {
      const response = await fetch(`/bookings/available_slots?date=${date}`, {
        headers: {
          "Accept": "text/vnd.turbo-stream.html, text/html, application/xhtml+xml"
        }
      })

      if (response.ok) {
        const contentType = response.headers.get("Content-Type")
        if (contentType && contentType.includes("turbo-stream")) {
          const html = await response.text()
          Turbo.renderStreamMessage(html)
        } else {
          const html = await response.text()
          if (this.hasTimeSlotsContainerTarget) {
            this.timeSlotsContainerTarget.innerHTML = html
          }
        }
      } else {
        throw new Error("Failed to load time slots")
      }
    } catch (error) {
      console.error("Error loading time slots:", error)
      if (this.hasTimeSlotsContainerTarget) {
        this.timeSlotsContainerTarget.innerHTML = '<div class="error-message">Failed to load available times. Please try again.</div>'
      }
    }
  }

  selectTimeSlot(event) {
    const button = event.currentTarget
    const startsAt = button.dataset.startsAt
    const displayTime = button.dataset.displayTime

    // Remove selected state from other buttons
    document.querySelectorAll('.time-slot-button').forEach(btn => {
      btn.classList.remove('is-selected')
    })

    // Add selected state to clicked button
    button.classList.add('is-selected')

    // Store selection
    this.selectedSlot = {
      startsAt: startsAt,
      displayTime: displayTime
    }

    // Update hidden form field
    if (this.hasStartsAtTarget) {
      this.startsAtTarget.value = startsAt
    }

    // Update summary display
    if (this.hasSummaryDateTarget && this.hasSelectedDateTarget) {
      this.summaryDateTarget.textContent = this.selectedDateTarget.textContent
    }
    if (this.hasSummaryTimeTarget) {
      this.summaryTimeTarget.textContent = displayTime
    }

    // Go to step 3
    this.showStep(3)
  }
}
