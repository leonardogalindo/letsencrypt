#!/bin/bash

# letsencrypt.sh - Realiza emissão do Let's Encrypt via SSH.
#
# Autor     : Leonardo Galindo <correio@leonardogalindo.xyz>
# Manutenção: Leonardo Galindo
#
# ---

# funções

letsencrypt() {

    read -p 'DOMÍNIO: ' -r domain

    pathdir="$(pwd)"

    # Se o retorno for difirente de True, irá gerar um arquivo de logs - ssl_logs e uma saída informando do erro, mais o log de erro.
    if ! bash acme.sh/acme.sh --issue -d "${domain}" -d www."${domain}" -w "${pathdir}"/public_html --server https://acme-v02.api.letsencrypt.org/directory &> ssl_logs; then
        printf >&2 "%sErro na emissão do Let's encrypt. Gerando logs de erro...\n"
        sleep 3
        printf '\n'
        cat ssl_logs
        # grep 'rateLimited' ssl_logs
        
        exit 1

    else

        printf '%sProcessando instalação...\n'

        certificates=("${domain}.cer" "${domain}.key" 'ca.cer')

        printf '%s::::::::::::::::::::::::::::::::::::::::::::::::::::::::\n'

        for (( i=0; i<"${#certificates[@]}"; i++ )); do
            path_ssl="$(find acme.sh/ -type f -name "${certificates[$i]}")"

            printf '%s\n Path do SSL: ' "$path_ssl"
            printf '\n'

        done
        printf '%s::::::::::::::::::::::::::::::::::::::::::::::::::::::::\n'
    fi   
}


letsencrypt_ca() {
    git clone https://github.com/Neilpang/acme.sh.git &> /dev/null
    bash acme.sh/acme.sh --set-default-ca --server letsencrypt &> /dev/null
}


asciiart='

    /~_______________________~\ 
    .-------------------------. 
    (| Let’s Encrypt Generator |)
    '-------------------------' 
    \_~~~~~~~~~~~~~~~~~~~~~~~_/ 
\n
'

printf "$asciiart"
sleep 3
clear


# condicional para verificar se o arquivo acme.sh existe.
if [[ -e "acme.sh/acme.sh" ]] ; then

    letsencrypt    
else

    letsencrypt_ca
    letsencrypt

fi