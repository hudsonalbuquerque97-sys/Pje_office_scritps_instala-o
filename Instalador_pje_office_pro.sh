#!/usr/bin/env bash
#
# Instalação do PJe Office Pro 2.5.16u com atalho e ícone (no home)
#

set -e

PJE_URL="https://pje-office.pje.jus.br/pro/pjeoffice-pro-v2.5.16u-linux_x64.zip"
ICON_URL="https://oabsc.s3.sa-east-1.amazonaws.com/images/201907301559070.jpg"
DEST_DIR="$HOME/pjeoffice-pro"
ICON_FILE="$DEST_DIR/pje-office.jpg"

# Diretórios de atalho
DESKTOP_DIR="$HOME/Desktop"
MENU_DIR="$HOME/.local/share/applications"
DESKTOP_FILE_NAME="pjeoffice-pro.desktop"
DESKTOP_FILE_PATH="$DESKTOP_DIR/$DESKTOP_FILE_NAME"
MENU_FILE_PATH="$MENU_DIR/$DESKTOP_FILE_NAME"

# Cria diretórios necessários
mkdir -p "$DEST_DIR" "$DESKTOP_DIR" "$MENU_DIR"

echo "==> Baixando PJe Office Pro..."
wget -c "$PJE_URL" -O /tmp/pjeoffice-pro.zip

echo "==> Extraindo pacote..."
unzip -o /tmp/pjeoffice-pro.zip -d "$DEST_DIR"

# Localiza executável
PJE_SH=$(find "$DEST_DIR" -type f -name "pjeoffice-pro.sh" | head -n 1)

if [ -z "$PJE_SH" ]; then
    echo "Erro: não foi possível localizar pjeoffice-pro.sh dentro de $DEST_DIR"
    exit 1
fi

echo "Executável encontrado em: $PJE_SH"

echo "==> Ajustando permissões de execução..."
chmod +x "$PJE_SH"

echo "==> Baixando ícone..."
wget -c "$ICON_URL" -O "$ICON_FILE"

# --- Cria arquivo .desktop ---
for FILE in "$DESKTOP_FILE_PATH" "$MENU_FILE_PATH"; do
    cat > "$FILE" <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=PJe Office Pro
Comment=Carregador de Certificados
Exec=$PJE_SH
Icon=$ICON_FILE
Categories=Office;
StartupNotify=false
Terminal=false
EOF
    chmod +x "$FILE"
done

echo "==> Atalho criado em $DESKTOP_DIR e no menu de aplicativos"

echo
echo "======================================================"
echo "Instalação concluída!"
echo "- Menu de aplicativos: PJe Office Pro"
echo "- Executável usado: $PJE_SH"
echo "- Atalho criado em: $DESKTOP_DIR"
echo "======================================================"
