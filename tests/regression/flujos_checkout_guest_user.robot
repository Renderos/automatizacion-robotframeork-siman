*** Settings ***
Documentation       Verifica flujos principales en Checkout.

Resource            ../../resources/keywords/browser_keywords.resource
Resource            ../../resources/keywords/general_keywords.resource
Resource            ../../resources/keywords/checkout_keywords.resource
Resource            ../../resources/locators/home_locators.resource

Suite Setup    Disable SSL Warnings

Test Teardown   Close Browser

*** Test Cases ***
Test Checkout Small Ticket New User
    [Tags]    CSC-8202  delivery_siman
    Open Browser To Checkout    any    sv
    Login Checkout    sv    new_user
    Create New Adress In Checkout   new_user   San Salvador    San Salvador Centro    San Salvador
    Select Payment Method   transferencia_bancaria
    Finish Purchase   no_verify

Test Checkout Split Siman Guest User
    [Tags]    CSC-8202  split_siman    SmallTicket    BigTicket    guest_user
    Open Browser To Checkout    split_siman    sv
    Login Checkout    sv    guest_user
    Select Split Delivery  guest_user   San Salvador    San Salvador Centro    San Salvador    SIMAN SV LA GRAN VIA 
    Select Payment Method   transferencia_bancaria
    Finish Purchase  no_verify

Test Checkout Split Siman New User    
    [Tags]    CSC-8202  split_siman_new_user
    Open Browser To Checkout    split_siman    sv
    Login Checkout    sv    new_user
    #Create New Adress In Checkout   new_user   San Salvador    San Salvador Centro    San Salvador
    Select Split Delivery  new_user   San Salvador    San Salvador Centro    San Salvador    SIMAN SV LA GRAN VIA 
    Select Payment Method   transferencia_bancaria
    Finish Purchase  no_verify

Test Checkout Split Siman Recurrent User
    [Tags]    CSC-8202  split_siman_recurrent_user 
    Open Browser To Checkout    split_siman    sv 
    Login Checkout    sv    recurrent_user
    Select Split Delivery  recurrent_user   San Salvador    San Salvador Centro    San Salvador    SIMAN SV LA GRAN VIA 
    Select Payment Method   transferencia_bancaria
    Finish Purchase  no_verify

Test Checkout Split MK Guest User
    [Tags]    CSC-8202  split_siman_mk 
    Open Browser To Checkout    split_siman_mk    sv 
    Login Checkout    sv    guest_user
    Select Split Delivery  guest_user   San Salvador    San Salvador Centro    San Salvador    SIMAN SV LA GRAN VIA 
    Select Payment Method   transferencia_bancaria
    Finish Purchase  no_verify

Test Checkout Split MK New User
    [Tags]    CSC-8202  split_siman_mk_new_user 
    Open Browser To Checkout    split_siman_mk    sv 
    Login Checkout    sv    new_user
    Select Split Delivery  new_user   San Salvador    San Salvador Centro    San Salvador    SIMAN SV LA GRAN VIA 
    Select Payment Method   transferencia_bancaria
    Finish Purchase  no_verify

Test Checkout Split MK Recurrent User
    [Tags]    CSC-8202  split_siman_mk_recurrent_user
    Open Browser To Checkout    split_siman_mk    sv 
    Login Checkout    sv    recurrent_user
    Select Split Delivery  recurrent_user   San Salvador    San Salvador Centro    San Salvador    SIMAN SV LA GRAN VIA
    Select Payment Method   transferencia_bancaria
    Finish Purchase  no_verify

Test Checkout Split ST BT MK Guest User
    [Tags]    CSC-8202  split_st_bt_mk 
    Open Browser To Checkout    split_st_bt_mk    sv 
    Login Checkout    sv    guest_user
    Select Split Delivery  guest_user   San Salvador    San Salvador Centro    San Salvador    SIMAN SV LA GRAN VIA 
    Select Payment Method   transferencia_bancaria
    Finish Purchase  no_verify    

Test Checkout Split ST BT MK New User
    [Tags]    CSC-8202  split_st_bt_mk_new_user 
    Open Browser To Checkout    split_st_bt_mk    sv 
    Login Checkout    sv    new_user
    Select Split Delivery  new_user   San Salvador    San Salvador Centro    San Salvador    SIMAN SV LA GRAN VIA 
    Select Payment Method   transferencia_bancaria
    Finish Purchase  no_verify

Test Checkout Split ST BT MK Recurrent User 
    [Tags]    CSC-8202  split_st_bt_mk_recurrent_user
    Open Browser To Checkout    split_st_bt_mk    sv
    Login Checkout    sv    recurrent_user
    Select Split Delivery  recurrent_user   San Salvador    San Salvador Centro    San Salvador    SIMAN SV LA GRAN VIA
    Select Payment Method   transferencia_bancaria
    Finish Purchase  no_verify

Test Checkout Split ST Moto Guest User
    [Tags]    CSC-8202  split_st_moto 
    Open Browser To Checkout    split_st_moto    sv 
    Login Checkout    sv    guest_user
    Select Split Delivery  guest_user   San Salvador    San Salvador Centro    San Salvador    Motocity 
    Select Payment Method   transferencia_bancaria
    Finish Purchase  no_verify

Test Checkout Split ST Moto New User
    [Tags]    CSC-8202  split_st_moto_new_user 
    Open Browser To Checkout    split_st_moto    sv
    Login Checkout    sv    new_user
    Select Split Delivery  new_user   San Salvador    San Salvador Centro    San Salvador    Motocity
    Select Payment Method   transferencia_bancaria
    Finish Purchase  no_verify

