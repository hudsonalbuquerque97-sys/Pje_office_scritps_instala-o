#!/usr/bin/env bash
#
# Instalação do PJe Office Pro 2.5.16u no home (sem root)
#

set -e

# URLs
PJE_URL="https://pje-office.pje.jus.br/pro/pjeoffice-pro-v2.5.16u-linux_x64.zip"
ICON_URL="https://oabsc.s3.sa-east-1.amazonaws.com/images/201907301559070.jpg"

# Diretórios no home
DEST_DIR="$HOME/pjeoffice-pro"
DESKTOP_DIR="$HOME/Desktop"
MENU_DIR="$HOME/.local/share/applications"

# Arquivos de atalho
DESKTOP_FILE="$DESKTOP_DIR/pjeoffice-pro.desktop"
MENU_FILE="$MENU_DIR/pjeoffice-pro.desktop"

# Cria diretórios necessários
mkdir -p "$DEST_DIR" "$DESKTOP_DIR" "$MENU_DIR"

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

# Localiza ícone no pacote ou baixa se não existir
ICON_FILE=$(find "$DEST_DIR" -type f -iname "*.png" -o -iname "*.jpg" | head -n 1)
if [ -z "$ICON_FILE" ]; then
    echo "Ícone não encontrado no pacote, baixando..."
    ICON_FILE="$DEST_DIR/pje-office.jpg"
    wget -c "$ICON_URL" -O "$ICON_FILE"
fi

# Ajusta permissões
chmod -R 777 "$DEST_DIR"
chmod 777 "$PJE_SH"

# Função para criar atalhos .desktop
create_desktop() {
    local FILE="$1"
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
    chmod 777 "$FILE"
}

echo "==> Criando atalhos..."
create_desktop "$DESKTOP_FILE"
create_desktop "$MENU_FILE"

echo
echo "======================================================"
echo "Instalação concluída!"
echo "- Executável: $PJE_SH"
echo "- Atalhos criados:"
echo "    Desktop: $DESKTOP_FILE"
echo "    Menu:    $MENU_FILE"
echo "======================================================"

