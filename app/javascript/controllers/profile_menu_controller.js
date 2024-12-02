import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="profile-menu"
export default class extends Controller {
  static targets = ["menu"];

  connect() {
    // Menu hidden initially
    this.menuTarget.classList.add("hidden");
  }

  toggleMenu(event) {
    event.stopPropagation(); // Prevent closing immediately when clicking on the div
    this.menuTarget.classList.toggle("hidden");
  }

  closeMenu(event) {
    // Close the menu if clicking outside of it
    if (!this.element.contains(event.target)) {
      this.menuTarget.classList.add("hidden");
    }
  }
}
