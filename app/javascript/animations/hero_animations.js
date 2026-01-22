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
 * Hero background mouse parallax
 * Subtle movement based on cursor position (max 10px)
 */
export function initHeroParallax() {
  const hero = document.querySelector('[data-hero-parallax]');
  if (!hero) return;

  const bgImage = hero.querySelector('.hero-bg-image');
  if (!bgImage) return;

  // Parallax intensity (px)
  const maxMove = 10;

  // Throttle for performance
  let ticking = false;

  function handleMouseMove(e) {
    if (ticking) return;

    ticking = true;
    requestAnimationFrame(() => {
      const rect = hero.getBoundingClientRect();
      const centerX = rect.width / 2;
      const centerY = rect.height / 2;

      // Calculate offset from center (normalized -1 to 1)
      const offsetX = (e.clientX - rect.left - centerX) / centerX;
      const offsetY = (e.clientY - rect.top - centerY) / centerY;

      // Apply parallax (inverse direction for natural feel)
      const moveX = -offsetX * maxMove;
      const moveY = -offsetY * maxMove;

      bgImage.style.transform = `translate(${moveX}px, ${moveY}px)`;
      ticking = false;
    });
  }

  function handleMouseLeave() {
    // Reset position smoothly
    bgImage.style.transform = 'translate(0, 0)';
  }

  // Only enable on non-touch devices
  if (!('ontouchstart' in window)) {
    hero.addEventListener('mousemove', handleMouseMove, { passive: true });
    hero.addEventListener('mouseleave', handleMouseLeave);
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
  initHeroParallax();
}

// Initialize on page load
document.addEventListener('turbo:load', () => {
  // Small delay to ensure DOM is ready
  requestAnimationFrame(() => {
    initHeroAnimations();
  });
});

// Export for manual initialization if needed
export default { initHeroAnimations, animateHeroHeadline, animateHeroCTAs, animateHeroSubtitle, animateNavigation, initHeroParallax };
