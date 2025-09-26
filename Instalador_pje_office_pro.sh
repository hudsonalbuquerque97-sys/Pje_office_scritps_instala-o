#!/usr/bin/env bash
#
# Instalação híbrida do PJe Office Pro
# Parte root para instalar, parte usuário para criar atalhos
#

set -e

# URL do pacote
PJE_URL="https://pje-office.pje.jus.br/pro/pjeoffice-pro-v2.5.16u-linux_x64.zip"

# Diretório de instalação (root)
DEST_DIR="/usr/share/pjeoffice-pro"

# Desktop e menu do usuário normal
USER_DESKTOP="$HOME/Desktop"
USER_MENU="$HOME/.local/share/applications"

DESKTOP_FILE_NAME="pjeoffice-pro.desktop"
DESKTOP_FILE_PATH="$USER_DESKTOP/$DESKTOP_FILE_NAME"
MENU_FILE_PATH="$USER_MENU/$DESKTOP_FILE_NAME"

# Verifica se está sendo rodado como root
if [ "$EUID" -ne 0 ]; then
    echo "Este script precisa ser executado como root para instalar o PJe Office Pro."
    exit 1
fi

# Cria diretório de instalação
mkdir -p "$DEST_DIR"

echo "==> Baixando PJe Office Pro..."
wget -c "$PJE_URL" -O /tmp/pjeoffice-pro.zip

echo "==> Extraindo pacote..."
unzip -o /tmp/pjeoffice-pro.zip -d "$DEST_DIR"

# Localiza executável
PJE_SH=$(find "$DEST_DIR" -type f -iname "pjeoffice-pro.sh" | head -n 1)
if [ -z "$PJE_SH" ]; then
    echo "Erro: não foi possível localizar pjeoffice-pro.sh em $DEST_DIR"
    exit 1
fi

chmod +x "$PJE_SH"
echo "Executável encontrado em: $PJE_SH"

# Localiza ícone (ou baixa se não existir)
ICON_FILE=$(find "$DEST_DIR" -type f -iname "*.png" -o -iname "*.jpg" | head -n 1)
if [ -z "$ICON_FILE" ]; then
    ICON_FILE="$DEST_DIR/pje-office.jpg"
    wget -c "https://oabsc.s3.sa-east-1.amazonaws.com/images/201907301559070.jpg" -O "$ICON_FILE"
fi

# --- Parte do usuário normal ---
# Usa su -c ou sudo -u para criar atalhos no home do usuário
USER_NAME=$(logname)  # pega usuário que chamou sudo

sudo -u "$USER_NAME" mkdir -p "$USER_DESKTOP" "$USER_MENU"

create_desktop() {
    local FILE="$1"
    local PJE_SH_PATH="$2"
    local ICON_PATH="$3"
    cat > "$FILE" <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=PJe Office Pro
Comment=Carregador de Certificados
Exec=$PJE_SH_PATH
Icon=$ICON_PATH
Categories=Office;
StartupNotify=false
Terminal=false
EOF
    chmod 777 "$FILE"
}

# Cria atalhos para o usuário
sudo -u "$USER_NAME" bash -c "create_desktop \"$DESKTOP_FILE_PATH\" \"$PJE_SH\" \"$ICON_FILE\""
sudo -u "$USER_NAME" bash -c "create_desktop \"$MENU_FILE_PATH\" \"$PJE_SH\" \"$ICON_FILE\""

echo
echo "======================================================"
echo "Instalação concluída!"
echo "- Executável: $PJE_SH"
echo "- Atalhos criados para o usuário $USER_NAME:"
echo "    Desktop: $DESKTOP_FILE_PATH"
echo "    Menu:    $MENU_FILE_PATH"
echo "======================================================"


