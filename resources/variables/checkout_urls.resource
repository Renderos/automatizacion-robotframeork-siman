*** Variables ***

# Workspaces por país
${WS_SV}                               https://simanqa.myvtex.com/
${WS_GT}                               https://simanqagt.myvtex.com/
${WS_CR}                               https://simanqacr.myvtex.com/
${WS_NI}                               https://simanqanicor.myvtex.com/

# Workspaces Instore por país
${WS_SV_INSTORE}                       https://simanqainstoresv.myvtex.com/
${WS_GT_INSTORE}                       https://simanqainstoregt.myvtex.com/
${WS_CR_INSTORE}                       https://simanqainstorecr.myvtex.com/
${WS_NI_INSTORE}                       https://simanqainstoreni.myvtex.com/

# URLs de Checkout para diferentes carritos - PRODUCCIÓN
${CHECKOUT_PROD_SMALL}                 https://sv.siman.com/checkout/cart/add/?sku=8695234&qty=1&seller=1&sc=1&sku=8481414&qty=1&seller=1&sc=1
${CHECKOUT_PROD_SMALL_MK}              https://sv.siman.com/checkout/cart/add/?sku=10034338&qty=1&seller=Disprobe&sc=1
${CHECKOUT_PROD_BIG}                   https://sv.siman.com/checkout/cart/add/?sku=6810697&qty=1&seller=1&sc=1
${CHECKOUT_PROD_SPLIT_SIMAN}           https://sv.siman.com/checkout/cart/add/?sku=8523292&qty=1&seller=1&sc=1&sku=7849463&qty=1&seller=1&sc=1
${CHECKOUT_PROD_SPLIT_SIMAN_MK}        https://sv.siman.com/checkout/cart/add/?sku=10034338&qty=1&seller=Disprobe&sc=1&sku=8523292&qty=1&seller=1&sc=1

# URLs de Checkout SV - SANDBOX
${CHECKOUT_SANDBOX_ANY}                ${WS_SV}checkout/cart/add/?sku=7469998&qty=1&seller=1&sc=1
${CHECKOUT_SANDBOX_SMALL}              ${WS_SV}checkout/cart/add/?sku=7334848&qty=1&seller=1&sc=1
${CHECKOUT_SANDBOX_SMALL_MK}           ${WS_SV}checkout/cart/add/?sku=7469998&qty=1&seller=1&sc=1
${CHECKOUT_SANDBOX_BIG}                ${WS_SV}checkout/cart/add/?sku=7469998&qty=1&seller=1&sc=1
${CHECKOUT_SANDBOX_SPLIT_SIMAN}        ${WS_SV}checkout/cart/add/?sku=2106542&qty=1&seller=1&sc=1&sku=10010037&qty=1&seller=1&sc=1
${CHECKOUT_SANDBOX_SPLIT_SIMAN_MK}     ${WS_SV}checkout/cart/add/?sku=10047548&qty=1&seller=ADOC&sc=1&sku=10021163&qty=1&seller=Calzadopruebas1&sc=1&sku=10021161&qty=1&seller=Calzadopruebas1&sc=1
${CHECKOUT_SANDBOX_SPLIT_ST_BT_MK}     ${WS_SV}checkout/cart/add/?sku=10047548&qty=1&seller=ADOC&sc=1&sku=10047598&qty=1&seller=ADOC&sc=1&sku=5777008&qty=1&seller=1&sc=1
${CHECKOUT_SANDBOX_SPLIT_ST_MOTO}      ${WS_SV}checkout/cart/add/?sku=10047601&qty=1&seller=TiendaDomus21&sc=1&sku=5777008&qty=1&seller=1&sc=1
${CHECKOUT_SANDBOX_SPLIT_BT_MOTO}      ${WS_SV}checkout/cart/add/?sku=10047598&qty=1&seller=ADOC&sc=1&sku=5777008&qty=1&seller=1&sc=1&sku=10047601&qty=1&seller=TiendaDomus21&sc=1
${CHECKOUT_SANDBOX_SPLIT_ST_BT_MOTO}    ${WS_SV}checkout/cart/add/?sku=10047548&qty=1&seller=ADOC&sc=1&sku=10047598&qty=1&seller=ADOC&sc=1&sku=5777008&qty=1&seller=1&sc=1&sku=10020042&qty=1&seller=1&sc=1&sku=10047601&qty=1&seller=TiendaDomus21&sc=1
${CHECKOUT_SANDBOX_SPLIT_MK_MOTO}      ${WS_SV}checkout/cart/add/?sku=10047601&qty=1&seller=TiendaDomus21&sc=1&sku=10047548&qty=1&seller=ADOC&sc=1
${CHECKOUT_SANDBOX_SPLIT_ST_BT_MK_MOTO}    ${WS_SV}checkout/cart/add/?sku=10047548&qty=1&seller=ADOC&sc=1&sku=10047598&qty=1&seller=ADOC&sc=1&sku=5777008&qty=1&seller=1&sc=1&sku=10020042&qty=1&seller=1&sc=1&sku=10047601&qty=1&seller=TiendaDomus21&sc=1

# URLs de Checkout por país
${CHECKOUT_SANDBOX_GT}                 ${WS_GT}checkout/cart/add/?sku=7334803&qty=1&seller=1&sc=4&sku=5777006&qty=1&seller=1&sc=4
${CHECKOUT_SANDBOX_CR}                 ${WS_CR}checkout/cart/add/?sku=7334803&qty=1&seller=1&sc=6&sku=5777006&qty=1&seller=1&sc=6
${CHECKOUT_SANDBOX_NI}                 ${WS_NI}checkout/cart/add/?sku=7334803&qty=1&seller=1&sc=8&sku=5777006&qty=1&seller=1&sc=8

# URLs de Checkout Instore por país
${CHECKOUT_INSTORE_SV}                 ${WS_SV_INSTORE}checkout/cart/add/?sku=7469998&qty=1&seller=1
${CHECKOUT_INSTORE_GT}                 ${WS_GT_INSTORE}checkout/cart/add/?sku=7469998&qty=1&seller=1
${CHECKOUT_INSTORE_CR}                 ${WS_CR_INSTORE}checkout/cart/add/?sku=7469998&qty=1&seller=1
${CHECKOUT_INSTORE_NI}                 ${WS_NI_INSTORE}checkout/cart/add/?sku=7469998&qty=1&seller=1
