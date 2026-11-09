*** Settings ***
Documentation       Suite para demostración en vivo del checkout de siman.com (sandbox).
...
...                 Recorre 10 casos ordenados de más rápido a más largo:
...                 carga de carritos online e instore, guarda de configuración, validación de Envío,
...                 invitado y usuario nuevo con OTP (small y big ticket), compra completa,
...                 la API de Mailsac y el checkout de GT, CR y NI.
...
...                 Ejecutar SOLO en sandbox: en producción las compras terminan en SKIP.
...
...                 robot -d results/demo tests/demo/demo_en_vivo.robot
...                 robot -d results/demo --variable DEMO_SPEED:0.3s tests/demo/demo_en_vivo.robot
...                 robot -d results/demo --include rapido tests/demo/demo_en_vivo.robot

Resource            ../../resources/keywords/browser_keywords.resource
Resource            ../../resources/keywords/general_keywords.resource
Resource            ../../resources/keywords/checkout_keywords.resource
Resource            ../../resources/keywords/mailsac_keywords.resource
Resource            ../../resources/locators/checkout_locators.resource
Resource            ../../resources/variables/testdata.resource

Suite Setup         Preparar Demo
Test Teardown       Cerrar Navegador Con Evidencia


*** Variables ***
# Pausa entre acciones de Selenium para que el público pueda seguir el flujo (ej. 0.3s)
${DEMO_SPEED}       1 seconds


*** Test Cases ***
DEMO-01 El carrito de SV carga con productos
    [Documentation]    Smoke test: el carrito se arma desde la URL y muestra el botón para continuar.
    [Tags]    demo    rapido    smoke
    Open Browser To Checkout    small    sv
    Element Should Be Visible    ${BTN_GO_PAYMENT}
    Location Should Contain    /checkout

DEMO-02 Una combinacion sin URL falla con un mensaje claro
    [Documentation]    Guarda de configuración: un canal inexistente falla antes de abrir el navegador,
    ...    en vez de abrir otro carrito por defecto.
    [Tags]    demo    rapido    negativo
    Run Keyword And Expect Error    No hay URL de checkout*
    ...    Open Browser To Checkout    small    sv    channel=marketplace

DEMO-03 Envio bloquea el avance con campos vacios
    [Documentation]    CA-1 de JC-HU029: sin dirección no se puede pasar al paso de Pago.
    [Tags]    demo    CSC-9359    negativo
    Abrir Checkout Como Invitado    sv
    Intentar Continuar Al Pago Sin Direccion
    Element Should Be Visible    ${INPUT_STREET}
    ...    msg=El checkout avanzó al pago con campos obligatorios vacíos
    ${url}=    Get Location
    Should Not Contain    ${url}    /payment

DEMO-04 El carrito Instore de SV carga con productos
    [Documentation]    Canal tienda física: el carrito se arma en el workspace instore.
    ...    Continuar queda bloqueado hasta ingresar código de vendedor, por eso solo se valida la carga.
    [Tags]    demo    rapido    smoke    instore
    Open Browser To Checkout    small    sv    channel=instore
    Element Should Be Visible    ${BTN_GO_PAYMENT}
    Location Should Contain    simanqainstoresv

DEMO-05 Invitado SV llega al paso de Pago
    [Documentation]    Identificación + dirección completa como invitado. Se detiene en Pago, sin comprar.
    [Tags]    demo    guest_user    CSC-8202
    Abrir Checkout Como Invitado    sv
    Create New Adress In Checkout    guest_user    San Salvador    San Salvador Centro    San Salvador
    Location Should Contain    /payment
    Wait Until Element Is Visible    ${BTN_CONFIRM_PURCHASE}    30s

DEMO-06 Invitado SV completa la compra con transferencia bancaria
    [Documentation]    Flujo completo de punta a punta como invitado en la cuenta QA simanqa.
    [Tags]    demo    guest_user    compra    CSC-8202
    Abrir Checkout Como Invitado    sv
    Create New Adress In Checkout    guest_user    San Salvador    San Salvador Centro    San Salvador
    Select Payment Method    transferencia_bancaria
    Finish Purchase    no_verify

