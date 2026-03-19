xml.instruct! :xml, version: "1.0", encoding: "UTF-8"
xml.urlset xmlns: "http://www.sitemaps.org/schemas/sitemap/0.9" do
  # Homepage
  xml.url do
    xml.loc "https://zelusottomayor.com/"
    xml.lastmod Date.today.to_s
    xml.changefreq "weekly"
    xml.priority "1.0"
  end

  # Blog index
  xml.url do
    xml.loc "https://zelusottomayor.com/blog"
    xml.lastmod Date.today.to_s
    xml.changefreq "daily"
    xml.priority "0.8"
  end

  # Individual blog posts
  @blog_posts.each do |post|
    xml.url do
      xml.loc "https://zelusottomayor.com/blog/#{post[:slug]}"
      xml.lastmod post[:date].to_s
      xml.changefreq "monthly"
      xml.priority "0.7"
    end
  end
end
