#!/usr/bin/env bash
#
# Instalação do PJe Office Pro 2.5.16u com atalho e ícone
#

set -e

PJE_URL="https://pje-office.pje.jus.br/pro/pjeoffice-pro-v2.5.16u-linux_x64.zip"
ICON_URL="https://www.trt13.jus.br/informe-se/noticias/2017/04/usuarios-externos-podem-participar-da-homologacao-da-nova-versao-do-pje/pje-logo.png/@@images/image.png"
DEST_DIR="/usr/share/pjeoffice-pro"
ICON_FILE="$DEST_DIR/pjeoffice-icon.png"
DESKTOP_FILE="/usr/share/applications/pjeoffice-pro.desktop"
USER_DESKTOP="$HOME/Área de Trabalho/pjeoffice-pro.desktop"

echo "==> Baixando PJe Office Pro..."
wget -c "$PJE_URL" -O /tmp/pjeoffice-pro.zip

echo "==> Criando diretório destino $DEST_DIR..."
mkdir -p "$DEST_DIR"

echo "==> Extraindo pacote..."
unzip -o /tmp/pjeoffice-pro.zip -d "$DEST_DIR"

echo "==> Localizando arquivo executável real..."
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

# --- Parte final: renomear a pasta e criar o atalho ---
USER_HOME=$(eval echo "~$SUDO_USER")
ORIG_DESKTOP="$USER_HOME/Área de Trabalho"
NEW_DESKTOP="$USER_HOME/Desktop"

# Renomeia a pasta se existir
if [ -d "$ORIG_DESKTOP" ]; then
    mv "$ORIG_DESKTOP" "$NEW_DESKTOP"
    echo "Pasta renomeada de 'Área de Trabalho' para 'Desktop'."
fi

# Cria o atalho na nova pasta Desktop
if [ -d "$NEW_DESKTOP" ]; then
    DESKTOP_FILE_PATH="$NEW_DESKTOP/pjeoffice-pro.desktop"

    cat > "$DESKTOP_FILE_PATH" <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=PJe Office Pro
Comment=Carregador de Certificados
Exec=/usr/share/pjeoffice-pro/pjeoffice-pro/pjeoffice-pro.sh
Icon=/usr/share/pjeoffice-pro/pje-office.png
Categories=Office;
StartupNotify=false
Terminal=false
EOF

    chmod +x "$DESKTOP_FILE_PATH"
    echo "==> Atalho criado em $NEW_DESKTOP"
else
    echo "==> Pasta Desktop não encontrada. Atalho criado apenas no menu de aplicativos."
fi

echo
echo "======================================================"
echo "Instalação concluída!"
echo "- Menu de aplicativos: PJe Office Pro"
echo "- Executável usado: $PJE_SH"
echo "======================================================"
