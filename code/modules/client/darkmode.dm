//Darkmode preference by Kmc2000//

/*
This lets you switch chat themes by using winset and CSS loading, you must relog to see this change (or rebuild your browseroutput datum)

Things to note:
If you change ANYTHING in interface/skin.dmf you need to change it here:
Format:
winset(src, "window as appears in skin.dmf after elem", "var to change = currentvalue;var to change = desired value")

How this works:
I've added a function to browseroutput.js which registers a cookie for darkmode and swaps the chat accordingly. You can find the button to do this under the "cog" icon next to the ping button (top right of chat)
This then swaps the window theme automatically

Thanks to spacemaniac and mcdonald for help with the JS side of this.

*/

/client/verb/toggledarkmode()
	set name = "Toggle Darkmode"
	set category = "Preferences"
	set desc = "Toggles between lightmode and darkmode."

	switch(prefs.darkmode)
		if(null)
			force_dark_theme()
			prefs.darkmode = TRUE
			prefs.save_preferences()
		if(FALSE)
			force_dark_theme()
			prefs.darkmode = TRUE
			prefs.save_preferences()
		if(TRUE)
			force_white_theme()
			prefs.darkmode = FALSE
			prefs.save_preferences()


/client/proc/force_white_theme() //There's no way round it. We're essentially changing the skin by hand. It's painful but it works, and is the way Lummox suggested.
	//Main windows
	winset(src, "infowindow", "background-color = #2c2f33;background-color = none")
	winset(src, "infowindow", "text-color = #99aab5;text-color = #000000")
	winset(src, "info", "background-color = #272727;background-color = none")
	winset(src, "info", "text-color = #99aab5;text-color = #000000")
	winset(src, "browseroutput", "background-color = #272727;background-color = none")
	winset(src, "browseroutput", "text-color = #99aab5;text-color = #000000")
	winset(src, "outputwindow", "background-color = #272727;background-color = none")
	winset(src, "outputwindow", "text-color = #99aab5;text-color = #000000")
	winset(src, "mainwindow", "background-color = #2c2f33;background-color = none")
	winset(src, "split", "background-color = #272727;background-color = none")
	winset(src, "rpane", "background-color = #272727;background-color = none")
	winset(src, "rpanewindow", "background-color = #272727;background-color = none")
	//Buttons [In order of appearance]
	winset(src, "textb", "background-color = #494949;background-color = none")
	winset(src, "textb", "text-color = #99aab5;text-color = #000000")
	winset(src, "infob", "background-color = #494949;background-color = none")
	winset(src, "infob", "text-color = #99aab5;text-color = #000000")
	winset(src, "wikib", "background-color = #494949;background-color = none")
	winset(src, "wikib", "text-color = #99aab5;text-color = #000000")
	winset(src, "forumb", "background-color = #494949;background-color = none")
	winset(src, "forumb", "text-color = #99aab5;text-color = #000000")
	winset(src, "rulesb", "background-color = #494949;background-color = none")
	winset(src, "rulesb", "text-color = #99aab5;text-color = #000000")
	winset(src, "changelog", "background-color = #494949;background-color = none")
	winset(src, "changelog", "text-color = #99aab5;text-color = #000000")
	winset(src, "reportbugb", "background-color = #492020;background-color = none")
	winset(src, "reportbugb", "text-color = #99aab5;text-color = #000000")
	winset(src, "interfaceb", "background-color = #3a3a3a;background-color = none")
	winset(src, "interfaceb", "text-color = #99aab5;text-color = #000000")
	winset(src, "discordb", "background-color = #3a3a3a;background-color = none")
	winset(src, "discordb", "text-color = #99aab5;text-color = #000000")
	//Status and verb tabs
	winset(src, "output", "background-color = #272727;background-color = none")
	winset(src, "output", "text-color = #99aab5;text-color = #000000")
	winset(src, "outputwindow", "background-color = #272727;background-color = none")
	winset(src, "outputwindow", "text-color = #99aab5;text-color = #000000")
	winset(src, "statwindow", "background-color = #272727;background-color = none")
	winset(src, "statwindow", "text-color = #eaeaea;text-color = #000000")
	winset(src, "stat", "background-color = #2c2f33;background-color = #FFFFFF")
	winset(src, "stat", "tab-background-color = #272727;tab-background-color = none")
	winset(src, "stat", "text-color = #99aab5;text-color = #000000")
	winset(src, "stat", "tab-text-color = #99aab5;tab-text-color = #000000")
	//Say, OOC, me Buttons etc.
	winset(src, "saybutton", "background-color = #272727;background-color = none")
	winset(src, "saybutton", "text-color = #99aab5;text-color = #000000")
	winset(src, "oocbutton", "background-color = #272727;background-color = none")
	winset(src, "oocbutton", "text-color = #99aab5;text-color = #000000")
	winset(src, "mebutton", "background-color = #272727;background-color = none")
	winset(src, "mebutton", "text-color = #99aab5;text-color = #000000")
	winset(src, "asset_cache_browser", "background-color = #272727;background-color = none")
	winset(src, "asset_cache_browser", "text-color = #99aab5;text-color = #000000")
	winset(src, "tooltip", "background-color = #272727;background-color = none")
	winset(src, "tooltip", "text-color = #99aab5;text-color = #000000")

