/**
 * THREE.JS PARTICLE BACKGROUND
 * Interactive particle system for homepage hero
 */

import * as THREE from 'three';

export class ParticleBackground {
  constructor(container) {
    this.container = container;
    this.scene = null;
    this.camera = null;
    this.renderer = null;
    this.particles = null;
    this.mouse = new THREE.Vector2();
    this.targetMouse = new THREE.Vector2();

    // Check if user prefers reduced motion
    this.prefersReducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

    if (!this.prefersReducedMotion) {
      this.init();
    }
  }

  init() {
    // Create scene
    this.scene = new THREE.Scene();

    // Create camera
    this.camera = new THREE.PerspectiveCamera(
      75,
      this.container.clientWidth / this.container.clientHeight,
      0.1,
      1000
    );
    this.camera.position.z = 5;

    // Create renderer
    this.renderer = new THREE.WebGLRenderer({
      alpha: true,
      antialias: true
    });
    this.renderer.setSize(this.container.clientWidth, this.container.clientHeight);
    this.renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));
    this.container.appendChild(this.renderer.domElement);

    // Create particles
    this.createParticles();

    // Add event listeners
    this.container.addEventListener('mousemove', this.onMouseMove.bind(this));
    window.addEventListener('resize', this.onResize.bind(this));

    // Start animation
    this.animate();
  }

  createParticles() {
    const particleCount = window.innerWidth < 768 ? 120 : 220;
    const geometry = new THREE.BufferGeometry();
    const positions = new Float32Array(particleCount * 3);
    const colors = new Float32Array(particleCount * 3);

    // Muted palette aligned to site tones
    const colorPalette = [
      new THREE.Color(0x1b2538), // Deep ink
      new THREE.Color(0x2f6f5e), // Forest
      new THREE.Color(0xc8a15a), // Gold
    ];

    for (let i = 0; i < particleCount; i++) {
      // Positions
      positions[i * 3] = (Math.random() - 0.5) * 10;
      positions[i * 3 + 1] = (Math.random() - 0.5) * 10;
      positions[i * 3 + 2] = (Math.random() - 0.5) * 5;

      // Colors
      const color = colorPalette[Math.floor(Math.random() * colorPalette.length)];
      colors[i * 3] = color.r;
      colors[i * 3 + 1] = color.g;
      colors[i * 3 + 2] = color.b;
    }

    geometry.setAttribute('position', new THREE.BufferAttribute(positions, 3));
    geometry.setAttribute('color', new THREE.BufferAttribute(colors, 3));

    // Material
    const material = new THREE.PointsMaterial({
      size: 0.065,
      vertexColors: true,
      transparent: true,
      opacity: 0.75,
      blending: THREE.AdditiveBlending,
      sizeAttenuation: true
    });

    this.particles = new THREE.Points(geometry, material);
    this.scene.add(this.particles);
  }

  onMouseMove(event) {
    const rect = this.container.getBoundingClientRect();
    this.targetMouse.x = ((event.clientX - rect.left) / rect.width) * 2 - 1;
    this.targetMouse.y = -((event.clientY - rect.top) / rect.height) * 2 + 1;
  }

  onResize() {
    this.camera.aspect = this.container.clientWidth / this.container.clientHeight;
    this.camera.updateProjectionMatrix();
    this.renderer.setSize(this.container.clientWidth, this.container.clientHeight);
  }

  animate() {
    requestAnimationFrame(this.animate.bind(this));

    // Smooth mouse following
    this.mouse.x += (this.targetMouse.x - this.mouse.x) * 0.05;
    this.mouse.y += (this.targetMouse.y - this.mouse.y) * 0.05;

    // Rotate particles
    if (this.particles) {
      this.particles.rotation.y += 0.0006;
      this.particles.rotation.x = this.mouse.y * 0.06;
      this.particles.rotation.y += this.mouse.x * 0.006;

      // Animate individual particles
      const positions = this.particles.geometry.attributes.position.array;
      const time = Date.now() * 0.00008;

      for (let i = 0; i < positions.length; i += 3) {
        positions[i + 1] += Math.sin(time + positions[i]) * 0.0006;
      }

      this.particles.geometry.attributes.position.needsUpdate = true;
    }

    this.renderer.render(this.scene, this.camera);
  }

  destroy() {
    if (this.renderer) {
      this.container.removeChild(this.renderer.domElement);
      this.renderer.dispose();
    }
    if (this.particles) {
      this.particles.geometry.dispose();
      this.particles.material.dispose();
    }
  }
}

// Initialize particle background on homepage
export function initParticleBackground() {
  const heroSection = document.querySelector('.hero-above-fold');

  if (heroSection && !window.matchMedia('(prefers-reduced-motion: reduce)').matches) {
    // Create container for Three.js canvas
    const particleContainer = document.createElement('div');
    particleContainer.className = 'particle-container';
    particleContainer.style.position = 'absolute';
    particleContainer.style.top = '0';
    particleContainer.style.left = '0';
    particleContainer.style.width = '100%';
    particleContainer.style.height = '100%';
    particleContainer.style.pointerEvents = 'none';
    particleContainer.style.zIndex = '1';

    heroSection.insertBefore(particleContainer, heroSection.firstChild);

    // Debug indicator to confirm canvas is mounting
    const debugBadge = document.createElement('div');
    debugBadge.className = 'particle-debug';
    debugBadge.textContent = 'Particles ON';
    particleContainer.appendChild(debugBadge);

    // Initialize particles
    const particles = new ParticleBackground(particleContainer);

    // Cleanup on page unload
    document.addEventListener('turbo:before-cache', () => {
      particles.destroy();
    });
  }
}

// Auto-initialize on Turbo load
document.addEventListener('turbo:load', () => {
  initParticleBackground();
});

export default { ParticleBackground, initParticleBackground };
