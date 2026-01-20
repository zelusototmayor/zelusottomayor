class BookingsController < ApplicationController
  before_action :set_booking, only: [:show, :cancel]

  def new
    @booking = Booking.new
    @current_month = Date.current
    @availability_service = AvailabilityService.new
  end

  def available_slots
    date = params[:date]
    return head :bad_request if date.blank?

    begin
      @date = Date.parse(date)
      @slots = AvailabilityService.new.available_slots_for_date(@date)

      respond_to do |format|
        format.turbo_stream
        format.html { render partial: 'time_slots', locals: { slots: @slots, date: @date } }
        format.json { render json: @slots }
      end
    rescue ArgumentError
      head :bad_request
    end
  end

  def calendar_days
    year = params[:year].to_i
    month = params[:month].to_i

    return head :bad_request if year < 2024 || year > 2030 || month < 1 || month > 12

    @current_month = Date.new(year, month, 1)

    respond_to do |format|
      format.turbo_stream
      format.html { render partial: 'calendar', locals: { current_month: @current_month } }
    end
  end

  def create
    @booking = Booking.new(booking_params)

    if @booking.save
      # Queue the Google Calendar sync job
      GoogleCalendarSyncJob.perform_later(@booking.id)

      # Send initial confirmation email
      BookingMailer.confirmation(@booking).deliver_later

      redirect_to booking_path(@booking.confirmation_token),
                  notice: 'Your call has been booked! Check your email for confirmation.'
    else
      @current_month = Date.current
      @availability_service = AvailabilityService.new

      flash.now[:alert] = 'Please fix the errors below.'
      render :new, status: :unprocessable_entity
    end
  end

  def show
    # @booking is set by before_action
  end

  def cancel
    if @booking.pending? || @booking.confirmed?
      @booking.cancel!

      # Queue the Google Calendar cancellation job if there's an event
      if @booking.google_event_id.present?
        GoogleCalendarCancelJob.perform_later(@booking.google_event_id)
      end

      # Send cancellation email
      BookingMailer.cancellation(@booking).deliver_later

      redirect_to book_call_path, notice: 'Your booking has been cancelled.'
    else
      redirect_to booking_path(@booking.confirmation_token),
                  alert: 'This booking cannot be cancelled.'
    end
  end

  private

  def set_booking
    @booking = Booking.find_by!(confirmation_token: params[:confirmation_token])
  rescue ActiveRecord::RecordNotFound
    redirect_to book_call_path, alert: 'Booking not found.'
  end

  def booking_params
    params.require(:booking).permit(
      :guest_name,
      :guest_email,
      :guest_company,
      :starts_at,
      :timezone,
      :notes
    )
  end
end
