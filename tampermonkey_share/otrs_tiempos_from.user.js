// ==UserScript==
// @name        otrs_tiempos_from
// @namespace   none
// @description rellena TimeUnits a partir de los customfields
// @include  https://*/otrs/*
// @require  http://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js
// @require  https://gist.github.com/raw/2625891/waitForKeyElements.js
// @grant    GM_addStyle
// ==/UserScript==
/*- The @grant directive is needed to work around a design change
    introduced in GM 1.0.   It restores the sandbox.
*/


// marcar como checked inicio/fin y poner valor por defecto en timeunits
$('#DynamicField_arthorainicioUsed').prop('checked', true);
$('#DynamicField_arthorafinUsed').prop('checked', true);
$('#TimeUnits').val(0);


// al cambiar cualquier parámentro rellenar "TimeUnits"
$('.Field').change(function(){

inicio = new Date($('#DynamicField_arthorainicioYear').val(),
              $('#DynamicField_arthorainicioMonth').val(),
              $('#DynamicField_arthorainicioDay').val(),
              $('#DynamicField_arthorainicioHour').val(),
              $('#DynamicField_arthorainicioMinute').val(),
              0,
              0);

fin = new Date($('#DynamicField_arthorafinYear').val(),
              $('#DynamicField_arthorafinMonth').val(),
              $('#DynamicField_arthorafinDay').val(),
              $('#DynamicField_arthorafinHour').val(),
              $('#DynamicField_arthorafinMinute').val(),
              0,
              0);

var timediff = fin - inicio ;

$('#TimeUnits').val(timediff/60000);


});


