# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts "Seeding database..."

# Clear existing data (optional - comment out if you want to keep existing data)
CaseStudy.destroy_all
Testimonial.destroy_all

# Create Case Studies (Personal Products)
puts "Creating case studies..."

CaseStudy.create!(
  name: "UX Audit App",
  client_name: "UX Audit App",
  client_type: :product,
  tagline: "AI tool that analyzes user session recordings to find UX problems",
  slug: "uxpilot",
  problem: "Watching user session recordings to find UX issues is tedious and time-consuming. Product teams need to review hours of footage to spot where users struggle.",
  approach: "Built a Rails app that uses Claude API to analyze user session recordings. The AI watches the recordings and identifies where users hesitate, click repeatedly, or seem confused. It generates a report with specific UX issues and timestamps.",
  results: "Currently in use by several product teams. Turns hours of manual review into a 5-minute AI analysis. Most useful for finding obvious friction points that are easy to miss when reviewing manually.",
  metrics: [],
  link: "https://uxauditapp.com",
  icon: "ux-audit-app.png",
  featured: true,
  display_order: 1,
  published_at: Time.current
)

CaseStudy.create!(
  name: "AI Talk Coach",
  client_name: "AI Talk Coach",
  client_type: :product,
  tagline: "Practice speaking with AI feedback on filler words and pacing",
  slug: "ai-talk-coach",
  problem: "Practicing for interviews or presentations is awkward because you need someone to listen and give feedback. Recording yourself doesn't help you identify what to improve.",
  approach: "Built a web app where you practice 60-180 second responses on common topics. Uses browser speech recognition to transcribe your answer, then sends it to Claude for feedback on filler words, pacing, clarity, and structure. Provides specific drills to improve weak areas.",
  results: "Useful for interview prep and presentation practice. The AI feedback is surprisingly good at catching filler words and suggesting clearer phrasing. Several users have mentioned it helped them prepare for job interviews.",
  metrics: [],
  link: "https://aitalkcoach.com",
  icon: "ai-talk-coach.png",
  featured: true,
  display_order: 2,
  published_at: Time.current
)

CaseStudy.create!(
  name: "Signal Harvester",
  client_name: "Signal Harvester",
  client_type: :product,
  tagline: "Turn Instagram and TikTok comments into new customers",
  slug: "signal-harvester",
  problem: "High-intent leads hide in social comment sections, but manually scanning thousands of posts is slow and inconsistent.",
  approach: "Built a tool that monitors influencer and competitor comment threads, detects intent signals, and drafts replies or DMs so you can engage fast.",
  results: "Turns social listening into a repeatable pipeline for inbound leads by surfacing questions, complaints, and buying signals in real time.",
  metrics: [],
  link: "https://signalharvester.com",
  icon: "signal-harvester-logo.png",
  featured: true,
  display_order: 3,
  published_at: Time.current
)

CaseStudy.create!(
  name: "Floating Clock",
  client_name: "Floating Clock",
  client_type: :product,
  tagline: "Minimal floating timer for presentations and recordings",
  slug: "floating-clock",
  problem: "When recording videos or giving presentations, I needed a simple, clean timer that wouldn't clutter the screen.",
  approach: "Built a minimal web app with a floating timer. Customizable size, position, and color. No unnecessary features - just a clean timer that does one thing well.",
  results: "Use it myself for timed presentations. Simple, works reliably. Some content creators have found it useful too.",
  metrics: [],
  link: "https://floatingclock.zelusottomayor.com",
  icon: "floating-clock.png",
  featured: false,
  display_order: 4,
  published_at: Time.current
)

CaseStudy.create!(
  name: "Website Image Scraper",
  client_name: "Image Scraping Tool",
  client_type: :product,
  tagline: "Bulk download images from websites",
  slug: "image-scraper",
  problem: "Manually downloading images from a website one by one is tedious. Right-clicking and saving dozens of images wastes time.",
  approach: "Built a web scraping tool that extracts all images from a given URL and lets you download them in bulk. Handles different image formats and provides filtering options.",
  results: "Practical tool for when you need to grab multiple images quickly. Works on most standard websites. Useful for research and competitive analysis.",
  metrics: [],
  link: "https://imagescrapingtool.zelusottomayor.com",
  icon: "website-image-scraper.png",
  featured: false,
  display_order: 5,
  published_at: Time.current
)

