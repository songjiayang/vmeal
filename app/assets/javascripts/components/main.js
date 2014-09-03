/*
 *  Document   : main.js
 *  Author     : songjiayang
 *  Description: Custom scripts and plugin initializations; inspired by freshui 
 */

$(document).ready(function(){

  var webSite = function() {

    /* Cache variables of some often used jquery objects */
    var body    = $('body');

    var header  = $('header');

    // 50 is the height of .sidebar-search and .user-info in pixels
    var sScrollHeight = $(window).height() - 51;

    /* Initialization UI Code */
    var uiInit = function() {

      // Add opacity to the header when scrolling (you can comment/remove the following line if you prefer a solid header)
      $(window).scroll(function() { if ($(this).scrollTop() > 60) { header.addClass('add-opacity'); body.addClass('add-affix'); } else { header.removeClass('add-opacity'); body.removeClass('add-affix'); } });

      // Initialize tabs
      $(document).on("click",'[data-toggle="tabs"] a, .enable-tabs a', function(e){ e.preventDefault(); $(this).tab('show'); });

      // Initialize Tooltips
      $(document).on('mouseenter','[data-toggle="tooltip"], .enable-tooltip',function(){$(this).tooltip({ animation: false }).triggerHandler('mouseover'); });

      // Initialize Popovers
      $(document).on('mouseenter','[data-toggle="popover"], .enable-popover', function() { $(this).popover({trigger:'hover'}); $(this).triggerHandler('mouseover');});

      // Initialize single image lightbox
      $(document).on('mouseenter','[data-toggle="lightbox-image"]', function() { $(this).magnificPopup({type: 'image', image: {titleSrc: 'title'}}); });

      // Initialize image gallery lightbox
      $(document).on('mouseenter','[data-toggle="lightbox-gallery"]',function(){
          $(this).magnificPopup({
              delegate: 'a.gallery-link',
              type: 'image',
              gallery: {
                  enabled: true,
                  navigateByImgClick: true,
                  arrowMarkup: '<button type="button" class="mfp-arrow mfp-arrow-%dir%" title="%title%"></button>',
                  tPrev: 'Previous',
                  tNext: 'Next',
                  tCounter: '<span class="mfp-counter">%curr% of %total%</span>'
              },
              image: {titleSrc: 'title'}
          });
      });

      // Initialize Elastic
      $(document).on('mouseenter','textarea.textarea-elastic',function(){ $(this).elastic() });

      // Initialize Editor
      // $('.textarea-editor').wysihtml5();

      // Initialize Chosen
      // $('.select-chosen').chosen();

      // Initialize Datepicker
      $(document).on('mouseenter','.input-datepicker, .input-daterange',function(){ $(this).datepicker(); });

      // Initialize Timepicker
      // $('.input-timepicker').timepicker({minuteStep: 1,showSeconds: true,showMeridian: true});
      // $('.input-timepicker24').timepicker({minuteStep: 1,showSeconds: true,showMeridian: false});

      ///* Easy Pie Chart */
      //$('.pie-chart').easyPieChart({
      //    barColor: '#f39c12',
      //    trackColor: '#eeeeee',
      //    scaleColor: false,
      //    lineWidth: 3,
      //    size: $(this).data('size'),
      //    animate: 1200
      //});
    };

    /* Scroll to top functionality */
    var scrollToTop = function() {

      // Get link
      var link = $('#scrollUp');

      $(window).scroll(function() {
          // If the user scrolled a bit (150 pixels) show the link
          if ($(this).scrollTop() > 150) {
              link.fadeIn(100);
          } else {
              link.fadeOut(100);
          }
      });

      // On click get to top
      link.click(function() {
          $('html, body').animate({scrollTop: 0}, 200);
          return false;
      });
    };


    /* Input placeholder for older browsers */
    var oldiePlaceholder = function() {

      // Check if placeholder feature is supported by the browser
      if (!Modernizr.input.placeholder) {
        // If not, add the functionality
        $('[placeholder]').focus(function() {
          var input = $(this);
          if (input.val() === input.attr('placeholder')) {
              input.val('');
              input.removeClass('ph');
          }
        }).blur(function() {
          var input = $(this);
          if (input.val() === '' || input.val() === input.attr('placeholder')) {
              input.addClass('ph');
              input.val(input.attr('placeholder'));
          }
        }).blur().parents('form').submit(function() {
          $(this).find('[placeholder]').each(function() {
              var input = $(this);
              if (input.val() === input.attr('placeholder')) {
                  input.val('');
              }
          });
        });
      }
    };

    return {
      init: function() {
        uiInit(); // Initialize UI Code
        scrollToTop(); // Scroll to top functionality
        oldiePlaceholder(); // Make input placeholder work in older browsers
      }
    };
  }();

  /* Initialize WebApp when page loads */
  $(function() { webSite.init(); });

}); // end document ready wrap


