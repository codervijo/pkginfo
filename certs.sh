#!/bin/bash

cmd_openssl="";

function check_prereqs {
	# Check if OpenSSL is available
	command -v openssl 2>/dev/null || { echo >&2 "Need OpenSSL to continue.  Aborting."; exit 1; }
	cmd_openssl=`command -v openssl`;
	echo "Using ${cmd_openssl}";
	return 0;
}

check_prereqs;
exit 0;
# Parse arguments
${cmd_openssl} x509 -in server.crt 
${cmd_openssl} genrsa  -out $clientkey 4096
${cmd_openssl} req -new -key $clientkey -out $clientcsr -subj \"$clientsubj\" 
${cmd_openssl} req -new -key $clientkey -out $clientcsr -subj $clientsubj 
${cmd_openssl} req -new -key $clientkey -out $clientcsr -subj \"$clientsubj\" 
${cmd_openssl} req -new -key $clientkey -out $clientcsr -subj "$clientsubj" 
${cmd_openssl} ca -config $caconf -in $clientcsr -out $clientcert -batch
${cmd_openssl} ca -config $caconf -in $clientcsr -out $clientcert -batch
${cmd_openssl} ca -config $caconf -in $clientcsr -out $clientcert -batch
${cmd_openssl} ca -config $caconf -in $clientcsr -out $clientcert -batch
${cmd_openssl} ca -config $caconf -in $clientcsr -out $clientcert -batch
${cmd_openssl} ca -config $caconf -in $clientcsr -out $clientcert -batch
${cmd_openssl} ca -config $caconf -in $clientcsr -out $clientcert -batch --verbose
${cmd_openssl} ca -config $caconf -in $clientcsr -out $clientcert -batch -verbose
${cmd_openssl} ca -config $caconf -in $clientcsr -out $clientcert -batch -verbose
${cmd_openssl} ca -config $caconf -in $clientcsr -out $clientcert -batch -verbose
${cmd_openssl} ca -config $caconf -in $clientcsr -out $clientcert -batch -verbose
${cmd_openssl} ca -config $caconf -in $clientcsr -out $clientcert -batch -verbose
${cmd_openssl} ca -config $caconf -in $clientcsr -out $clientcert -batch -verbose
${cmd_openssl} ca -config $caconf -in $clientcsr -out $clientcert -batch -verbose
${cmd_openssl} x509 -in client.crt -text
${cmd_openssl} x509 -in client.crt -text|less
	${cmd_openssl} genrsa -out $ikeyfile 4096
	${cmd_openssl} req -new  -sha256 -key $ikeyfile -out $icsrfile -days 365 -subj \"$icasubj\"
	${cmd_openssl} req -new  -sha256 -key $ikeyfile -out $icsrfile -days 365 -subj \"$icasubj\"
	${cmd_openssl} req -new  -sha256 -key $ikeyfile -out $icsrfile -days 365 -subj \"$icasubj\"
	${cmd_openssl} req -new  -sha256 -key $ikeyfile -out $icsrfile -days 365 -subj \"$icasubj\"
	${cmd_openssl} req -new  -sha256 -key $ikeyfile -out $icsrfile -days 365 -subj \"$icasubj\"
	${cmd_openssl} req -new  -sha256 -key $ikeyfile -out $icsrfile -days 365 -subj "$icasubj"
	${cmd_openssl} ca -batch -config $caconf -notext -in $icsrfile  -out $icrtfile
${cmd_openssl} x509 -in interca.crt  -text -out |less
${cmd_openssl} x509 -in interca.crt   -out |less
${cmd_openssl} x509 -in interca.crt   -out 
${cmd_openssl} x509  interca.crt   -out 
${cmd_openssl} x509  interca.crt -text
${cmd_openssl} x509 -in interca.crt -text
${cmd_openssl} x509 -in interca.crt -text|less
${cmd_openssl} genrsa -out $usrkey 4096 
${cmd_openssl} req -new -sha256 -key $usrkey -out $usrcsr -days 365 -subj $usrsubj
${cmd_openssl} req -new -sha256 -key $usrkey -out $usrcsr -days 365 -subj $usrsubj
${cmd_openssl} req -new -sha256 -key $usrkey -out $usrcsr -days 365 -subj "$usrsubj"
${cmd_openssl} ca -batch -config $icaconf -notext -in $usrcsr -out $usrcrt
${cmd_openssl} ca -batch -config $icaconf  -in $usrcsr -out $usrcrt
${cmd_openssl} ca -batch -config $icaconf  -in $usrcsr -out $usrcrt
${cmd_openssl} ca -batch -config $icaconf  -in $usrcsr -out $usrcrt
${cmd_openssl} x509 -in certs/server.crt -text

