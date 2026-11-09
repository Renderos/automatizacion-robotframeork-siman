*** Settings ***
Library     String
Library     Collections
Library     SeleniumLibrary
Resource    ../../resources/keywords/general_keywords.resource
Resource    ../../resources/locators/checkout_locators.resource
Resource    ../../resources/variables/testdata.resource


*** Variables ***
# Cuentas donde una compra sería real: siman.myvtex.com (con o sin workspace) y cualquier *.siman.com
${PRODUCTION_URL_REGEX}    ^https?://(([\\w-]+--)?siman\\.myvtex\\.com|([\\w-]+\\.)?siman\\.com)(/|:|$)
${ALLOW_REAL_ORDERS}       ${False}


*** Keywords ***
Login Checkout
    [Documentation]    Metodo general para logearse en checkout ya sea como usuario recurrente o no
    [Arguments]    ${country}    ${user_type}

    ${country}=    Convert To Upper Case    ${country}

    Click Element By Type   ${BTN_GO_PAYMENT}    button

    # Espera específica para el campo de email
    Wait Until Element Is Visible    ${INPUT_NAME}    30s
    Wait Until Element Is Enabled    ${INPUT_NAME}    30s

    IF    '${user_type}' == 'guest_user'
        ${random_email}=    Create Random Email
        Fill User Form    ${country}    ${user_type}    ${random_email}
    ELSE IF    '${user_type}' == 'new_user'
        ${random_email}=    Create Random Email
        Fill User Form    ${country}    ${user_type}    ${random_email}
        Send OTP Email    ${user_type}    ${random_email}
    ELSE IF    '${user_type}' == 'recurrent_user'
        Fill Element By Text    ${INPUT_EMAIL}    ${EMAIL_RECURRENT}
        Click Element By Type    ${INPUT_NAME}    other
        Send OTP Email    ${user_type}    ${EMAIL_RECURRENT}
    ELSE
        Fail    Tipo de usuario no soportado: '${user_type}'. Usa guest_user, new_user o recurrent_user.
    END

Fill User Form
    [Documentation]    Llena el formulario de identificación con el tipo y número de documento del país
    [Arguments]    ${country}    ${user_type}    ${mail}
    ${country}=    Convert To Upper Case    ${country}
    IF    $country not in $DOCUMENT_TYPE_BY_COUNTRY
        Fail    País no soportado en Fill User Form: '${country}'. Usa SV, GT, CR o NI.
    END
    Fill Element By Text    ${INPUT_EMAIL}    ${mail}
    Click Element By Type    ${INPUT_NAME}    other
    Fill Element By Text    ${INPUT_NAME}    ${NAME}
    Fill Element By Text    ${INPUT_LAST_NAME}    ${LAST_NAME}
    Select List Item    ${SELECT_DOCUMENT}    ${DOCUMENT_TYPE_BY_COUNTRY}[${country}]
    Type Into Masked Input    ${INPUT_DOCUMENT}    ${DOCUMENT_BY_COUNTRY}[${country}]
    Fill Element By Text    ${INPUT_PHONE}    ${PHONE}
    # La casilla viene marcada: si queda así, el checkout exige iniciar sesión y un invitado no puede avanzar
    IF    $user_type == 'new_user'
        Click Element By Type    ${CHECK_SAVE_DATA}    checkbox
    ELSE
        Unselect Checkbox    ${CHECK_SAVE_DATA}
    END
    Click Element By Type    ${CHECK_PRIVACY_TERMS}    checkbox
    Click Element By Type    ${BTN_GO_SHIPPING}    button

Send OTP Email
    [Documentation]    Envía el código OTP al correo del usuario para login en checkout
    [Arguments]    ${user_type}    ${email}
        Request OTP Email    ${user_type}    ${email}
        ${OTP}=    Login Mailsac   ${email}    ${user_type}
        Fill Element By Text    ${INPUT_EMAIL_CODE}    ${OTP}
        Click Element By Type   ${BTN_CONFIRM_LOGIN}    button

