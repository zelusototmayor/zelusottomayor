class BookingMailer < ApplicationMailer
  default from: ENV.fetch('MAILER_FROM_EMAIL', 'noreply@example.com')

  def confirmation(booking)
    @booking = booking
    @booking_url = booking_url(booking.confirmation_token)

    mail(
      to: booking.guest_email,
      subject: "Your call is confirmed - #{booking.display_date}"
    )
  end

  def confirmed_with_meet_link(booking)
    @booking = booking
    @booking_url = booking_url(booking.confirmation_token)

    mail(
      to: booking.guest_email,
      subject: "Google Meet link ready - #{booking.display_date}"
    )
  end

  def cancellation(booking)
    @booking = booking

    mail(
      to: booking.guest_email,
      subject: "Call cancelled - #{booking.display_date}"
    )
  end

  def host_notification(booking)
    @booking = booking
    @booking_url = booking_url(booking.confirmation_token)

    mail(
      to: ENV.fetch('CONTACT_EMAIL', 'zelu@zelusottomayor.com'),
      subject: "New booking from #{booking.guest_name}",
      reply_to: booking.guest_email
    )
  end
end
