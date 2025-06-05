import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="builds"
export default class extends Controller {
  static targets = ["select", "form"]

  connect() {
    console.log("Builds controller connected")
  }

  addSelectedItem(event) {
    event.preventDefault()

    const selectElement = this.selectTarget
    if (!selectElement || !selectElement.value) {
      alert("Please select an item first")
      return
    }

    const formElement = this.formTarget
    const targetId = formElement.id + "_select_target"
    const targetElement = Array.from(this.formTarget.getElementsByTagName("input")).find((element) => element.id == targetId)
    
    // Set the selected value in the hidden field
    targetElement.value = selectElement.value
    
    // Submit the form and let Turbo handle the stream response
    formElement.requestSubmit()
  }
}