$(function(){

  $('#nav li a').hover( function() {
    $(this).stop().animate({ 'padding-top' : 90 }, 300).css({ background: '#fa453c'});
  }, function() {
    $(this).stop().animate({ 'padding-top' : 60 }, 300).css({ background: '#585858'});
  });

  if( $('#works').length ) {
    var $container = $('#works');

    // Filter Buttons
    $('#filters a').click(function(){
      var selector = $(this).attr('data-filter');
      $container.isotope({ filter: selector });
      return false;
    });

    $('#options').find('#filters a').click(function() {
      var $this = $(this);

      if( !$this.hasClass('selected') ) {
        $this.parents('#filters').find('.selected').removeClass('selected');
        $this.addClass('selected');
      }
    });

    $('#works').imagesLoaded( function(){
      $container.isotope({
        itemSelector : '.work'
      });
    });
  };

});
