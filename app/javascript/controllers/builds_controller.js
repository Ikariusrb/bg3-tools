import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="builds"
export default class extends Controller {
  static targets = ["select", "form"]

  connect() {
    console.log("Builds controller connected")
  }

  addSelectedItem(event) {
    event.preventDefault()
    // Get the value from the main form's item selector
    const selectElement = this.selectTarget
    
    if (!selectElement || !selectElement.value) {
      alert("Please select an item first")
      return
    }
    
    // Set the selected item ID in the hidden field
    document.getElementById("selected_item_id").value = selectElement.value
    
    // Submit the form and let Turbo handle the stream response
    this.formTarget.requestSubmit()
  }
}