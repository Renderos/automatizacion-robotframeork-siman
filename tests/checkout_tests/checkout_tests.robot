*** Settings ***
Documentation    CSC-9359 | JC-HU029 - Validación de campos obligatorios en Shipping
...
...              Historia: Mejorar validación y señalización de campos obligatorios en el
...              Paso 2 (Shipping) del checkout de siman.com.
...
...              URL de prueba: carrito small del workspace de SV (ver checkout_urls.resource)
...
...              CAs cubiertos: CA-1, CA-2, CA-3, CA-4, CA-5, CA-8
...
...              *** IMPORTANTE ***
...              Estos tests SOLO validan hasta el paso Shipping (Paso 2).
...              NO se finaliza ninguna compra.

Resource    ../../resources/keywords/browser_keywords.resource
Resource    ../../resources/keywords/general_keywords.resource
Resource    ../../resources/keywords/checkout_keywords.resource
Resource    ../../resources/locators/checkout_locators.resource
Resource    ../../resources/variables/testdata.resource
Resource    ../../resources/variables/environment.resource

Test Teardown    Run Keywords
...    Capture Page Screenshot    teardown_${TEST NAME}.png
...    AND    Close Browser

*** Test Cases ***

TC-01 JC-HU029 CA-1 - Bloqueo de avance con campos vacios al presionar Continuar al pago
    [Documentation]    Verifica que al presionar "Continuar al pago" en Shipping con campos
    ...                obligatorios vacíos, el sistema bloquea el avance al paso de pago.
    ...                CA-1: El sistema debe bloquear el avance y mostrar feedback de error
    ...                en cada campo obligatorio faltante.
    [Tags]    CSC-9359    CA-1    shipping_validation
    Abrir Checkout CSC9359 Y Completar Identificacion
    Wait For Shipping Address Fields
    Capture Page Screenshot    TC01_01_en_shipping_paso2.png
    Intentar Continuar Al Pago Sin Llenar Campos
    Sleep    2s
    Capture Page Screenshot    TC01_02_despues_click_continuar.png
    # Verificar que el usuario NO avanzó a payment - el formulario de Shipping sigue visible
    Element Should Be Visible    ${INPUT_STREET}
    ...    msg=FALLO CA-1: El sistema avanzó al pago con campos obligatorios vacíos
    Capture Page Screenshot    TC01_03_bloqueo_verificado.png
    Log    PASS CA-1: El sistema bloqueó el avance correctamente


TC-02 JC-HU029 CA-2 - Mensaje de error visible en campos obligatorios de Shipping
    [Documentation]    Verifica que al disparar la validación en Shipping, aparece el mensaje
    ...                "Este campo es obligatorio." en los campos faltantes.
    ...                CA-2: Cada campo obligatorio debe mostrar título en rojo, borde en rojo
    ...                y el mensaje/disclaimer "Este campo es obligatorio."
    [Tags]    CSC-9359    CA-2    shipping_validation
    Abrir Checkout CSC9359 Y Completar Identificacion
    Wait For Shipping Address Fields
    Capture Page Screenshot    TC02_01_en_shipping_paso2.png
    Intentar Continuar Al Pago Sin Llenar Campos
    Sleep    2s
    Capture Page Screenshot    TC02_02_validacion_disparada.png
    # Verificar que el mensaje de error es visible
    Wait Until Element Is Visible    ${SHIPPING_ERROR_MSG}    10s
    ...    error=FALLO CA-2: No se mostró el mensaje "Este campo es obligatorio." en ningún campo de Shipping
    ${error_count}=    Get Element Count    ${SHIPPING_ERROR_MSG}
    Should Be True    ${error_count} > 0
    ...    msg=FALLO CA-2: Se esperaba al menos 1 mensaje de error pero se encontraron ${error_count}
    Log    PASS CA-2: Se mostraron ${error_count} mensaje(s) de "Este campo es obligatorio."
    Capture Page Screenshot    TC02_03_mensajes_error_visibles.png


