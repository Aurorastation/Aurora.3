/datum/browser
	var/mob/user
	var/title = ""
	/// window_id is used as the window name for browse and onclose
	var/window_id
	var/width = 0
	var/height = 0
	var/datum/weakref/source_ref = null
	/// window option is set using window_id
	var/window_options = "can_close=1;can_minimize=1;can_maximize=0;can_resize=1;titlebar=1;"
	var/stylesheets = list()
	var/scripts = list()
	var/title_image
	var/head_elements
	var/body_elements
	var/head_content = ""
	var/content = ""
	var/title_buttons = ""


/datum/browser/New(mob/user, window_id, title = "", width = 0, height = 0, atom/source = null, skip_common_stylesheet = FALSE)

	src.user = user
	RegisterSignal(user, COMSIG_QDELETING, PROC_REF(user_deleted))
	src.window_id = window_id
	if (title)
		src.title = format_text(title)
	if (width)
		src.width = width
	if (height)
		src.height = height
	if (source)
		src.source_ref = WEAKREF(source)
	if(!skip_common_stylesheet)
		add_stylesheet("common", 'html/browser/common.css') // this CSS sheet is common to all UIs

/datum/browser/proc/user_deleted(datum/source)
	SIGNAL_HANDLER
	user = null

/datum/browser/proc/set_user(mob/user)
	src.user = user

/datum/browser/proc/set_title(title)
	src.title = format_text(title)

/datum/browser/proc/add_head_content(head_content)
	src.head_content += head_content

/datum/browser/proc/set_head_content(head_content)
	src.head_content = head_content

/datum/browser/proc/set_title_buttons(title_buttons)
	src.title_buttons = title_buttons

/datum/browser/proc/set_window_options(window_options)
	src.window_options = window_options

/datum/browser/proc/set_title_image(ntitle_image)
	//title_image = ntitle_image

/datum/browser/proc/add_stylesheet(name, file)
	if (istype(name, /datum/asset/spritesheet))
		var/datum/asset/spritesheet/sheet = name
		stylesheets["spritesheet_[sheet.name].css"] = "data/spritesheets/[sheet.name]"
	else
		var/asset_name = "[name].css"

		stylesheets[asset_name] = file

		if (!SSassets.cache[asset_name])
			SSassets.transport.register_asset(asset_name, file)

/datum/browser/proc/add_script(name, file)
	scripts["[ckey(name)].js"] = file
	SSassets.transport.register_asset("[ckey(name)].js", file)

/datum/browser/proc/set_content(content)
	src.content = content

/datum/browser/proc/add_content(content)
	src.content += content

