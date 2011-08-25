/**
 * Example: inputPlaceholder( document.getElementById('my_input_element') )
 * @param {Element} input
 * @param {String} [color='#AAA']
 * @return {Element} input
 */
function inputPlaceholder (input, color) {

	if (!input) return null;

	// Do nothing if placeholder supported by the browser (Webkit, Firefox 3.7)
	if (input.placeholder && 'placeholder' in document.createElement(input.tagName)) return input;

	color = color || '#AAA';
	var default_color = input.style.color;
	var placeholder = input.getAttribute('placeholder');

	if (input.value === '' || input.value == placeholder) {
		input.value = placeholder;
		input.style.color = color;
		input.setAttribute('data-placeholder-visible', 'true');
	}

	var add_event = /*@cc_on'attachEvent'||@*/'addEventListener';

	input[add_event](/*@cc_on'on'+@*/'focus', function(){
	 input.style.color = default_color;
	 if (input.getAttribute('data-placeholder-visible')) {
		 input.setAttribute('data-placeholder-visible', '');
		 input.value = '';
	 }
	}, false);

	input[add_event](/*@cc_on'on'+@*/'blur', function(){
		if (input.value === '') {
			input.setAttribute('data-placeholder-visible', 'true');
			input.value = placeholder;
			input.style.color = color;
		} else {
			input.style.color = default_color;
			input.setAttribute('data-placeholder-visible', '');
		}
	}, false);

	input.form && input.form[add_event](/*@cc_on'on'+@*/'submit', function(){
		if (input.getAttribute('data-placeholder-visible')) {
			input.value = '';
		}
	}, false);

	return input;
}


function showFlash() {
  $('#flash .message').each(function() {
    $.jGrowl($(this).html());
  });
}

function scrollToComments() {
  var anchor_value;
  var stripped_url = document.location.toString().split("#");

  if (stripped_url.length > 1)
    anchor_value = stripped_url[1];

  if (anchor_value == 'comments')
    $.scrollTo( $('#vk_comments'), 800 );
}

// Imperavi Redactor
var redactor = {
  focus: true,
  path: '/redactor/',
  image_upload: '/manage/photos'
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

  // Wikipoop links
  if ($('.wikipoop').size() > 0) {

    $('a.wikipoop_link').click(function() {
      $(this).parent().find('.text').slideToggle();
      $(this).toggleClass('active');
      return false;
    });

    $("a.wikipoop_video").fancybox({
      'width'         : 640,
      'height'        : 480,
      'autoScale'     : false,
      'transitionIn'  : 'elastic',
      'transitionOut' : 'elastic',
      'type'          : 'iframe'
    });

  }

  // With #comments anchor scroll to comments box
  scrollToComments();
  $('.comments_button').live('click', function() {
    $.scrollTo( $('#vk_comments'), 800 );
    return false;
  });

});
