## Instalação

Mantenha a energia estável durante todo o processo. Não remova o cartão enquanto a unidade estiver gravando, e nunca instale ou depure enquanto estiver dirigindo.

**Se certifique que o Firmware da sua multimídia está na MU1367 (`MHI2_ER_VWG13_K4525_MU1367`), caso contrário não vai funcionar.**

Esta versão traz o CarPlay Maps VC atualizado e, de forma opcional, o **mapa do Android Auto no painel** (a mesma tela do cockpit, um celular por vez — a instalação do CarPlay não é afetada). A tela de fábrica "AndroidAuto Customization" (que liberava apps de terceiros no Android Auto do rádio, sem relação com esse mapa) foi removida desta Toolbox.

Apenas uma rota de instalação é suportada: o pacote completo do MQB Toolbox.

### CarPlay (igual às versões anteriores)

1. Baixe o arquivo CarPlay_Maps_AndroidAuto_MQB_Toolbox_V2.0.0.zip.
2. Extraia seu conteúdo em uma pasta e depois copie o conteúdo **diretamente para a raiz** de um cartão SD.
3. Insira o cartão e instale ou atualize o MQB Toolbox na unidade (seu Multimídia).
4. Abra a tela verde (GEM) segurando o botão Menu da sua multimídia **Customization → Navigation → Ignore navigation-active status from smartphone**. Depois disso reinicie a unidade segurando o botão liga/desliga até aparecer o logo da VW.
5. Abra o GEM > **Customization → CarPlay Maps VC** e selecione **Install 791 AID 12.3 (AUTO MU)**. O instalador detecta o MU1367 automaticamente.
6. Aguarde por `CPMAP_INSTALL_OK`, em seguida, saia da toolbox e faça **uma reinicialização completa da unidade**. Depois disso reinicie a unidade segurando o botão liga/desliga até aparecer o logo da VW.
7. Conecte o cabo no iPhone, inicie uma rota no Waze / Apple Maps / Google Maps e verifique o mapa do cockpit, o cartão de navegação e os controles do volante.

### Mapa do Android Auto no painel (novo, opcional)

8. Com o cartão ainda na unidade, abra o GEM > **Customization → Android Auto map on the cluster (keeps CarPlay)** e selecione **1. Status** para confirmar que ainda não está instalado, depois **2. Install Android Auto map (+ dual navigation)**.
9. Aguarde por `AAMAP_INSTALL_OK` e reinicie a unidade segurando o botão liga/desliga até aparecer o logo da VW. Mantenha o cartão na unidade: os scripts de Uninstall e Save logs rodam a partir dele.
10. Conecte um celular Android com Android Auto (cabo USB), abra o Google Maps ou o Waze e coloque o painel na visão de mapa pelos controles do volante. O CarPlay com iPhone continua funcionando normalmente — basta desconectar um celular antes de conectar o outro.

**Atualizando de uma versão anterior do MU1367:**

Instale o firmware com MU1367, sites como esses podem ajudar: https://mibsolution.one/index.php/f/17315 e https://mibvault.com/files/MHI2%20-%20HARMAN/Firmware/VW

Segure o botão Menu da multimídia para abrir a atualização do SW, em seguida, selecione **Atualizar**. Aguarde o processo de instalação, vai reiniciar algumas vezes.

Segure o botão Menu da multimídia mais uma vez para se certificar que a versão correta foi instalada.

Agora atualize a multimídia com o toolbox e GEM, baixe a versão [CarPlay_Maps_AndroidAuto_MQB_Toolbox_V2.0.0.zip], extraia para um cartão SD.

Segure o botão Menu da multimídia para abrir a atualização do SW, em seguida, selecione **Atualizar**. Selecione **SD Card**, e aguarde o processo de instalação, vai reiniciar algumas vezes.

## Créditos

Essa Toolbox reúne o trabalho de vários projetos de código aberto:

- **[omonob/MHI2-Carplay-Maps](https://github.com/omonob/MHI2-Carplay-Maps)** — projeto original CarPlay Maps VC.
- **[mathsls/MHI2-Carplay-Maps](https://github.com/mathsls/MHI2-Carplay-Maps)** — fork em que o trabalho de CarPlay deste repositório se baseia.
- **[tomasz-twardzicki/MHI2-Carplay-Maps](https://github.com/tomasz-twardzicki/MHI2-Carplay-Maps)** — porte para MU1367 / 791 AID 12.3, base deste repositório.
- **[MacsInSpace/mib-cluster-map](https://github.com/MacsInSpace/mib-cluster-map)** (GPL-3) — mapa do Android Auto no painel.
- **[Nataliel/MHI2-Maps-Cluster](https://github.com/Nataliel/MHI2-Maps-Cluster)** — payload de CarPlay atualizado e a integração do mapa do Android Auto nesta Toolbox (tela verde, scripts de instalação/desinstalação/status e a remoção da tela de fábrica "AndroidAuto Customization").

Esse projeto é independente e não tem vínculo com a Volkswagen AG, Škoda Auto, Apple Inc. ou Google LLC. Cada componente de terceiros mantém sua licença original.
