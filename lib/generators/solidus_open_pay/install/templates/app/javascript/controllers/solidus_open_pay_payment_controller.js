// import { Controller } from "@hotwired/stimulus"
// // import { OpenPay } from "openpay"

// debugger

// export default class extends Controller {
//   static values = {
//     merchantId: String,
//     privateKey: String,
//     country: {
//       type: String,
//       default: 'mx'
//     },
//     sandbox: {
//       type: Boolean,
//       default: true
//     }

//     // // For now we don't have a controller to interact with
//     // // and we can't use outlets, so we fallback on acquiring selectors.
//     // submitSelector: String,
//     // radioSelector: String,
//   }

//   // static targets = ["paymentElement", "message", "paymentMethodInput"]

//   // get submitOutletElement() {
//   //   return document.querySelector(this.submitSelectorValue)
//   // }

//   // get radioOutletElement() {
//   //   return document.querySelector(this.radioSelectorValue)
//   // }

//   async connect() {
//     debugger
//     this.openPay = OpenPay
//     await this.openPay.setId(this.merchantIdValue);
//     await this.openPay.setApiKey(this.privateKeyValue);
//     await this.openPay.setSandboxMode(this.sandboxValue);
//     // var deviceSessionId = this.openPay.deviceData.setup("payment-form", "deviceIdHiddenFieldName");
//     // this.setupPaymentElement()
//   }

//   // @action
//   async handleSubmit(e) {
//     // Bail out if not on the payment method form.
//     if (e.target !== this.radioOutletElement.form) return

//     // Bail out if the current payment method is not selected.
//     if (!this.radioOutletElement.checked) return

//     e.preventDefault()

//     this.setLoading(true)

//     // Trigger form validation and wallet collection
//     const { error: submitError } = await this.elements.submit()

//     if (submitError) {
//       this.messageTarget.textContent = submitError.message
//       this.setLoading(false)
//       return
//     }

//     // Create the PaymentMethod using the details collected by the Payment Element
//     const { error, paymentMethod } = await this.stripe.createPaymentMethod({
//       elements: this.elements,
//       params: { billing_details: {} },
//     })

//     if (error) {
//       if (error.type === "card_error" || error.type === "validation_error") {
//         this.messageTarget.textContent = error.message
//       } else {
//         this.messageTarget.textContent = "An unexpected error occurred."
//       }
//       this.setLoading(false)
//       return
//     }

//     this.setLoading(false)
//     this.paymentMethodInputTarget.value = paymentMethod.id
//     this.paymentMethodInputTarget.form.submit()
//   }

//   setupPaymentElement() {
//     this.elements = this.stripe.elements(this.optionsValue.elementsInitialization)
//     this.paymentElement = this.elements.create("payment", this.optionsValue.paymentElementCreation)
//     this.paymentElementTarget.innerHTML = "" // Remove child nodes used for loading
//     this.paymentElement.mount(this.paymentElementTarget)
//   }

//   setLoading(isLoading) {
//     const element = this.submitOutletElement

//     if (isLoading) {
//       element.setAttribute("disabled", "")
//     } else {
//       element.removeAttribute("disabled")
//     }
//   }
// }
