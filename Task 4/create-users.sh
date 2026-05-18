#!/bin/bash
# create-security-auditor.sh

USER_NAME="security-auditor"
GROUP_NAME="security-auditors"

# 1. Генерация приватного ключа
openssl genrsa -out ${USER_NAME}.key 2048

# 2. Создание CSR (Certificate Signing Request)
openssl req -new -key ${USER_NAME}.key -out ${USER_NAME}.csr -subj "/CN=${USER_NAME}/O=${GROUP_NAME}"

# 3. Подпись сертификата CA кластера
#    Путь к CA кластера (укажите свой)
CA_CERT="/etc/kubernetes/pki/ca.crt"
CA_KEY="/etc/kubernetes/pki/ca.key"

openssl x509 -req -in ${USER_NAME}.csr -CA ${CA_CERT} -CAkey ${CA_KEY} -CAcreateserial -out ${USER_NAME}.crt -days 365

# 4. Настройка kubectl config
kubectl config set-credentials ${USER_NAME} --client-certificate=${USER_NAME}.crt --client-key=${USER_NAME}.key --embed-certs=true

# 5. Создание контекста (опционально)
kubectl config set-context ${USER_NAME}-context --cluster=$(kubectl config view --minify -o jsonpath='{.clusters[0].name}') --user=${USER_NAME}

echo "✅ Пользователь ${USER_NAME} создан"

#!/bin/bash
# create-devops-engineer.sh

USER_NAME="devops-engineer"
GROUP_NAME="devops-engineers"

# 1. Генерация ключа и CSR
openssl genrsa -out ${USER_NAME}.key 2048
openssl req -new -key ${USER_NAME}.key -out ${USER_NAME}.csr -subj "/CN=${USER_NAME}/O=${GROUP_NAME}"

# 2. Подпись CA кластера
CA_CERT="/etc/kubernetes/pki/ca.crt"
CA_KEY="/etc/kubernetes/pki/ca.key"

openssl x509 -req -in ${USER_NAME}.csr -CA ${CA_CERT} -CAkey ${CA_KEY} -CAcreateserial -out ${USER_NAME}.crt -days 365

# 3. Настройка kubectl config
kubectl config set-credentials ${USER_NAME} --client-certificate=${USER_NAME}.crt --client-key=${USER_NAME}.key --embed-certs=true

echo "✅ Пользователь ${USER_NAME} создан"