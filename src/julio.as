import flash.external.ExternalInterface;
import mx.transitions.Tween;
import mx.transitions.easing.*;

_root.dados._visible = false;
//Define valores padrão
_root.COR_INICIAL_CONTORNO = "0xFFFFFF"
_root.COR_INICIAL_ESTADOS = "0x228833"
_root.OPACIDADE_INICIAL_ESTADOS = 100
_root.DIFERENCA_ROLLOVER = 25
_root.INTERATIVO = true
_root.MOSTRA_LEGENDA = true
_root.FUNCAO = "zoom"
_root.FUNCAO_TIPO = "AS"
_root.ZOOM_UF = ''
_root.ZOOM_RAZAO = 1
_root.X_BR_INICIAL = _root.br._x
_root.Y_BR_INICIAL = _root.br._y
_root.SOMBRA = true



//Sobrescreve os valores padrão com o que recebe na chamada do arquivo.
//Para fazer isso se usa julio.swf?cor=0xFF00FF&opacidade=20&funcao_js=cliqueiNoEstado
//Deve ser colocado na chamada do arquivo tanto no Embed quanto no Param
if(contorno) {
	_root.COR_INICIAL_CONTORNO = contorno;
}
if(cor) {
	_root.COR_INICIAL_ESTADOS= cor;
}
if(opacidade) {
	_root.OPACIDADE_INICIAL_ESTADOS = opacidade;
}
if(diferenca_rollover) {
	_root.DIFERENCA_ROLLOVER = diferenca_rollover;
}
if(interativo == false) {
	_root.INTERATIVO = false;
}
if(funcao) {
	_root.FUNCAO = funcao;
}
if(funcao_tipo) {
	_root.FUNCAO_TIPO = funcao_tipo;
}

if(legenda) {
	_root.MOSTRA_LEGENDA = MOSTRA_LEGENDA;
}
if(zoom_uf) {
	_root.ZOOM_UF = zoom_uf;
}

//Define grupos de estados
_root.todas_ufs = new Array("AC", "AL", "AM", "AP", "BA", "CE", "DF", "ES", "GO", "MA", "MG", "MS", "MT", "PA", "PB", "PE", "PI", "PR", "RJ", "RN", "RO", "RR", "RS", "SC", "SE", "SP", "TO");
_root.nomes_ufs = new Array("Acre", "Alagoas", "Amazonas", "Amapá", "Bahia", "Ceará", "Distrito Federal", "Espírito Santo", "Goiás", "Maranhão", "Minas Gerais", "Mato Grosso do Sul", "Mato Grosso", "Pará", "Paraíba", "Pernambuco", "Piauí", "Paraná", "Rio de Janeiro", "Rio Grande do Norte", "Rondônia", "Roraima", "Rio Grande do Sul", "Santa Catarina", "Sergipe", "São Paulo", "Tocantins");

_root.regiao_norte = new Array("AC", "AM", "AP", "PA", "RO", "RR", "TO");
_root.regiao_nordeste = new Array("AL", "BA", "CE", "MA", "PB", "PE", "PI", "RN", "SE");
_root.regiao_centrooeste = new Array("MT", "MS", "GO", "DF");
_root.regiao_sudeste = new Array("MG", "ES", "RJ", "SP");
_root.regiao_sul = new Array("PR", "SC", "RS");

//Começam as funções
escreveNoMapa = function(str:String):Void {
 texto.text = str;
}
ExternalInterface.addCallback("escreveNoMapa", this, escreveNoMapa);

executaLote = function(funcao, siglas, alvo, parametro):Void {
	// Executa alguma função em um array de siglas
	// Use alvo "" se quiser atuar sobre os estados
	// e alvo="b" se quiser atuar nos botões
	for (var i = 0; i<siglas.length; i++) {
		if(parametro == "") {
			funcao(siglas[i]);
		} else {
			funcao(parametro, siglas[i]);
		}
	}
}
gravaInfoNoBotao = function(sigla, chave, valor):Void {
	br['b'+ sigla][chave] = valor;
}
gravaInfoNoBotaoEmLote = function(siglas, chave, valores):Void {
	for (var i = 0; i<siglas.length; i++) {
		gravaInfoNoBotao(siglas[i], chave, valores[i]);
	}
}

atribuiValor = function(sigla, valor) {
	gravaInfoNoBotao(sigla, 'valor', valor);
}
ExternalInterface.addCallback("atribuiValor", this, atribuiValor);

atribuiValorEmLote = function(siglas, valores) {
	gravaInfoNoBotaoEmLote(siglas, 'valor', valores);
}
ExternalInterface.addCallback("atribuiValorEmLote", this, atribuiValorEmLote);