TC-03 JC-HU029 CA-3 - Persistencia del mensaje de error (no efimero)
    [Documentation]    Verifica que el mensaje "Este campo es obligatorio." persiste en
    ...                pantalla y no desaparece de forma efímera.
    ...                CA-3: El mensaje debe mantenerse visible hasta que el usuario complete
    ...                el campo. No debe aparecer/desaparecer en milisegundos.
    [Tags]    CSC-9359    CA-3    shipping_validation
    Abrir Checkout CSC9359 Y Completar Identificacion
    Wait For Shipping Address Fields
    Intentar Continuar Al Pago Sin Llenar Campos
    Sleep    1s
    Capture Page Screenshot    TC03_01_inmediatamente_despues_click.png
    # El mensaje debe aparecer inmediatamente al hacer click en Continuar
    Wait Until Element Is Visible    ${SHIPPING_ERROR_MSG}    5s
    ...    error=FALLO CA-3: El mensaje de error no apareció al presionar "Continuar al pago"
    Capture Page Screenshot    TC03_02_error_aparecio_inmediato.png
    # Esperar 3 segundos y verificar que el mensaje NO desaparece (no es efímero)
    Sleep    3s
    Element Should Be Visible    ${SHIPPING_ERROR_MSG}
    ...    msg=FALLO CA-3: El mensaje de error desapareció (comportamiento efímero detectado)
    Capture Page Screenshot    TC03_03_error_persiste_3_segundos.png
    # Hacer click en otra parte de la página y verificar que el mensaje sigue visible
    Execute JavaScript    document.body.click()
    Sleep    1s
    Capture Page Screenshot    TC03_04_despues_click_en_otra_parte.png
    Element Should Be Visible    ${SHIPPING_ERROR_MSG}
    ...    msg=FALLO CA-3: El mensaje desapareció al hacer click fuera del campo
    Log    PASS CA-3: El mensaje persiste correctamente (no efímero)


TC-04 JC-HU029 CA-4 - Consistencia de errores en primer y segundo intento de Continuar
    [Documentation]    Verifica que el estado de error es consistente entre el primer y segundo
    ...                intento de presionar "Continuar al pago" con campos vacíos.
    ...                CA-4: El estado de error no debe degradarse ni cambiar entre intentos.
    [Tags]    CSC-9359    CA-4    shipping_validation
    Abrir Checkout CSC9359 Y Completar Identificacion
    Wait For Shipping Address Fields
    # Primer intento
    Intentar Continuar Al Pago Sin Llenar Campos
    Sleep    2s
    Capture Page Screenshot    TC04_01_primer_intento_continuar.png
    Wait Until Element Is Visible    ${SHIPPING_ERROR_MSG}    5s
    ...    error=FALLO CA-4: No hubo mensajes de error en el primer intento
    ${count_intento_1}=    Get Element Count    ${SHIPPING_ERROR_MSG}
    Should Be True    ${count_intento_1} > 0
    ...    msg=FALLO CA-4: No se encontraron mensajes de error en el primer intento
    Log    Primer intento: ${count_intento_1} mensaje(s) de error visible(s)
    # Segundo intento - los campos siguen vacíos
    Intentar Continuar Al Pago Sin Llenar Campos
    Sleep    2s
    Capture Page Screenshot    TC04_02_segundo_intento_continuar.png
    Wait Until Element Is Visible    ${SHIPPING_ERROR_MSG}    5s
    ...    error=FALLO CA-4: Los mensajes de error desaparecieron en el segundo intento
    ${count_intento_2}=    Get Element Count    ${SHIPPING_ERROR_MSG}
    Should Be True    ${count_intento_2} > 0
    ...    msg=FALLO CA-4: No se encontraron mensajes de error en el segundo intento
    # Verificar consistencia: la cantidad de mensajes debe ser igual entre intentos
    Should Be Equal As Integers    ${count_intento_1}    ${count_intento_2}
    ...    msg=FALLO CA-4: Inconsistencia detectada: 1er intento=${count_intento_1} vs 2do intento=${count_intento_2}
    Log    PASS CA-4: Consistencia verificada - ${count_intento_1} error(es) en ambos intentos
    Capture Page Screenshot    TC04_03_consistencia_verificada.png


TC-05 JC-HU029 CA-5 - Mensaje de error sin necesidad de click accidental fuera del campo
    [Documentation]    Verifica que al presionar "Continuar al pago", el mensaje de error
    ...                aparece directamente sin requerir un click accidental en otra parte.
    ...                CA-5: La visualización del error debe ser determinística al dispararse
    ...                la validación, no depender de interacciones "accidentales".
    [Tags]    CSC-9359    CA-5    shipping_validation
    Abrir Checkout CSC9359 Y Completar Identificacion
    Wait For Shipping Address Fields
    Capture Page Screenshot    TC05_01_shipping_listo_sin_interaccion.png
    # Presionar Continuar directamente, sin hacer click en ningún otro lugar antes
    Intentar Continuar Al Pago Sin Llenar Campos
    # Verificar INMEDIATAMENTE que el mensaje aparece sin interacción adicional
    Wait Until Element Is Visible    ${SHIPPING_ERROR_MSG}    5s
    ...    error=FALLO CA-5: El mensaje de error requirió interacción adicional para mostrarse
    Capture Page Screenshot    TC05_02_error_directo_sin_click_externo.png
    Log    PASS CA-5: El mensaje de error se mostró directamente sin clicks accidentales


