/**
 * CARD ANIMATIONS
 * 3D tilt effects and hover interactions for cards
 */

import { gsap } from './gsap_init';

/**
 * Add 3D tilt effect to cards based on mouse position
 */
export function init3DTiltCards(selector = '.case-study-card, .service-card, .package-card') {
  const cards = document.querySelectorAll(selector);

  // Check if user prefers reduced motion
  const prefersReducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

  if (prefersReducedMotion) {
    return; // Skip tilt effects if user prefers reduced motion
  }

  cards.forEach((card) => {
    // Set perspective on card
    card.style.transformStyle = 'preserve-3d';
    card.style.transition = 'transform 0.1s ease-out';

    card.addEventListener('mousemove', (e) => {
      const rect = card.getBoundingClientRect();
      const x = e.clientX - rect.left;
      const y = e.clientY - rect.top;

      const centerX = rect.width / 2;
      const centerY = rect.height / 2;

      const rotateX = (y - centerY) / 10; // Reduced from typical values for subtle effect
      const rotateY = (centerX - x) / 10;

      gsap.to(card, {
        rotationX: rotateX,
        rotationY: rotateY,
        duration: 0.3,
        ease: 'power2.out',
        transformPerspective: 1000
      });
    });

    card.addEventListener('mouseleave', () => {
      gsap.to(card, {
        rotationX: 0,
        rotationY: 0,
        duration: 0.5,
        ease: 'power2.out'
      });
    });
  });
}

/**
 * Add image zoom effect on card hover
 */
export function initCardImageZoom(selector = '.case-study-card img, .case-study-card .case-study-icon-wrapper') {
  const images = document.querySelectorAll(selector);

  images.forEach((img) => {
    const card = img.closest('.case-study-card, .service-card');

    if (!card) return;

    card.addEventListener('mouseenter', () => {
      gsap.to(img, {
        scale: 1.1,
        duration: 0.4,
        ease: 'power2.out'
      });
    });

    card.addEventListener('mouseleave', () => {
      gsap.to(img, {
        scale: 1,
        duration: 0.4,
        ease: 'power2.out'
      });
    });
  });
}

/**
 * Add magnetic effect to buttons (button follows cursor)
 */
export function initMagneticButtons(selector = '.cta-button, .tab-button') {
  const buttons = document.querySelectorAll(selector);

  // Check if user prefers reduced motion or is on touch device
  const prefersReducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
  const isTouchDevice = 'ontouchstart' in window;

  if (prefersReducedMotion || isTouchDevice) {
    return; // Skip magnetic effect
  }

  buttons.forEach((button) => {
    button.addEventListener('mousemove', (e) => {
      const rect = button.getBoundingClientRect();
      const x = e.clientX - rect.left - rect.width / 2;
      const y = e.clientY - rect.top - rect.height / 2;

      // Calculate distance from center
      const distance = Math.sqrt(x * x + y * y);
      const magneticRadius = 50;

      if (distance < magneticRadius) {
        const strength = (magneticRadius - distance) / magneticRadius;
        gsap.to(button, {
          x: x * strength * 0.3,
          y: y * strength * 0.3,
          duration: 0.3,
          ease: 'power2.out'
        });
      }
    });

    button.addEventListener('mouseleave', () => {
      gsap.to(button, {
        x: 0,
        y: 0,
        duration: 0.5,
        ease: 'elastic.out(1, 0.5)'
      });
    });
  });
}

/**
 * Add ripple effect on button click
 */
export function initRippleEffect(selector = '.cta-button') {
  const buttons = document.querySelectorAll(selector);

  buttons.forEach((button) => {
    button.addEventListener('click', function(e) {
      // Create ripple element
      const ripple = document.createElement('span');
      ripple.style.position = 'absolute';
      ripple.style.borderRadius = '50%';
      ripple.style.background = 'rgba(255, 255, 255, 0.6)';
      ripple.style.pointerEvents = 'none';

      const rect = button.getBoundingClientRect();
      const size = Math.max(rect.width, rect.height);
      const x = e.clientX - rect.left - size / 2;
      const y = e.clientY - rect.top - size / 2;

      ripple.style.width = ripple.style.height = size + 'px';
      ripple.style.left = x + 'px';
      ripple.style.top = y + 'px';

      button.style.position = 'relative';
      button.style.overflow = 'hidden';
      button.appendChild(ripple);

      gsap.fromTo(ripple,
        {
          scale: 0,
          opacity: 1
        },
        {
          scale: 2.5,
          opacity: 0,
          duration: 0.6,
          ease: 'power2.out',
          onComplete: () => ripple.remove()
        }
      );
    });
  });
}

/**
 * Add floating badge effect on card hover
 */
export function initFloatingBadges() {
  const cards = document.querySelectorAll('.case-study-card, .service-card');

  cards.forEach((card) => {
    const badge = card.querySelector('.type-badge, .badge');

    if (!badge) return;

    card.addEventListener('mouseenter', () => {
      gsap.to(badge, {
        y: -5,
        duration: 0.3,
        ease: 'power2.out'
      });
    });

    card.addEventListener('mouseleave', () => {
      gsap.to(badge, {
        y: 0,
        duration: 0.3,
        ease: 'power2.out'
      });
    });
  });
}

/**
 * Initialize all card animations
 */
export function initCardAnimations() {
  init3DTiltCards();
  initCardImageZoom();
  initMagneticButtons();
  initRippleEffect();
  initFloatingBadges();
}

// Initialize on page load
document.addEventListener('turbo:load', () => {
  initCardAnimations();
});

// Export for manual initialization if needed
export default {
  initCardAnimations,
  init3DTiltCards,
  initCardImageZoom,
  initMagneticButtons,
  initRippleEffect,
  initFloatingBadges
};