mudaCor = function(cor, sigla):Void {
	var novacor:Color = new Color(_root.br[sigla]);
	novacor.setRGB(cor);	
}
ExternalInterface.addCallback("mudaCor", this, mudaCor);

mudaCorEmLote = function(cor, siglas):Void {
	executaLote(mudaCor, siglas, "", cor);
}
ExternalInterface.addCallback("mudaCorEmLote", this, mudaCorEmLote);

mudaCorRegiao = function(cor, regiao):Void {
	mudaCorEmLote(cor, _root['regiao_'+regiao]);
}
ExternalInterface.addCallback("mudaCorRegiao", this, mudaCorRegiao);

mudaCorBr = function(cor):Void {
	mudaCorEmLote(cor, todas_ufs);
}
ExternalInterface.addCallback("mudaCorBr", this, mudaCorBr);

mudaOpacidade = function(valor, sigla):Void {
	_root.br[sigla]._alpha = valor;
	_root.br[sigla].opacidade = valor;
}
ExternalInterface.addCallback("mudaOpacidade", this, mudaOpacidade);

mudaOpacidadeEmLote = function(valor, siglas):Void {
	executaLote(mudaOpacidade, siglas, "", valor);
}
ExternalInterface.addCallback("mudaOpacidadeEmLote", this, mudaOpacidadeEmLote);

mudaOpacidadeRegiao = function(valor, regiao):Void {
	mudaOpacidadeEmLote(valor, _root['regiao_'+regiao]);
}
ExternalInterface.addCallback("mudaOpacidadeRegiao", this, mudaOpacidadeRegiao);

mudaOpacidadeBr = function(valor):Void {
	mudaOpacidadeEmLote(valor, todas_ufs);
	
}
ExternalInterface.addCallback("mudaOpacidadeBr", this, mudaOpacidadeBr);




inserePonto = function(x, y, tamanho, cor, opacidade, nome) {
	nome = getGrupoDePontos(nome);
	
	if(!tamanho) {
		tamanho = 5;
	}
	
	if(!cor) {
		cor = "0x0000FF";
	}
	if(!opacidade) {
		opacidade = 100;
	}
	x_safe = x.toString().split('.').join('')
	y_safe = y.toString().split('.').join('')
	_root.br[nome].attachMovie("bolinha", "bolinha_"+x_safe+"_"+y_safe, _root.br[nome].getNextHighestDepth(), {
																							  _x:x, 
																							  _y:y,
																							  _width: tamanho,
																							  _height: tamanho,																		
																							  _alpha: opacidade});
	mc_bolinha = _root.br[nome]["bolinha_"+x_safe+"_"+y_safe]
	var colorido = new Color(mc_bolinha.circulo);
   	colorido.setRGB(cor);
	
	
	//trace("_root.br[\'"+nome+"\'][\'bolinha_"+x_safe+"_"+y_safe+"\']")
	
	_root.br[nome].pontos.push("bolinha_"+x_safe+"_"+y_safe)
	
}
ExternalInterface.addCallback("inserePonto", this, inserePonto);



inserePontoLongLat = function(long, lat, tamanho, cor, opacidade, nome) {

	zero_x_em_lat = -73.7404
	zero_y_em_long = 4.6111	
	razao_x = 8.17	
	razao_y = 8.17	
	x_em_px = -(zero_x_em_lat - lat) * razao_x;
	
	//alternativo
	//x_em_px = zero_x_em_lat + (lat + 180.0) * 330 / 360.0;
	
	y_em_px = (zero_y_em_long - long) * razao_y;
	
	trace(x_em_px + " " + y_em_px);	
	
	inserePonto(x_em_px, y_em_px, tamanho, cor, opacidade, nome);	
}
ExternalInterface.addCallback("inserePontoLongLat", this, inserePontoLongLat);

insereLoteLongLat = function(coordenadas, tamanho, cor, opacidade, nome):Void {
	nome = getGrupoDePontos(nome)
	for (var i = 0; i<coordenadas.length; i++) {
		inserePontoLongLat(coordenadas[i][0], coordenadas[i][1], tamanho, cor, opacidade, nome);
	}
	
}
ExternalInterface.addCallback("insereLoteLongLat", this, insereLoteLongLat);

getGrupoDePontos = function(nome) {
	if(nome == '') {
		nome = 'pontos';
	}
	//Cria novo grupo de pontos
	if(!_root.br[nome]) {
	  _root.br.createEmptyMovieClip(nome,_root.br.getNextHighestDepth())
	  _root.br[nome].pontos = []
	}
	return nome;
}


