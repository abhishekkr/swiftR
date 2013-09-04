#!/bin/sh
 
echodo()
{
    echo "${@}"
    (${@})
}
 
yearmon()
{
    date '+%Y%m%d'
}
 
fqdn()
{
    (nslookup ${1} 2>&1 || echo Name ${1}) | tail -3 | grep Name | sed -e 's,.*e:[ \t]*,,'
}

certify(){
    cd $SWIFTR_BASEDIR

    C=IN
    ST=KA
    L=Bangalore
    O=ABK
    OU=DevOps
    HOST=${1:-`hostname`}
    DATE=`yearmon`
    CN=`fqdn $HOST`
     
    SWIFTR_CSR="${HOST}.csr"
    export SWIFTR_KEY="${HOST}.key"
    export SWIFTR_CERT="${HOST}.cert"
     
    # Create the certificate signing request
    openssl req -config /etc/pki/tls/openssl.cnf -new -passin pass:password -passout pass:password -out $SWIFTR_CSR <<EOF
${C}
${ST}
${L}
${O}
${OU}
${CN}
$USER@${CN}
.
.
EOF
    echo ""
     
    [ -f ${SWIFTR_CSR} ] && echodo openssl req -text -noout -in ${SWIFTR_CSR}
    echo ""
     
    # Create the Key
    echodo openssl rsa -in privkey.pem -passin pass:password -passout pass:password -out ${SWIFTR_KEY}
     
    # Create the Certificate
    echodo openssl x509 -in ${SWIFTR_CSR} -out ${SWIFTR_CERT} -req -signkey ${SWIFTR_KEY} -days 1000
}