Request OTP Email
    [Documentation]    Solicita el envío del OTP. En el correo recurrente vacía antes la bandeja para no leer un código viejo.
    [Arguments]    ${user_type}    ${email}
        Wait Until Element Is Visible   ${BTN_SEND_EMAIL_CODE}    10s
        Click Element By Type   ${BTN_SEND_EMAIL_CODE}    button
        Wait Until Element Is Visible  ${BTN_CONFIRM_EMAIL_CODE}    10s
        IF    '${user_type}' == 'recurrent_user'
            Vaciar bandeja correo recurrente    ${email}
        END
        Click Element By Type   ${BTN_CONFIRM_EMAIL_CODE}    button

Wait For Shipping Address Fields
    [Documentation]    Espera el formulario de Envío. Se usa la calle porque existe en todas las cuentas,
    ...    mientras que los #ship-* de ubicación están ocultos en SV.
    Wait Until Element Is Visible    ${INPUT_STREET}    30s

Select Address Level
    [Documentation]    Selecciona un nivel de ubicación (0=departamento, 1=municipio, 2=distrito), con reintentos
    ...    porque el formulario se recarga al cambiar cada nivel.
    [Arguments]    ${level}    ${native_locator}    ${value}
    Wait Until Keyword Succeeds    30s    2s
    ...    Select Address Level Now    ${level}    ${native_locator}    ${value}

Select Address Level Now
    [Documentation]    Usa el <select> con id si está visible (QA) y, si no, el selector regional sin id (SV)
    [Arguments]    ${level}    ${native_locator}    ${value}
    ${native_visible}=    Run Keyword And Return Status    Element Should Be Visible    ${native_locator}
    IF    ${native_visible}
        Select And Verify List Item    ${native_locator}    ${value}
    ELSE
        @{selects}=    Get WebElements    ${SELECT_REGIONAL}
        ${visible}=    Evaluate    [e for e in $selects if e.is_displayed()]
        ${select}=    Evaluate    $visible[int($level)]
        Select From List By Label    ${select}    ${value}
        ${selected}=    Get Selected List Label    ${select}
        Should Be Equal    ${selected}    ${value}
    END

Create New Adress In Checkout
    [Documentation]    Metodo para crear una nueva direccion en el checkout
    [Arguments]    ${user_type}    ${DEPARTMENT}    ${CITY}    ${NEIGHBORHOOD}

    IF    '${user_type}' == 'recurrent_user'
        Click Element By Type    ${BTN_NEW_ADDRESS_OPTION}    button
    ELSE IF    '${user_type}' != 'guest_user' and '${user_type}' != 'new_user'
        Fail    Tipo de usuario no soportado: '${user_type}'. Usa guest_user, new_user o recurrent_user.
    END

    Wait For Shipping Address Fields
    Select Address Level    0    ${SELECT_DEPARMENT}    ${DEPARTMENT}
    Select Address Level    1    ${SELECT_CITY}    ${CITY}
    Select Address Level    2    ${SELECT_NEIGHBORHOOD}    ${NEIGHBORHOOD}
    # Al terminar el login, el checkout puede recargar el formulario y borrar los campos de texto
    Wait Until Keyword Succeeds    60s    2s    Fill Address And Go To Payment

Fill Address And Go To Payment
    [Documentation]    Llena los campos de texto, los verifica y continúa hasta confirmar que se llegó a Pago
    Retype Text Field    ${INPUT_STREET}    Test Street
    # GT y NI no muestran este campo
    ${has_complement}=    Run Keyword And Return Status    Element Should Be Visible    ${INPUT_COMPLEMENT}
    IF    ${has_complement}
        Retype Text Field    ${INPUT_COMPLEMENT}    Apto 123
    END
    Retype Text Field    ${INPUT_RECEIVER_NAME}    User Test
    Sleep    1s
    Textfield Value Should Be    ${INPUT_STREET}    Test Street
    Textfield Value Should Be    ${INPUT_RECEIVER_NAME}    User Test
    Wait Until Element Is Visible    ${BTN_GO_TO_STEP3_PAYMENT}    30s
    Click Element By Type    ${BTN_GO_TO_STEP3_PAYMENT}    button
    Wait Until Location Contains    /payment    15s

