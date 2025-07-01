#!/bin/bash
#Fecha: 23/06/2025
#Versión: 1.0
#Descripción: Script para eliminar contenedores de laboratorio de pivoting
#X: https://x.com/XK3NF4
#Telegram: https://t.me/XK3NF4

echo "[-] Eliminando laberinto de pivoting..."
docker rm target3 target2 target1 --force &> /dev/null
docker network rm pivoting1 pivoting2 pivoting3 &> /dev/null
docker rmi pivoting-target &> /dev/null
docker network rm pivoting1 pivoting2 pivoting3 &> /dev/null
echo "[+] Eliminacion de laberinto de pivoting completada"