function show_description(elem) {
  Effect.toggle('description_'+elem, 'Blind', { duration: 0.4 });
}

function cookiesEnabled() {
  Set_Cookie("CookieTest", "Enabled");
  return (Get_Cookie("CookieTest") == "Enabled");
}

function vote(id, type, salt) {
  if (cookiesEnabled()) {
    if (type == 0) 
      vote_type = 'bad';
    else
      vote_type = 'good';

    new Ajax.Request('/'+id+'/'+vote_type+'?salt='+salt,
    {
      method:'get',
      onSuccess: function(transport){
        var response = transport.responseText;
        eval(response);
      },
      onFailure: function(){ alert('Ошибка при голосовании!') }
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
