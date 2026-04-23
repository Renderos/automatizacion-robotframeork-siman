*** Settings ***
Library    Collections
Library    String
Library    RequestsLibrary
Resource    ../../resources/variables/environment.resource

*** Keywords ***
Disable SSL Warnings
    [Documentation]    Desactiva los warnings de SSL de urllib3
    Evaluate    __import__('urllib3').disable_warnings(__import__('urllib3').exceptions.InsecureRequestWarning)

# Obtener Codigo OTP Catchmail
#     [Documentation]    Obtiene el código OTP del correo en Catchmail
#     [Arguments]    ${email_address}    ${max_reintentos}=36    ${tiempo_espera}=5s
    