# 🐳 TOTVS Protheus - SmartClient HTML WebApp (Interface Module)

Este repositório é um componente isolado da arquitetura TOTVS Protheus Modern DevOps [https://github.com/rodrigomicrosiga-devops/totvs-protheus-modern-devops], e isola o ciclo de vida do componente **SmartClient WebApp** dentro da organização **`rodrigomicrosiga-devops`**. Ele funciona sob o padrão *Delivery/Sidecar Container*, desacoplando completamente as atualizações de interface visual do Kernel de execução do AppServer.

---

## 🏗️ Arquitetura de Entrega Dinâmica (Hot-Swap Delivery)

Ao invés de embutir os binários da WebApp estaticamente dentro da imagem do AppServer, este microsserviço limpa e injeta os componentes atualizados do HTML/JS dentro de um volume compartilhado em runtime.

```mermaid
graph TD
    %% Fluxo de Atualização
    A[docker compose up] -->|1. Inicializa Servidor| B[protheus_webapp:10.2.0]
    B -->|2. Roda entrypoint.sh| C[🧹 Limpa Volume Compartilhado]
    C -->|3. Extrai Binários v10.2.0| D[(Volume: webapp_shared_data)]
    
    %% Consumo pelo AppServer
    E[protheus_appserver:24.3.1.5] -->|4. Mapeia Volume Read-Only| D
    E -->|5. Inicializa HTTP/REST| F[Disponibiliza Portal HTTP no Navegador]

    %% Link de Atualização Transparente
    style B fill:#bbf,stroke:#333,stroke-width:2px
    style D fill:#f9f,stroke:#333,stroke-width:2px
    style E fill:#bfb,stroke:#333,stroke-width:2px
```

### 🚀 Vantagens Técnicas do Desacoplamento
* **Atualização Zero-Downtime**: É possível atualizar a versão da interface de tela (ex: migrar de 10.2.0 para uma versão superior) substituindo apenas este container, sem a necessidade de reiniciar o AppServer principal ou derrubar conexões de usuários/Workers em background.

* **Pipeline Isolado**: O build da interface roda de forma independente, gerando imagens leves baseadas em Alpine Linux.

### 🏷️ Rastreabilidade de Build

A tag da imagem publicada permanece fixa entre builds — só muda em uma nova release de versão. Para rastrear qual commit gerou um build específico sem depender da tag, o `pipeline` grava o label `org.opencontainers.image.revision` com o SHA do commit em toda imagem publicada:

```bash
docker inspect --format '{{ index .Config.Labels "org.opencontainers.image.revision" }}' rodrigomicrosiga/webapp-dev:10.2.1
```