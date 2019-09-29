/client/verb/VuChat_reload()
	set name = "VUChat: Reload"
	set category = "OOC"
	chat.show()
	chat.LoadHTML()
	to_chat(src, "VüChat reloaded.")

/client/verb/VuChat_hide()
	set name = "VUChat: Hide"
	set category = "OOC"
	chat.hide()