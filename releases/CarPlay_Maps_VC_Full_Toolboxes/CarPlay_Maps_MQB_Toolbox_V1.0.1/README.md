# MIB2 High toolbox

Escolha seu idioma:
- [Português (Brasil)](./README.md)
- [English](./README.en-US.md)

---

A melhor toolbox MIB2-HIGH para todas as suas necessidades de personalização do MIB2 High.

Nota: esta tela tem o potencial de danificar sua unidade MIB2 HIGH. Os desenvolvedores não são responsáveis por quaisquer problemas a qualquer pessoa ou coisa causados por esta toolbox.
Nunca é nossa intenção prejudicar qualquer pessoa, carro ou marca. Use as ferramentas com sabedoria, não seja um idiota.

Nota2: Esta **não** é uma solução universal tipo Jailbreak para todas as suas necessidades e versões de firmware.

Nota3: Se você é uma empresa que tenta lucrar com isso: Não seja um egoísta, não cobre dinheiro por isso. Este projeto é feito em nosso tempo livre, por amor à comunidade. Eu arrisquei danificar meu próprio hardware durante os testes e investi muito tempo na pesquisa. Em vez de ganhar dinheiro, por que não apoiar este projeto com seu conhecimento ou uma [pequena doação](https://paypal.me/chillout1) ou se tornar um [Patreon](https://patreon.com/jille).

# Requisitos
- Leia o README completo
- Pelo menos 1 conjunto saudável de cérebros
- Uma unidade de infotainment MIB2 HIGH ou MIB2.5 HIGH. Não funcionará em unidades MIB1 ou MIB2 Standard. Discover Media / Composition Media não é MIB2 HIGH! Para MIB2 Standard, consulte o projeto [olli991/mib-std2-pq-zr-toolbox](https://github.com/olli991/mib-std2-pq-zr-toolbox).
- 1 cartão SD vazio, **formatado em FAT32**, com espaço suficiente. Qualquer coisa maior que 1GB está bom.
- Algum lugar para salvar seus backups

## Requisitos opcionais ##
- Python 3, se você quiser extrair/comprimir containers de gráficos (canim/mcf)
- Um editor de texto, se você quiser criar seus próprios arquivos ou scripts de Green Menu
- Software de edição de imagens, se você quiser personalizar arquivos de gráficos

# Como instalar
- Se você instalou uma versão anterior (antes da V4.0) da toolbox: limpe seu cartão SD antes de tentar instalar.
- Baixe todos os arquivos do repositório. Isso pode ser feito via `git clone` ou "Download zip" do GitHub e depois extraia o zip.
- Coloque todos os arquivos e pastas em um cartão SD vazio, de preferência >1GB.
- Insira o cartão SD em um dos slots da sua unidade MIB2.
- Certifique-se de que há apenas 1 cartão SD na sua unidade, caso contrário, os scripts não saberão onde procurar.
- Mantenha o botão MENU no seu MIB2 pressionado até que a tela de serviço apareça.
- Selecione o menu "Software updates/versions", então clique no botão "Update" no canto superior direito.
- Selecione o cartão SD e escolha "MQB Coding MIB2 Toolbox".
- Deixe a unidade executar a atualização completa do software. Ela reiniciará várias vezes antes de mostrar uma tela listando muitos módulos como N/A. A linha "Toolbox" deve ser Y. Você pode então clicar no botão "back" no canto superior direito.
- Quando terminar, ele pedirá para você conectar um computador e limpar os códigos de erro. Isso não é necessário, você pode clicar no botão "Cancel".
- A unidade reiniciará uma última vez e você estará de volta ao menu principal do carro. A instalação está concluída.
- Mantenha o botão MENU pressionado e vá para TESTMODE. Em versões mais antigas, você pode ir ao menu do desenvolvedor mantendo o botão MENU pressionado por cerca de 10 segundos.
- Vá para o Green Developer Menu.
- Haverá um menu adicional chamado "mqbcoding". Ao vê-lo, a instalação foi bem-sucedida.
- Vá para "mqbcoding" e você verá o seguinte:

![O menu da MQB Coding toolbox](https://i.imgur.com/wGUZ4xw.png)

- Você terminou.
- Aproveite!

# Como fazer uma instalação manual
- Coloque a `mib2-toolbox` em um cartão SD e insira-o no slot SD1 da unidade MIB.
- Faça uma conexão com o `debug console` da unidade (através de D-Link Dub-E100 ou ASIX AX88179 na porta USB, ou `serial interface` na parte traseira da unidade).
- Faça `log in`.
- Monte o cartão SD:
  * `mount -uw /net/mmx/fs/sda0`
- Execute o `finalScript`:
  * `sh /net/mmx/fs/sda0/Toolbox/final/finalScripts.sh`

- Mantenha o botão MENU pressionado e vá para TESTMODE. Em versões mais antigas, você pode ir ao menu do desenvolvedor mantendo o botão MENU pressionado por cerca de 10 segundos.
- Vá para o Green Developer Menu.
- Haverá um menu adicional chamado "mqbcoding". Ao vê-lo, a instalação foi bem-sucedida.
- Você terminou.
- Aproveite!

# Visão geral da tela Green Menu:
# Green menu screen overview:

```
MQBCoding Main
|
+---Customization                       # Customization features
|   +---Adaptations                     # Adaptation channels
|       +---CarDeviceBUSAssignment
|       +---CarFunctionsList_BAP
|       +---CarFunctionsList_CAN
|       +---CarMenuOperation
|       +---HMI_FunctionBlockingTable
|       +---RCCAdaptions
|       +---VariantInfo
|       +---VehicleConfiguration
|       +---WLAN
|   +---Advanced                        # Import shadow file, FECs pf.conf and such
|   +---AndroidAuto                     # Android Auto custom apps patch
|   +---Coding                          # Long coding editor
|   +---Display                         # Displaymanager and other related features
|   +---GreenMenu                       # Import new GreenMenu screens and scripts
|   +---Language                        # Replacing language data
|   +---Navigation                      # Navigation tweaks, mapstyles switching
|   +---Privacy                         # Privacy features
|   +---Skin                            # Skin graphics import
|   +---Sounds                          # Sounds import (experimental)
|   +---Startup                         # Startup graphics import
|   +---Updates                         # Custom SWDL modes and emergency
|   +---Various                         # Various tweaks
|
+---Disclaimer                          # Some wise words
|
+---Dump                                # Dump various data to SD-card
|
+---History                             # Version history of the Toolbox
|
+---MIB_Information                     # Information about the unit
|   +---Password                        # Password finder
|
+---Uninstall                           # Uninstalls and or cleans up the MIB Toolbox
```
# Como usar as novas telas
A maioria das telas tem uma descrição interna ou mostra informações ao executar um script. É sempre prudente ter um cartão SD no slot 1.

## dump
Aqui você pode despejar várias coisas que você precisa para personalizar sua unidade. Certifique-se de que um cartão SD esteja inserido.

## customization
### androidauto
Esta tela possui 2 botões:
- `Patch Android Auto` para habilitar aplicativos de terceiros personalizados. Não é necessário `root` no seu telefone.
- Restaurar o arquivo `gal.json` original caso você não tenha gostado do `patch` ou algo não esteja funcionando corretamente.

### skin
Esta tela permite que você instale novos `images.mcf` para cada uma das 6 pastas de `skin`, da pasta `SkinFiles` no seu cartão SD. Use os arquivos `dump` como guia. Não instale arquivos que são destinados a outros firmwares porque isso **irá** bagunçar seus gráficos e funcionalidades da sua unidade de infotainment.
Esta tela também permitirá que você recupere os `skins` do backup.

### greenmenu
Esta tela permitirá que você importe novos arquivos `.esd` da pasta `GreenMenu` no seu cartão SD.

# Como usar as ferramentas
Na pasta `Tools`, você encontrará algumas ferramentas:
- extract-canim.py

Estes são scripts Python para extrair arquivos de tela de inicialização (`.canim files`) em 2 formatos. Se um dos scripts não extrair seu `canim`, tente o outro. Ambos funcionam da mesma forma: `extract_canim.py <filename> <outdir>`, por exemplo:
extract_canim.py test.canim .\testfiles\
```extract_canim.py test.canim .\testfiles\```

- extract-mcf.py
Este é um script Python para extrair `containers` de `skinfile` (`mcf`) e funciona de forma semelhante ao `canim-extract`: `extract_mcf.py <filename> <outdir>`, por exemplo:

 ```extract_mcf.py images.mcf .\extracted\```
 
 
- compress-canim.py

Este é o script para comprimir as `startup-screens`. Certifique-se de usar o mesmo `compress-method` que você usou ao extrair. Uso: `compress-canim.
extract_mcf.py images.mcf .\extracted\
```compress-canim.py test.canim modified.canim .\testfiles\```

- compress-mcf.py

Este é o script para comprimir MCF-container.
```compress-mcf.py images.mcf images2.mcf .\extracted\```

- extract-cff.py

Este é o script para extrair imagess de `cff` (container files) em formato `png`.
```extract-cff.py images.cff c:\extracted\```

## F.A.Q.
Se você encontrar algum problema, consulte o [F.A.Q.](https://github.com/jilleb/mib2-toolbox/blob/master/FAQ.md).

## Versões de firmware suportadas
Esta `toolbox` provavelmente não funciona em todas as versões de `firmware` disponíveis, mas a instalação atual via cartão SD prova ser majoritariamente compatível com a maioria dos `firmwares`.


# Aviso legal:
**Atenção** Estas telas têm o potencial de danificar sua unidade e anular sua garantia. Tenha cuidado. Não somos responsáveis por quaisquer problemas a você, seu carro ou software. MQB Coding está sempre procurando por `hacks` e `retrofitts` interessantes para aumentar o potencial da plataforma MQB. Nunca é nossa intenção prejudicar qualquer pessoa, carro ou marca.

## Apoie este projeto

Você é sempre bem-vindo para apoiar este projeto com seu conhecimento, ideias ou uma [pequena doação](https://paypal.me/chillout1) para meu Paypal ou [Patreon](https://patreon.com/jille).
```extract-cff.py images.cff c:\extracted\```