ativaBotao = function(sigla):Void {
	bt = _root.br["b"+sigla];
	
	bt.onRelease = function():Void {
			trace('cliquei:'+this.sigla);
			if(_root.FUNCAO_TIPO == "JS") {
				ExternalInterface.call(_root.FUNCAO, this.sigla);
			} else if (_root.FUNCAO_TIPO == "AS") {
				fn = eval(_root.FUNCAO);
				fn(this.sigla);
			}
	}
	bt.onRollOver = function():Void {
			valor = _root.br[this.sigla]._alpha;
			mudaOpacidade(valor - _root.DIFERENCA_ROLLOVER, this.sigla);
			_root.br[this.sigla].opacidade = valor;
			
			if(_root.MOSTRA_LEGENDA) {
				_root.dados.legenda.text = this.nome;
				_root.dados._visible = true;
			}
			if(this.valor) {
				_root.dados.valor.text = this.valor;
			} else {
				_root.dados.valor.text = this.sigla;
			}
	}	
	bt.onRollOut = function():Void {
			mudaOpacidade(_root.br[this.sigla].opacidade, this.sigla);
			
			_root.dados.legenda.text = "";
			_root.dados.legenda.valor = "";
			_root.dados._visible = false;
    }	
}


defineFuncao = function(tipo, funcao) {
	_root.FUNCAO = funcao
	_root.FUNCAO_TIPO = tipo
	executaLote(ativaBotao, todas_ufs, "b", "");
}
ExternalInterface.addCallback("defineFuncao", this, defineFuncao);



defineDiferencaRollover = function(diferenca_rollover) {
	_root.DIFERENCA_ROLLOVER = diferenca_rollover;
	executaLote(ativaBotao, todas_ufs, "b", "");
}
ExternalInterface.addCallback("defineDiferencaRollover", this, defineDiferencaRollover);



zoom = function(sigla) {
	
	if(sigla == 'BR' || _root.ZOOM_RAZAO > 1 ) {
		tw_xscale = new Tween(_root.br, "_xscale", Strong.easeOut, _root.br._xscale, 100, 0.2, true);
		tw_yscale = new Tween(_root.br, "_yscale", Strong.easeOut, _root.br._yscale, 100, 0.2, true);
		tw_x = new Tween(_root.br, "_x", Strong.easeOut, _root.br._x, _root.X_BR_INICIAL, 0.2, true);		
		tw_y = new Tween(_root.br, "_y", Strong.easeOut, _root.br._y, _root.Y_BR_INICIAL, 0.2, true);		
		tw_xscale.onMotionChanged = function() {
			tw_yscale.nextFrame()
			tw_x.nextFrame()
			tw_y.nextFrame()
		}
		_root.ZOOM_UF = sigla;
		_root.ZOOM_RAZAO = 1;
		mudaOpacidadeBr(_root.OPACIDADE_INICIAL_ESTADOS)
		return true				
	}
	x_inicial =_root.br._x
	y_inicial =_root.br._y
	w = Stage.width
	h = Stage.height
	x_centro_inicial = w/2
	y_centro_inicial = h/2
	
	_root.ZOOM_UF = sigla;
	uf = _root.br[sigla]
	
	//Determina razao para zoom
	razao = w/uf._width
	razao_y = h/uf._height
	if( razao_y < razao) {
		razao = razao_y
	}
	razao -= razao*0.15	
	if(razao > 6) {
		razao = 6
	}	
	//Altera tamanho
	//_root.br._xscale *= razao;
	//_root.br._yscale *= razao;
	
	//Tamanho resolvido, agora falta centralizar
	//_root.br._x -= uf._x*razao - x_centro_inicial + x_inicial
	//_root.br._y -= uf._y*razao - y_centro_inicial + y_inicial
	
	tw_xscale = new Tween(_root.br, "_xscale", Strong.easeOut, _root.br._xscale, _root.br._xscale*razao, 0.2, true);
	tw_yscale = new Tween(_root.br, "_yscale", Strong.easeOut, _root.br._yscale, _root.br._yscale*razao, 0.2, true);
	tw_x = new Tween(_root.br, "_x", Strong.easeOut, _root.br._x, _root.br._x-(uf._x*razao - x_centro_inicial + x_inicial), 0.2, true);		
	tw_y = new Tween(_root.br, "_y", Strong.easeOut, _root.br._y, _root.br._y-(uf._y*razao - y_centro_inicial + y_inicial), 0.2, true);		
	tw_xscale.onMotionChanged = function() {
		tw_yscale.nextFrame()
		tw_x.nextFrame()
		tw_y.nextFrame()
	}

	_root.ZOOM_RAZAO = razao;
	destaca(sigla)
	
}
ExternalInterface.addCallback("zoom", this, zoom);


destaca = function(sigla) {
	mudaOpacidadeBr(_root.OPACIDADE_INICIAL_ESTADOS-40)
	mudaOpacidade(_root.OPACIDADE_INICIAL_ESTADOS,sigla)
}
ExternalInterface.addCallback("destaca", this, destaca);

