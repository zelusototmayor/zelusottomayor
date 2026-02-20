class PagesController < ApplicationController
  before_action :load_content_config, only: [:home, :work, :about]

  def home
    @featured_projects = (@config[:projects] || []).select { |project| project["featured"] }.first(6)
    @testimonials = Testimonial.featured.ordered.limit(3)
    @services = @config[:services] if @config
    @process_steps = @config[:process] if @config
    @packages = @config[:packages] if @config
  end

  def work
    @projects = @config[:projects] || []
    @client_projects = @projects.select { |project| project["type"] == "client" }
    @product_projects = @projects.select { |project| project["type"] == "product" }
    @automation_projects = @projects.select { |project| project["type"] == "automation" }
  end

  def about
    @about_content = @config[:about] if @config
    @testimonials = Testimonial.featured.ordered.limit(3)
  end

  def contact
    @contact = ContactSubmission.new
  end

  def automation
  end

  def demo
    render layout: 'demo'
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

    if File.exist?(config_path.join('projects.yml'))
      @config[:projects] = YAML.load_file(config_path.join('projects.yml'))
    end
  rescue => e
    Rails.logger.error "Error loading content config: #{e.message}"
    @config = {}
  end
end
