/**
 * Convienence class for formatting cents as dollars
 */
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

/** Wraps a DOM element and provides a few ways to interact with it
  *
  * For example:
  *
  *    const input = new WrappedElement("input[name='order[quantity]']")
  *    input.onChange( () => {
  *      alert(`Value is now ${input.value}`)
  *    })
  *
  */
class WrappedElement {
  /** 
   * Create the WrappedElement
   *
   * @param {string} selector - A CSS selector that will be passed to document.querySelector. If there
   *                            is no element matching the selector, an error will be thrown.
   */
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
  /** Return the element's value, if it has one */
  get value()           { return this.element.value }
  /** Return the element's selectedOptions, if it has any */
  get selectedOptions() { return this.element.selectedOptions }
  /** Set the element's innerText, if that's relevant */
  set innerText(value)  { this.element.innerText = value }
  /** Set up a listener that is called when the "change" event is fired, if
   * that event could be fired from the element. The listener is just
   * a function and will be given no arguments.
   * */
  onChange(listener)    { this.changeListeners.push(listener) }
}

const setupPriceCalculator = () => {

  const $product    = new WrappedElement("select[name='order[product_id]']")
  const $quantity   = new WrappedElement("input[name='order[quantity]']")
  const $total      = new WrappedElement("[data-total]")
  const $totalLabel = new WrappedElement("[data-total-label]")

  const updatePrice = () => {
    const quantity = $quantity.value
    const price = $product.selectedOptions[0].dataset.productPrice
    if (price) {
      $total.innerText = new FormattedCents(quantity * price)
      $totalLabel.innerText = "Total Price"
    }
    else {
      $total.innerText = ""
      $totalLabel.innerText = "";
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
