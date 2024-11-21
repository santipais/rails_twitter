import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="profile-menu"
export default class extends Controller {
  static targets = ["menu"]; // Define targets (dropdown menu)

  connect() {
    // Menu should be hidden initially
    this.menuTarget.classList.add("hidden");
  }

  toggleMenu(event) {
    event.stopPropagation(); // Prevent closing immediately when clicking on the div
    this.menuTarget.classList.toggle("hidden"); // Toggle visibility
  }

  closeMenu(event) {
    // Close the menu if clicking outside of it
    if (!this.element.contains(event.target)) {
      this.menuTarget.classList.add("hidden");
    }
  }
}
