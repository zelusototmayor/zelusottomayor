class AvailabilityService
  SLOT_DURATION = Booking::SLOT_DURATION
  START_HOUR = Booking::AVAILABILITY_START_HOUR
  END_HOUR = Booking::AVAILABILITY_END_HOUR
  TIMEZONE = Booking::HOST_TIMEZONE

  def initialize(google_calendar_service: nil)
    @google_calendar_service = google_calendar_service || GoogleCalendarService.new
  end

  def available_slots_for_date(date)
    date = parse_date(date)
    return [] if date < Date.current

    all_slots = generate_all_slots_for_date(date)
    booked_slots = get_booked_slots_for_date(date)
    google_busy_times = get_google_busy_times_for_date(date)

    filter_available_slots(all_slots, booked_slots, google_busy_times)
  end

  def available_dates_in_month(year, month)
    start_date = Date.new(year, month, 1)
    end_date = start_date.end_of_month

    dates = []
    (start_date..end_date).each do |date|
      next if date < Date.current
      dates << date if available_slots_for_date(date).any?
    end

    dates
  end

  private

  def parse_date(date)
    case date
    when Date
      date
    when Time, DateTime, ActiveSupport::TimeWithZone
      date.to_date
    when String
      Date.parse(date)
    else
      raise ArgumentError, "Cannot parse date from #{date.class}"
    end
  end

  def generate_all_slots_for_date(date)
    slots = []
    current_time = date.in_time_zone(TIMEZONE).change(hour: START_HOUR, min: 0)
    end_time = date.in_time_zone(TIMEZONE).change(hour: END_HOUR, min: 0)

    while current_time < end_time
      slot_end = current_time + SLOT_DURATION
      break if slot_end > end_time

      slots << {
        starts_at: current_time,
        ends_at: slot_end,
        display_time: current_time.strftime('%H:%M'),
        display_time_12h: current_time.strftime('%l:%M %p').strip
      }

      current_time = slot_end
    end

    slots
  end

  def get_booked_slots_for_date(date)
    Booking.active.on_date(date).pluck(:starts_at, :ends_at).map do |starts_at, ends_at|
      { starts_at: starts_at, ends_at: ends_at }
    end
  end

  def get_google_busy_times_for_date(date)
    @google_calendar_service.busy_times_for_date(date)
  rescue StandardError => e
    Rails.logger.error "GoogleCalendarService error: #{e.message}"
    []
  end

  def filter_available_slots(all_slots, booked_slots, google_busy_times)
    now = Time.current

    all_slots.select do |slot|
      slot_start = slot[:starts_at]
      slot_end = slot[:ends_at]

      # Skip past slots
      next false if slot_start <= now

      # Check against booked slots
      booked = booked_slots.any? do |booked|
        times_overlap?(slot_start, slot_end, booked[:starts_at], booked[:ends_at])
      end
      next false if booked

      # Check against Google Calendar busy times
      google_busy = google_busy_times.any? do |busy|
        times_overlap?(slot_start, slot_end, busy[:starts_at], busy[:ends_at])
      end
      next false if google_busy

      true
    end
  end

  def times_overlap?(start1, end1, start2, end2)
    start1 < end2 && end1 > start2
  end
end
