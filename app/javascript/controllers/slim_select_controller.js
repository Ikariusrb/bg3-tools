import { Controller } from "@hotwired/stimulus"
import SlimSelect from 'slim-select'
import 'slim-select/dist/slimselect.css'

// Connects to data-controller="tagify"
export default class extends Controller {
    static targets = ['field']
    connect() {
      new SlimSelect({
        select: this.fieldTarget,
        // closeOnSelect: false
      })
    }

//   async connect() {
//     var tagList = []
//     if (this.element.value) {
//       tagList = this.element.value.split(',').map(function(val) { return val.trim() })
//     } 
//     var tagify = new Tagify(this.element, {
//       enforceWhitelist: true,
//       dropdown: { enabled: 1 },
//       originalInputValueFormat: valuesArr => valuesArr.map(item => item.value).join(',')
//     })
//     tagify.removeAllTags()
//     tagify.loading(true).dropdown.hide()
//     fetch('/tags.json')
//       .then((response) => { return response.json() })
//       .then((data) => {
//         tagify.whitelist = data
//         tagify.addTags(tagList)
//         tagify.loading(false)
//       })
//   }

  disconnect() {
    this.element.destroy()
  }

}
