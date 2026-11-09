*** Variables ***
${INPUT_CUPON}                id=cart-coupon
${BTN_CUPON}                  id=cart-coupon-add
${BTN_GO_PAYMENT}             id=cart-to-orderform

# Step 2 Form

${INPUT_EMAIL}                id=client-email
${INPUT_NAME}                 id=input-firstName
${INPUT_LAST_NAME}            id=input-lastName
${SELECT_DOCUMENT}            id=input-documentType
${INPUT_DOCUMENT}             id=input-document
${INPUT_PHONE}                id=input-homePhone

${CHECK_SAVE_DATA}            id=opt-in-save-data
${CHECK_PRIVACY_TERMS}        id=privacy-terms

${BTN_GO_SHIPPING}            id=go-to-shipping
${BTN_SEND_EMAIL_CODE}        id=loginWithAccessKeyBtn
${BTN_CONFIRM_EMAIL_CODE}     id=sendAccessKeyBtn
${INPUT_EMAIL_CODE}          id=access-code
${BTN_CONFIRM_LOGIN}     id=confirmLoginAccessKeyBtn

# Step 2 shipping

${BTN_EDIT_SHIPPING}          id=edit-shipping-data
${BTN_SHIPPING_DELIVERY}      id=shipping-option-delivery
${BTN_SHIPPING_PICKUP}        id=shipping-option-pickup-in-point
${BTN_SELECT_PICKUP}          id=change-pickup-button
${FIND_PICKP_AVAIBLES}        id=find-pickups-manualy-button
${SHOW_ALL_PICKUP_POINTS}     id=pkpmodal-show-list-btn
${BTN_GO_TO_FILL_ADDRESS}     css=button[class*='vtex-omnishipping-1-x-btnDelivery']
${CHANGE_PICKUP_BUTTON}       id=change-pickup-button

# Selector regional de SV: los <select> no tienen id y los #ship-* quedan ocultos
${SELECT_REGIONAL}            xpath=//div[contains(@class,'ShippingFormJanisChange-container')]//select
${SELECT_DEPARMENT}           id=ship-state
${SELECT_CITY}                id=ship-city
${SELECT_NEIGHBORHOOD}        id=ship-neighborhood

${INPUT_STREET}               id=ship-street
${INPUT_COMPLEMENT}           id=ship-complement
${INPUT_RECEIVER_NAME}        id=ship-receiverName

${BTN_EDIT_ADRESS}            id=edit-address-button
${BTN_NEW_ADDRESS_OPTION}     id=new-address-button
${BTN_RETURN_TO_SHIPPING}     id=back-to-address-list

${BTN_GO_PAYMENT_SHIPPING}    xpath=(//button[@id="btn-go-to-payment"])[2]
${BTN_GO_TO_STEP3_PAYMENT}    xpath=(//button[@id='btn-go-to-payment'])[2]

# Step 3 Payment

${CARD_CREDIT_CART}                       id=payment-group-creditCardPaymentGroup
${paymentgroupSerfinsaPaymeLocator}       id=payment-group-SerfinsaPaymentGroup
${bankpaymentgroupSerfinsaPLocator}       id=payment-group-SerfinsaPaymentGroup-6e9cce93-b4bc-47b9-b9e0-17056181bbc2
${bancoCuscatlanLocator}                  id=payment-group-SerfinsaPaymentGroup-f1ad2a66-7143-4e42-8246-c2684ea5f058
${daviviendaLocator}                      id=payment-group-SerfinsaPaymentGroup-fa39d06a-55d7-4d86-8856-0053e625cd3e
${cuotasLocator}                          id=paymentCustomInstallment
${paymentgroupcustom207PaymLocator}       id=payment-group-custom207PaymentGroupPaymentGroup
${paymentgroupcustomPrivateLocator}       id=payment-group-customPrivate_406PaymentGroup
${paymentgroupcustomPrivate2Locator}      id=payment-group-customPrivate_404PaymentGroup
${paymentgrouppromissoryPayLocator}       id=payment-group-promissoryPaymentGroup
${paymentgroupcustom203PaymLocator}       id=payment-group-custom203PaymentGroupPaymentGroup
${paymentgroupcustomPrivate3Locator}      id=payment-group-customPrivate_401PaymentGroup

#crediisiman
${PAYMENT_CREDISIMAN}                     id=payment-group-customPrivate_402PaymentGroup
${INPUT_CREDISIMAN_CARD}                  xpath=/html/body/div/div/div/div/div[1]/div[1]/input
${INPUT_CREDISIMAN_NAME}                  xpath=/html/body/div/div/div/div/div[3]/p/input

${paymentgroupcustomPrivate5Locator}      id=payment-group-customPrivate_403PaymentGroup
${shortcutvisacuotasLocator}              id=shortcut-visa-cuotas
${PAYMENT_TRANS_BANK}                     id=payment-group-custom205PaymentGroupPaymentGroup  

${BTN_FINISH_PURCHASE}                    id=payment-data-submit
${BTN_CONFIRM_PURCHASE}                   xpath=(//button[@id='payment-data-submit'])[2]

# CSC-9359 - Locators para validación de errores en Shipping (JC-HU029)
${SHIPPING_ERROR_MSG}                     xpath=//*[contains(text(), 'Este campo es obligatorio.')]
${SHIPPING_INPUT_STREET_LABEL}            xpath=//label[@for='ship-street']
${SHIPPING_INPUT_RECEIVERNAME_LABEL}      xpath=//label[@for='ship-receiverName']