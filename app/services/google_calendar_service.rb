require 'google/apis/calendar_v3'
require 'googleauth'

class GoogleCalendarService
  CALENDAR_SCOPE = Google::Apis::CalendarV3::AUTH_CALENDAR
  APPLICATION_NAME = 'Portfolio Booking System'

  def initialize
    @host_email = credentials_config[:host_email]
    @calendar_id = @host_email || 'primary'
    @service = build_service
  end

  def busy_times_for_date(date)
    return [] unless configured?

    date = date.to_date if date.respond_to?(:to_date)
    timezone = Booking::HOST_TIMEZONE

    start_time = date.in_time_zone(timezone).beginning_of_day
    end_time = date.in_time_zone(timezone).end_of_day

    request = Google::Apis::CalendarV3::FreeBusyRequest.new(
      time_min: start_time.iso8601,
      time_max: end_time.iso8601,
      time_zone: timezone,
      items: [{ id: @calendar_id }]
    )

    response = @service.query_freebusy(request)
    calendar_busy = response.calendars[@calendar_id]&.busy || []

    calendar_busy.map do |busy_period|
      {
        starts_at: Time.parse(busy_period.start).in_time_zone(timezone),
        ends_at: Time.parse(busy_period.end).in_time_zone(timezone)
      }
    end
  rescue Google::Apis::Error => e
    Rails.logger.error "Google Calendar API error (busy_times): #{e.message}"
    []
  end

  def create_event(booking)
    return nil unless configured?

    # Note: Service accounts can't invite attendees without Domain-Wide Delegation
    # So we create the event without attendees and include Meet link in description
    event = Google::Apis::CalendarV3::Event.new(
      summary: "Call with #{booking.guest_name}",
      description: event_description(booking),
      start: Google::Apis::CalendarV3::EventDateTime.new(
        date_time: booking.starts_at.iso8601,
        time_zone: Booking::HOST_TIMEZONE
      ),
      end: Google::Apis::CalendarV3::EventDateTime.new(
        date_time: booking.ends_at.iso8601,
        time_zone: Booking::HOST_TIMEZONE
      ),
      reminders: Google::Apis::CalendarV3::Event::Reminders.new(
        use_default: false,
        overrides: [
          Google::Apis::CalendarV3::EventReminder.new(reminder_method: 'email', minutes: 60),
          Google::Apis::CalendarV3::EventReminder.new(reminder_method: 'popup', minutes: 15)
        ]
      )
    )

    # Try to add Google Meet - service accounts may not have permission
    begin
      event.conference_data = Google::Apis::CalendarV3::ConferenceData.new(
        create_request: Google::Apis::CalendarV3::CreateConferenceRequest.new(
          request_id: SecureRandom.uuid,
          conference_solution_key: Google::Apis::CalendarV3::ConferenceSolutionKey.new(
            type: 'hangoutsMeet'
          )
        )
      )

      created_event = @service.insert_event(
        @calendar_id,
        event,
        conference_data_version: 1,
        send_updates: 'none'
      )
    rescue Google::Apis::ClientError => e
      if e.message.include?('Invalid conference type')
        # Fall back to event without Meet link
        Rails.logger.info "Google Meet not available for this calendar, creating event without conference"
        event.conference_data = nil
        created_event = @service.insert_event(
          @calendar_id,
          event,
          send_updates: 'none'
        )
      else
        raise e
      end
    end

    {
      event_id: created_event.id,
      meet_link: created_event.hangout_link || extract_meet_link(created_event)
    }
  rescue Google::Apis::Error => e
    Rails.logger.error "Google Calendar API error (create_event): #{e.message}"
    nil
  end

  def cancel_event(event_id)
    return false unless configured? && event_id.present?

    @service.delete_event(@calendar_id, event_id, send_updates: 'all')
    true
  rescue Google::Apis::Error => e
    Rails.logger.error "Google Calendar API error (cancel_event): #{e.message}"
    false
  end

  def configured?
    credentials_config[:service_account_key].present? && @host_email.present?
  end

  private

  def build_service
    service = Google::Apis::CalendarV3::CalendarService.new
    service.client_options.application_name = APPLICATION_NAME

    if configured?
      service.authorization = authorize
    end

    service
  end

  def authorize
    key_data = credentials_config[:service_account_key]
    return nil unless key_data.present?

    # Convert to JSON string if it's a hash
    key_json = key_data.is_a?(Hash) ? key_data.to_json : key_data

    authorizer = Google::Auth::ServiceAccountCredentials.make_creds(
      json_key_io: StringIO.new(key_json),
      scope: CALENDAR_SCOPE
    )

    # For service accounts to access user calendars, we need to impersonate
    # The service account needs domain-wide delegation enabled
    # and the calendar must be shared with the service account email
    authorizer.fetch_access_token!
    authorizer
  rescue StandardError => e
    Rails.logger.error "Google Auth error: #{e.message}"
    nil
  end

  def credentials_config
    @credentials_config ||= begin
      if Rails.application.credentials.google.present?
        Rails.application.credentials.google.to_h.with_indifferent_access
      else
        {}
      end
    end
  end

  def event_description(booking)
    parts = ["30-minute call booked via portfolio website."]
    parts << "Guest: #{booking.guest_name} (#{booking.guest_email})"
    parts << "Company: #{booking.guest_company}" if booking.guest_company.present?
    parts << "Notes: #{booking.notes}" if booking.notes.present?
    parts << "Guest timezone: #{booking.timezone}"
    parts << ""
    parts << "---"
    parts << "To add a Google Meet link: Edit this event and click 'Add Google Meet video conferencing'"
    parts.join("\n\n")
  end

  def extract_meet_link(event)
    entry_points = event.conference_data&.entry_points
    return nil unless entry_points

    video_entry = entry_points.find { |ep| ep.entry_point_type == 'video' }
    video_entry&.uri
  end
end
