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
