function showFlash() {
  $('#flash .flash_message').each(function() {
    $.jGrowl($(this).html());
  });
}

function scrollToComments() {
  var anchor_value;
  var stripped_url = document.location.toString().split("#");

  if (stripped_url.length > 1) {
    anchor_value = stripped_url[1];
  }

  if (anchor_value == 'comments') {
    $.scrollTo( $('#vk_comments'), 800 );
  }
}

// OnLoad
$(function() {

  // Show description button toggle
  $('.description_link a').live('click', function() {
    $(this).parent().parent().find('.description').slideToggle();
    return false;
  });

  // Show jGrowl notifications
  showFlash();

  // Placeholders for old browsers
  $('[placeholder]').each(function() {
    inputPlaceholder(this);
  });

  // Handy tooltips
  $('abbr, #social a').tipsy();
  $('form textarea[title], form input[type=text][title]').tipsy({offset: 10, trigger: 'focus', gravity: 'w'});

  // Ajax pagination
  if (history && history.pushState) {
    $(".pagination a").live("click", function(e) {
      $.getScript(this.href);
      history.pushState(null, document.title, this.href);
      e.preventDefault();
    });
    if ($('.pagination a').size() > 0) {
      $(window).bind("popstate", function() {
        $.getScript(location.href);
      });
    }
  }

  // With #comments anchor scroll to comments box
  scrollToComments();
  $('.comments_button').live('click', function() {
    $.scrollTo( $('#vk_comments'), 800 );
    return false;
  });

});
