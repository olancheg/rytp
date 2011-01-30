document.onkeydown = NavigateThrough;

function NavigateThrough(event)
{
        if (window.event) event = window.event;
        if (event.ctrlKey)
        {
                var link = null;

                switch (event.keyCode ? event.keyCode : event.which ? event.which : null)
                {
                        case 0x25:
                                link = $$('.prev_page')[0];
                                break;

                        case 0x27:
                                link = $$('.next_page')[0];
                                break;

                        case 0x28:
                                link = $('random');
                                break;
                }

                if (link && link.href) document.location = link.href;
        }  
}
