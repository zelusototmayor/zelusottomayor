class ContactMailer < ApplicationMailer
  default from: ENV.fetch('MAILER_FROM_EMAIL', 'noreply@example.com')

  def new_submission(contact_submission)
    @contact = contact_submission

    mail(
      to: ENV.fetch('CONTACT_EMAIL', 'zelu@zelusottomayor.com'),
      subject: "New Contact Form Submission from #{@contact.name}",
      reply_to: @contact.email
    )
  end
end
