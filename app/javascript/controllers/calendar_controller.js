import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["timezoneDisplay"]

  connect() {
    this.updateTimezoneDisplay()
  }

  updateTimezoneDisplay() {
    if (this.hasTimezoneDisplayTarget) {
      const timezone = Intl.DateTimeFormat().resolvedOptions().timeZone
      // Format timezone for display (e.g., "America/New_York" -> "New York")
      const displayTimezone = timezone.replace(/_/g, ' ').split('/').pop()
      this.timezoneDisplayTarget.textContent = displayTimezone
    }
  }

  selectDate(event) {
    const date = event.currentTarget.dataset.date
    const displayDate = event.currentTarget.dataset.displayDate

    // Remove selected state from other days
    document.querySelectorAll('.calendar-day').forEach(day => {
      day.classList.remove('is-selected')
    })

    // Add selected state to clicked day
    event.currentTarget.classList.add('is-selected')

    // Find the booking controller and call dateSelected directly
    const bookingElement = this.element.closest('[data-controller~="booking"]')
    if (bookingElement) {
      const bookingController = this.application.getControllerForElementAndIdentifier(bookingElement, 'booking')
      if (bookingController) {
        bookingController.handleDateSelection(date, displayDate)
      }
    }
  }

  async previousMonth(event) {
    const year = event.currentTarget.dataset.year
    const month = event.currentTarget.dataset.month
    await this.loadMonth(year, month)
  }

  async nextMonth(event) {
    const year = event.currentTarget.dataset.year
    const month = event.currentTarget.dataset.month
    await this.loadMonth(year, month)
  }

  async loadMonth(year, month) {
    try {
      const response = await fetch(`/bookings/calendar_days?year=${year}&month=${month}`, {
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
          const calendar = document.getElementById("calendar")
          if (calendar) {
            calendar.outerHTML = html
          }
        }
      } else {
        throw new Error("Failed to load calendar")
      }
    } catch (error) {
      console.error("Error loading calendar:", error)
    }
  }
}
