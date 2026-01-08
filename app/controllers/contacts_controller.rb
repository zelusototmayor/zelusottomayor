class ContactsController < ApplicationController
  def create
    @contact = ContactSubmission.new(contact_params)

    if @contact.save
      # Send notification email (will set up mailer later)
      begin
        ContactMailer.new_submission(@contact).deliver_later
      rescue => e
        Rails.logger.error "Failed to send contact email: #{e.message}"
      end

      redirect_to contact_path, notice: "Thanks for reaching out! I'll get back to you within 24 hours."
    else
      flash.now[:alert] = "Please fix the errors below."
      render 'pages/contact', status: :unprocessable_entity
    end
  end

  private

  def contact_params
    params.require(:contact_submission).permit(
      :name,
      :email,
      :company,
      :project_type,
      :budget_range,
      :timeline,
      :message,
      :referral_source
    )
  end
end
