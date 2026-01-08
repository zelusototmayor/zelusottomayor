/**
 * SCROLL-TRIGGERED ANIMATIONS
 * Handles animations that trigger as elements come into view
 */

import { gsap, ScrollTrigger } from './gsap_init';

/**
 * Initialize all scroll-triggered animations
 */
export function initScrollAnimations() {
  // Check if user prefers reduced motion
  const prefersReducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
  const root = document.documentElement;

  if (prefersReducedMotion) {
    root.classList.remove('js-animations');
    return; // Skip animations if user prefers reduced motion
  }

  root.classList.add('js-animations');

  // Section fade-up animations
  const sections = document.querySelectorAll('.scroll-reveal, .section-padding');
  sections.forEach((section) => {
    gsap.fromTo(section,
      {
        opacity: 0,
        y: 50
      },
      {
        opacity: 1,
        y: 0,
        duration: 1,
        scrollTrigger: {
          trigger: section,
          start: 'top 85%',
          end: 'bottom 15%',
          toggleActions: 'play none none reverse'
        }
      }
    );
  });

  // Card stagger animations
  const cardContainers = document.querySelectorAll('.services-grid, .case-studies-grid, .packages-grid');
  cardContainers.forEach((container) => {
    const cards = container.querySelectorAll('.service-card, .case-study-card, .package-card');

    gsap.fromTo(cards,
      {
        opacity: 0,
        y: 40,
        scale: 0.95
      },
      {
        opacity: 1,
        y: 0,
        scale: 1,
        duration: 0.6,
        stagger: 0.1,
        ease: 'back.out(1.2)',
        scrollTrigger: {
          trigger: container,
          start: 'top 80%',
        }
      }
    );
  });

  // Text reveal animations (split by line)
  const textReveals = document.querySelectorAll('.text-reveal');
  textReveals.forEach((text) => {
    gsap.fromTo(text,
      {
        opacity: 0,
        y: 20
      },
      {
        opacity: 1,
        y: 0,
        duration: 0.8,
        scrollTrigger: {
          trigger: text,
          start: 'top 90%',
        }
      }
    );
  });

  // Process steps with line animation
  const processSteps = document.querySelectorAll('.process-step');
  processSteps.forEach((step, index) => {
    gsap.fromTo(step,
      {
        opacity: 0,
        x: -30
      },
      {
        opacity: 1,
        x: 0,
        duration: 0.8,
        delay: index * 0.15,
        scrollTrigger: {
          trigger: step,
          start: 'top 85%',
        }
      }
    );
  });

  // Testimonial cards fade in
  const testimonialCards = document.querySelectorAll('.testimonial-card');
  if (testimonialCards.length > 0) {
    gsap.fromTo(testimonialCards,
      {
        opacity: 0,
        scale: 0.9
      },
      {
        opacity: 1,
        scale: 1,
        duration: 0.7,
        stagger: 0.15,
        scrollTrigger: {
          trigger: testimonialCards[0].parentElement,
          start: 'top 80%',
        }
      }
    );
  }

  // Scale animations for images
  const images = document.querySelectorAll('.scroll-scale');
  images.forEach((img) => {
    gsap.fromTo(img,
      {
        opacity: 0,
        scale: 0.9
      },
      {
        opacity: 1,
        scale: 1,
        duration: 1,
        scrollTrigger: {
          trigger: img,
          start: 'top 85%',
        }
      }
    );
  });

  // Parallax effect for hero backgrounds
  const parallaxElements = document.querySelectorAll('.parallax-bg');
  parallaxElements.forEach((el) => {
    gsap.to(el, {
      y: () => el.offsetHeight * 0.3,
      ease: 'none',
      scrollTrigger: {
        trigger: el.parentElement,
        start: 'top top',
        end: 'bottom top',
        scrub: 1
      }
    });
  });
}

/**
 * Initialize number counter animations
 */
export function initCounterAnimations() {
  const counters = document.querySelectorAll('[data-counter]');

  counters.forEach((counter) => {
    const target = parseInt(counter.dataset.counter);
    const prefix = counter.dataset.prefix || '';
    const suffix = counter.dataset.suffix || '';

    ScrollTrigger.create({
      trigger: counter,
      start: 'top 85%',
      once: true,
      onEnter: () => {
        gsap.fromTo(counter,
          { textContent: 0 },
          {
            textContent: target,
            duration: 2,
            ease: 'power1.out',
            snap: { textContent: 1 },
            onUpdate: function() {
              counter.textContent = prefix + Math.ceil(counter.textContent) + suffix;
            }
          }
        );
      }
    });
  });
}

// Initialize on page load
document.addEventListener('turbo:load', () => {
  initScrollAnimations();
  initCounterAnimations();
});

// Export for manual initialization if needed
export default { initScrollAnimations, initCounterAnimations };
