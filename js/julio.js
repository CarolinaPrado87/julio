// JavaScript Document



 function getFlashMovie(movieName) {
  var isIE = navigator.appName.indexOf("Microsoft") != -1;
  return (isIE) ? window[movieName] : document[movieName];
 }
 
 
function inicializaJulio(){
    //Quando o flash carrega é que o JS começa a atuar nele
    if (document.URL.split("/")[4] == 'detalhes_rede') {
       getFlashMovie('julio').escreveNoMapa('Carregando mapa...');
        
        id_rede = document.URL.split("/")[5];
        $.get('http://donosdamidia.epcom.inf.br/publicador/class_redes/gera_csv/' + id_rede, function(data){
        
            pintaJulio(data);
            
        });
        
    }
}

 function pintaJulio(data) {          
     var a = data.split("\n");
     julio = getFlashMovie('julio');
     julio.escreveNoMapa('Número de estações em cada estado. Quanto mais escuro, maior o número.');
    // $('#debug').html(a.length);
     
     max = parseInt(a[0].split(';')[1]);
     //min = parseInt(a[a.length -1 ].split(';')[1]);
     razao = 100/600;
     
     
     
     for (key in a) {
     
    // $.each(a, function(){
         uf = Array(a[key].split(';')[0]);
         num = parseInt(a[key].split(';')[1]);
        

   
         julio.mudaCor("0x3366CC", uf);
         
         if(num>0) {
             num = Math.round((num * razao)+15);
         }
         //$('#debug').after("---"+num+"---");
         julio.mudaOpacidade(num, uf);
        
     };//);
 }
