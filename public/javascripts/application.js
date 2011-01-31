function show_description(elem) {
  Effect.toggle('description_'+elem, 'Blind', { duration: 0.4 });
}

function cookiesEnabled() {
  Set_Cookie("CookieTest", "Enabled");
  return (Get_Cookie("CookieTest") == "Enabled");
}

function vote(obj, id) {
  if (cookiesEnabled()) {

    $(obj+'_form_'+id).request({
      onFailure: function(){ alert('Ошибка при голосовании! Попробуйте перезагрузить страницу') }
    });

  } else 
    alert('Для голосования необходимо включить cookies!');
}

Event.observe(window, 'load', function() {
  var anchor_value;
  var stripped_url = document.location.toString().split("#");
  if (stripped_url.length > 1)
    anchor_value = stripped_url[1];
  if (anchor_value == 'comments')
    $('vk_comments').scrollTo();
});
