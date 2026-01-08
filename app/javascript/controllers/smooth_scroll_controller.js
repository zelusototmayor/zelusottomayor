import { Controller } from "@hotwired/stimulus"

// Smooth scroll controller using Lenis
export default class extends Controller {
  connect() {
    this.initSmoothScroll()
  }

  disconnect() {
    if (this.lenis) {
      this.lenis.destroy()
    }
  }

  async initSmoothScroll() {
    // Check if user prefers reduced motion
    const prefersReducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches

    if (prefersReducedMotion) {
      return // Skip smooth scroll if user prefers reduced motion
    }

    try {
      // Import Lenis dynamically
      const Lenis = (await import('lenis')).default

      // Initialize Lenis
      this.lenis = new Lenis({
        duration: 1.2,
        easing: (t) => Math.min(1, 1.001 - Math.pow(2, -10 * t)), // easeOutExpo
        direction: 'vertical',
        gestureDirection: 'vertical',
        smooth: true,
        mouseMultiplier: 1,
        smoothTouch: false,
        touchMultiplier: 2,
        infinite: false,
      })

      // Animation frame loop
      const raf = (time) => {
        this.lenis.raf(time)
        requestAnimationFrame(raf)
      }

      requestAnimationFrame(raf)

      // Sync with GSAP ScrollTrigger if available
      if (window.ScrollTrigger) {
        this.lenis.on('scroll', window.ScrollTrigger.update)
      }

    } catch (error) {
      console.warn('Lenis smooth scroll not available:', error)
    }
  }
}
