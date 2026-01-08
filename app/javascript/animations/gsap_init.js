/**
 * GSAP and ScrollTrigger Initialization
 * Sets up GSAP with ScrollTrigger plugin for scroll-based animations
 */

import gsap from 'gsap';
import ScrollTrigger from 'gsap/ScrollTrigger';

// Register ScrollTrigger plugin
gsap.registerPlugin(ScrollTrigger);

// Set GSAP defaults
gsap.defaults({
  ease: 'power2.out',
  duration: 0.8
});

// ScrollTrigger defaults
ScrollTrigger.defaults({
  markers: false, // Set to true for debugging
  start: 'top 80%', // Animation starts when element is 80% from top of viewport
  toggleActions: 'play none none reverse' // play on enter, reverse on leave
});

// Refresh ScrollTrigger on Turbo navigation
document.addEventListener('turbo:load', () => {
  ScrollTrigger.refresh();
});

// Refresh ScrollTrigger on resize (debounced)
let resizeTimer;
window.addEventListener('resize', () => {
  clearTimeout(resizeTimer);
  resizeTimer = setTimeout(() => {
    ScrollTrigger.refresh();
  }, 250);
});

export { gsap, ScrollTrigger };
