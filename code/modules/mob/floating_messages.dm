// Thanks to Burger from Burgerstation for the foundation for this
var/list/floating_chat_colors = list()

/atom/movable
	var/list/stored_chat_text

/atom/movable/proc/get_floating_chat_color()
	return get_random_colour(0, 160, 230)

/atom/movable/proc/set_floating_chat_color(color)
	floating_chat_colors[name] = color

/atom/movable/proc/animate_chat(message, datum/language/language, small, list/show_to, duration, override_color)
	SHOULD_NOT_SLEEP(TRUE)

	var/style	//additional style params for the message
	var/fontsize = GENERATE_FLOATING_TEXT_MEDIUM
	if(small)
		fontsize = GENERATE_FLOATING_TEXT_SMALL
	var/limit = 50
	if(copytext(message, length(message) - 1) == "!!")
		fontsize = GENERATE_FLOATING_TEXT_LARGE
		limit = 30
		style += "font-weight: bold;"

	if(length(message) > limit)
		message = "[copytext(message, 1, limit)]..."

	if(istype(language, /datum/language/noise))
		message = "<font color='#7F7F7F'>*</font> " + uncapitalize(message)

	if(!floating_chat_colors[name])
		floating_chat_colors[name] = get_floating_chat_color()
	style += "color: [floating_chat_colors[name]];"

	INVOKE_ASYNC(src, PROC_REF(send_chat_floating_text_to_clients), show_to, message, fontsize, style, duration, language)


/**
 * Generates a floating message image and sent it to the clients
 *
 * This process can and does sleep, it should _never_ be waited on, and should only be called inside a non-blocking call chain
 *
 * * show_to - A `/list` of clients to show the image to
 * * message - A string, the message to show
 * * style - String, a CSS-DM that will be injected in the style of the maptext, MUST be semicolon (;) terminated
 * * duration - Duration in deciseconds to show the message for
 * * language - A `/datum/language`, to appropriately change the image based on the understanding of the mob that receives it
 */
/atom/movable/proc/send_chat_floating_text_to_clients(list/client/show_to, message, fontsize, style, duration, datum/language/language)
	// create 2 messages, one that appears if you know the language, and one that appears when you don't know the language
	for(var/client/C in show_to)
		if(!(C.prefs.toggles_secondary & FLOATING_MESSAGES))
			continue

		var/message_to_put_in_image

		//See if it needs an understood message, or a gibberish one, to be shown, and generate it
		if(isnull(language) || C.mob.say_understands(null, language))
			message_to_put_in_image = capitalize(message)
		else if(!isnull(language))
			message_to_put_in_image = language.scramble(message)

		//Generate the image, sent it to the client
		generate_floating_text(src, message_to_put_in_image, style, fontsize, duration, C)


/**
 * Generates a floating text message and takes care of showing it to the client, and remove it
 *
 * * holder - The holder of the floating text, an `/atom/movable`
 * * message - String, the text to put into the floating text
 * * style - String, a CSS-DM that will be injected in the style of the maptext, MUST be semicolon (;) terminated
 * * size - One of the GENERATE_FLOATING_TEXT_* macros defined in `code\__DEFINES\text.dm`, determines the size
 * * duration - Duration in deciseconds to show the message for
 *
 * This process can sleep as it uses the client to measure the size of text, it should only be called inside a non-blocking call chain
 *
 * Returns an `/image`, the image is what was sent to the client specified in `show_to`
 */
/atom/movable/proc/generate_floating_text(atom/movable/holder, message, style, size = GENERATE_FLOATING_TEXT_MEDIUM, duration, client/show_to)
	RETURN_TYPE(/image)

	//No point is the source or the destination of the floating text are deleted
	if(QDELETED(holder) || QDELETED(show_to))
		return FALSE

	var/atom/movable/attached_holder = get_last_atom_before_turf(holder)
	var/image/I = image(null, attached_holder, layer = FLY_LAYER)
	I.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA | KEEP_APART | PIXEL_SCALE

	I.plane = FLOAT_PLANE

	I.alpha = 0

	I.maptext_width = CHAT_MESSAGE_WIDTH

	I.maptext_x = (CHAT_MESSAGE_WIDTH - holder.bound_width) * -0.5

	I.pixel_y = holder.get_floating_chat_y_offset()
	I.pixel_x = holder.get_floating_chat_x_offset()

	//Select the various parameters for the maptext, to ensure pixel-perfect scaling
	var/font_family
	var/font_size
	var/other
	switch(size)
		if(GENERATE_FLOATING_TEXT_SMALL)
			font_family = "Spess Font"
			font_size = 6
			other = "-dm-text-outline: 1px black sharp; line-height: 1.4;"
		if(GENERATE_FLOATING_TEXT_MEDIUM)
			font_family = "Grand9K Pixel"
			font_size = 6
			other = "-dm-text-outline: 1px black sharp;"
		if(GENERATE_FLOATING_TEXT_LARGE)
			font_family = "Grand9K Pixel"
			font_size = 12
			other = "-dm-text-outline: 1.2px black sharp;"
		else
			crash_with("Wrong size specified, use one of the defines!")

	//I.maptext = "<span style='font-family: \"[font_family]\"; font-size: [font_size]pt; [other] [style] text-align: center;'>[message]</span>"
	var/complete_text = "<span class='center'><span style='font-family: \"[font_family]\"; font-size: [font_size]pt; [other] [style] text-align: center;'>[message]</span></span>"

	var/mheight = 0
	if(istype(show_to))
		WXH_TO_HEIGHT(show_to.MeasureText(complete_text, null, CHAT_MESSAGE_WIDTH), mheight)

	I.maptext_height = mheight * 1.25

	I.maptext = complete_text

	animate(I, 1, alpha = 255, pixel_y = I.pixel_y + 23)

	for(var/image/old in holder.stored_chat_text)
		animate(old, 2, pixel_y = old.pixel_y + 8)
	LAZYADD(holder.stored_chat_text, I)

	//Send the image to the client, takes care to remove it afterwards
	flick_overlay(I, list(show_to), (duration + 2))

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(remove_floating_text), holder, I), duration)

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
