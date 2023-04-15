// Container for all essesal state for NTRC message while it's proccessed
/datum/ntnet_message
    var/mob/user
    var/datum/computer_file/program/chat_client/client
    var/datum/ntnet_user/nuser
    var/play_sound = FALSE

/datum/ntnet_message/New(var/datum/computer_file/program/chat_client/Pr = null, var/mob/user = null)
    if(user)
        src.user = user
    if(Pr)
        client = Pr
        nuser = Pr.my_user

// Should be sanitized
/datum/ntnet_message/proc/format_chat_notification(var/datum/ntnet_conversation/Conv, var/datum/computer_file/program/chat_client/Cl)
    return FALSE

/datum/ntnet_message/proc/format_admin_log(var/datum/ntnet_conversation/Conv)
    return FALSE

// Should be sanitized
/datum/ntnet_message/proc/format_ntnet_log(var/datum/ntnet_conversation/Conv)
    return FALSE

/datum/ntnet_message/proc/format_chat_log(var/datum/ntnet_conversation/Conv)
    return FALSE



/datum/ntnet_message/message
    play_sound = TRUE
    var/message = ""

/datum/ntnet_message/message/format_chat_notification(var/datum/ntnet_conversation/Conv, var/datum/computer_file/program/chat_client/Cl)
    . = "<b>([sanitize(Conv.get_title(Cl))]) <i>[nuser.username]</i>:</b> [sanitize(message)] (<a href='byond://?src=\ref[Cl]&Reply=\ref[Conv]'>Reply</a>)"

/datum/ntnet_message/message/format_chat_log(var/datum/ntnet_conversation/Conv)
    . = "[worldtime2text()] [nuser.username]: [message]"

/datum/ntnet_message/message/format_admin_log(var/datum/ntnet_conversation/Conv)
    . = message

/datum/ntnet_message/message/format_ntnet_log(var/datum/ntnet_conversation/Conv)
    . = "[sanitize(Conv.get_title())] [nuser.username]: [sanitize(message)]"



/datum/ntnet_message/join/format_chat_notification(var/datum/ntnet_conversation/Conv, var/datum/computer_file/program/chat_client/Cl)
    . = FONT_SMALL("<b>([sanitize(Conv.get_title(Cl))]) <i>[nuser.username]</i> has entered the chat.</b>")

/datum/ntnet_message/join/format_chat_log(var/datum/ntnet_conversation/Conv)
    . = "[worldtime2text()] -!- [nuser.username] has entered the chat."



/datum/ntnet_message/leave/format_chat_notification(var/datum/ntnet_conversation/Conv, var/datum/computer_file/program/chat_client/Cl)
    . = FONT_SMALL("<b>([sanitize(Conv.get_title(Cl))]) <i>[nuser.username]</i> has left the chat.</b>")

/datum/ntnet_message/leave/format_chat_log(var/datum/ntnet_conversation/Conv)
    . = "[worldtime2text()] -!- [nuser.username] has left the chat."



/datum/ntnet_message/new_op/format_chat_log(var/datum/ntnet_conversation/Conv)
    . = "[worldtime2text()] -!- [nuser.username] has become operator."



/datum/ntnet_message/new_title
    var/title = ""

/datum/ntnet_message/new_title/format_chat_log(var/datum/ntnet_conversation/Conv)
    . = "[worldtime2text()] -!- [nuser.username] has changed channel title from [Conv.get_title()] to [title]"

/datum/ntnet_message/new_title/format_chat_notification(var/datum/ntnet_conversation/Conv, var/datum/computer_file/program/chat_client/Cl)
    . = FONT_SMALL("<b>([sanitize(Conv.get_title(Cl))]) <i>[nuser.username]</i> has changed the channel title to <i>[sanitize(title)].</i></b>")



/datum/ntnet_message/kick
    var/datum/ntnet_user/target

/datum/ntnet_message/kick/format_chat_log(var/datum/ntnet_conversation/Conv)
    . = "[worldtime2text()] -!- [nuser.username] has kicked [target.username] from conversation."

/datum/ntnet_message/kick/format_chat_notification(var/datum/ntnet_conversation/Conv, var/datum/computer_file/program/chat_client/Cl)
    . = FONT_SMALL("<b>([sanitize(Conv.get_title(Cl))]) <i>[nuser.username]</i> has kicked <i>[target.username]</i> from conversation.</b>")



/datum/ntnet_message/direct/format_chat_log(var/datum/ntnet_conversation/Conv)
    . = "[worldtime2text()] -!- [nuser.username] has opened direct conversation."

/datum/ntnet_message/direct/format_chat_notification(var/datum/ntnet_conversation/Conv, var/datum/computer_file/program/chat_client/Cl)
    . = FONT_SMALL("<b>([sanitize(Conv.get_title(Cl))]) <i>[nuser.username]</i> has opened direct conversation with you.</b>")
