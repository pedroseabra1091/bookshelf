import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['alert', 'notice']

  connect() {
    this.removeAlert(this.noticeTarget, 5000)
  }

  onClick(event) {
    event.preventDefault()
    const target = event.currentTarget
    this.removeAlert(target, 200)
  }

  removeAlert(target, delay_ms) {
    setTimeout(() => target.remove(), delay_ms)
  }
}
