/mob/living/silicon/robot/LateLogin()
	..()
	regenerate_icons()
	show_laws(0)

	if(client.prefs.toggles_secondary & HOTKEY_DEFAULT)
		winset(src, null, "mainwindow.macro=borghotkeymode hotkey_toggle.is-checked=true mapwindow.map.focus=true")
	else
		winset(src, null, "mainwindow.macro=borgmacro hotkey_toggle.is-checked=false input.focus=true")

	// Forces synths to select an icon relevant to their module
	if(module && !icon_selected)
		choose_icon()
	set_intent(a_intent) // to set the eye colour
