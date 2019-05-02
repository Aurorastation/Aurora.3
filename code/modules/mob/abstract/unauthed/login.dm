/mob/abstract/unauthed
    authed = FALSE
    var/client/my_client

/mob/abstract/unauthed/New()
    verbs -= typesof(/mob/verb)

/mob/abstract/unauthed/Login()
    update_Login_details()
    to_chat(src, "<span class='danger'><b>You need to authenticate before you can continue.</b></span>")
    // TODO: open login stuff.
    my_client = client
    client.verbs -= typesof(/client/verb)

/mob/abstract/unauthed/verb/testlogin(var/nckey as text)
    set name = "Login"
    set category = "Auth"
    my_client.verbs += typesof(/client/verb)
    my_client.authed = TRUE
    my_client.ckey = ckey(nckey)
    if(istype(my_client.mob, /mob/abstract/unauthed))
        my_client.mob = new /mob/abstract/new_player()
    my_client.InitClient()
