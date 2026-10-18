<div align="right">
  <a href="#english-version">English</a> | <a href="#portuguese-version">Português</a>
</div>

<!-- Portuguese Version -->
<a id="portuguese-version"></a>
<div align="center">

# CarPlay Maps VC para MHI2: MU1427 / AID 791

**Mapa do Apple CarPlay e Waze com cartão de navegação curva a curva no Volkswagen Active Info Display (cockpit virtual), para firmware MHI2 MU1367 / AID 791.**

[![License](https://img.shields.io/badge/license-GPL--3.0-blue?style=flat-square)](LICENSE)
![Platform](https://img.shields.io/badge/platform-MHI2%20%2F%20QNX%206.5-2f6f9f?style=flat-square)
![Firmware](https://img.shields.io/badge/firmware-MU1427-green?style=flat-square)
![Cluster](https://img.shields.io/badge/cluster-791%20AID%2012.3-green?style=flat-square)

[Download](#download-pt) · [Instalação](#installation-pt) · [Opções de Exibição](#display-options-pt) · [Diagnóstico](#diagnostics-pt) · [Estrutura do Repositório](#repository-layout-pt) · [Origem](#origin-and-upstream-project-pt) · [Aviso de Código Aberto](#open-source-notice-pt) · [Aviso Legal](#disclaimer-pt)

Este projeto é um fork de **[tomasz-twardzicki](https://github.com/tomasz-twardzicki)** e foi desenvolvido por ele. É baseado no projeto original [CarPlay Maps VC](https://github.com/omonob/MHI2-Carplay-Maps) de **[omonob (汽车大玩家)](https://github.com/omonob)**.

</div>

---

> [!WARNING]
> **Use inteiramente por sua conta e risco.** Este projeto modifica arquivos na unidade de infoentretenimento do seu carro. Uma instalação falha ou interrompida pode deixar a unidade incapaz de inicializar. Todo o código, scripts e pacotes são fornecidos "como estão", sem garantia de qualquer tipo. Nem o autor original nem os contribuidores deste fork são responsáveis por quaisquer danos, mau funcionamento, perda de dados, garantia ou consequências legais, ou qualquer outra coisa que resulte do uso. Consulte [Aviso Legal](#disclaimer-pt).

## <a id="overview-pt"></a>Visão Geral

Este fork leva o projeto CarPlay Maps VC para unidades MHI2 com firmware **MU1367** e o cockpit virtual **791 AID 12.3**. A versão original não funciona neste firmware.

Ele envia o vídeo do mapa do CarPlay para o cockpit, desenha o cartão de navegação do Apple Maps. Tudo é enviado como um pacote MQB Toolbox pronto para extração.

## <a id="features-pt"></a>Recursos (MU1367 / 791)

- **Mapa do CarPlay no cockpit virtual.** A pilha AirPlay mais antiga do MU1367 mantém a chave AES do fluxo do cluster em um offset diferente. `core.so` é corrigido para corresponder; sem isso, cada quadro é descriptografado como lixo.
- **Cartão de navegação curva a curva.** O iPhone desenha o cartão de próxima manobra do Apple Maps (seta e distância) no mapa do cockpit, com o nome da rua ao lado do carro. O cartão fica logo abaixo da barra do relógio.
- **Fluxo suave.** O fluxo do cockpit solicita 40 fps, o que removeu a gagueira e o atraso vistos no carro.
- **Controle pelo volante:** toque curto para ampliar o mapa, toque longo para alternar as visualizações do mapa (do projeto original).
- **Status, diagnóstico e restauração** no menu da toolbox.

Não incluído: metadados de música ou capa do álbum, e navegação curva a curva mostrada nos próprios gráficos de navegação do cockpit (setas estilo VW). O cartão de navegação faz parte do vídeo do CarPlay, desenhado pelo iPhone.

## <a id="compatibility-pt"></a>Compatibilidade

|          | Suportado                                                                                                |
|----------|----------------------------------------------------------------------------------------------------------|
| Firmware | **MU1367** (`MHI2_ER_VWG13_K4525_MU1367`), identificado por `/ifs/lsd.jxe` = **55,840,541 bytes**        |
| Cluster  | **791 AID 12.3**                                                                                         |
| Telefone | iPhone via USB. Testado com iPhone15 Pro no iOS 27.0.1; o cartão de navegação precisa de um iOS recente. |
| Carro    | Passat B8 2018                                                                                           |

O instalador verifica o tamanho exato do firmware e o perfil do cluster, e para antes de alterar qualquer arquivo de fábrica se eles não corresponderem.

O pacote ainda contém os perfis do projeto original para outros firmwares ([veja abaixo](#origin-and-upstream-project-pt)). Este fork não os alterou nem os retestou.

## <a id="download-pt"></a>Download

**MQB Toolbox V4.2A com CarPlay Maps VC:** Download direto: [CarPlay_Maps_Waze_MQB_Toolbox_V1.1.0.zip](https://github.com/Nataliel/MHI2-Carplay-Maps/download/releases/CarPlay_Maps_Waze_MQB_Toolboxes/CarPlay_Maps_Waze_MQB_Toolbox_V1.1.0.zip)

## <a id="installation-pt"></a>Instalação

Mantenha a energia estável durante todo o processo. Não remova o cartão enquanto a unidade estiver gravando, e nunca instale ou depure enquanto estiver dirigindo.

**Se certifique que o Firmware da sua multimidia está na com a MU1367 (`MHI2_ER_VWG13_K4525_MU1367`), caso contrario não vai funcionar.**

Apenas uma rota de instalação é suportada: o pacote completo do MQB Toolbox.

1. Baixe o arquivo CarPlay_Maps_Waze_MQB_Toolbox_V1.1.0.zip.
2. Extraia seu conteúdo em uma pasta e depois copie o conteudo **diretamente para a raiz** de um cartão SD.
3. Insira o cartão e instale ou atualize o MQB Toolbox na unidade (seu Multimidia).
4. Abra **Customization → Navigation → Ignore navigation-active status from smartphone**. Depois disso reinicie a unidade segurando o botão liga/desliga até aparecer o logo da VW.
5. Abra **Customization → CarPlay Maps VC** e selecione **Install 791 AID 12.3 (AUTO MU)**. O instalador detecta o MU1367 automaticamente.
6. Aguarde por `CPMAP_INSTALL_OK`, em seguida, saia da toolbox e faça **uma reinicialização completa da unidade**. Depois disso reinicie a unidade segurando o botão liga/desliga até aparecer o logo da VW.
7. Conecte o cabo no iPhone, inicie uma rota no Waze / Apple Maps / Google Maps e verifique o mapa do cockpit, o cartão de navegação e os controles do volante.


**Atualizando de uma versão anterior do MU1367:** 

Instale o firmware com MU1367, sites como esses podem ajudar: https://mibsolution.one/index.php/f/17315 e https://mibvault.com/files/MHI2%20-%20HARMAN/Firmware/VW

Segure o botão Menu da multimidia para abrir a atualização do SW, em seguida, selecione **Atualizar**. Aguarde o processo de instalação, vai reiniciar algumas vezes.

Segure o botão Menu da multimidia mais uma vez para se certificar que a versão correta foi instalada.

Agora atualize a toolbox do novo pacote, baixe a versão [CarPlay_Maps_Waze_MQB_Toolbox_V1.1.0.zip], extrai para um cartão SD.

Segure o botão Menu da multimidia para abrir a atualização do SW, em seguida, selecione **Atualizar**. Selecione **SD Card**, e aguarde o processo de instalação, vai reiniciar algumas vezes.

## <a id="diagnostics-pt"></a>Diagnóstico e restauração

- **Coletar diagnósticos para SD:** grava `Log/cpmap-diag-<time>/` no cartão, sem modificar a unidade. Execute-o antes de reiniciar, porque os logs de tempo de execução vivem em `/ramdisk` e são limpos na reinicialização.
- **Mostrar status do CarPlay Maps VC:** firmware, perfil instalado e opção de exibição ativa.
- **Restaurar arquivos de fábrica:** coloca os arquivos `dio_manager` e `lsd.sh` de fábrica de volta e remove o tempo de execução. Uma reinicialização completa é necessária depois.

## <a id="origin-and-upstream-project-pt"></a>Origem e Projeto Upstream

O CarPlay Maps VC foi criado por **[omonob (汽车大玩家 / QCDWJ)](https://github.com/omonob)**: o tempo de execução do vídeo do mapa, os controles do volante, os instaladores e a integração original da toolbox. O projeto original está em **[github.com/omonob/MHI2-Carplay-Maps](https://github.com/omonob/MHI2-Carplay-Maps)**.

A versão original suporta as seguintes combinações de firmware e cluster:

| Firmware | Tamanho exato de `lsd.jxe` | 791/794 AID 12.3 | 790 AID 10.5 |
| --- | ---: | :---: | :---: |
| MU1102 | 55.915.411 bytes | ✅ | ✅ |
| MU1367 | 55.840.541 bytes | ✅ | ✅ |
| MU1440 Škoda | 55.840.933 bytes | ❌ | ✅ |

Esses perfis ([`MU1102/`](./MU1102/), [`MU1367/`](./MU1367/), [`MU1440_SKODA/`](./MU1440_SKODA/)) são mantidos aqui inalterados do upstream. Para eles, use o projeto original e seus lançamentos.

## <a id="open-source-notice-pt"></a>Aviso de Código Aberto

- Autor original do CarPlay Maps VC: **omonob (QCDWJ)**. Adaptação MU1427, opções de exibição e documentação neste fork: **tomasz-twardzicki**. Adaptação MU1367, com Waze e Google Maps estaveis: **Nataliel**.
- Os scripts de integração, lógica de compilação e documentação são licenciados sob a [GNU GPL v3](LICENSE). A redistribuição deve manter a atribuição e os termos da licença e fornecer o código-fonte correspondente conforme exigido pela GPLv3.
- MQB Toolbox, Volkswagen, Škoda, Apple, CarPlay, Apple Maps e outros componentes, nomes e marcas registradas de terceiros pertencem aos seus respectivos proprietários. A GPLv3 não relicencia firmware, toolbox ou componentes de fornecedores de terceiros.
- O toolbox completo é fornecido apenas para fornecer um layout de cartão SD pronto para uso; arquivos upstream e avisos de licença são mantidos intactos.
- Nenhuma senha específica da unidade, chaves privadas, K1/K2, `shadow`, texto cifrado NAVDB ou dados vinculados ao veículo são publicados.
- Este é um projeto comunitário independente. Não é afiliado ou endossado pela Volkswagen AG, Škoda Auto, Harman ou Apple Inc.

## <a id="disclaimer-pt"></a>Aviso Legal

**Todo o uso deste código, scripts e pacotes é por sua conta e risco.**

- A modificação do software de infoentretenimento pode fazer com que a unidade não inicialize, desative funções, anule garantias ou entre em conflito com regulamentações locais.
- Confirme seu firmware e cluster exatos, mantenha a energia estável e tenha uma rota de recuperação testada antes de instalar.
- Nunca instale, configure ou depure enquanto estiver dirigindo, e nunca deixe a tela do cockpit distraí-lo da estrada.

O software é fornecido "como está", sem garantia de qualquer tipo, expressa ou implícita. Em nenhum caso o autor original, os mantenedores ou qualquer colaborador serão responsáveis por qualquer reclamação, dano ou outra responsabilidade decorrente, de ou em conexão com o software ou seu uso. Isso se aplica a qualquer coisa que resulte dele, incluindo danos a veículos, hardware, software ou dados, e quaisquer lesões pessoais, perdas financeiras ou consequências legais.

---

<div align="center">

Fork MU1427 / AID 791 por **[tomasz-twardzicki](https://github.com/tomasz-twardzicki)** · Baseado no CarPlay Maps VC gratuito e de código aberto por **[omonob (QCDWJ)](https://github.com/omonob)** · GPL-3.0

</div>

---
---

<a id="english-version"></a>
<!-- English Version -->
<div align="right">
  <a href="#portuguese-version">Leia em Português</a> | <a href="#english-version">English</a>
</div>

<div align="center">

# CarPlay Maps VC for MHI2: MU1427 / AID 791

**Apple CarPlay map with turn-by-turn card on the Volkswagen Active Info Display (virtual cockpit), for MHI2 firmware MU1427.**

[![License](https://img.shields.io/badge/license-GPL--3.0-blue?style=flat-square)](LICENSE)
![Platform](https://img.shields.io/badge/platform-MHI2%20%2F%20QNX%206.5-2f6f9f?style=flat-square)
![Firmware](https://img.shields.io/badge/firmware-MU1427-green?style=flat-square)
![Cluster](https://img.shields.io/badge/cluster-791%20AID%2012.3-green?style=flat-square)

[Download](#download-en) · [Install](#installation-en) · [Display options](#display-options-en) · [Diagnostics](#diagnostics-en) · [Repository layout](#repository-layout-en) · [Origin](#origin-and-upstream-project-en) · [Open-source notice](#open-source-notice-en) · [Disclaimer](#disclaimer-en)

**MU1427 development: [tomasz-twardzicki](https://github.com/tomasz-twardzicki)** · Based on [CarPlay Maps VC](https://github.com/omonob/MHI2-Carplay-Maps) by **[omonob (汽车大玩家)](https://github.com/omonob)**

</div>

---

> [!WARNING]
> **Use entirely at your own risk.** This project modifies files on your car's infotainment unit. A failed or interrupted install can leave the unit unable to boot. All code, scripts and packages are provided as-is, without warranty of any kind. Neither the original author nor the contributors of this fork are responsible for any damage, malfunction, data loss, warranty or legal consequences, or anything else that results from using them. See [Disclaimer](#disclaimer-en).

## <a id="overview-en"></a>Overview

This fork carries the CarPlay Maps VC project to MHI2 units on firmware **MU1427** with the **791 AID 12.3** virtual cockpit. The original release doesn't work on this firmware.

It sends the CarPlay map video to the cockpit, draws Apple Maps' turn card on it, and fixes the "Ignore navigation-active" patch for MU1427. Everything ships as one ready-to-extract MQB Toolbox package.

## <a id="features-en"></a>Features (MU1427 / 791)

- **CarPlay map on the virtual cockpit.** MU1427's older AirPlay stack (210.81) keeps the cluster stream's AES key at a different offset. `core.so` is patched to match; without that, every frame decrypts to garbage.
- **Turn-by-turn card.** The iPhone draws Apple Maps' next-maneuver card (arrow and distance) on the cockpit map, with the road name next to the car. The card sits just under the clock bar.
- **Smooth stream.** The cockpit stream requests 30 fps instead of 40, which removed the stutter and lag seen in the car.
- **Display options in the toolbox menu:** the default narrow turn card, a wide turn card, or map only.
- **Steering-wheel control:** short press to zoom the map, long press to switch map views (from the original project).
- **"Ignore navigation-active" for MU1427:** keeps the factory navigation map running in the cockpit while CarPlay navigates. The toolbox's generic patch stops CarPlay from starting on MU1427, so this package includes a build made from MU1427's own HMI classes. The install script picks it automatically.
- **Status, diagnostics and restore** entries in the toolbox menu.

Not included: music metadata or cover art, and turn-by-turn shown in the cockpit's own navigation graphics (VW-style arrows). The turn card is part of the CarPlay video, drawn by the iPhone.

## <a id="compatibility-en"></a>Compatibility

| | Supported |
| --- | --- |
| Firmware | **MU1427** (`MHI2_ER_VWG11_K3342_MU1427`), identified by `/ifs/lsd.jxe` = **52,751,492 bytes** |
| Cluster | **791 AID 12.3** |
| Phone | iPhone over USB. Tested with iPhone19,2 on iOS build 24A437; the turn card needs a recent iOS. |

The installer checks the exact firmware size and cluster profile, and stops before changing any factory file if they don't match. The 790 installer refuses MU1427.

The package still contains the original project's profiles for other firmware ([see below](#origin-and-upstream-project-en)). This fork hasn't changed or re-tested them.

## <a id="download-en"></a>Download

**MQB Toolbox V4.2A with CarPlay Maps VC:** release [`toolbox-plaintext-v1.3.0`](https://github.com/tomasz-twardzicki/MHI2-Carplay-Maps/releases/tag/toolbox-plaintext-v1.3.0). Direct download: [CarPlay_Maps_VC_FULL_MQB_Toolbox_V4.2A.zip](https://github.com/tomasz-twardzicki/MHI2-Carplay-Maps/releases/download/toolbox-plaintext-v1.3.0/CarPlay_Maps_VC_FULL_MQB_Toolbox_V4.2A.zip)

Verify the archive with the release's [SHA-256 manifest](https://github.com/tomasz-twardzicki/MHI2-Carplay-Maps/releases/download/toolbox-plaintext-v1.3.0/FULL_TOOLBOX_SHA256.txt). Its sha256 is `90ee99d17ac70e7653790577c53fe8d248151840ca65aa7ca6ea55eb0ac2df50`.

## <a id="installation-en"></a>Installation

Only one installation route is supported: the full MQB Toolbox package.

1. Download the MQB Toolbox V4.2A archive and verify its SHA-256.
2. Extract its contents **directly to the root** of an SD card.
3. Insert the card and install or update the MQB Toolbox on the unit.
4. Open **Customization → CarPlay Maps VC** and select **Install 791 AID 12.3 (AUTO MU)**. The installer detects MU1427 automatically.
5. Wait for `CPMAP_INSTALL_OK`, then exit the toolbox and do **one full unit reboot**.
6. Connect the iPhone, start a route in Apple Maps, and check the cockpit map, the turn card and the steering-wheel controls.

Keep stable power during the whole process. Don't remove the card while the unit is writing, and never install or debug while driving.

Optional: **Customization → Navigation → Ignore navigation-active status from smartphone** keeps the factory navigation map running in the cockpit while CarPlay navigates. Undo it with **Uninstall Ignore navigation-active** in the same menu.

**Upgrading from an earlier MU1427 build:** update the toolbox from the new package, then run the install again, or pick **Default** under display options. Reboot afterwards.

## <a id="display-options-en"></a>Display options

**Customization → CarPlay Maps VC → carplay-maps-vc-tuning** switches the cockpit view. Every option runs at 30 fps and needs a full reboot after switching.

| Option | Cockpit view |
| --- | --- |
| **Default** | Map with a narrow turn card under the clock bar |
| **Map + wide turn card** | Same position, wider card |
| **Map only, no turn card** | Map without the card |

The options are read from the SD card (`Custom/carplay_maps_vc/tuning/`), so keep the card available when switching. **Show CarPlay Maps VC status** displays the active option.

The iPhone decides the card's size, and it grows with the guidance content (for example lane guidance). The receiver can't limit it. Technical details and the in-car test history are in [`MU1427/791_AID12.3/tuning/`](./MU1427/791_AID12.3/tuning/).

## <a id="diagnostics-en"></a>Diagnostics and restore

- **Collect diagnostics to SD:** writes `Log/cpmap-diag-<time>/` to the card, without modifying the unit. Run it before rebooting, because the runtime logs live in `/ramdisk` and are cleared on reboot.
- **Show CarPlay Maps VC status:** firmware, installed profile and active display option.
- **Restore factory files:** puts the factory `dio_manager` and `lsd.sh` back and removes the runtime. A full reboot is required afterwards.

## <a id="repository-layout-en"></a>Repository layout

| Path | Contents |
| --- | --- |
| [`MU1427/`](./MU1427/) | MU1427 notes: the `core.so` AES fix, the display settings, and offline verification against the factory package |
| [`MU1427/791_AID12.3/`](./MU1427/791_AID12.3/) | Standalone MU1427/791 profile: installer, payload, `patch-core-mu1427.py` |
| [`MU1427/791_AID12.3/tuning/`](./MU1427/791_AID12.3/tuning/) | `core.so` display patches, `build-mu1427-cores.sh` (rebuild and verify), test history |
| [`MU1427/NavActiveIgnore/`](./MU1427/NavActiveIgnore/) | MU1427 "Ignore navigation-active" build tooling and jar |
| [`releases/CarPlay_Maps_VC_Full_Toolboxes/`](./releases/CarPlay_Maps_VC_Full_Toolboxes/) | Source tree of the full MQB Toolbox package and its SHA-256 manifest |
| [`tests/`](./tests/) | Offline mock-install test |

## <a id="origin-and-upstream-project-en"></a>Origin and upstream project

CarPlay Maps VC was created by **[omonob (汽车大玩家 / QCDWJ)](https://github.com/omonob)**: the map-video runtime, the steering-wheel controls, the installers and the original toolbox integration. The original project lives at **[github.com/omonob/MHI2-Carplay-Maps](https://github.com/omonob/MHI2-Carplay-Maps)**.

The original release supports these firmware and cluster combinations:

| Firmware | Exact `lsd.jxe` size | 791/794 AID 12.3 | 790 AID 10.5 |
| --- | ---: | :---: | :---: |
| MU1102 | 55,915,411 bytes | ✅ | ✅ |
| MU1367 | 55,840,541 bytes | ✅ | ✅ |
| MU1440 Škoda | 55,840,933 bytes | ❌ | ✅ |

Those profiles ([`MU1102/`](./MU1102/), [`MU1367/`](./MU1367/), [`MU1440_SKODA/`](./MU1440_SKODA/)) are kept here unchanged from upstream. For them, use the original project and its releases.

## <a id="open-source-notice-en"></a>Open-source notice

- Original author of CarPlay Maps VC: **omonob (QCDWJ)**. MU1427 adaptation, display options and documentation in this fork: **tomasz-twardzicki**.
- The integration scripts, build logic and documentation are licensed under the [GNU GPL v3](LICENSE). Redistribution must keep the attribution and license terms and provide the corresponding source as GPLv3 requires.
- MQB Toolbox, Volkswagen, Škoda, Apple, CarPlay, Apple Maps and other third-party components, names and trademarks belong to their respective owners. GPLv3 does not relicense third-party firmware, toolbox or vendor components.
- The full toolbox is bundled only to provide a ready-to-use SD-card layout; upstream files and license notices are kept intact.
- No unit-specific passwords, private keys, K1/K2, `shadow`, NAVDB ciphertext or vehicle-bound data are published.
- This is an independent community project. It is not affiliated with or endorsed by Volkswagen AG, Škoda Auto, Harman or Apple Inc.

## <a id="disclaimer-en"></a>Disclaimer

**All use of this code, these scripts and these packages is at your own risk.**

- Modifying infotainment software can make the unit fail to boot, disable functions, void warranties, or conflict with local regulations.
- Confirm your exact firmware and cluster, keep stable power, and have a tested recovery route before installing.
- Never install, configure or debug while driving, and never let the cockpit display distract you from the road.

The software is provided "as is", without warranty of any kind, express or implied. In no event shall the original author, the maintainers or any contributor be liable for any claim, damage or other liability arising from, out of, or in connection with the software or its use. This applies to anything that comes out of it, including damage to vehicles, hardware, software or data, and any personal injury, financial loss or legal consequences.

---

<div align="center">

MU1427 / AID 791 fork by **[tomasz-twardzicki](https://github.com/tomasz-twardzicki)** · Based on the free, open-source CarPlay Maps VC by **[omonob (QCDWJ)](https://github.com/omonob)** · GPL-3.0

</div>
