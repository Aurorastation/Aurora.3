/mob/living/simple_animal/borer/send_emote(var/message, var/type)
    if(host)
        if(host.stat == CONSCIOUS)
            host.show_message(message, type)
    else
        ..()
