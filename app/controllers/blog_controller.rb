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

    return nil if front_matter["published"] == false
    return nil if front_matter["title"].blank?

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

    parsed_date = begin
      Date.parse(front_matter["date"].to_s)
    rescue ArgumentError, TypeError
      Date.today
    end

    {
      title: front_matter["title"],
      slug: front_matter["slug"] || File.basename(path, ".md").gsub(/^\d{4}-\d{2}-\d{2}-/, ""),
      date: parsed_date,
      meta_description: front_matter["meta_description"] || front_matter["description"],
      tags: Array(front_matter["tags"] || front_matter["keywords"]),
      author: front_matter["author"] || "Ze Lu Sottomayor",
      content_html: markdown.render(body_md).html_safe,
      excerpt: generate_excerpt(body_md)
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

  def generate_excerpt(body_md)
    # Skip Related reading, headings, and SEO metadata lines
    lines = body_md.split("\n")
    clean_lines = lines.reject do |line|
      l = line.strip
      l.start_with?("*Related reading", "Related reading", "#") ||
      l.match?(/^\*\*(Target keyword|Primary keyword|Secondary keyword|Meta title|Meta description|Slug)\*\*/) ||
      l.match?(/^(Target keyword|Primary keyword|Secondary keyword|Meta title|Meta description|Slug):/)
    end

    # Take first 3 non-empty paragraphs
    paragraphs = clean_lines.join("\n").split("\n\n").reject(&:blank?).first(2).join(" ")

    # Strip all markdown syntax
    paragraphs
      .gsub(/\[([^\]]+)\]\([^)]+\)/, '\1')  # [text](url) -> text
      .gsub(/[#*_`~]/, "")                   # headers, bold, italic, code
      .gsub(/^\s*[-*+]\s+/, "")             # list bullets
      .gsub(/\s+/, " ")                      # normalize whitespace
      .strip
      .truncate(220)
  end
end