# Automations
puts "Creating automations..."

CaseStudy.create!(
  name: "Content Factory",
  client_name: "Content Factory",
  client_type: :product,
  tagline: "Automated social content creation for Instagram and TikTok",
  slug: "content-factory",
  problem: "Creating consistent daily social content is time-consuming and draining. Manual posting leads to burnout, inconsistency, and missed opportunities. Content creators and brands need to maintain a strong presence but struggle with the relentless demand for fresh posts.",
  approach: "Built a fully automated content factory that generates and publishes 5 posts per day. The system uses AI-powered quote generation based on motivational psychology principles. Features include:

• Template-locked design system ensuring brand consistency
• 3 rotating color palettes with anti-repetition logic
• Automated Instagram publishing via Graph API
• TikTok video queue with one-tap manual posting
• Admin dashboard for queue management and analytics
• Job scheduling with Redis-backed queue processing",
  results: "The automation runs 24/7 without intervention. Posts are generated, designed, and published automatically on a configurable schedule. The admin panel provides full visibility into the content queue, publishing status, and performance stats. Zero manual design work required after initial setup.",
  metrics: ["5 posts/day", "3 color palettes", "Zero manual design"],
  link: nil,
  admin_panel_url: "https://social-factory.zelusottomayor.com",
  tech_stack: ["TypeScript", "Node.js", "OpenAI", "Instagram Graph API", "PostgreSQL", "Redis", "BullMQ", "Docker"],
  workflow_steps: [
    { "icon" => "brain", "title" => "AI Generation", "description" => "OpenAI generates psychology-based motivational quotes" },
    { "icon" => "palette", "title" => "Design System", "description" => "Template applies brand colors and rotating palettes" },
    { "icon" => "list", "title" => "Queue Management", "description" => "Posts scheduled across the day via Redis/BullMQ" },
    { "icon" => "send", "title" => "Auto-Publish", "description" => "Published to Instagram and queued for TikTok" }
  ],
  icon: nil,
  featured: true,
  display_order: 10,
  published_at: Time.current
)

CaseStudy.create!(
  name: "Full Outbound Automation",
  client_name: "Full Outbound Automation",
  client_type: :product,
  tagline: "Automated B2B lead sourcing and personalized cold email outreach",
  slug: "full-outbound-automation",
  problem: "Manual lead research and email personalization doesn't scale. Finding qualified prospects across multiple cities requires significant time investment. Writing personalized cold emails for each lead is tedious, and most outreach ends up generic and ineffective.",
  approach: "Built an end-to-end lead generation and outreach automation system that handles the entire pipeline:

• Lead sourcing via Google Maps Places API across 20+ target cities
• Automatic deduplication against existing CRM
• B2B enrichment with Apollo.io (contacts, company data, technologies)
• Lead scoring based on quality factors (website, email verification, company size, industry match)
• AI-powered email personalization using Claude
• Automated 4-email sequence delivery via Instantly.ai
• Google Sheets CRM for lead management and tracking",
  results: "The system finds and processes 10 qualified leads daily on autopilot. Each email is personalized based on company research and specific pain points. The 4-email sequence runs over 10 days with intelligent follow-ups. Monthly cost is approximately $105-184 depending on volume.",
  metrics: ["10 leads/day", "4-email sequence", "20+ target cities"],
  link: nil,
  admin_panel_url: "https://leads.zelusottomayor.com",
  tech_stack: ["Python", "Claude AI", "Google Maps API", "Apollo.io", "Instantly.ai", "Google Sheets", "Docker"],
  workflow_steps: [
    { "icon" => "search", "title" => "Lead Discovery", "description" => "Google Maps finds agencies across 20+ target cities" },
    { "icon" => "database", "title" => "Data Enrichment", "description" => "Apollo.io adds contacts, company data, and tech stack" },
    { "icon" => "sparkle", "title" => "AI Personalization", "description" => "Claude AI writes personalized emails for each lead" },
    { "icon" => "mail", "title" => "Email Delivery", "description" => "Instantly.ai sends automated 4-email sequence" }
  ],
  icon: nil,
  featured: true,
  display_order: 11,
  published_at: Time.current
)

# Testimonials removed - will add real client feedback when available

puts "Seeding complete!"
puts "Created #{CaseStudy.count} case studies"
