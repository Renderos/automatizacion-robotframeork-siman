*** Settings ***
Documentation       Verifica flujos principales en Checkout.

Resource    ../../resources/keywords/mailsac_keywords.resource
Resource    ../../resources/keywords/browser_keywords.resource
Resource    ../../resources/keywords/general_keywords.resource
Resource    ../../resources/keywords/checkout_keywords.resource
Suite Setup    Disable SSL Warnings

Test Teardown   Close Browser

*** Test Cases ***
Test Obtanin OTP Mailsac
    [Tags]    CSC-9000  otp_mailsac
    # Usa un correo nuevo y pide su propio OTP, para no depender de correos anteriores en la bandeja.
    # Se usa GT, una cuenta QA con formulario normal. Instore exige código de vendedor.
    ${email}=    Create Random Email
    Open Browser To Checkout    small    gt
    Click Element By Type    ${BTN_GO_PAYMENT}    button
    Wait Until Element Is Visible    ${INPUT_NAME}    30s
    Fill User Form    GT    new_user    ${email}
    Request OTP Email    new_user    ${email}
    ${otp}=    Obtener Codigo OTP Mailsac    ${email}
    Should Match Regexp    ${otp}    ^\\d{6}$
    Log To Console    El codigo OTP obtenido es: ${otp}