Test Checkout Split ST Moto Recurrent User
    [Tags]    CSC-8202  split_st_moto_recurrent_user
    Open Browser To Checkout    split_st_moto    sv
    Login Checkout    sv    recurrent_user
    Select Split Delivery  recurrent_user   San Salvador    San Salvador Centro    San Salvador    Motocity
    Select Payment Method   transferencia_bancaria
    Finish Purchase  no_verify

Test Checkout Split BT Moto Guest User
    [Tags]    CSC-8202  split_bt_moto 
    Open Browser To Checkout    split_bt_moto    sv 
    Login Checkout    sv    guest_user
    Select Split Delivery  guest_user   San Salvador    San Salvador Centro    San Salvador    Motocity 
    Select Payment Method   transferencia_bancaria
    Finish Purchase  no_verify

Test Checkout Split BT Moto New User
    [Tags]    CSC-8202  split_bt_moto_new_user 
    Open Browser To Checkout    split_bt_moto    sv
    Login Checkout    sv    new_user
    Select Split Delivery  new_user   San Salvador    San Salvador Centro    San Salvador    Motocity
    Select Payment Method   transferencia_bancaria
    Finish Purchase  no_verify

Test Checkout Split BT Moto Recurrent User
    [Tags]    CSC-8202  split_bt_moto_recurrent_user
    Open Browser To Checkout    split_bt_moto    sv
    Login Checkout    sv    recurrent_user
    Select Split Delivery  recurrent_user   San Salvador    San Salvador Centro    San Salvador    Motocity
    Select Payment Method   transferencia_bancaria
    Finish Purchase  no_verify

Test Checkout Split ST BT Moto Guest User
    [Tags]    CSC-8202  split_st_bt_moto 
    Open Browser To Checkout    split_st_bt_moto    sv 
    Login Checkout    sv    guest_user
    Select Split Delivery  guest_user   San Salvador    San Salvador Centro    San Salvador    Motocity 
    Select Payment Method   transferencia_bancaria
    Finish Purchase  no_verify

Test Checkout Split ST BT Moto New User
    [Tags]    CSC-8202  split_st_bt_moto_new_user
    Open Browser To Checkout    split_st_bt_moto    sv
    Login Checkout    sv    new_user
    Select Split Delivery  new_user   San Salvador    San Salvador Centro    San Salvador    Motocity
    Select Payment Method   transferencia_bancaria
    Finish Purchase  no_verify

Test Checkout Split ST BT Moto Recurrent User
    [Tags]    CSC-8202  split_st_bt_moto_recurrent_user
    Open Browser To Checkout    split_st_bt_moto    sv
    Login Checkout    sv    recurrent_user
    Select Split Delivery  recurrent_user   San Salvador    San Salvador Centro    San Salvador    Motocity
    Select Payment Method   transferencia_bancaria
    Finish Purchase  no_verify

Test Checkout Split MK Moto Guest User
    [Tags]    CSC-8202  split_mk_moto 
    Open Browser To Checkout    split_mk_moto    sv 
    Login Checkout    sv    guest_user
    Select Split Delivery  guest_user   San Salvador    San Salvador Centro    San Salvador    Motocity 
    Select Payment Method   transferencia_bancaria
    Finish Purchase  no_verify

Test Checkout Split MK Moto New User
    [Tags]    CSC-8202  split_mk_moto_new_user
    Open Browser To Checkout    split_mk_moto    sv
    Login Checkout    sv    new_user
    Select Split Delivery  new_user   San Salvador    San Salvador Centro    San Salvador    Motocity
    Select Payment Method   transferencia_bancaria
    Finish Purchase    no_verify

Test Checkout Split MK Moto Recurrent User
    [Tags]    CSC-8202  split_mk_moto_recurrent_user
    Open Browser To Checkout    split_mk_moto    sv
    Login Checkout    sv    recurrent_user
    Select Split Delivery  recurrent_user   San Salvador    San Salvador Centro    San Salvador    Motocity
    Select Payment Method   transferencia_bancaria
    Finish Purchase  no_verify

Test Checkout Split ST BT MK Moto Guest User
    [Tags]    CSC-8202  split_st_bt_mk_moto 
    Open Browser To Checkout    split_st_bt_mk_moto    sv 
    Login Checkout    sv    guest_user
    Select Split Delivery  guest_user   San Salvador    San Salvador Centro    San Salvador    Motocity 
    Select Payment Method   transferencia_bancaria
    Finish Purchase  no_verify

Test Checkout Split ST BT MK Moto New User
    [Tags]    CSC-8202  split_st_bt_mk_moto_new_user
    Open Browser To Checkout    split_st_bt_mk_moto    sv
    Login Checkout    sv    new_user
    Select Split Delivery  new_user   San Salvador    San Salvador Centro    San Salvador    Motocity
    Select Payment Method   transferencia_bancaria
    Finish Purchase  no_verify

Test Checkout Split ST BT MK Moto Recurrent User
    [Tags]    CSC-8202  split_st_bt_mk_moto_recurrent_user
    Open Browser To Checkout    split_st_bt_mk_moto    sv
    Login Checkout    sv    recurrent_user
    Select Split Delivery  recurrent_user   San Salvador    San Salvador Centro    San Salvador    Motocity
    Select Payment Method   transferencia_bancaria
    Finish Purchase  no_verify
