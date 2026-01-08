# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin_all_from "app/javascript/animations", under: "animations"
pin_all_from "app/javascript/three", under: "three"

# Animation libraries
pin "gsap", to: "https://cdn.skypack.dev/gsap@3.12.5"
pin "gsap/ScrollTrigger", to: "https://cdn.skypack.dev/gsap@3.12.5/ScrollTrigger"
pin "gsap/ScrollSmoother", to: "https://cdn.skypack.dev/gsap@3.12.5/ScrollSmoother"
pin "three", to: "https://cdn.skypack.dev/three@0.160.0"
pin "lenis", to: "https://cdn.skypack.dev/@studio-freight/lenis@1.0.42"
