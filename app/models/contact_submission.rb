class ContactSubmission < ApplicationRecord
  # Enums
  enum :status, {
    new: 0,
    contacted: 1,
    qualified: 2,
    converted: 3,
    archived: 4
  }

  # Validations
  validates :name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :message, presence: true, length: { minimum: 10 }

  # Scopes
  scope :recent, -> { order(created_at: :desc) }
  scope :unread, -> { where(status: :new) }
  scope :active, -> { where.not(status: :archived) }

  # Instance methods
  def mark_as_contacted!
    update(status: :contacted)
  end

  def mark_as_qualified!
    update(status: :qualified)
  end

  def mark_as_converted!
    update(status: :converted)
  end
end
