#!/bin/sh
set -e

echo "📦 [WebApp Delivery] Inicializando provisionamento da interface v10.2.0..."

TARGET_DIR="/mnt/webapp_shared"

# Limpa resíduos de versões antigas para garantir uma atualização limpa (Hot-Swap)
echo "🧹 Limpando diretório de destino..."
rm -rf ${TARGET_DIR:?}/*

echo "📂 Extraindo componentes do SmartClient HTML v10.2.0 na raiz do volume..."
# --strip-components=1 remove o nível de pasta interna do arquivo compactado e extrai os arquivos soltos
tar -xzf /tmp/webapp.tar.gz --strip-components=1 -C "$TARGET_DIR"

echo "✅ Interface WebApp v10.2.0 provisionada com sucesso no volume compartilhado!"
echo "💤 Mantendo container em standby para governança do volume."

# Mantém o container vivo sem consumir CPU
exec tail -f /dev/null