import { Controller } from "@hotwired/stimulus"

export default class DismissController extends Controller {
  static targets = ['alert', 'notice']

  connect() {
    this.hasAlertTarget && this.dismiss(this.alertTarget, 5000)
    this.hasNoticeTarget && this.dismiss(this.noticeTarget, 5000)
  }

  onClick(event) {
    event.preventDefault()
    const target = event.currentTarget
    this.dismiss(target, 0)
  }

  dismiss(target, delay_ms) {
    setTimeout(() => {
      target.classList.add('transition', 'ease-linear', 'delay-75', 'opacity-0', 'translate-x-full', 'duration-300')
    }, delay_ms)
  }
}
