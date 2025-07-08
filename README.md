# Laboratorio de Pivoting

Este es un laboratorio de pivoting creado en Docker, que simula tres máquinas Linux a las cuales se les proporcionan usuarios para acceder mediante SSH. La finalidad es enfocarse únicamente en el pivoting, sin necesidad de preocuparse por la explotación.

A continuación, se muestra un diagrama de la red.

![img](https://github.com/user-attachments/assets/d76bbc48-917f-4c72-ba6f-598cbe913af0)



## Requerimientos

```
  sudo apt update
  sudo apt install docker.io -y
  sudo systemctl enable docker
  sudo systemctl start docker
```

## Instalación 
```
  git clone https://github.com/XK3NF4/pivoting-lab.git
  cd pivoting-lab
  chmod +x ./deploy.sh
  sudo ./deploy.sh
```

Si deseas eliminar el laboratorio, ejecuta el siguiente script:
```
chmod +x ./clear.sh 
sudo ./clear.sh
```
### Usuarios creados: 
| **Usuario** | **Contraseña**     | **Host**                       |
| :-------- | :------- | :-------------------------------- |
| bob      | bob | 10.10.10.100 |
| alice      | alice | 10.20.20.100 |
| sabu      | sabu | 10.30.30.100 |
