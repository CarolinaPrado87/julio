# Julio - Documentação #

Esta página wiki é uma cópia do [julio\_docs.html](http://www.pedrovalente.com/projetos/julio/julio_docs.html).

**ATENÇÃO: Não execute ~~este arquivo~~ o julio\_docs.html abrindo diretamente de uma pasta. Use pelo menos um localhost, porque ao contrário o Flash se recusa a conversar com o Javascript.**

## Baixar o código ##

Entre em http://julio.googlecode.com e encontre a pasta trunk no svn.

## Carregar em uma página ##

O pré-requisito é o SWFobject. Carregue-o antes de tudo:
```
    <script type="text/javascript" src="js/swfobject.js"> </script>
```

E depois o julio.js
```
    <script type="text/javascript" src="js/julio.js"> </script>
```

O julio.js tem a seguinte estrutura:
```
    <script type="text/javascript">
        var flashvars = {};
			flashvars.contorno = "0xFFFFFF";
			var params = {};
			params.allowscriptaccess = "always";
			var attributes = {};
			attributes.id = "julio";
			attributes.name = "julio";
			swfobject.embedSWF("flash/julio.swf", "julio_div", "330", "320", "8.0.0", false, flashvars, params, attributes);
			
			function getJulio(nome) {
	           if(!nome) {
	                nome = 'julio'
	            }
		        var isIE = navigator.appName.indexOf("Microsoft") != -1;

                return (isIE) ? window[nome] : document[nome];
			}
			
		    function inicializaJulio() {
		        //Código a ser executado depois de o mapa carregar
		    }
    </script>
```
No código acima, é indispensável haver o `allowscriptaccess='always'` que permite a conversa entre o Flash e o Javascript. Além disso, dá pau no Internet Explorer se os parâmetros do `swfobject.embedSWF()` não forem colocados nessa ordem e com esses valores. Altere por sua conta e risco.

No seu código deve existir um `div` com id `julio`, que é o lugar onde o mapa será inserido. Geralmente é um div que pode ter um conteúdo alternativo que será exibido no caso de o carregamento do flash dar pau:
```
    <div id="julio"> Conteúdo alternativo </div>
```

## Como modificar ##

É possível alterar as variáveis predefinidas do julio na hora de carregá-lo ou durante a execução.

### Ao carregar a página ###

Para que o mapa apareça na página do jeito que você quer, as variáveis devem ser colocadas dentro do objeto `flashvars = {}` que o swfobject usa para montar o código do flash que vai ser carregado.

Por exemplo, para carregar um mapa com contorno branco, estados pintados de preto e zoom no estado do Paraná, o seguinte código funcionaria:
```
    flashvars.contorno = "0xFFFFFF"
    flashvars.cor = "0x000000"
    flashvars.zoom_uf = 'PR'
```

Uma lista de variáveis que podem ser utilizadas e seus possíveis valores está mais abaixo nesta página.

### Com javascript (runtime) ###

Caso você deseje alterar o julio via javascript depois de carregado na página, é recomendável que as suas ações sejam disparadas por uma função chamada `inicializaJulio()`
```
    <script type="text/javascript">
        function inicializaJulio() {
            //Esta função é chamada quando o mapa termina de carregar
            //e está pronto para receber comandos.
        }
    </script>
```

Aí é possível usar as funções da API do julio para mexer no mapa:
```
    getJulio().mudaCorBr('0x000000')

    getJulio().mudaCorRegiao('0xff3333','nordeste')

    getJulio().zoom('SC')
```

## Variáveis ##

Abaixo, a lista de variáveis que podem ser definidas no modelo `flashvars.variavel = valor`

```
contorno='0x0000CC'
```
> A cor da linha do mapa.

```
cor='0x22CC33'
```
> A cor de todas as UFs ao carregar o mapa.

```
opacidade=40
```
  1. 0 é totalmente opaco e 0 totalmente transparente.

```
interativo=true|false
```
> Determina se o mapa vai ser interativo ou não. Caso seja true, o mouseover e clique vai funcionar.

```
diferenca_rollover=25
```
> A redução de opacidade na UF que deve ocorrer ao passar o mouse sobre ela.

```
zoom_uf='BR'|'AL'...'TO'
```
> Inicia o mapa aproximado em um determinado estado ou no 'BR'.

```
funcao_tipo='AS'|'JS'
```
> Especifica se a função chamada ao clicar em uma UF é 'AS'-actionscript ou 'JS'-javascript. Funções 'AS' devem existir dentro do julio e receber apenas o parâmetro UF. Funções 'JS' devem existir na página onde o julio foi carregado e receber apenas o parâmetro UF.

```
funcao='minhaFuncao'
```
> O nome da função chamada na hora de clicar no estado. Ver item acima.


## Funções ##

O julio tem diversas funções bem simples que combinadas podem atingir resultados complexos. A seguir vemos uma lista delas que podem ser chamadas via Javascript, usando `getJulio().nomeDaFuncao(parametros)`

Perceba que cor e opacidade são propriedades independentes. Você pode ter o país todo com a mesma cor e variar apenas a opacidade entre os estados, por exemplo, ficando com vários tons da mesma cor.

```
mudaCor('0xFF3333','PA')
```
> Altera a cor de uma UF específica. Aceita as siglas de todas as UFs e também 'contorno'.

```
mudaCorRegiao('0x33FF33','centrooeste')
```
> Altera a cor de uma região. Aceita 'norte','nordeste','centrooeste','sudeste' e 'sul'.

```
mudaCorBr('0x3333FF')
```
> Altera a cor de todas as UFs.

```
mudaOpacidade(20,'MA')
```
> Altera a opacidade de uma UF específica. Aceita as siglas de todas as UFs e também 'contorno'.

```
mudaOpacidadeRegiao(30,'sul')
```
> Altera a opacidade de uma região. Aceita 'norte','nordeste','centrooeste','sudeste' e 'sul'.

```
mudaOpacidadeBr(90)
```
> Altera a opacidade de todas as UFs.

```
array_de_ufs = ['SP','SC','SE','AC']
mudaOpacidadeEmLote(70, array_de_ufs) e
mudaCorEmLote('0xCCFFCC', array_de_ufs)
```
> Altera a cor ou a opacidade de um array de siglas.

```
defineDiferencaRollover(50)
```
> Altera a redução de opacidade na UF que deve ocorrer ao passar o mouse sobre ela.

```
destaca('MG')
```
> Altera opacidades para deixar UF selecionada em destque. Ocorre automaticamente na função zoom.

```
defineFuncao('JS','alert')
```
> Define que função javascript as UFs chamam ao serem clicadas.

```
defineFuncao('AS','zoom')
```
> Define que função actionscript as UFs chamam ao serem clicadas.

```
atribuiValor('MT','73%')
```
> Define o texto ou número exibido na caixinha azul que aparece ao passar o mouse sobre a UF.

```
array_de_ufs = ['SP','SC','SE','AC']
array_de_valores = ['490','120','3','18']
atribuiValorEmLote(array_de_ufs, array_de_valores)
```
> Define o texto ou número exibido na caixinha azul que aparece ao passar o mouse sobre a UF.

```
inserePonto(x=165, y=160, tamanho=180, cor='0xFF0000', opacidade=30, nome='grupo_de_pontos')
inserePonto(x=190, y=100, tamanho=90, cor='0x0000FF', opacidade=30, nome='grupo_de_pontos')
```
> Insere um ponto no mapa usando X e Y em pixels.

```
alteraGrupoDePontos('grupo_de_pontos', [['visivel',true], ['cor','0xFF0000'],['tamanho',20],['opacidade',40]])
```
> Altera propriedades de um grupo de pontos nomeado.

```
apagaGrupoDePontos('grupo_de_pontos')
```
> Deleta para sempre um grupo de pontos nomeado.

**Experimental:**
```
inserePontoLongLat(long=-23.560022 , lat=-46.688643, tamanho=20, cor='0xFF0000', opacidade=30, nome='grupo_de_pontos')
```
> Insere um ponto no mapa usando X e Y em latitude e longitude no grupo nomeado.

**Experimental:**
```
coordenadas = [
    [-9.128321, -70.305667], [-9.654903, -36.694884],
    [-3.783865, -64.94969], [1.60032, -52.378036],
    [-13.42796, -41.994208], [-5.321156, -39.343291],
    [-15.776049, -47.797185], [-19.596027, -40.772473],
    [-15.947269, -49.579063], [-5.652143, -45.275482],
    [-18.577966, -45.45175]
    ];
insereLoteLongLat(coordenadas, tamanho=20, cor='0xFF0000', opacidade=30, nome='grupo_de_pontos')
```
> Insere um ponto no mapa usando X e Y em latitude e longitude no grupo nomeado. Atenção, a margem de erro ainda é grande, por isso os pontos podem não ficar no lugar certo.