class BlogController < ApplicationController
  BLOG_DIR = Rails.root.join("blog")

  def index
    @posts = load_all_posts.sort_by { |p| p[:date] }.reverse
  end

  def show
    slug = params[:slug]
    @post = load_post_by_slug(slug)
    render :not_found, status: :not_found unless @post
  end

  private

  def load_all_posts
    Dir.glob(BLOG_DIR.join("*.md")).filter_map do |path|
      parse_post_file(path)
    rescue => e
      Rails.logger.error "Error loading blog post #{path}: #{e.message}"
      nil
    end
  end

  def load_post_by_slug(slug)
    file = Dir.glob(BLOG_DIR.join("*.md")).find do |path|
      front_matter = extract_front_matter(File.read(path))
      front_matter["slug"] == slug
    end
    file ? parse_post_file(file) : nil
  end

  def parse_post_file(path)
    raw = File.read(path)
    front_matter = extract_front_matter(raw)
    body_md = extract_body(raw)

    return nil unless front_matter["published"] != false

    renderer = Redcarpet::Render::HTML.new(
      hard_wrap: false,
      filter_html: false,
      safe_links_only: true
    )
    markdown = Redcarpet::Markdown.new(renderer,
      autolink: true,
      tables: true,
      fenced_code_blocks: true,
      strikethrough: true,
      superscript: true,
      highlight: true,
      no_intra_emphasis: true
    )

    {
      title: front_matter["title"],
      slug: front_matter["slug"] || File.basename(path, ".md").gsub(/^\d{4}-\d{2}-\d{2}-/, ""),
      date: Date.parse(front_matter["date"].to_s) rescue Date.today,
      meta_description: front_matter["meta_description"],
      tags: Array(front_matter["tags"]),
      author: front_matter["author"] || "Ze Lu Sottomayor",
      content_html: markdown.render(body_md).html_safe,
      excerpt: body_md.split("\n\n").first(3).join(" ").gsub(/[#*_`]/, "").truncate(200)
    }
  end

  def extract_front_matter(raw)
    return {} unless raw.start_with?("---")
    parts = raw.split(/^---\s*$/, 3)
    YAML.safe_load(parts[1] || "") || {}
  rescue
    {}
  end

  def extract_body(raw)
    return raw unless raw.start_with?("---")
    parts = raw.split(/^---\s*$/, 3)
    parts[2].to_s.strip
  end
end
