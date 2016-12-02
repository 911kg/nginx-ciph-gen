#!/bin/bash
openssl ciphers -V > oci.txt
cat oci.txt | tr -s [:blank:] | cut -f 2,4 -d \ > oc2.txt
sed 's/,0x//g' oc2.txt > oc3.txt
sed -i 's/.*/\U&/' oc3.txt

sed 's/)/(/g' inet_ci.txt > ci1.txt
cat ci1.txt | cut -f 2 -d \( > ci2.txt
sed -i 's/0x//g' ci2.txt
sed -i 's/.*/\U&/' ci2.txt

touch ci4.txt
echo "" > ci4.txt

while read CI_NAME
do
        size=${#CI_NAME}
case $size in
 "3" ) CI_NAME="0"$CI_NAME;;
 "2" ) CI_NAME="00"$CI_NAME;;
 "1" ) CI_NAME="000"$CI_NAME;;
 esac

#  echo $CI_NAME
cat oc3.txt | grep $CI_NAME >> ci4.txt
done < ci2.txt

cat ci4.txt | cut -f 2 -d \ | tr '\n' ':' | rev | cut -c 2- | rev > ci5.txt

echo "ssl_ciphers \"""$(cat ci5.txt)"\"\;

rm ci*.txt
rm oc*.txt
