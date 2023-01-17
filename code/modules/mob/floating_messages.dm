// Thanks to Burger from Burgerstation for the foundation for this
var/list/floating_chat_colors = list()

/atom/movable
	var/list/stored_chat_text

/atom/movable/proc/get_floating_chat_color()
	return get_random_colour(0, 160, 230)

/atom/movable/proc/set_floating_chat_color(color)
	floating_chat_colors[name] = color

/atom/movable/proc/animate_chat(message, datum/language/language, small, list/show_to, duration, override_color)
	set waitfor = FALSE

	var/style	//additional style params for the message
	var/fontsize = 6
	if(small)
		fontsize = 5
	var/limit = 50
	if(copytext(message, length(message) - 1) == "!!")
		fontsize = 8
		limit = 30
		style += "font-weight: bold;"

	if(length(message) > limit)
		message = "[copytext(message, 1, limit)]..."

	if(istype(language, /datum/language/noise))
		message = "<font color='#7F7F7F'>*</font> " + uncapitalize(message)

	if(!floating_chat_colors[name])
		floating_chat_colors[name] = get_floating_chat_color()
	style += "color: [floating_chat_colors[name]];"

	// create 2 messages, one that appears if you know the language, and one that appears when you don't know the language
	var/image/understood = generate_floating_text(src, capitalize(message), style, fontsize, duration, show_to)
	var/image/gibberish
	if(!isnull(language))
		gibberish = generate_floating_text(src, language.scramble(message), style, fontsize, duration, show_to)

	for(var/client/C in show_to)
		if(!(C.prefs.toggles_secondary & FLOATING_MESSAGES))
			continue

		if(isnull(language))
			C.images += understood
			continue

		if(C.mob.say_understands(null, language))
			C.images += understood
		else
			C.images += gibberish

/proc/generate_floating_text(atom/movable/holder, message, style, size, duration, show_to)
	var/atom/movable/attached_holder = recursive_loc_turf_check(holder, 5)
	var/image/I = image(null, attached_holder)
	I.layer = FLY_LAYER
	I.alpha = 0
	I.maptext_width = 80
	I.maptext_height = 64
	I.plane = FLOAT_PLANE
	I.layer = HUD_LAYER - 0.01
	I.pixel_x = (-round(I.maptext_width/2) + 16) + attached_holder.get_floating_chat_x_offset()
	I.appearance_flags = RESET_COLOR|RESET_ALPHA|RESET_TRANSFORM

	style = "font-family: 'Small Fonts'; -dm-text-outline: 1 black; font-size: [size]px; [style]"
	I.maptext = "<center><span style=\"[style]\">[message]</span></center>"
	animate(I, 1, alpha = 255, pixel_y = 23)

	for(var/image/old in holder.stored_chat_text)
		animate(old, 2, pixel_y = old.pixel_y + 8)
	LAZYADD(holder.stored_chat_text, I)

	addtimer(CALLBACK(GLOBAL_PROC, .proc/remove_floating_text, holder, I), duration)
	addtimer(CALLBACK(GLOBAL_PROC, .proc/remove_images_from_clients, I, show_to), duration + 2)

	return I

/// Gives floating text to src upon holder entering
/atom/movable/proc/give_floating_text(atom/movable/holder)
	if(!holder)
		return
	for(var/image/I in holder.stored_chat_text)
		I.loc = src

/// Returns floating text to holder upon leaving src
/atom/movable/proc/return_floating_text(atom/movable/holder)
	if(!holder)
		return
	for(var/image/I in holder.stored_chat_text)
		I.loc = holder

/proc/remove_floating_text(atom/movable/holder, image/I)
	animate(I, 2, pixel_y = I.pixel_y + 10, alpha = 0)
	LAZYREMOVE(holder.stored_chat_text, I)
