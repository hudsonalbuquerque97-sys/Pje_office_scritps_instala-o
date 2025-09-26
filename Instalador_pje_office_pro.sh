#!/usr/bin/env bash
set -e

PJE_URL="https://pje-office.pje.jus.br/pro/pjeoffice-pro-v2.5.16u-linux_x64.zip"
ICON_URL="https://oabsc.s3.sa-east-1.amazonaws.com/images/201907301559070.jpg"
DEST_DIR="/usr/share/pjeoffice-pro"
ICON_FILE="$DEST_DIR/pjeoffice-icon.jpg"
DESKTOP_FILE="/usr/share/applications/pjeoffice-pro.desktop"

echo "==> Baixando PJe Office Pro..."
wget -c "$PJE_URL" -O /tmp/pjeoffice-pro.zip

echo "==> Criando diretório destino $DEST_DIR..."
sudo mkdir -p "$DEST_DIR"

echo "==> Extraindo pacote..."
sudo unzip -o /tmp/pjeoffice-pro.zip -d "$DEST_DIR"

echo "==> Baixando ícone..."
sudo wget -c "$ICON_URL" -O "$ICON_FILE"

echo "==> Ajustando permissões..."
sudo chmod +x "$DEST_DIR/pjeoffice-pro.sh"

echo "==> Criando arquivo .desktop..."
sudo tee "$DESKTOP_FILE" >/dev/null <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=PJe Office Pro
Comment=Carregador de Certificados
Exec=$DEST_DIR/pjeoffice-pro.sh
Icon=$ICON_FILE
Categories=Office;
StartupNotify=false
Terminal=false
EOF

sudo chmod +x "$DESKTOP_FILE"

# Copiar atalho para a Área de Trabalho usando XDG
DESKTOP_PATH="$(xdg-user-dir DESKTOP)"
if [ -d "$DESKTOP_PATH" ]; then
    cp "$DESKTOP_FILE" "$DESKTOP_PATH/pjeoffice-pro.desktop"
    chmod +x "$DESKTOP_PATH/pjeoffice-pro.desktop"
    echo "==> Atalho criado em $DESKTOP_PATH"
else
    echo "==> Pasta de área de trabalho não encontrada."
fi
