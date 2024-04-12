// Thanks to Burger from Burgerstation for the foundation for this
var/list/floating_chat_colors = list()

///Compute an unique key that is used to associate an image to the client that received said image
#define STORED_CHAT_TEXT_HASH(client) "[client.ckey]"
/atom/movable
	/**
	 * A lazy list with the following format:
	 *
	 * * K -> The hash function result of STORED_CHAT_TEXT_HASH, a string
	 * * V -> A `/list` of `/image`, the images are the runetext sent to be shown to the various clients (as per the hash function)
	 */
	VAR_PRIVATE/list/stored_chat_text

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
		message = "[copytext_char(message, 1, limit)]..."

	if(istype(language, /datum/language/noise))
		message = "<font color='#7F7F7F'>*</font> " + uncapitalize(message)

	if(!floating_chat_colors[name])
		floating_chat_colors[name] = get_floating_chat_color()
	style += "color: [floating_chat_colors[name]];"

	send_chat_floating_text_to_clients(show_to, message, fontsize, style, duration, language)


/**
 * Generates a floating message image and sent it to the clients
 *
 *
 * * show_to - A `/list` of clients to show the image to
 * * message - A string, the message to show
 * * style - String, a CSS-DM that will be injected in the style of the maptext, MUST be semicolon (;) terminated
 * * duration - Duration in deciseconds to show the message for
 * * language - A `/datum/language`, to appropriately change the image based on the understanding of the mob that receives it
 */
/atom/movable/proc/send_chat_floating_text_to_clients(list/client/show_to, message, fontsize, style, duration, datum/language/language)
	SHOULD_NOT_SLEEP(TRUE)

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
		generate_floating_text(message_to_put_in_image, style, fontsize, duration, C)


/**
 * Generates a floating text message and takes care of showing it to the client, and remove it
 *
 *
 * * message - String, the text to put into the floating text
 * * style - String, a CSS-DM that will be injected in the style of the maptext, MUST be semicolon (;) terminated
 * * fontsize - One of the GENERATE_FLOATING_TEXT_* macros defined in `code\__DEFINES\text.dm`, determines the size
 * * duration - Duration in deciseconds to show the message for
 *
 * This process can sleep as it uses the client to measure the size of text, it should only be called inside a non-blocking call chain
 *
 */
/atom/movable/proc/generate_floating_text(message, style, fontsize = GENERATE_FLOATING_TEXT_MEDIUM, duration, client/show_to)
	set waitfor = FALSE
	PRIVATE_PROC(TRUE)

	if(!istype(show_to))
		crash_with("Wrong argument supplied, show_to is not a client!")

	//No point if the source or the destination of the floating text are deleted
	if(QDELETED(src) || QDELETED(show_to))
		return FALSE

	var/atom/movable/attached_holder = get_last_atom_before_turf(src)
	var/image/I = image(null, attached_holder, layer = FLY_LAYER)
	I.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA | KEEP_APART | PIXEL_SCALE

	I.plane = FLOAT_PLANE
	I.layer = UNDER_HUD_LAYER
	I.pixel_x = (-round(I.maptext_width/2) + 16) + attached_holder.get_floating_chat_x_offset()
	I.appearance_flags = RESET_COLOR|RESET_ALPHA|RESET_TRANSFORM

	I.alpha = 0

	I.maptext_width = CHAT_MESSAGE_WIDTH

	I.maptext_x = (CHAT_MESSAGE_WIDTH - src.bound_width) * -0.5

	I.pixel_y = src.get_floating_chat_y_offset()
	I.pixel_x = src.get_floating_chat_x_offset()

	//Select the various parameters for the maptext, to ensure pixel-perfect scaling
	var/font_family
	var/font_size
	var/other
	switch(fontsize)
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

	var/complete_text = "<span class='center'><span style='font-family: \"[font_family]\"; font-size: [font_size]pt; [other] [style] text-align: center;'>[message]</span></span>"

	I.maptext = complete_text

	//At this point we enter the wait, we patiently wait for the client to tell us how large
	//the text will be on its screen, as we need that info for the image generation afterwards
	var/mheight = 0
	WXH_TO_HEIGHT(show_to.MeasureText(complete_text, null, CHAT_MESSAGE_WIDTH), mheight)

	//Then we register a callback to complete the image generation, this is done to avoid
	//the proc waking up at the end of a tick and cause overtime
	SSrunechat.message_queue += CALLBACK(src, PROC_REF(finish_generate_floating_text), I, mheight, show_to, duration)


/**
 * Runs after the calculation of the client for the runechat size measurement,
 * takes care of the last things needed to be set on the image, to display it to the clients,
 * and to register it for removal when it expires
 *
 * Should only, ever be called by the runechat subsystem as a consequence of the `generate_floating_text()` callback insertion
 */
/atom/movable/proc/finish_generate_floating_text(image/runetext_image, mheight, client/show_to, lifespan)
	SHOULD_NOT_SLEEP(TRUE)
	PRIVATE_PROC(TRUE)

	runetext_image.maptext_height = mheight * 1.25

	var/stored_chat_text_hash_cache = STORED_CHAT_TEXT_HASH(show_to)

	//Older runetext messages are shifted up so they clear the visual for the new ones
	for(var/image/old in LAZYACCESS(src.stored_chat_text, stored_chat_text_hash_cache))
		animate(old, 2, pixel_y = old.pixel_y + min(runetext_image.maptext_height, 45) + 8)

	//We register ourself as a stored chat text image
	LAZYADDASSOCLIST(src.stored_chat_text, stored_chat_text_hash_cache, runetext_image)

	//Send the image to the client, takes care to remove it afterwards
	flick_overlay(runetext_image, list(show_to), (lifespan + 2))

	//Animation to show the text "appearing up"
	animate(runetext_image, 1, alpha = 255, pixel_y = runetext_image.pixel_y + 23)

	//Register a timer for our removal from the list
	addtimer(CALLBACK(src, PROC_REF(remove_floating_text), runetext_image, stored_chat_text_hash_cache), lifespan)


/// Gives floating text to src upon holder entering
/atom/movable/proc/give_floating_text(atom/movable/holder)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

	if(!holder)
		return
	for(var/key in holder.stored_chat_text)
		for(var/image/I in holder.stored_chat_text[key])
			I.loc = src

/// Returns floating text to holder upon leaving src
/atom/movable/proc/return_floating_text(atom/movable/holder)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

	if(!holder)
		return
	for(var/key in holder.stored_chat_text)
		for(var/image/I in holder.stored_chat_text[key])
			I.loc = holder

/atom/movable/proc/remove_floating_text(image/image_to_remove, stored_chat_text_hash)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

	var/list/image/client_associated_images = LAZYACCESS(src.stored_chat_text, stored_chat_text_hash)
	if(!(client_associated_images?.Find(image_to_remove)))
		crash_with("Trying to remove a floating text image that is not there!")

	animate(image_to_remove, 2, pixel_y = image_to_remove.pixel_y + 10, alpha = 0)
	LAZYREMOVEASSOC(src.stored_chat_text, stored_chat_text_hash, image_to_remove)

#undef STORED_CHAT_TEXT_HASH
