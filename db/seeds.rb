# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Create actual projects
Project.find_or_create_by!(name: "Floating Clock") do |project|
  project.description = "An elegant floating clock application with customizable display options and smooth animations. Features real-time updates and responsive design."
  project.link = "https://floatingclock.zelusottomayor.com"
end

Project.find_or_create_by!(name: "Image Scraping Tool") do |project|
  project.description = "A powerful web scraping tool for extracting and downloading images from websites. Built with modern web technologies and optimized for performance."
  project.link = "https://imagescrapingtool.zelusottomayor.com"
end
