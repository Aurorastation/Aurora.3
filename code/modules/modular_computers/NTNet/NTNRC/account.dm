/datum/ntnet_account
    var/uid
    var/username = "New User"
    var/obj/item/card/id/ident

/datum/ntnet_account/New(mob/user, var/hidden=FALSE)
    if(!user)
        return
    if(!hidden)
        ntnet_global.users += src
    uid = ntnet_global.users.len
    ident = user.getIdCard()
    if(ident && ident.registered_name && ident.assignment)
        username = "[ident.registered_name] ([ident.assignment])"
    else if(ident.registered_name)
        username = "[ident.registered_name]"
    else
        username = "Unknown User #[uid]"