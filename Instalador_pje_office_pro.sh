#!/usr/bin/env bash
#
# Instalação do PJe Office Pro 2.5.16u com atalho e ícone
#

set -e

PJE_URL="https://pje-office.pje.jus.br/pro/pjeoffice-pro-v2.5.16u-linux_x64.zip"
ICON_URL="https://oabsc.s3.sa-east-1.amazonaws.com/images/201907301559070.jpg"
DEST_DIR="/usr/share/pjeoffice-pro"
ICON_FILE="$DEST_DIR/pjeoffice-icon.jpg"
DESKTOP_FILE="/usr/share/applications/pjeoffice-pro.desktop"
USER_DESKTOP="$HOME/Área de Trabalho/pjeoffice-pro.desktop"

echo "==> Baixando PJe Office Pro..."
wget -c "$PJE_URL" -O /tmp/pjeoffice-pro.zip

echo "==> Criando diretório destino $DEST_DIR..."
mkdir -p "$DEST_DIR"

echo "==> Extraindo pacote..."
unzip -o /tmp/pjeoffice-pro.zip -d "$DEST_DIR"

echo "==> Verificando criação do pjeoffice-pro.sh..."
# Espera até 10 segundos o arquivo surgir após a extração
for i in {1..10}; do
    if [ -f "$DEST_DIR/pjeoffice-pro.sh" ]; then
        echo "Arquivo encontrado!"
        sudo chmod +x "$DEST_DIR/pjeoffice-pro.sh"
        break
    fi
    sleep 1
done

# Se mesmo assim não encontrou, aborta
if [ ! -x "$DEST_DIR/pjeoffice-pro.sh" ]; then
    echo "Erro: pjeoffice-pro.sh não encontrado em $DEST_DIR"
    exit 1
fi

echo "==> Baixando ícone..."
wget -c "$ICON_URL" -O "$ICON_FILE"

echo "==> Criando arquivo .desktop..."
cat > "$DESKTOP_FILE" <<EOF
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

chmod +x "$DESKTOP_FILE"

# Copiar atalho para a Área de Trabalho, se a pasta existir
if [ -d "$HOME/Área de Trabalho" ]; then
    cp "$DESKTOP_FILE" "$USER_DESKTOP"
    chmod +x "$USER_DESKTOP"
    echo "==> Atalho criado na Área de Trabalho."
fi

echo
echo "======================================================"
echo "Instalação concluída!"
echo "- Menu de aplicativos: PJe Office Pro"
echo "- Ícone: $ICON_FILE"
echo "- Atalho criado na Área de Trabalho (se a pasta existir)."
echo "======================================================"

