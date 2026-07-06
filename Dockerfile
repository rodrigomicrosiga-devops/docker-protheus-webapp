FROM alpine:3.19
LABEL maintainer="Rodrigo dos Santos Brandão <rodrigomicrosiga>" \
      version="10.2.0" \
      description="TOTVS Protheus SmartClient HTML WebApp Module - Delivery Container"

WORKDIR /tmp

# Instala o tar para garantir a descompactação correta
RUN apk add --no-cache tar

# Cria o ponto de montagem do volume compartilhado
RUN mkdir -p /mnt/webapp_shared

# Copia o pacote proprietário e o script de entrega
COPY ./webapp.tar.gz /tmp/webapp.tar.gz
COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]