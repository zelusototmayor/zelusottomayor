class CaseStudy < ApplicationRecord
  # Enums
  enum :client_type, { client: 0, product: 1 }

  # Serialization for metrics stored as JSON in text field
  serialize :metrics, type: Array, coder: JSON
  serialize :tech_stack, type: Array, coder: JSON
  serialize :workflow_steps, type: Array, coder: JSON

  # Validations
  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :client_type, presence: true

  # Scopes
  scope :featured, -> { where(featured: true) }
  scope :published, -> { where.not(published_at: nil).where("published_at <= ?", Time.current) }
  scope :ordered, -> { order(display_order: :asc, published_at: :desc) }
  scope :client_work, -> { where(client_type: :client) }
  scope :products, -> { where(client_type: :product) }

  # Callbacks
  before_validation :generate_slug, if: -> { slug.blank? && name.present? }

  # Instance methods
  def published?
    published_at.present? && published_at <= Time.current
  end

  def key_metrics
    return [] unless metrics.present?
    metrics.is_a?(Array) ? metrics : []
  end

  def technologies
    return [] unless tech_stack.present?
    tech_stack.is_a?(Array) ? tech_stack : []
  end

  def has_admin_panel?
    admin_panel_url.present?
  end

  def workflow
    return [] unless workflow_steps.present?
    workflow_steps.is_a?(Array) ? workflow_steps : []
  end

  def has_workflow?
    workflow.any?
  end

  private

  def generate_slug
    self.slug = name.parameterize
  end
end
