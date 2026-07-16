# ==============================================================================
# ESTÁGIO 1: Builder (Extração e Limpeza por Strip)
# ==============================================================================
FROM alpine:3.19 AS builder

RUN apk add --no-cache tar binutils

WORKDIR /tmp/build

# 🌟 SUPORTE DINÂMICO: Copia apenas o instalador da WebApp com tolerância de caixa no nome
COPY ./*[wW][eE][bB][aA][pP][pP]*.[tT][aA][rR].[gG][zZ] ./webapp.tar.gz

RUN mkdir -p webapp && \
    tar -xzf webapp.tar.gz -C webapp/

# ⚡ A MÁGICA DO STRIP: Remove símbolos de depuração recursivamente se houver libs compiladas (.so) no pacote
RUN find webapp/ -type f -name "*.so*" -exec strip --strip-unneeded {} + 2>/dev/null || true

# ==============================================================================
# ESTÁGIO 2: Runner (Imagem Enxuta de Delivery)
# ==============================================================================
FROM alpine:3.19 AS runner
LABEL maintainer="Rodrigo dos Santos Brandão <rodrigomicrosiga>" \
      version="10.2.1" \
      description="TOTVS Protheus SmartClient HTML WebApp Module - Delivery Container - Ultra Light"

# Instala o tar para garantir a descompactação/manuseio de arquivos adicionais se necessário
RUN apk add --no-cache tar

WORKDIR /tmp

# Cria o ponto de montagem do volume compartilhado
RUN mkdir -p /mnt/webapp_shared

# Copia os arquivos limpos e otimizados pelo builder para o runner
COPY --from=builder /tmp/build/webapp /tmp/webapp

COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]