DEMO-07 Usuario nuevo SV compra con login por OTP
    [Documentation]    Correo aleatorio de Mailsac, el OTP se lee por API y se escribe en el checkout.
    [Tags]    demo    new_user    otp    compra    CSC-8202
    Open Browser To Checkout    small    sv
    Login Checkout    SV    new_user
    Create New Adress In Checkout    new_user    San Salvador    San Salvador Centro    San Salvador
    Select Payment Method    transferencia_bancaria
    Finish Purchase    no_verify

DEMO-08 Invitado SV con carrito big ticket llega a Pago
    [Documentation]    Mismo flujo de invitado con un producto de alto valor (big ticket). Se detiene en Pago.
    [Tags]    demo    guest_user    big_ticket
    Open Browser To Checkout    big    sv
    Login Checkout    SV    guest_user
    Create New Adress In Checkout    guest_user    San Salvador    San Salvador Centro    San Salvador
    Location Should Contain    /payment
    Wait Until Element Is Visible    ${BTN_CONFIRM_PURCHASE}    30s

DEMO-09 La API de Mailsac entrega un OTP de 6 digitos
    [Documentation]    Pide un OTP desde el checkout de GT y lo valida consultando la API REST de Mailsac.
    [Tags]    demo    api    otp    CSC-9000
    ${email}=    Create Random Email
    Open Browser To Checkout    small    gt
    Click Element By Type    ${BTN_GO_PAYMENT}    button
    Wait Until Element Is Visible    ${INPUT_NAME}    30s
    Fill User Form    GT    new_user    ${email}
    Request OTP Email    new_user    ${email}
    ${otp}=    Obtener Codigo OTP Mailsac    ${email}
    Should Match Regexp    ${otp}    ^\\d{6}$
    Log To Console    \nOTP recibido en ${email}: ${otp}

DEMO-10 Invitado llega al paso de Envio en GT, CR y NI
    [Documentation]    Mismo flujo en tres países: documento propio de cada país y formulario de Envío.
    [Tags]    demo    multipais    guest_user
    [Template]    Invitado Llega A Envio En
    gt
    cr
    ni


*** Keywords ***
Preparar Demo
    Disable SSL Warnings
    Set Selenium Speed    ${DEMO_SPEED}
    Log To Console    \nEntorno: ${ENVIRONMENT} | Navegador: ${BROWSER} | Velocidad: ${DEMO_SPEED}

Cerrar Navegador Con Evidencia
    Run Keyword If Test Failed    Run Keyword And Ignore Error    Capture Page Screenshot
    Close All Browsers

Abrir Checkout Como Invitado
    [Arguments]    ${country}
    Open Browser To Checkout    small    ${country}
    Login Checkout    ${country}    guest_user
    Wait For Shipping Address Fields

Intentar Continuar Al Pago Sin Direccion
    [Documentation]    Elige entrega a domicilio si está disponible y pulsa "Continuar al pago".
    ${hay_opcion}=    Run Keyword And Return Status
    ...    Wait Until Element Is Visible    ${BTN_SHIPPING_DELIVERY}    5s
    IF    ${hay_opcion}    Click Element By Type    ${BTN_SHIPPING_DELIVERY}    button
    Wait Until Element Is Visible    ${BTN_GO_TO_STEP3_PAYMENT}    15s
    Scroll Element Into View    ${BTN_GO_TO_STEP3_PAYMENT}
    Click Element    ${BTN_GO_TO_STEP3_PAYMENT}

Invitado Llega A Envio En
    [Documentation]    Cada iteración abre y cierra su propio navegador.
    [Arguments]    ${country}
    TRY
        Abrir Checkout Como Invitado    ${country}
        Log To Console    \n${country.upper()}: formulario de Envío visible
    EXCEPT    AS    ${error}
        Run Keyword And Ignore Error    Capture Page Screenshot
        Fail    ${country.upper()}: ${error}
    FINALLY
        Close All Browsers
    END