Retype Text Field
    [Documentation]    Borra con teclado y escribe: en estos campos Clear Element Text no siempre limpia el valor
    [Arguments]    ${locator}    ${text}
    Wait Until Element Is Visible    ${locator}    30s
    Click Element    ${locator}
    Press Keys    None    CTRL+a
    Press Keys    None    DELETE
    Input Text    ${locator}    ${text}    clear=False

Select Pickup Point
    [Documentation]    Selecciona un punto de recogida por nombre de tienda
    [Arguments]    ${store_name}

    Wait Until Element Is Visible    css=.vtex-pickup-points-modal-3-x-pointsList    30s

    # Buscar y hacer click en el elemento que contiene el nombre de la tienda
    Click Element
    ...    xpath=//p[contains(@class, 'pickupPointName') and contains(text(), '${store_name}')]/ancestor::div[contains(@class, 'pointsItem')]

    # Esperar a que se active el botón de confirmar
    Wait Until Element Is Visible    xpath=//button[text()='Recogida en este punto']    30s
    Click Element    xpath=//button[text()='Recogida en este punto']

    # Verificar que el modal se cerró
    Wait Until Element Is Not Visible    xpath=//button[text()='Recogida en este punto']    30s

Select Split Delivery
    [Documentation]    Método para seleccionar la opción de delivery y pickup en checkout con esperas dinámicas
    [Arguments]    ${user_type}    ${DEPARTMENT}    ${CITY}    ${NEIGHBORHOOD}    ${PICKUP_NAME}

    # Espera para el campo de departamento
    #Log To Console    Seleccionando opción de Split Delivery con pickup point: ${PICKUP_NAME}

    IF    '${user_type}' == 'guest_user' or '${user_type}' == 'new_user'
        # Espera para el campo de departamento
        Wait For Shipping Address Fields
        Select Split Method    ${DEPARTMENT}    ${CITY}    ${NEIGHBORHOOD}    ${PICKUP_NAME}
        
    ELSE IF   '${user_type}' == 'recurrent_user'
        TRY
            Wait Until Element Is Visible    ${BTN_EDIT_SHIPPING}    10s
            Wait Until Keyword Succeeds    3x    1s    
            ...    Click Element By Type    ${BTN_EDIT_SHIPPING}    link    
        EXCEPT
            Log To Console    No se encontró el botón de editar dirección, procediendo.
        END
        Select Split Method    ${DEPARTMENT}    ${CITY}    ${NEIGHBORHOOD}    ${PICKUP_NAME}
    ELSE IF    '${user_type}' == 'guest_user' or '${user_type}' == 'new_user' and '${PICKUP_NAME}' == 'Motocity'
        # Seleccionar el punto de recogida
        Select Split Method    ${DEPARTMENT}    ${CITY}    ${NEIGHBORHOOD}    'Florely'    
    END

