#!/usr/bin/env bash
#
# Baixa e descompacta o PJe Office Pro na home do usuário
#

set -e

# URL do pacote
PJE_URL="https://pje-office.pje.jus.br/pro/pjeoffice-pro-v2.5.16u-linux_x64.zip"

# Diretório de destino dentro do home
DEST_DIR="$HOME/pjeoffice-pro"

# Cria o diretório de destino
mkdir -p "$DEST_DIR"

echo "==> Baixando PJe Office Pro..."
wget -c "$PJE_URL" -O /tmp/pjeoffice-pro.zip

echo "==> Extraindo pacote..."
unzip -o /tmp/pjeoffice-pro.zip -d "$DEST_DIR"

echo
echo "======================================================"
echo "Download e extração concluídos!"
echo "- PJe Office Pro foi descompactado em: $DEST_DIR"
echo "======================================================"
