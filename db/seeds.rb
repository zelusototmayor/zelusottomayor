# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Create actual projects
Project.find_or_create_by!(name: "Floating Clock") do |project|
  project.description = "An elegant floating clock application with customizable display options and smooth animations. Features real-time updates and responsive design."
  project.link = "https://floatingclock.zelusottomayor.com"
  project.icon = "floating-clock.png"
end

Project.find_or_create_by!(name: "Image Scraping Tool") do |project|
  project.description = "A powerful web scraping tool for extracting and downloading images from websites. Built with modern web technologies and optimized for performance."
  project.link = "https://imagescrapingtool.zelusottomayor.com"
  project.icon = "website-image-scraper.png"
end

Project.find_or_create_by!(name: "UXPilot") do |project|
  project.description = "An AI-powered UX analysis tool that analyzes screen recordings to detect user interaction friction points and provides actionable improvement suggestions. Perfect for startups and product teams who need quick UX insights."
  project.link = "https://uxauditapp.zelusottomayor.com"
  project.icon = "ux-audit-app.png"
end

Project.find_or_create_by!(name: "AI Talk Coach") do |project|
  project.description = "AI Talk Coach helps you practice 60–180 second responses, detect filler words, measure clarity & pace, and gives you targeted drills to improve—anytime, on the web."
  project.link = "https://aitalkcoach.com"
  project.icon = "ai-talk-coach.png"
end