Select Split Method
    [Arguments]       ${DEPARTMENT}    ${CITY}    ${NEIGHBORHOOD}    ${PICKUP_NAME}
    [Documentation]    Método para seleccionar la opción de delivery y pickup en checkout con esperas dinámicas
        Wait Until Keyword Succeeds    25s    2s
        ...    Click Element By Type    ${BTN_SHIPPING_PICKUP}    button
        IF    '${PICKUP_NAME}' == 'Motocity'
            ${PICKUP_NAME}=    Set Variable    Florely
        ELSE
                    # Esperar a que aparezca el botón de buscar pickups disponibles
            TRY
                Wait Until Keyword Succeeds    15s    2s
                ...    Element Should Be Visible    ${FIND_PICKP_AVAIBLES}
                
                Wait Until Keyword Succeeds    10s    1s
                ...    Click Element By Type    ${FIND_PICKP_AVAIBLES}    button
            EXCEPT
                    Wait Until Keyword Succeeds    15s    2s
                    ...    Element Should Be Visible    ${CHANGE_PICKUP_BUTTON} 
                    
                    Wait Until Keyword Succeeds    10s    1s
                    ...    Click Element By Type    ${CHANGE_PICKUP_BUTTON}     button
            END
        END

        
        # Esperar a que cargue el modal de pickup points
        Wait Until Keyword Succeeds    3x    5s
        ...    Element Should Be Enabled    id:controls-wrapper
        
        # Seleccionar el punto de recogida
        Select Pickup Point    ${PICKUP_NAME}

        # Esperar a que se cierre el modal y aparezca el botón de continuar
        TRY
            Wait Until Keyword Succeeds    15s    2s
            ...    Element Should Be Visible    ${BTN_GO_TO_FILL_ADDRESS}
        
            Click Element By Type    ${BTN_GO_TO_FILL_ADDRESS}    button
        
            # Llenar información de dirección
            Select Address Level    0    ${SELECT_DEPARMENT}    ${DEPARTMENT}
                        Select Address Level    1    ${SELECT_CITY}    ${CITY}
                        Select Address Level    2    ${SELECT_NEIGHBORHOOD}    ${NEIGHBORHOOD}
            Fill Element By Text    ${INPUT_STREET}    Test Street
            Fill Element By Text    ${INPUT_COMPLEMENT}    Apto 123
            Fill Element By Text    ${INPUT_RECEIVER_NAME}    User Test
            # Finalizar y continuar a pago
            Wait Until Keyword Succeeds    15s    2s
            ...    Click Element By Type    ${BTN_GO_PAYMENT_SHIPPING}    button
        EXCEPT
            #Log To Console    El botón de continuar a dirección no apareció, procediendo con dirección guardada.
            # Finalizar y continuar a pago
            Wait Until Keyword Succeeds    15s    2s
            ...    Click Element By Type    ${BTN_GO_PAYMENT_SHIPPING}    button
        END  



Select Payment Method
    [Documentation]    Selección de método de pago en checkout
    [Arguments]    ${payment_method}

    # En producción no se elige método: algunos piden datos de tarjeta y la compra no se va a finalizar
    Skip Purchase On Production Account

    IF    '${payment_method}' == 'credisiman'
        # Lógica para seleccionar tarjeta de crédito
        Wait Until Element Is Visible    ${PAYMENT_CREDISIMAN}    30s
        Click Element By Type    ${PAYMENT_CREDISIMAN}    button
        Click Element By Type    ${PAYMENT_TRANS_BANK}    button
        Click Element By Type    ${PAYMENT_CREDISIMAN}    button
        Sleep    3s
        Wait Until Element Is Visible    xpath://form//iframe[contains(@src,'vtexpayments.com.br/card-ui')]
        Select Frame    xpath://form//iframe[contains(@src,'vtexpayments.com.br/card-ui')]
        Fill Element By Text    ${INPUT_CREDISIMAN_CARD}    4111 1111 1111 1111
        Fill Element By Text    ${INPUT_CREDISIMAN_NAME}    Test User
        Unselect Frame
    ELSE IF    '${payment_method}' == 'credisiman cuotas'
        # Lógica para seleccionar PayPal
        Log To Console    Seleccionando pago con credisiman cuotas
    ELSE IF    '${payment_method}' == 'credisiman cuotas intereses'
        # Lógica para seleccionar transferencia bancaria
        Log To Console    Seleccionando pago con credisiman cuotas intereses
    ELSE IF    '${payment_method}' == 'credisiman visa'
        # Lógica para seleccionar PayPal
        Log To Console    Seleccionando pago con credisiman visa
    ELSE IF    '${payment_method}' == 'tarjeta credito debito'
        # Lógica para seleccionar transferencia bancaria
        Log To Console    Seleccionando pago con tarjeta credito debito
    ELSE IF    '${payment_method}' == 'transferencia_bancaria'
        Wait Until Element Is Visible    ${PAYMENT_TRANS_BANK}    30s
        Wait Until Element Is Enabled    ${PAYMENT_TRANS_BANK}    30s
        Click Element By Type    ${paymentgroupcustomPrivate3Locator}    button
        Sleep    2s
        Click Element By Type    ${PAYMENT_TRANS_BANK}    button
    END

