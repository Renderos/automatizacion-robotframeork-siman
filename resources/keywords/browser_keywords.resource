*** Settings ***
Library     SeleniumLibrary
Resource    ../../resources/variables/checkout_urls.resource
Resource    ../../resources/variables/environment.resource
Resource    ../../resources/locators/checkout_locators.resource


*** Keywords ***
Open Browser To Checkout
    [Arguments]     ${cart_type}        ${country}    ${channel}=online
    [Documentation]    Abre checkout según environment (prod o sandbox), país (sv/gt/cr/ni) y canal (online/instore).
    ...    En instore y en gt/cr/ni el carrito es único por país, así que ${cart_type} no se usa.
    ...    Falla si la combinación no tiene URL definida, en vez de abrir otra por defecto.
    ${country_key}=    Set Variable    ${{ $country.upper() }}
    ${env_key}=    Set Variable    ${{ $ENVIRONMENT.upper() }}
    ${cart_key}=    Set Variable    ${{ $cart_type.upper() }}

    IF    '${channel}' == 'instore' and '${env_key}' == 'SANDBOX'
        ${checkout_url}=    Get Variable Value    \${CHECKOUT_INSTORE_${country_key}}
    ELSE IF    '${channel}' != 'online'
        ${checkout_url}=    Set Variable    ${None}
    ELSE IF    '${country_key}' == 'SV'
        ${checkout_url}=    Get Variable Value    \${CHECKOUT_${env_key}_${cart_key}}
    ELSE IF    '${env_key}' == 'SANDBOX'
        ${checkout_url}=    Get Variable Value    \${CHECKOUT_SANDBOX_${country_key}}
    ELSE
        ${checkout_url}=    Set Variable    ${None}
    END

    IF    $checkout_url is None
        Fail    No hay URL de checkout para environment='${ENVIRONMENT}', país='${country}', carrito='${cart_type}', canal='${channel}'.
    END

    Open Browser With Options    ${checkout_url}
    # Agregar al carrito falla a veces y deja el carrito vacío, por eso se reintenta antes de fallar
    Wait Until Keyword Succeeds    3x    3s    Cart Should Be Loaded    ${checkout_url}

Cart Should Be Loaded
    [Documentation]    Verifica que el carrito tenga productos; si no, vuelve a cargar la URL y falla para reintentar
    [Arguments]    ${checkout_url}
    ${loaded}=    Run Keyword And Return Status
    ...    Wait Until Element Is Visible    ${BTN_GO_PAYMENT}    20s
    IF    not ${loaded}
        Go To    ${checkout_url}
        Fail    El carrito no cargó con productos: ${checkout_url}. Revisa que los SKUs tengan stock en el workspace.
    END

Open Browser With Options
    [Documentation]    Abre navegador con opciones configuradas (Headless solo en CI)
    [Arguments]    ${url}

    # 1. Inicializar las opciones según el navegador
    IF    '${BROWSER}' == 'chrome'
        ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
        IF    ${INCOGNITO_MODE}
            Call Method    ${options}    add_argument    --incognito
        END
    ELSE IF    '${BROWSER}' == 'firefox'
        ${options}=    Evaluate    sys.modules['selenium.webdriver'].FirefoxOptions()    sys, selenium.webdriver
        IF    ${INCOGNITO_MODE}
            Call Method    ${options}    add_argument    -private
        END
    END

    # 2. HEADLESS: Usamos comillas para asegurar que se pase como string
    # Nota: También puedes usar solo "--headless" si "--headless=new" te da problemas
    IF    '${CI}' == 'true'
        Call Method    ${options}    add_argument    --headless\=new
    END

    # 3. Opciones de estabilidad (Crucial para GitHub Actions)
    Call Method    ${options}    add_argument    --disable-extensions
    Call Method    ${options}    add_argument    --disable-gpu
    Call Method    ${options}    add_argument    --no-sandbox
    Call Method    ${options}    add_argument    --disable-dev-shm-usage

    # 4. Forzar el tamaño de ventana (evita que elementos no sean clickeables en headless)
    Call Method    ${options}    add_argument    --window-size\=1920,1080

    # 5. Abrir el navegador pasando el objeto de opciones correctamente
    Create Webdriver    ${BROWSER.capitalize()}    options=${options}
    Set Window Size    1920    1080  # <--- Agrega esto
    Go To    ${url}
