require "test_helper"

class ContactMailerTest < ActionMailer::TestCase
  test "new_submission" do
    contact = contact_submissions(:one)
    mail = ContactMailer.new_submission(contact)
    assert_equal "New Contact Form Submission from #{contact.name}", mail.subject
    assert_equal [ ENV.fetch('CONTACT_EMAIL', 'zelu@zelusottomayor.com') ], mail.to
    assert_equal [ ENV.fetch('MAILER_FROM_EMAIL', 'noreply@example.com') ], mail.from
  end
end
