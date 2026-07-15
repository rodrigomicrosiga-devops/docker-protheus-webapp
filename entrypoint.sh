#!/bin/sh
set -e

echo "📦 [WebApp Delivery] Inicializando provisionamento da interface v10.2.0..."

TARGET_DIR="/mnt/webapp_shared"

# 🧹 Limpeza cirúrgica sem tentar deletar pastas presas pelo Kernel (Evita "Device or resource busy")
echo "🧹 Limpando resíduos antigos de forma segura..."
if [ -d "$TARGET_DIR" ]; then
    # Encontra e deleta arquivos normais de forma silenciosa. 
    # Pastas que estiverem ocupadas pelo AppServer/Kernel serão ignoradas sem travar o script.
    find "$TARGET_DIR" -mindepth 1 -maxdepth 3 -type f -delete 2>/dev/null || true
fi

echo "📂 Provisionando componentes do SmartClient HTML v10.2.0 na raiz do volume..."
# Copia recursivamente os arquivos limpos que estão em /tmp/webapp para a pasta de destino
cp -r /tmp/webapp/* "$TARGET_DIR/" 2>/dev/null || cp -r /tmp/webapp/. "$TARGET_DIR/"

echo "✅ Interface WebApp v10.2.0 provisionada com sucesso no volume compartilhado!"
echo "💤 Mantendo container em standby para governança do volume."

# Mantém o container vivo sem consuming de CPU
exec tail -f /dev/null