*** Settings ***
Documentation    Verifica flujos de finalización de compra con usuario nuevo en Checkout.

Resource    ../../resources/keywords/browser_keywords.resource
Resource    ../../resources/keywords/general_keywords.resource
Resource    ../../resources/keywords/checkout_keywords.resource

Test Template   Test Checkout Delivery
Test Teardown   Close Browser

*** Test Cases ***    COUNTRY    CART_TYPE    USER_TYPE
Test Checkout Split Siman New User
    [Tags]    CSC-8202  small_ticket_new_user
    SV    split_siman    new_user

Test Checkout Split Siman MK Guest User
    [Tags]    CSC-8202  small_ticket_new_user
    SV    split_siman_mk    guest_user

Test Checkout Small Ticket Guest User
    [Tags]    CSC-8202  small_ticket_new_user
    SV    small    guest_user


*** Keywords ***
Test Checkout Delivery
    [Arguments]    ${country}    ${cart_type}    ${user_type}
    Open Browser To Checkout    ${cart_type}    ${country}
    Login Checkout  ${country}    ${user_type}
    Create New Adress In Checkout   ${user_type}   San Salvador    San Salvador Centro    San Salvador
    Select Payment Method   transferencia_bancaria
    Finish Purchase   no_verify
