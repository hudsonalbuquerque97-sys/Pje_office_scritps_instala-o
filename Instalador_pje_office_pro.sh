v#!/usr/bin/env bash
#
# Instalação do PJe Office Pro 2.5.16u (sem root)
#
set -euo pipefail

# ---------- Config ----------
PJE_URL="https://pje-office.pje.jus.br/pro/pjeoffice-pro-v2.5.16u-linux_x64.zip"
# PNG público confiável para ícone. Se preferir usar outro, altere aqui.
ICON_URL="https://upload.wikimedia.org/wikipedia/commons/4/44/Icon_document-png.png"

WORK_ZIP="/tmp/pjeoffice-pro.zip"
DEST_DIR="$HOME/pjeoffice-pro"
ICON_FILE="$DEST_DIR/pje-office.png"

MENU_DIR="$HOME/.local/share/applications"
DESKTOP_FILE_NAME="pjeoffice-pro.desktop"

# ---------- Segurança: não rodar como root ----------
if [ "$(id -u)" -eq 0 ]; then
    echo "ERRO: este script deve ser executado COMO USUÁRIO (sem sudo)."
    echo "Você pode rodar como seu usuário comum; o script instala tudo em \$HOME."
    exit 1
fi

# ---------- Detecta Desktop real (XDG) com fallbacks ----------
DESKTOP_DIR="$(xdg-user-dir DESKTOP 2>/dev/null || true)"
if [ -z "$DESKTOP_DIR" ] || [ ! -d "$DESKTOP_DIR" ]; then
    # fallback common names
    if [ -d "$HOME/Desktop" ]; then
        DESKTOP_DIR="$HOME/Desktop"
    elif [ -d "$HOME/Área de Trabalho" ]; then
        DESKTOP_DIR="$HOME/Área de Trabalho"
    else
        # cria ~/Desktop como fallback
        DESKTOP_DIR="$HOME/Desktop"
        mkdir -p "$DESKTOP_DIR"
    fi
fi

# ---------- Cria pastas ----------
mkdir -p "$DEST_DIR" "$MENU_DIR" "$DESKTOP_DIR"

echo "Usuário: $(whoami)"
echo "Instalando em: $DEST_DIR"
echo "Desktop: $DESKTOP_DIR"
echo "Menu (user): $MENU_DIR"

# ---------- Baixa e extrai ----------
echo "==> Baixando pacote PJe Office..."
wget -c "$PJE_URL" -O "$WORK_ZIP"

echo "==> Extraindo para $DEST_DIR..."
unzip -o "$WORK_ZIP" -d "$DEST_DIR"

# ---------- Localiza executável ----------
PJE_SH="$(find "$DEST_DIR" -type f -iname "pjeoffice-pro.sh" | head -n 1 || true)"
if [ -z "$PJE_SH" ]; then
    echo "Erro: não localizei pjeoffice-pro.sh em $DEST_DIR"
    exit 1
fi
echo "Executável encontrado em: $PJE_SH"

# ---------- Permissão ----------
echo "==> Ajustando permissão de execução (usuario)..."
chmod +x "$PJE_SH"

# ---------- Ícone ----------
echo "==> Baixando ícone PNG..."
wget -c "$ICON_URL" -O "$ICON_FILE"

# Se preferir usar o ícone que já veio no pacote (ex.: pje-office.jpg/png), podemos priorizar:
# local_icon_candidate=$(find "$DEST_DIR" -type f -iname "pje*office*.png" -o -iname "pje*office*.jpg" | head -n1 || true)
# if [ -n "$local_icon_candidate" ]; then
#     cp "$local_icon_candidate" "$ICON_FILE"
# fi

# ---------- Cria .desktop (Desktop + Menu user) ----------
DESKTOP_PATH_FILE="$DESKTOP_DIR/$DESKTOP_FILE_NAME"
MENU_PATH_FILE="$MENU_DIR/$DESKTOP_FILE_NAME"

create_desktop() {
    local file="$1"
    cat > "$file" <<EOF
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
    chmod +x "$file"
}

echo "==> Criando atalho na Desktop..."
create_desktop "$DESKTOP_PATH_FILE"

echo "==> Criando atalho no menu do usuário..."
create_desktop "$MENU_PATH_FILE"

echo
echo "======================================================"
echo "Instalação concluída (sem root)!"
echo "- Arquivos em: $DEST_DIR"
echo "- Executável: $PJE_SH"
echo "- Atalhos criados:"
echo "    Desktop: $DESKTOP_PATH_FILE"
echo "    Menu:    $MENU_PATH_FILE"
echo "======================================================"

