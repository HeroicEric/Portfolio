$(function(){

 $('#nav li a').hover( function() {

  $(this).stop().animate({ 'padding-top' : 90 }, 300).css({ background: '#fa453c'});

 }, function() {

  $(this).stop().animate({ 'padding-top' : 60 }, 300).css({ background: '#585858'});

 }); 

});