alteraGrupoDePontos = function(nome, propriedades) {
	for (var i = 0; i<propriedades.length; i++) {
		switch(propriedades[i][0]) {
			case 'visivel':
				_root.br[nome]._visible = propriedades[i][1];
			break;
			case 'cor':				
				var colorido = new Color(_root.br[nome]);
				colorido.setRGB(propriedades[i][1]);				
			break;
			case 'opacidade':
				_root.br[nome]._alpha = propriedades[i][1];
			break;
			case 'tamanho':
				for(p in _root.br[nome].pontos) {
					nome_ponto = _root.br[nome].pontos[p]
					_root.br[nome][nome_ponto]._width = propriedades[i][1]
					_root.br[nome][nome_ponto]._height = propriedades[i][1]
				}
			break;
		}
	}
}
ExternalInterface.addCallback("alteraGrupoDePontos", this, alteraGrupoDePontos);

apagaGrupoDePontos = function(nome) {
		if(_root.br[nome]) {
			_root.br[nome].removeMovieClip();
		}
	}
ExternalInterface.addCallback("apagaGrupoDePontos", this, apagaGrupoDePontos);

alternaContorno = function() {
	if(_root.br.contorno._visible) {
		_root.br.contorno._visible = false
	} else {
		_root.br.contorno._visible = true
	}
}
ExternalInterface.addCallback("alternaContorno", this, alternaContorno);


//Este é o loop por todos os estados ao carregar o mapa.
gravaInfoNoBotaoEmLote(todas_ufs, 'sigla', todas_ufs);
gravaInfoNoBotaoEmLote(todas_ufs, 'nome', nomes_ufs);
if(ZOOM_UF) {
	zoom(ZOOM_UF);
}

if(INTERATIVO) {
	executaLote(ativaBotao, todas_ufs, "b", "");
}
mudaCor(_root.COR_INICIAL_CONTORNO, 'contorno');
mudaCorEmLote(_root.COR_INICIAL_ESTADOS, todas_ufs);
mudaOpacidadeEmLote(_root.OPACIDADE_INICIAL_ESTADOS, todas_ufs);





//inserePontoLatLong([-64.537598, -27.605671], 10);
// -26.323199999999986, 'Y': 17.293
//inserePonto(120, 138, 10);


/*executaLote(mudaCor, regiao_norte, "", '0x6B8E00');
executaLote(mudaCor, regiao_sul, "", '0x9F71B2');
executaLote(mudaCor, regiao_sudeste, "", '0x7292B2');
executaLote(mudaCor, regiao_centrooeste, "", '0xB29F00');
executaLote(mudaCor, regiao_nordeste, "", '0xB28519');
*/


coordenadas = [
			   	[-9.128321,	-70.305667],
				[-9.654903,	-36.694884],
				[-3.783865,	-64.94969],
				[1.60032,	-52.378036],
				[-13.42796,	-41.994208],
				[-5.321156,	-39.343291],
				[-15.776049, -47.797185],
				[-19.596027, -40.772473],
				[-15.947269, -49.579063],
				[-5.652143,	-45.275482],
				[-18.577966, -45.45175]
				];


//coordenadas = [[-54.537598, -17.605671]];

coordenadasB = [
			   	[-10.128321,	-72.305667],
				[-8.654903,	-33.694884],
				[-4.783865,	-63.94969],
				[2.60032,	-55.378036],
				[-11.42796,	-42.994208],
				[-6.321156,	-34.343291],
				[-13.776049, -45.797185],
				[-14.596027, -43.772473],
				[-18.947269, -39.579063],
				[-8.652143,	-48.275482],
				[-12.577966, -40.45175]
				];

//insereLoteLatLong(coordenadas, tamanho=5, cor='0x000000', opacidade=80, nome='loteA');
//insereLoteLongLat(coordenadasB, tamanho=6, cor='0x0000FF', opacidade=90, nome='loteB');
//alteraGrupoDePontos('loteB', [['visivel',true],['cor','0xFF0000'],['tamanho',20],['opacidade',40]])
//pontos = CoordinateFromLongLat(-27.644606, -48.47168)
sp = [-23.560022 , -46.688643]
fpolis = [-27.644606, -48.47168]
rio_branco = [-9.947209, -67.80761]
//trace(pontos.X + " " +pontos.Y)
//inserePonto(pontos.X,pontos.Y, 5, cor='0x0000FF', opacidade=90, nome='loteB')
//insereLoteLongLat([rio_branco, fpolis,sp ], 5, cor='0xFF0000', opacidade=90, nome='loteA')

_root.onLoad = function() {
	//Inicia o javascript somente ao carregar tudo aqui.
	ExternalInterface.call('inicializaJulio');
}