/client/proc/force_dark_theme() //Inversely, if theyre using white theme and want to swap to the superior dark theme, let's get WINSET() ing
	//Main windows
	winset(src, "infowindow", "background-color = none;background-color = #2c2f33")
	winset(src, "infowindow", "text-color = #000000;text-color = #99aab5")
	winset(src, "info", "background-color = none;background-color = #272727")
	winset(src, "info", "text-color = #000000;text-color = #99aab5")
	winset(src, "browseroutput", "background-color = none;background-color = #272727")
	winset(src, "browseroutput", "text-color = #000000;text-color = #99aab5")
	winset(src, "browser", "background-color = none;background-color = #272727")
	winset(src, "browser", "text-color = #000000;text-color = #99aab5")
	winset(src, "outputwindow", "background-color = none;background-color = #272727")
	winset(src, "outputwindow", "text-color = #000000;text-color = #99aab5")
	winset(src, "mainwindow", "background-color = none;background-color = #2c2f33")
	winset(src, "mapwindow", "background-color = none;background-color = #2c2f33")
	winset(src, "browserwindow", "background-color = none;background-color = #2c2f33")
	winset(src, "mainvsplit", "background-color = none;background-color = #272727")
	winset(src, "splitter_vertical", "background-color = none;background-color = #2c2f33")
	winset(src, "splitter_horizontal", "background-color = none;background-color = #2c2f33")
	winset(src, "input", "background-color = none;background-color = #2c2f33")
	winset(src, "rpane", "background-color = none;background-color = #2c2f33")
	winset(src, "rpanemode", "background-color = none;background-color = #2c2f33")
	winset(src, "rpanemode", "text-color = #000000;text-color = #99aab5")
	winset(src, "rpanewindow", "background-color = none;background-color = #99aab5")
	winset(src, "text_editor", "background-color = none;background-color = #99aab5")
	//Buttons
	winset(src, "textb", "background-color = none;background-color = #494949")
	winset(src, "textb", "text-color = #000000;text-color = #99aab5")
	winset(src, "infob", "background-color = none;background-color = #494949")
	winset(src, "infob", "text-color = #000000;text-color = #99aab5")
	winset(src, "wikib", "background-color = none;background-color = #494949")
	winset(src, "wikib", "text-color = #000000;text-color = #99aab5")
	winset(src, "forumb", "background-color = none;background-color = #494949")
	winset(src, "forumb", "text-color = #000000;text-color = #99aab5")
	winset(src, "rulesb", "background-color = none;background-color = #494949")
	winset(src, "rulesb", "text-color = #000000;text-color = #99aab5")
	winset(src, "changelog", "background-color = none;background-color = #494949")
	winset(src, "changelog", "text-color = #000000;text-color = #99aab5")
	winset(src, "reportbugb", "background-color = none;background-color = #494949")
	winset(src, "reportbugb", "text-color = #000000;text-color = #99aab5")
	winset(src, "interfaceb", "background-color = none;background-color = #494949")
	winset(src, "interfaceb", "text-color = #000000;text-color = #99aab5")
	winset(src, "discordb", "background-color = none;background-color = #43454d")
	winset(src, "discordb", "text-color = #000000;text-color = #99aab5")
	winset(src, "hotkey_toggle", "background-color = none;background-color = #492020")
	winset(src, "hotkey_toggle", "text-color = #000000;text-color = #99aab5")
	//Status and verb tabs
	winset(src, "output", "background-color = none;background-color = #272727")
	winset(src, "output", "text-color = #000000;text-color = #99aab5")
	winset(src, "outputwindow", "background-color = none;background-color = #272727")
	winset(src, "outputwindow", "text-color = #000000;text-color = #99aab5")
	winset(src, "statwindow", "background-color = none;background-color = #272727")
	winset(src, "statwindow", "text-color = #000000;text-color = #eaeaea")
	winset(src, "stat", "background-color = #FFFFFF;background-color = #2c2f33")
	winset(src, "stat", "tab-background-color = none;tab-background-color = #272727")
	winset(src, "stat", "text-color = #000000;text-color = #99aab5")
	winset(src, "stat", "tab-text-color = #000000;tab-text-color = #99aab5")
	//Say, OOC, me Buttons etc.
	winset(src, "saybutton", "background-color = none;background-color = #272727")
	winset(src, "saybutton", "text-color = #000000;text-color = #99aab5")
	winset(src, "oocbutton", "background-color = none;background-color = #272727")
	winset(src, "oocbutton", "text-color = #000000;text-color = #99aab5")
	winset(src, "mebutton", "background-color = none;background-color = #272727")
	winset(src, "mebutton", "text-color = #000000;text-color = #99aab5")
	winset(src, "asset_cache_browser", "background-color = none;background-color = #272727")
	winset(src, "asset_cache_browser", "text-color = #000000;text-color = #99aab5")
	winset(src, "tooltip", "background-color = none;background-color = #272727")
	winset(src, "tooltip", "text-color = #000000;text-color = #99aab5")