/datum/browser/proc/get_header()
	var/list/new_head_content = list()
	for (var/file as anything in stylesheets)
		new_head_content += "<link rel='stylesheet' type='text/css' href='[SSassets.transport.get_asset_url(file)]'>"

	if(user.client?.window_scaling && user.client?.window_scaling != 1 && !user.client?.prefs.ui_scale && width && height)
		new_head_content += {"
			<style>
				body {
					zoom: [100 / user.client?.window_scaling]%;
				}
			</style>
			"}

	for (var/file as anything in scripts)
		new_head_content += "<script type='text/javascript' src='[SSassets.transport.get_asset_url(file)]'></script>"

	var/title_attributes = "class='uiTitle'"
	if (title_image)
		title_attributes = "class='uiTitle icon' style='background-image: url([title_image]);'"

	head_content += new_head_content.Join()
	return {"<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<meta http-equiv="Content-Type" content="text/html; utf-8">
		[head_content]
	</head>
	<body scroll=auto>
		<div class='uiWrapper'>
			[title ? "<div class='uiTitleWrapper'><div [title_attributes]><tt>[title]</tt></div><div class='uiTitleButtons'>[title_buttons]</div></div>" : ""]
			<div class='uiContent'>
	"}

/datum/browser/proc/get_footer()
	return {"
			</div>
		</div>
	</body>
</html>"}

/datum/browser/proc/get_content()
	return {"
		[get_header()]
		[content]
		[get_footer()]
	"}

/datum/browser/proc/open(var/use_onclose = 1)
	if(isnull(window_id)) //null check because this can potentially nuke goonchat
		WARNING("Browser [title] tried to open with a null ID")
		to_chat(user, SPAN_DANGER("The [title] browser you tried to open failed a sanity check! Please report this on GitHub!"))
		return

	var/window_size = ""
	if(width && height)
		if(user.client?.prefs.ui_scale)
			var/scaling = user.client.window_scaling
			window_size = "size=[width * scaling]x[height * scaling];"
		else
			window_size = "size=[width]x[height];"
	if (length(stylesheets))
		SSassets.transport.send_assets(user.client, stylesheets)
	if (length(scripts))
		SSassets.transport.send_assets(user.client, scripts)
	user << browse(get_content(), "window=[window_id];[window_size][window_options]")
	if (use_onclose)
		setup_onclose()

// Fix from /tg/.
/datum/browser/proc/setup_onclose()
	set waitfor = 0
	for (var/i in 1 to 10)
		if (!user?.client || !winexists(user, window_id))
			continue
		var/atom/send_ref
		if(source_ref)
			send_ref = source_ref.resolve()
			if(!send_ref)
				source_ref = null
		onclose(user, window_id, send_ref)

/datum/browser/proc/update(var/force_open = 0, var/use_onclose = 1)
	if(force_open)
		open(use_onclose)
	else
		send_output(user, get_content(), "[window_id].browser")

/datum/browser/proc/close()
	user << browse(null, "window=[window_id]")
	if(!isnull(window_id))//null check because this can potentially nuke goonchat
		user << browse(null, "window=[window_id]")
	else
		WARNING("Browser [title] tried to close with a null ID")

// This will allow you to show an icon in the browse window
// This is added to mob so that it can be used without a reference to the browser object
// There is probably a better place for this...
/mob/proc/browse_rsc_icon(icon, icon_state, dir = -1)
	/*
	var/icon/I
	if (dir >= 0)
		I = new /icon(icon, icon_state, dir)
	else
		I = new /icon(icon, icon_state)
		dir = "default"

	var/filename = "[ckey("[icon]_[icon_state]_[dir]")].png"
	to_chat(src, browse_rsc(I, filename))
	return filename
	*/


/// Registers the on-close verb for a browse window (client/verb/windowclose)
/// this will be called when the close-button of a window is pressed.
///
/// This is usually only needed for devices that regularly update the browse window,
/// e.g. canisters, timers, etc.
///
/// windowid should be the specified window name
/// e.g. code is : user << browse(text, "window=fred")
/// then use : onclose(user, "fred")
///
/// Optionally, specify the "source" parameter as the controlled atom (usually src)
// to pass a "close=1" parameter to the atom's Topic() proc for special handling.
/// Otherwise, the user mob's machine var will be reset directly.
///
/proc/onclose(mob/user, windowid, atom/source = null)
	if(!user || !user.client) return
	var/param = "null"
	if(source)
		param = "[REF(source)]"

	winset(user, windowid, "on-close=\".windowclose [param]\"")


/// the on-close client verb
/// called when a browser popup window is closed after registering with proc/onclose()
/// if a valid atom reference is supplied, call the atom's Topic() with "close=1"
/// otherwise, just reset the client mob's machine var.
/client/verb/windowclose(atomref as text)
	set hidden = TRUE // hide this verb from the user's panel
	set name = ".windowclose" // no autocomplete on cmd line

	if(atomref == "null")
		return
	// if passed a real atomref
	var/atom/hsrc = locate(atomref) // find the reffed atom
	var/href = "close=1"
	if(!hsrc)
		return
	usr = src.mob
	src.Topic(href, params2list(href), hsrc) // this will direct to the atom's Topic() proc via client.Topic()
