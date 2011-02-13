var can_vote = true;

function show_description(elem) {
  Effect.toggle('description_'+elem, 'Blind', { duration: 0.4 });
}

function cookiesEnabled() {
  Set_Cookie("CookieTest", Date.now);
  return (Get_Cookie("CookieTest") < Date.now+5000);
}

function vote(obj, id) {
  if (cookiesEnabled()) 
    if (can_vote) {

      can_vote = false;

      $(obj+'_form_'+id).request({
        onFailure: function(){ can_vote = true; alert('Ошибка при голосовании! Попробуйте перезагрузить страницу') },
        onSuccess: function(){ can_vote = true; }
      });

    }else alert('Вы слишком быстро нажимаете на кнопочки');
  else alert('Для голосования необходимо включить cookies!');
}

Event.observe(window, 'load', function() {
  var anchor_value;
  var stripped_url = document.location.toString().split("#");
  if (stripped_url.length > 1)
    anchor_value = stripped_url[1];
  if (anchor_value == 'comments')
    $('vk_comments').scrollTo();
});
