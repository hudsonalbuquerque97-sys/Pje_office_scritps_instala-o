#!/usr/bin/env bash
#
# Instalação completa do Token + SafeSign para Ubuntu/Debian
# Inclui: dependências, pacotes antigos, SafeSign e ativação do serviço pcscd
#

set -e  # aborta em caso de erro

### 1. Grupo scard
GRUPO="scard"
USUARIO="$SUDO_USER"

echo "==> Criando grupo $GRUPO (se não existir)..."
if ! getent group "$GRUPO" >/dev/null; then
    addgroup "$GRUPO"
else
    echo "Grupo $GRUPO já existe."
fi

echo "==> Adicionando usuário $USUARIO ao grupo $GRUPO..."
adduser "$USUARIO" "$GRUPO"

### 2. Dependências gerais
echo "==> Instalando dependências gerais..."
apt update
apt install -y \
    libengine-pkcs11-openssl \
    libp11-3 \
    libpcsc-perl \
    libccid \
    pcsc-tools \
    libasedrive-usb \
    opensc \
    openssl

### 3. Dependências específicas VeriSign
echo "==> Instalando dependências específicas..."
apt install -y \
    pcscd \
    libc6 \
    libgcc-s1 \
    libgdbm-compat4 \
    libglib2.0-0 \
    libpcsclite1 \
    libssl3 \
    libstdc++6

### 4. Pacotes antigos do arquivo Ubuntu
echo "==> Baixando pacotes antigos..."
mkdir -p /tmp/token_debs && cd /tmp/token_debs

wget -c http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1-1ubuntu2.1~18.04.23_amd64.deb
wget -c http://archive.ubuntu.com/ubuntu/pool/universe/w/wxwidgets3.0/libwxbase3.0-0v5_3.0.5.1+dfsg-4_amd64.deb
wget -c http://archive.ubuntu.com/ubuntu/pool/main/g/gdk-pixbuf-xlib/libgdk-pixbuf-xlib-2.0-0_2.40.2-2build4_amd64.deb
wget -c http://archive.ubuntu.com/ubuntu/pool/universe/g/gdk-pixbuf-xlib/libgdk-pixbuf2.0-0_2.40.2-2build4_amd64.deb
wget -c http://archive.ubuntu.com/ubuntu/pool/main/t/tiff/libtiff5_4.3.0-6_amd64.deb
wget -c http://archive.ubuntu.com/ubuntu/pool/universe/w/wxwidgets3.0/libwxgtk3.0-gtk3-0v5_3.0.5.1+dfsg-4_amd64.deb

echo "==> Instalando pacotes antigos na ordem correta..."
dpkg -i \
  libssl1.1_1.1.1-1ubuntu2.1~18.04.23_amd64.deb \
  libwxbase3.0-0v5_3.0.5.1+dfsg-4_amd64.deb \
  libgdk-pixbuf-xlib-2.0-0_2.40.2-2build4_amd64.deb \
  libgdk-pixbuf2.0-0_2.40.2-2build4_amd64.deb \
  libtiff5_4.3.0-6_amd64.deb \
  libwxgtk3.0-gtk3-0v5_3.0.5.1+dfsg-4_amd64.deb

echo "==> Corrigindo dependências pendentes..."
apt -f install -y

### 5. Instalação do SafeSign
echo "==> Baixando SafeSign..."
cd /tmp
wget -c https://safesign.gdamericadosul.com.br/content/SafeSign_IC_Standard_Linux_ub2204_3.8.0.0_AET.000.zip -O safesign.zip

echo "==> Extraindo SafeSign..."
unzip -o safesign.zip -d safesign_pkg
cd safesign_pkg

# Localiza o arquivo .deb principal (há variações de nome)
SAFE_DEB=$(ls *.deb | head -n1)
if [ -n "$SAFE_DEB" ]; then
    echo "==> Instalando $SAFE_DEB..."
    dpkg -i "$SAFE_DEB"
    apt -f install -y
else
    echo "!! Não foi encontrado arquivo .deb dentro do zip. Verifique manualmente em /tmp/safesign_pkg"
fi

### 6. Ativar serviço pcscd no boot
echo "==> Habilitando serviço pcscd para iniciar no boot..."
systemctl enable pcscd
systemctl start pcscd

echo
echo "======================================================"
echo "Instalação concluída!"
echo "- Saia e entre novamente na sessão para o grupo $GRUPO."
echo "- Abra o aplicativo 'tokenadmin' para integrar ao Firefox:"
echo "    Menu Integração -> Instalar o SafeSign no Firefox."
echo "======================================================"

