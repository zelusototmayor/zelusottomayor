class PagesController < ApplicationController
  before_action :load_content_config, only: [:home, :about]

  def home
    @featured_case_studies = CaseStudy.featured.published.ordered.limit(6)
    @testimonials = Testimonial.featured.ordered.limit(3)
    @services = @config[:services] if @config
    @process_steps = @config[:process] if @config
    @packages = @config[:packages] if @config
  end

  def work
    @case_studies = CaseStudy.published.ordered
    @client_projects = @case_studies.client_work
    @product_projects = @case_studies.products
  end

  def about
    @about_content = @config[:about] if @config
    @testimonials = Testimonial.featured.ordered.limit(3)
  end

  def contact
    @contact = ContactSubmission.new
  end

  def book_call
    # Redirect to scheduling tool (Calendly, Cal.com, etc.)
    # Replace this URL with your actual scheduling link
    redirect_to ENV.fetch('CALENDLY_URL', 'https://calendly.com/zalusottomayor'), allow_other_host: true
  end

  private

  def load_content_config
    @config = {}

    # Load YAML content files if they exist
    config_path = Rails.root.join('config/content')

    if File.exist?(config_path.join('services.yml'))
      @config[:services] = YAML.load_file(config_path.join('services.yml'))
    end

    if File.exist?(config_path.join('process.yml'))
      @config[:process] = YAML.load_file(config_path.join('process.yml'))
    end

    if File.exist?(config_path.join('packages.yml'))
      @config[:packages] = YAML.load_file(config_path.join('packages.yml'))
    end

    if File.exist?(config_path.join('about.yml'))
      @config[:about] = YAML.load_file(config_path.join('about.yml'))
    end
  rescue => e
    Rails.logger.error "Error loading content config: #{e.message}"
    @config = {}
  end
end