Click Payment Submit Button
    [Documentation]    Click en el boton de finalizar compra en el checkout.
    ...    En una cuenta de producción no hace click: la prueba termina en SKIP para no crear un pedido real,
    ...    salvo que se ejecute explícitamente con --variable ALLOW_REAL_ORDERS:True.
    Skip Purchase On Production Account
    Wait Until Element Is Visible    ${BTN_CONFIRM_PURCHASE}    30s
    Wait Until Element Is Enabled    ${BTN_CONFIRM_PURCHASE}    10s
    Click Element By Type    ${BTN_CONFIRM_PURCHASE}    button

Skip Purchase On Production Account
    [Documentation]    En una cuenta de producción confirma que se llegó al botón de compra y termina la prueba en SKIP
    ${current_url}=    Get Location
    ${is_production}=    Evaluate    bool(re.match($PRODUCTION_URL_REGEX, $current_url))    modules=re
    IF    ${is_production} and not ${ALLOW_REAL_ORDERS}
        Wait Until Element Is Visible    ${BTN_CONFIRM_PURCHASE}    30s
        Skip    Se llegó al botón de compra, pero no se pulsó porque ${current_url} es una cuenta de producción.
    END


## ---- Finalizar compra ---- ##
## ---- Se refactorizará este keyword para incluir la verificación de orden ---- ##
Finish Purchase
    [Documentation]    Finaliza la compra en el checkout
    [Arguments]    ${verify_orden}

    IF    '${verify_orden}' == 'verify'

        Click Payment Submit Button

        # Realizar login en VTEX para verificar la orden
        Login Vtex    juan_valencia@siman.com

        # Esperar a que aparezca el card completo
        Wait Until Element Is Visible    xpath=//div[contains(., 'Vendido y entregado por')]    30s

        # Extraer texto completo
        ${FULL_TEXT}=    Get Text    xpath=//div[contains(., 'Orden #')]

        # Extraer Orden # (números después de "Orden #")
        ${ORDER_NUMBER}=    Get Regexp Matches    ${FULL_TEXT}    Orden #(\\d+)    1
        ${ORDER_NUMBER}=    Get From List    ${ORDER_NUMBER}    0

        # Extraer fecha (formato d/m/yyyy)
        ${ORDER_DATE}=    Get Regexp Matches    ${FULL_TEXT}    (\\d{1,2}/\\d{1,2}/\\d{4})    1
        ${ORDER_DATE}=    Get From List    ${ORDER_DATE}    0

        # Extraer email (patrón: texto@dominio.com)
        ${ORDER_EMAIL}=    Get Regexp Matches    ${FULL_TEXT}    ([\\w.-]+@[\\w.-]+\\.\\w+)    1
        ${ORDER_EMAIL}=    Get From List    ${ORDER_EMAIL}    0

        Log To Console    ***\n Información de la Orden ***
        Log To Console    Orden #${ORDER_NUMBER}
        Log To Console    Fecha: ${ORDER_DATE}
        Log To Console    Email: ${ORDER_EMAIL}
    ELSE IF    '${verify_orden}' == 'no_verify'
        
        Click Payment Submit Button

        # Solo se valida que la el login de vtex sea visible
        Wait Until Element Is Visible    ${INPUT_VTEX_LOGIN}    60s
        Log To Console    Compra finalizada sin verificación de orden
    END
