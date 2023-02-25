class FormattedCents {
  constructor(cents) {
    this.cents = cents
    this.formatter = Intl.NumberFormat('en-US', {
      style: 'currency',
      currency: 'USD'}
    )
  }
  toString() {
    return this.formatter.format(this.cents / 100)
  }
}

class WrappedElement {
  constructor(selector) {
    this.element = document.querySelector(selector)
    if (!this.element) {
      throw `Could not locate element with selector ${selector}`
    }
    this.changeListeners = []
    this.element.addEventListener("change", () => {
      this.changeListeners.forEach( (f) => f() )
    })
  }
  get value()           { return this.element.value }
  get selectedOptions() { return this.element.selectedOptions }
  set innerText(value)  { this.element.innerText = value }
  onChange(listener)    { this.changeListeners.push(listener) }
}

const setupPriceCalculator = () => {

  const $product  = new WrappedElement("select[name='order[product_id]']")
  const $quantity = new WrappedElement("input[name='order[quantity]']")
  const $total    = new WrappedElement("[data-total]")

  const updatePrice = () => {
    const quantity = $quantity.value
    const price = $product.selectedOptions[0].dataset.productPrice
    if (price) {
      $total.innerText = new FormattedCents(quantity * price)
    }
    else {
      $total.innerText = ""
    }
  }

  $product.onChange(updatePrice)
  $quantity.onChange(updatePrice)
  updatePrice()
}

document.addEventListener("DOMContentLoaded", () => {

  const controller = document.body.dataset.controller
  const action     = document.body.dataset.action

  if ( (controller == "orders") && ( (action == "new") || (action == "create") ) ) {
    setupPriceCalculator()
  }
})
