#!/bin/bash
#Autor: k3nf4
#Fecha: 23/06/2025
#Versión: 1.0
#Descripción: Script para crear redes y contenedores para laboratorio de pivoting
#X: https://x.com/XK3NF4
#Telegram: https://t.me/XK3NF4


# Colores
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color


rm /$USER/.ssh/known_hosts > /dev/null 2>&1
docker build -t pivoting-target . --no-cache

TARGET1_NET="10.10.10.0/24"
TARGET1_GW="10.10.10.1"
TARGET1_IP="10.10.10.100"


TARGET2_NET="10.20.20.0/24"
TARGET2_GW="10.20.20.1"
TARGET2_IP="10.20.20.100"


TARGET3_NET="10.30.30.0/24"
TARGET3_GW="10.30.30.1"
TARGET3_IP="10.30.30.100"


crear_red() {
    local nombre=$1
    local subnet=$2
    local gateway=$3
    local tipo=$4

    echo -n "Creando red $nombre (Subnet: $subnet, Gateway: $gateway)... "
    
    if [ "$tipo" == "normal" ]; then
        docker network create --subnet=$subnet --gateway=$gateway $nombre --attachable > /dev/null 2>&1
    else
        docker network create -d macvlan \
            --subnet=$subnet \
            --gateway=$gateway \
            --internal \
            --opt macvlan_mode=bridge \
            $nombre > /dev/null 2>&1
    fi

    if [ $? -eq 0 ]; then
        echo "OK"
        return 0
    else
        echo "FALLÓ"
        return 1
    fi
}


echo -e "${GREEN}Iniciando configuración de redes para laboratorio de pivoting...${NC}"
crear_red "pivoting1" "$TARGET1_NET" "$TARGET1_GW" "normal" || exit 1
crear_red "pivoting2" "$TARGET2_NET" "$TARGET2_GW" "macvlan" || exit 1
crear_red "pivoting3" "$TARGET3_NET" "$TARGET3_GW" "macvlan" || exit 1

echo -e "${GREEN}Configurando contenedores...${NC}"


echo -e "${GREEN}Creando Target1...${NC}"
docker run -d --name target1 \
    --network pivoting1 \
    --ip $TARGET1_IP \
    -e CONTAINER_ROLE=TARGET1 \
    --hostname target1 \
    pivoting-target


docker network connect pivoting2 target1


echo -e "${GREEN}Creando Target2...${NC}"
docker run -d --name target2 \
    --network pivoting2 \
    --ip $TARGET2_IP \
    -e CONTAINER_ROLE=TARGET2 \
    --hostname target2 \
    pivoting-target


docker network connect pivoting3 target2


echo -e "${GREEN}Creando Target3...${NC}"
docker run -d --name target3 \
    --network pivoting3 \
    --ip $TARGET3_IP \
    -e CONTAINER_ROLE=TARGET3 \
    --hostname target3 \
    pivoting-target


docker exec target1 bash -c "useradd -m bob -s /bin/bash && echo 'bob:bob' | chpasswd"
docker exec target1 bash -c "usermod -aG sudo bob"
docker exec target1 bash -c "echo 'bob ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers"
docker exec target1 bash -c "echo 'target1' > /var/www/html/index.html"

docker exec target2 bash -c "useradd -m alice -s /bin/bash && echo 'alice:alice' | chpasswd"
docker exec target2 bash -c "usermod -aG sudo alice"
docker exec target2 bash -c "echo 'alice ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers"
docker exec target2 bash -c "echo 'target2' > /var/www/html/index.html"

docker exec target3 bash -c "useradd -m sabu -s /bin/bash && echo 'sabu:sabu' | chpasswd"
docker exec target3 bash -c "usermod -aG sudo sabu"
docker exec target3 bash -c "echo 'sabu ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers"
docker exec target3 bash -c "echo 'target3' > /var/www/html/index.html"


echo -e "${GREEN}Verificando configuración...${NC}"
echo -e "${GREEN}\nResumen de redes creadas:${NC}"
docker network ls | grep pivoting

echo -e "\n${BLUE}Direcciones IP asignadas:${NC}"
echo -e "${YELLOW}Target1: $TARGET1_IP (pivoting1)${NC}"
echo -e "${YELLOW}Target2: $TARGET2_IP (pivoting2)${NC}"
echo -e "${YELLOW}Target3: $TARGET3_IP (pivoting3)${NC}"

echo -e "\n${MAGENTA}[+] Configuración completada exitosamente!${NC}"

echo -e "\n${BLUE}[+] Usuarios creados:${NC}"
echo -e "${YELLOW}Target1${NC} - ${GREEN}bob${NC} - ${YELLOW}Password${NC}: ${GREEN}bob${NC}"
echo -e "${YELLOW}Target2${NC} - ${GREEN}alice${NC} - ${YELLOW}Password${NC}: ${GREEN}alice${NC}"
echo -e "${YELLOW}Target3${NC} - ${GREEN}sabu${NC} - ${YELLOW}Password${NC}: ${GREEN}sabu${NC}"

