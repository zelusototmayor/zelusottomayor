class Booking < ApplicationRecord
  # Constants
  SLOT_DURATION = 30.minutes
  AVAILABILITY_START_HOUR = 10
  AVAILABILITY_END_HOUR = 20
  HOST_TIMEZONE = 'Europe/Lisbon'

  # Enums
  enum :status, {
    pending: 0,
    confirmed: 1,
    cancelled: 2
  }

  # Callbacks
  before_validation :generate_confirmation_token, on: :create
  before_validation :set_ends_at, on: :create

  # Validations
  validates :guest_name, presence: true
  validates :guest_email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :starts_at, presence: true
  validates :ends_at, presence: true
  validates :timezone, presence: true
  validates :confirmation_token, presence: true, uniqueness: true
  validate :starts_at_must_be_in_future, on: :create
  validate :starts_at_must_be_within_availability_hours, on: :create
  validate :no_overlapping_bookings, on: :create

  # Scopes
  scope :upcoming, -> { where('starts_at > ?', Time.current) }
  scope :active, -> { where(status: [:pending, :confirmed]) }
  scope :on_date, ->(date) {
    date = date.in_time_zone(HOST_TIMEZONE)
    where(starts_at: date.beginning_of_day..date.end_of_day)
  }
  scope :between, ->(start_time, end_time) {
    where(starts_at: start_time..end_time)
  }

  # Instance methods
  def confirm!
    update(status: :confirmed, confirmed_at: Time.current)
  end

  def cancel!
    update(status: :cancelled, cancelled_at: Time.current)
  end

  def display_date
    starts_at.in_time_zone(timezone).strftime('%A, %B %d, %Y')
  end

  def display_time
    starts_at.in_time_zone(timezone).strftime('%l:%M %p').strip
  end

  def display_time_range
    start_time = starts_at.in_time_zone(timezone).strftime('%l:%M %p').strip
    end_time = ends_at.in_time_zone(timezone).strftime('%l:%M %p').strip
    "#{start_time} - #{end_time}"
  end

  def host_display_date
    starts_at.in_time_zone(HOST_TIMEZONE).strftime('%A, %B %d, %Y')
  end

  def host_display_time_range
    start_time = starts_at.in_time_zone(HOST_TIMEZONE).strftime('%l:%M %p').strip
    end_time = ends_at.in_time_zone(HOST_TIMEZONE).strftime('%l:%M %p').strip
    "#{start_time} - #{end_time} (Lisbon)"
  end

  private

  def generate_confirmation_token
    self.confirmation_token ||= SecureRandom.urlsafe_base64(24)
  end

  def set_ends_at
    self.ends_at ||= starts_at + SLOT_DURATION if starts_at.present?
  end

  def starts_at_must_be_in_future
    return unless starts_at.present?
    if starts_at <= Time.current
      errors.add(:starts_at, 'must be in the future')
    end
  end

  def starts_at_must_be_within_availability_hours
    return unless starts_at.present?

    lisbon_time = starts_at.in_time_zone(HOST_TIMEZONE)
    hour = lisbon_time.hour

    unless hour >= AVAILABILITY_START_HOUR && hour < AVAILABILITY_END_HOUR
      errors.add(:starts_at, "must be between #{AVAILABILITY_START_HOUR}:00 and #{AVAILABILITY_END_HOUR}:00 Lisbon time")
    end
  end

  def no_overlapping_bookings
    return unless starts_at.present? && ends_at.present?

    overlapping = Booking.active
      .where('starts_at < ? AND ends_at > ?', ends_at, starts_at)

    if overlapping.exists?
      errors.add(:starts_at, 'overlaps with an existing booking')
    end
  end
end
