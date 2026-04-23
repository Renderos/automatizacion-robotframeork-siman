*** Variables ***

${BASE_URL_SANDBOX_SV}                 https://csc8596--simanqa.myvtex.com/   
${BASE_URL_SANDBOX_GT}                 https://csc8596--simanqagt.myvtex.com/
${BASE_URL_SANDBOX_CR}                 https://csc8596--simanqacr.myvtex.com/
${BASE_URL_SANDBOX_NI}                 https://csc8596--simanqanicor.myvtex.com/
#${BASE_URL_SANDBOX}                   https://csc8346--simanqa.myvtex.com/

# URLs de Checkout para diferentes carritos - PRODUCCIÓN
${CHECKOUT_PROD_SMALL}                 https://sv.siman.com/checkout/cart/add/?sku=8695234&qty=1&seller=1&sc=1&sku=8481414&qty=1&seller=1&sc=1
${CHECKOUT_PROD_SMALL_MK}              https://sv.siman.com/checkout/cart/add/?sku=10034338&qty=1&seller=Disprobe&sc=1
${CHECKOUT_PROD_BIG}                   https://sv.siman.com/checkout/cart/add/?sku=6810697&qty=1&seller=1&sc=1
${CHECKOUT_PROD_SPLIT_SIMAN}           https://sv.siman.com/checkout/cart/add/?sku=8523292&qty=1&seller=1&sc=1&sku=7849463&qty=1&seller=1&sc=1
${CHECKOUT_PROD_SPLIT_SIMAN_MK}        https://sv.siman.com/checkout/cart/add/?sku=10034338&qty=1&seller=Disprobe&sc=1&sku=8523292&qty=1&seller=1&sc=1

# URLs de Checkout para diferentes carritos - SANDBOX
${CHECKOUT_SANDBOX_SMALL}                  checkout/cart/add/?sku=7334848&qty=1&seller=1&sc=1
${CHECKOUT_SANDBOX_SMALL_MK}               checkout/cart/add/?sku=7469998&qty=1&seller=1&sc=1
${CHECKOUT_SANDBOX_BIG}                    checkout/cart/add/?sku=7469998&qty=1&seller=1&sc=1
${CHECKOUT_SANDBOX_SPLIT_SIMAN}            checkout/cart/add/?sku=2106542&qty=1&seller=1&sc=1&sku=10010037&qty=1&seller=1&sc=1
${CHECKOUT_SANDBOX_SPLIT_SIMAN_MK}         checkout/cart/add/?sku=10047548&qty=1&seller=ADOC&sc=1&sku=10021163&qty=1&seller=Calzadopruebas1&sc=1&sku=10021161&qty=1&seller=Calzadopruebas1&sc=1
${CHECKOUT_SANDBOX_SPLIT_ST_BT_MK}         checkout/cart/add/?sku=10047548&qty=1&seller=ADOC&sc=1&sku=10047598&qty=1&seller=ADOC&sc=1&sku=5777008&qty=1&seller=1&sc=1
${CHECKOUT_SANDBOX_SPLIT_ST_MOTO}          checkout/cart/add/?sku=10047601&qty=1&seller=TiendaDomus21&sc=1&sku=5777008&qty=1&seller=1&sc=1
${CHECKOUT_SANDBOX_SPLIT_BT_MOTO}          checkout/cart/add/?sku=10047598&qty=1&seller=ADOC&sc=1&sku=5777008&qty=1&seller=1&sc=1&sku=10047601&qty=1&seller=TiendaDomus21&sc=1
${CHECKOUT_SANDBOX_SPLIT_ST_BT_MOTO}       checkout/cart/add/?sku=10047548&qty=1&seller=ADOC&sc=1&sku=10047598&qty=1&seller=ADOC&sc=1&sku=5777008&qty=1&seller=1&sc=1&sku=10020042&qty=1&seller=1&sc=1&sku=10047601&qty=1&seller=TiendaDomus21&sc=1
${CHECKOUT_SANDBOX_SPLIT_MK_MOTO}          checkout/cart/add/?sku=10047601&qty=1&seller=TiendaDomus21&sc=1&sku=10047548&qty=1&seller=ADOC&sc=1
${CHECKOUT_SANDBOX_SPLIT_ST_BT_MK_MOTO}    checkout/cart/add/?sku=10047548&qty=1&seller=ADOC&sc=1&sku=10047598&qty=1&seller=ADOC&sc=1&sku=5777008&qty=1&seller=1&sc=1&sku=10020042&qty=1&seller=1&sc=1&sku=10047601&qty=1&seller=TiendaDomus21&sc=1
${CHECKOUT_SANDBOX_ANY}                    checkout/cart/add/?sku=7469998&qty=1&seller=1&sc=1                 

# URLs checkout por entorno
${CHECKOUT_SANDBOX_GT}               https://simanqagt.myvtex.com/checkout/cart/add/?sku=7334803&qty=1&seller=1&sc=4&sku=5777006&qty=1&seller=1&sc=4
${CHECKOUT_SANDBOX_CR}               https://simanqacr.myvtex.com/checkout/cart/add/?sku=7334803&qty=1&seller=1&sc=6&sku=5777006&qty=1&seller=1&sc=6
${CHECKOUT_SANDBOX_NI}               https://simanqanicor.myvtex.com/checkout/cart/add/?sku=7334803&qty=1&seller=1&sc=8&sku=5777006&qty=1&seller=1&sc=8
