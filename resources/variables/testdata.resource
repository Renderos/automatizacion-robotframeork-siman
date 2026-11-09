*** Variables ***
# Variables para formularios / Direcciones

${NAME}               Robot
${LAST_NAME}          Framework
${DOCUMENT}           060247028
${PHONE}              75391216
${DUI}                DUI
${PASSPORT}           Pasaporte
${RESIDENT_CARD}      Carné de Residente

# Números ficticios con dígito verificador válido, porque GT y NI lo validan en el formulario
&{DOCUMENT_TYPE_BY_COUNTRY}    SV=DUI    GT=DPI    CR=Cédula    NI=Cédula
&{DOCUMENT_BY_COUNTRY}         SV=${DOCUMENT}    GT=1234567890101    CR=109870654    NI=0010101900000M

${EMAIL_RECURRENT}    robotsiman@mailsac.com
${EMAIL_VTEX}         ronald_ramos@siman.com