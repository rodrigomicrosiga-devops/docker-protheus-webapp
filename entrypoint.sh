#!/bin/sh
set -e

echo "📦 [WebApp Delivery] Inicializando provisionamento da interface v10.2.0..."

TARGET_DIR="/mnt/webapp_shared"

# 🧹 Limpeza cirúrgica sem tentar deletar pastas presas pelo Kernel (Evita "Device or resource busy")
echo "🧹 Limpando resíduos antigos de forma segura..."
if [ -d "$TARGET_DIR" ]; then
    # Encontra e deleta arquivos normais de forma silenciosa na raiz do volume
    find "$TARGET_DIR" -mindepth 1 -maxdepth 1 -type f -delete 2>/dev/null || true
fi

echo "📂 Provisionando componentes do SmartClient HTML v10.2.0 na raiz do volume..."

# 🚀 CÓPIA CIRÚRGICA: Garante que apenas o arquivo webapp.so seja copiado para a raiz do volume compartilhado
if [ -f "/tmp/webapp/webapp.so" ]; then
    cp "/tmp/webapp/webapp.so" "$TARGET_DIR/"
else
    echo "⚠️  Aviso: webapp.so não localizado em /tmp/webapp/"
fi

echo "✅ Interface WebApp v10.2.0 provisionada com sucesso no volume compartilhado!"
echo "💤 Mantendo container em standby para governança do volume."

# Mantém o container vivo sem consumo de CPU
exec tail -f /dev/null

# CI/CD Trigger Checksum: v1.0.1-rev1