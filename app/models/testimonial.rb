class Testimonial < ApplicationRecord
  # Validations
  validates :client_name, presence: true
  validates :content, presence: true
  validates :rating, inclusion: { in: 1..5 }, allow_nil: true

  # Scopes
  scope :featured, -> { where(featured: true) }
  scope :ordered, -> { order(display_order: :asc, created_at: :desc) }
  scope :high_rated, -> { where("rating >= ?", 4) }

  # Instance methods
  def star_rating
    return "★" * 5 if rating.nil?
    "★" * rating + "☆" * (5 - rating)
  end

  def client_full_info
    parts = [client_name]
    parts << client_title if client_title.present?
    parts << "at #{client_company}" if client_company.present?
    parts.join(", ")
  end
end