${cmd_openssl} genrsa -out $ikeyfile 4096
${cmd_openssl} req -new  -sha256 -key $ikeyfile -out $icsrfile -days 365 -subj "$icasubj"
${cmd_openssl} req -new  -sha256 -key $ikeyfile -out $icsrfile -days 365 -subj "$icasubj"
${cmd_openssl} ca -batch -config $caconf -notext -in $icsrfile  -out $icrtfile
${cmd_openssl} ca -config rootca.conf  -revoke revoked.crt 
${cmd_openssl} ca -config rootca.conf -gencrl -keyfile test-ca-key.pem -cert test-ca-cert.pem -out revokedcrl.pem
${cmd_openssl} ca -config rootca.conf -gencrl -keyfile test-ca-key.pem -cert test-ca-cert.pem -out revokedcrl.pem
${cmd_openssl} ca -config rootca.conf -gencrl -keyfile test-ca-key.pem -cert test-ca-cert.pem -out revokedcrl.pem
${cmd_openssl} ca -config rootca.conf -gencrl -keyfile test-ca-key.pem -cert test-ca-cert.pem -out revokedcrl.pem
${cmd_openssl} req -x509 -nodes -newkey rsa:4096 -keyout $keyfile -out $certfile -days 365 -subj "$certsubj"
${cmd_openssl} req -new -sha256 -key certs/expired.key -out server.csr -days 365 -subj "/C=US/ST=CA/L=Server Mystery Spot/O=Serv/CN=WgetTestingServer/emailAddress=servertester"
${cmd_openssl} ca -batch -config certs/rootca.conf -notext -enddate 170508160342-0700 -in certs/expired.csr -out certs/expired.crt
${cmd_openssl} ca -batch -config certs/rootca.conf -notext -enddate 170508160342-0700 -in certs/expired.csr -out certs/expired.crt
${cmd_openssl} ca -batch -config certs/rootca.conf -notext -enddate 170508160342-0700 -in certs/expired.csr -out certs/expired.crt
${cmd_openssl} ca -batch -config certs/rootca.conf -notext -enddate 170508160342-0700 -in certs/expired.csr -out certs/expired.crt
${cmd_openssl} ca -batch -config certs/rootca.conf -notext -enddate 170508160342-0700 -in certs/expired.csr -out certs/expired.crt
${cmd_openssl} ca -batch -config certs/rootca.conf  -enddate 170508160342-0700 -in certs/expired.csr -out certs/expired.crt
${cmd_openssl} ca -batch -config certs/rootca.conf  -enddate 170508160342-0700 -in certs/expired.csr -out certs/expired.crt
${cmd_openssl} ca -batch -config certs/rootca.conf  -enddate 170508160342-0700 -in certs/expired.csr -out certs/expired.crt
${cmd_openssl} ca -batch -config certs/rootca.conf  -enddate 170508160342-0700 -in certs/expired.csr -out certs/expired.crt
${cmd_openssl} ca -batch -config certs/rootca.conf  -enddate 170508160342-0700 -in certs/expired.csr -out certs/expired.crt
${cmd_openssl} ca -batch -config certs/rootca.conf  -enddate 170508160342-0700 -in certs/expired.csr -out certs/expired.crt
${cmd_openssl} ca -batch -config certs/rootca.conf  -enddate 170508160342-0700 -in certs/expired.csr -out certs/expired.crt
${cmd_openssl} x509 -in certs/expired.crt  -text -out |less
${cmd_openssl} x509 -in certs/expired.crt  -text  |less
${cmd_openssl} genrsa -out certs/invalid.key 4096
${cmd_openssl} req -new -sha256 -key certs/invalid.key -out certs/invalid.csr -days 365 -subj "/C=US/ST=CA/L=Server Mystery Spot/O=Serv/CN=WgetTestingServer/emailAddress=servertester"
${cmd_openssl} ca -batch -config certs/rootca.conf  -startdate 170508161628-0700 -in certs/invalid.csr -out certs/invalid.crt
${cmd_openssl} ca -batch -config certs/rootca.conf  -startdate 170508161628-0700 -in certs/invalid.csr -out certs/invalid.crt
${cmd_openssl} x509 -in invalid.crt  -text
${cmd_openssl} x509 -in invalid.crt  -text|less
${cmd_openssl} ca -batch -config certs/rootca.conf  -startdate 370504163014-0700 -in certs/invalid.csr -out certs/invalid.crt
${cmd_openssl} ca -batch -config certs/rootca.conf  -startdate 370504163014-0700 -in certs/invalid.csr -out certs/invalid.crt
${cmd_openssl} x509 -in invalid.crt  -text
