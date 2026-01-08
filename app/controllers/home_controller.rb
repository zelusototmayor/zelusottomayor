class HomeController < ApplicationController
  def index
    @projects = [
      {
        name: "AI Talk Coach",
        description: "AI Talk Coach helps you practice 60–180 second responses, detect filler words, measure clarity & pace, and gives you targeted drills to improve—anytime, on the web.",
        link: "https://aitalkcoach.com",
        icon: "ai-talk-coach.png"
      },
      {
        name: "UX Audit App",
        description: "An AI-powered UX analysis tool that analyzes screen recordings to detect user interaction friction points and provides actionable improvement suggestions. Perfect for startups and product teams who need quick UX insights.",
        link: "https://uxauditapp.com",
        icon: "ux-audit-app.png"
      },
      {
        name: "Image Scraping Tool",
        description: "A powerful web scraping tool for extracting and downloading images from websites. Built with modern web technologies and optimized for performance.",
        link: "https://imagescrapingtool.zelusottomayor.com",
        icon: "website-image-scraper.png"
      },
      {
        name: "Floating Clock",
        description: "An elegant floating clock application with customizable display options and smooth animations. Features real-time updates and responsive design.",
        link: "https://floatingclock.zelusottomayor.com",
        icon: "floating-clock.png"
      },
      {
        name: "Signal Harvester",
        description: "Find high-intent comments on Instagram and TikTok, draft replies or DMs, and turn social conversations into new customers.",
        link: "https://signalharvester.com",
        icon: "signal-harvester-logo.png"
      }
    ]
  end
end
