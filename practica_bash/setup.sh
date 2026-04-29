#!/bin/bash

echo "==============================" | tee -a log.txt
echo " INICIANDO CONFIGURACIÓN " | tee -a log.txt
echo "==============================" | tee -a log.txt

# 1. Actualización
echo "Actualizando sistema..." | tee -a log.txt
sudo apt update && sudo apt upgrade -y | tee -a log.txt

# 2. Instalación de paquetes
echo "Instalando paquetes esenciales..." | tee -a log.txt

paquetes=(
    git
    curl
    wget
    vim
    htop
    net-tools
)

for paquete in "${paquetes[@]}"
do
    echo "Instalando $paquete..." | tee -a log.txt
    sudo apt install -y $paquete | tee -a log.txt
done

# 3. Crear carpetas
echo "Creando estructura..." | tee -a log.txt
mkdir -p ~/proyectos ~/scripts ~/backup

# 4. Datos usuario
read -p "Ingresa tu nombre: " nombre
read -p "Ingresa tu correo: " correo

echo "Configurando git..." | tee -a log.txt
git config --global user.name "$nombre"
git config --global user.email "$correo"

# 5. Alias
echo "Configurando alias..." | tee -a log.txt
echo "alias ll='ls -la'" >> ~/.bashrc
echo "alias gs='git status'" >> ~/.bashrc
echo "alias update='sudo apt update && sudo apt upgrade -y'" >> ~/.bashrc

source ~/.bashrc

# 6. Seguridad
echo "Configurando firewall..." | tee -a log.txt
sudo apt install -y ufw | tee -a log.txt
sudo ufw enable
sudo ufw allow ssh

# 7. Node con NVM
echo "Instalando NVM..." | tee -a log.txt
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

export NVM_DIR="$HOME/.nvm"
source "$NVM_DIR/nvm.sh"

echo "Instalando Node..." | tee -a log.txt
nvm install --lts
nvm use --lts

# 8. LAMP
echo "Instalando LAMP..." | tee -a log.txt
sudo apt install -y apache2 mysql-server php libapache2-mod-php php-mysql | tee -a log.txt

sudo systemctl enable apache2
sudo systemctl start apache2

# 9. Limpieza
echo "Limpiando sistema..." | tee -a log.txt
sudo apt autoremove -y | tee -a log.txt
sudo apt autoclean | tee -a log.txt

echo "PROCESO COMPLETADO" | tee -a log.txt
