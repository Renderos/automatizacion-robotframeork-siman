*** Settings ***
Documentation    Verifica flujos de finalización de compra con usuario nuevo en Checkout.

Resource    ../../resources/keywords/browser_keywords.resource
Resource    ../../resources/keywords/general_keywords.resource
Resource    ../../resources/keywords/checkout_keywords.resource

Test Teardown   Close Browser

*** Test Cases ***
Test Checkout Small Ticket New User
    [Tags]    CSC-8202  small_ticket_new_user
    [Template]    Test Checkout Split Siman New User
    1    gt    split_siman    new_user
    2    gt    split_split_siman_mk    new_user
    3    gt    small    recurrent_user


*** Keywords ***
Test Checkout Split Siman New User
    [Arguments]    ${iteration}    ${country}    ${cart_type}    ${user_type}
    Open Browser To Checkout    ${cart_type}    ${country}
    Login Checkout  ${country}    ${user_type}
    Create New Adress In Checkout   ${user_type}   San Salvador    San Salvador Centro    San Salvador
    #Select Payment Method   transferencia_bancaria
    #Finish Purchase   no_verify
    Close Browser