TC-06 JC-HU029 CA-8 - Flujo feliz - campos completos permiten avanzar al pago
    [Documentation]    Verifica que al completar correctamente todos los campos obligatorios
    ...                en Shipping, el checkout permite avanzar al paso de pago sin fricción.
    ...                CA-8: El checkout debe permitir avanzar al pago normalmente cuando los
    ...                campos están completos. No se introduce fricción adicional.
    ...
    ...                *** IMPORTANTE: El test se detiene al llegar a Paso 3 (Pago). ***
    ...                *** NO se presiona el botón de finalizar compra. ***
    [Tags]    CSC-9359    CA-8    shipping_validation    happy_path
    Abrir Checkout CSC9359 Y Completar Identificacion
    Wait For Shipping Address Fields
    Capture Page Screenshot    TC06_01_shipping_campos_vacios.png
    # Llenar todos los campos obligatorios correctamente
    Completar Campos Obligatorios Shipping
    Capture Page Screenshot    TC06_02_campos_completos.png
    # Avanzar al pago
    Wait Until Element Is Visible    ${BTN_GO_TO_STEP3_PAYMENT}    20s
    Scroll Element Into View    ${BTN_GO_TO_STEP3_PAYMENT}
    Click Element By Type    ${BTN_GO_TO_STEP3_PAYMENT}    button
    Sleep    3s
    Capture Page Screenshot    TC06_03_navegando_a_pago.png
    # Verificar llegada al Paso 3 (Pago) sin finalizar compra
    Wait Until Element Is Visible    ${BTN_CONFIRM_PURCHASE}    30s
    Location Should Contain    /payment
    Log    PASS CA-8: Se llegó correctamente al paso de Pago con campos completos
    Log    STOP: Test finalizado. La compra NO fue procesada.
    Capture Page Screenshot    TC06_04_en_paso_pago_sin_finalizar.png


*** Keywords ***

Abrir Checkout CSC9359 Y Completar Identificacion
    [Documentation]    Navega a la URL específica de CSC-9359, abre el checkout y completa
    ...                el Paso 1 (Identificación) como usuario invitado (guest_user) para
    ...                llegar al Paso 2 (Shipping).
    Open Browser To Checkout    small    sv
    Sleep    3s
    Capture Page Screenshot    setup_01_pagina_cargada.png
    Login Checkout    SV    guest_user
    Sleep    2s
    Capture Page Screenshot    setup_02_identificacion_completada.png

Intentar Continuar Al Pago Sin Llenar Campos
    [Documentation]    Intenta avanzar al pago desde el formulario de Shipping sin llenar
    ...                los campos obligatorios. Selecciona "Entrega a domicilio" si es
    ...                necesario antes de intentar continuar.
    # Asegurarse de que la opción de entrega a domicilio esté seleccionada
    TRY
        Wait Until Element Is Visible    ${BTN_SHIPPING_DELIVERY}    5s
        Click Element By Type    ${BTN_SHIPPING_DELIVERY}    button
        Sleep    1s
    EXCEPT
        Log    Opción de entrega a domicilio no visible o ya seleccionada - continuando
    END
    # Intentar avanzar al pago sin llenar los campos
    TRY
        Wait Until Element Is Visible    ${BTN_GO_TO_STEP3_PAYMENT}    10s
        Scroll Element Into View    ${BTN_GO_TO_STEP3_PAYMENT}
        Click Element    ${BTN_GO_TO_STEP3_PAYMENT}
    EXCEPT
        Wait Until Element Is Visible    ${BTN_GO_PAYMENT_SHIPPING}    10s
        Scroll Element Into View    ${BTN_GO_PAYMENT_SHIPPING}
        Click Element    ${BTN_GO_PAYMENT_SHIPPING}
    END

Completar Campos Obligatorios Shipping
    [Documentation]    Llena todos los campos obligatorios del formulario de Shipping con
    ...                datos de prueba válidos para el flujo feliz (CA-8).
    # Seleccionar entrega a domicilio si es necesario
    TRY
        Wait Until Element Is Visible    ${BTN_SHIPPING_DELIVERY}    5s
        Click Element By Type    ${BTN_SHIPPING_DELIVERY}    button
        Sleep    1s
    EXCEPT
        Log    Opción de entrega a domicilio no visible o ya seleccionada
    END
    # Esperar y llenar el formulario de dirección
    Wait For Shipping Address Fields
    Select Address Level    0    ${SELECT_DEPARMENT}    San Salvador
    Select Address Level    1    ${SELECT_CITY}    San Salvador Centro
    Select Address Level    2    ${SELECT_NEIGHBORHOOD}    San Salvador
    Fill Element By Text    ${INPUT_STREET}    Test Street 123
    Fill Element By Text    ${INPUT_COMPLEMENT}    Apto 1
    Fill Element By Text    ${INPUT_RECEIVER_NAME}    Robot Test
    Sleep    1s
