class GoogleCalendarCancelJob < ApplicationJob
  queue_as :default

  retry_on StandardError, wait: :polynomially_longer, attempts: 3

  def perform(event_id)
    return if event_id.blank?

    service = GoogleCalendarService.new
    return unless service.configured?

    service.cancel_event(event_id)
  rescue StandardError => e
    Rails.logger.error "GoogleCalendarCancelJob error for event #{event_id}: #{e.message}"
    raise
  end
end
