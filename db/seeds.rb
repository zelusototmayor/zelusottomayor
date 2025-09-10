# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Create sample projects
Project.find_or_create_by!(name: "E-commerce Website") do |project|
  project.description = "A full-stack e-commerce platform built with Rails and React. Features include user authentication, product catalog, shopping cart, and payment processing."
  project.link = "https://github.com/example/ecommerce-app"
end

Project.find_or_create_by!(name: "Task Management API") do |project|
  project.description = "RESTful API for task management with user authentication, CRUD operations, and real-time updates using WebSockets."
  project.link = "https://github.com/example/task-api"
end

Project.find_or_create_by!(name: "Weather Dashboard") do |project|
  project.description = "A responsive weather dashboard that displays current conditions and forecasts using external weather APIs. Built with modern CSS Grid and JavaScript."
  project.link = "https://github.com/example/weather-dashboard"
end

Project.find_or_create_by!(name: "Blog Platform") do |project|
  project.description = "A multi-user blog platform with markdown support, comment system, and admin panel. Includes SEO optimization and responsive design."
  project.link = "https://github.com/example/blog-platform"
end
