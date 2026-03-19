class SitemapsController < ApplicationController
  def show
    @blog_posts = load_blog_slugs
    respond_to do |format|
      format.xml
    end
  end

  private

  def load_blog_slugs
    blog_dir = Rails.root.join("blog")
    return [] unless blog_dir.exist?

    Dir.glob(blog_dir.join("*.md")).filter_map do |path|
      raw = File.read(path)
      front_matter = extract_front_matter(raw)
      next if front_matter["published"] == false
      next if front_matter["title"].blank?

      date = begin
        Date.parse(front_matter["date"].to_s)
      rescue ArgumentError, TypeError
        Date.today
      end

      {
        slug: front_matter["slug"] || File.basename(path, ".md").gsub(/^\d{4}-\d{2}-\d{2}-/, ""),
        date: date
      }
    end.sort_by { |p| p[:date] }.reverse
  end

  def extract_front_matter(raw)
    return {} unless raw.start_with?("---")
    parts = raw.split(/^---\s*$/, 3)
    YAML.safe_load(parts[1] || "") || {}
  rescue
    {}
  end
end
