/**
 * HERO SECTION ANIMATIONS
 * Page-load animations for hero sections
 */

import { gsap } from './gsap_init';

/**
 * Animate hero headline with word-by-word reveal
 */
export function animateHeroHeadline(selector = '.hero-headline') {
  const headlines = document.querySelectorAll(selector);

  headlines.forEach((headline) => {
    // Split text into words
    const text = headline.textContent;
    const words = text.split(' ');

    // Clear the headline and wrap each word
    headline.innerHTML = '';
    words.forEach((word, index) => {
      const wordSpan = document.createElement('span');
      wordSpan.style.display = 'inline-block';
      wordSpan.style.overflow = 'hidden';
      wordSpan.style.verticalAlign = 'top';
      wordSpan.style.marginRight = '0.3em';

      const innerSpan = document.createElement('span');
      innerSpan.textContent = word;
      innerSpan.style.display = 'inline-block';

      wordSpan.appendChild(innerSpan);
      headline.appendChild(wordSpan);
    });

    // Animate each word
    const wordElements = headline.querySelectorAll('span span');
    gsap.fromTo(wordElements,
      {
        yPercent: 100,
        opacity: 0
      },
      {
        yPercent: 0,
        opacity: 1,
        duration: 0.8,
        ease: 'power3.out',
        stagger: 0.05,
        delay: 0.2
      }
    );
  });
}

/**
 * Animate hero CTA buttons
 */
export function animateHeroCTAs(selector = '.cta-group .cta-button, .hero-above-fold .cta-button') {
  const buttons = document.querySelectorAll(selector);

  gsap.fromTo(buttons,
    {
      opacity: 0,
      scale: 0.8,
      y: 20
    },
    {
      opacity: 1,
      scale: 1,
      y: 0,
      duration: 0.6,
      ease: 'back.out(1.5)',
      stagger: 0.1,
      delay: 0.8
    }
  );
}

/**
 * Animate hero subtitle/tagline
 */
export function animateHeroSubtitle(selector = '.hero-subtitle, .hero-above-fold p') {
  const subtitles = document.querySelectorAll(selector);

  gsap.fromTo(subtitles,
    {
      opacity: 0,
      y: 20
    },
    {
      opacity: 1,
      y: 0,
      duration: 0.8,
      delay: 0.5
    }
  );
}

/**
 * Animate navigation on page load
 */
export function animateNavigation() {
  const nav = document.querySelector('.main-navigation');

  if (nav) {
    gsap.fromTo(nav,
      {
        y: -20,
        opacity: 0
      },
      {
        y: 0,
        opacity: 1,
        duration: 0.6,
        ease: 'power2.out'
      }
    );
  }
}

/**
 * Initialize all hero animations
 */
export function initHeroAnimations() {
  // Check if user prefers reduced motion
  const prefersReducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

  if (prefersReducedMotion) {
    return; // Skip animations if user prefers reduced motion
  }

  animateNavigation();
  animateHeroHeadline();
  animateHeroSubtitle();
  animateHeroCTAs();
}

// Initialize on page load
document.addEventListener('turbo:load', () => {
  // Small delay to ensure DOM is ready
  requestAnimationFrame(() => {
    initHeroAnimations();
  });
});

// Export for manual initialization if needed
export default { initHeroAnimations, animateHeroHeadline, animateHeroCTAs, animateHeroSubtitle, animateNavigation };
