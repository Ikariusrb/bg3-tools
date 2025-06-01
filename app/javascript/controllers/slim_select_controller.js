import { Controller } from "@hotwired/stimulus"
import SlimSelect from 'slim-select'
// import 'slim-select/dist/slimselect.css'

// Connects to data-controller="slim-select"
export default class extends Controller {
    static targets = ['field']
    connect() {
      console.log("SlimSelect controller connected")
      new SlimSelect({
        select: this.element,
        // closeOnSelect: false
      })
    }

  disconnect() {
    this.element.destroy()
  }

}
