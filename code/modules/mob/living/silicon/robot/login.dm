/mob/living/silicon/robot/LateLogin()
	..()
	regenerate_icons()
	show_laws(0)

	if(client.prefs.toggles_secondary & HOTKEY_DEFAULT)
		winset(src, null, "mainwindow.macro=borghotkeymode hotkey_toggle.is-checked=true mapwindow.map.focus=true input.background-color=#D3B5B5")
	else
		winset(src, null, "mainwindow.macro=borgmacro hotkey_toggle.is-checked=false input.focus=true input.background-color=#D3B5B5")

	// Forces synths to select an icon relevant to their module
	if(module && !icon_selected)
		choose_icon()
	set_intent(a_intent) // to set the eye colour