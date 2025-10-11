/atom/var/langchat_height = 32 // abovetile usually
/atom/var/langchat_color = "#FFFFFF"
/atom/var/langchat_styles = ""

#define LANGCHAT_LONGEST_TEXT 64
#define LANGCHAT_WIDTH 96
#define LANGCHAT_MAX_ALPHA 196

//pop defines
#define LANGCHAT_DEFAULT_POP 0 //normal message
#define LANGCHAT_PANIC_POP 1 //this causes shaking
#define LANGCHAT_FAST_POP 2 //this just makes it go away faster

// params for default pop
#define LANGCHAT_MESSAGE_POP_TIME 3
#define LANGCHAT_MESSAGE_POP_Y_SINK 8

// params for panic pop
#define LANGCHAT_MESSAGE_PANIC_POP_TIME 1
#define LANGCHAT_MESSAGE_PANIC_POP_Y_SINK 8
#define LANGCHAT_MESSAGE_PANIC_SHAKE_SIZE 6
#define LANGCHAT_MESSAGE_PANIC_SHAKE_TIMES 6
#define LANGCHAT_MESSAGE_PANIC_SHAKE_TIME_TAKEN 1
// params for fast pop
#define LANGCHAT_MESSAGE_FAST_POP_TIME 1
#define LANGCHAT_MESSAGE_FAST_POP_Y_SINK 8

#define langchat_client_enabled(M) (M && M.client && M.client.prefs && (M.client.prefs.toggles_secondary & FLOATING_MESSAGES))

/*
 * Duplicate vars and logic created for untranslated images for the sake of getting an untranslated langchat to display for listeners who do not understand
 * the language being spoken. Someone could certainly think of cleaner ways to do this, but for want of a better solution right now, it has been implemented
 * in this rote manner to make it easier to strip out in future if it needs replaced.
 */

/atom/var/image/langchat_image
/atom/var/image/langchat_image_untranslated
/atom/var/list/mob/langchat_listeners
/atom/var/list/mob/langchat_listeners_untranslated

/// Hides the images, if they exist. Do not null the langchat images; they are rotated when the mob is buckled or proned to maintain text orientation.
/atom/proc/langchat_drop_images()
	if(langchat_listeners)
		for(var/mob/M in langchat_listeners)
			if(M.client)
				M.client.images -= langchat_image
		for(var/mob/M in langchat_listeners_untranslated)
			if(M.client)
				M.client.images -= langchat_image_untranslated
	langchat_listeners = null
	langchat_listeners_untranslated = null

/atom/proc/get_maxptext_x_offset(image/maptext_image)
	return (world.icon_size / 2) - (maptext_image.maptext_width / 2)

/atom/movable/get_maxptext_x_offset(image/maptext_image)
	return (bound_width / 2) - (maptext_image.maptext_width / 2)

/mob/get_maxptext_x_offset(image/maptext_image)
	return (icon_size / 2) - (maptext_image.maptext_width / 2)

/// Creates the image if it doesn't exist, resets settings that are modified by speech procs.
/atom/proc/langchat_make_image(override_color = null)
	if(!langchat_image)
		langchat_image = image(null, src)
		langchat_image.layer = 20
		langchat_image.plane = EFFECTS_ABOVE_LIGHTING_PLANE
		langchat_image.appearance_flags = NO_CLIENT_COLOR|KEEP_APART|RESET_COLOR|RESET_TRANSFORM
		langchat_image.maptext_y = langchat_height
		langchat_image.maptext_height = 64
		langchat_image.maptext_y -= LANGCHAT_MESSAGE_POP_Y_SINK
		langchat_image.maptext_x = get_maxptext_x_offset(langchat_image)
		langchat_image.filters = filter(type="drop_shadow", size = 1, color = COLOR_BLACK)

	langchat_image.pixel_y = 0
	langchat_image.alpha = 0
	langchat_image.color = override_color ? override_color : langchat_color
	if(appearance_flags & PIXEL_SCALE)
		langchat_image.appearance_flags |= PIXEL_SCALE

/mob/langchat_make_image(override_color = null)
	var/new_image = FALSE
	if(!langchat_image)
		new_image = TRUE
	. = ..()
	// Recenter for icons more than 32 wide
	if(new_image)
		langchat_image.maptext_x += (icon_size - 32) / 2

/// Creates the (untranslated) image if it doesn't exist, resets settings that are modified by speech procs.
/atom/proc/langchat_make_image_untranslated(override_color = null)
	if(!langchat_image_untranslated)
		langchat_image_untranslated = image(null, src)
		langchat_image_untranslated.layer = 20
		langchat_image_untranslated.plane = EFFECTS_ABOVE_LIGHTING_PLANE
		langchat_image_untranslated.appearance_flags = NO_CLIENT_COLOR|KEEP_APART|RESET_COLOR|RESET_TRANSFORM
		langchat_image_untranslated.maptext_y = langchat_height
		langchat_image_untranslated.maptext_height = 64
		langchat_image_untranslated.maptext_y -= LANGCHAT_MESSAGE_POP_Y_SINK
		langchat_image_untranslated.maptext_x = get_maxptext_x_offset(langchat_image_untranslated)
		langchat_image_untranslated.filters = filter(type="drop_shadow", size = 1, color = COLOR_BLACK)

	langchat_image_untranslated.pixel_y = 0
	langchat_image_untranslated.alpha = 0
	langchat_image_untranslated.color = override_color ? override_color : langchat_color
	if(appearance_flags & PIXEL_SCALE)
		langchat_image_untranslated.appearance_flags |= PIXEL_SCALE

/mob/langchat_make_image_untranslated(override_color = null)
	var/new_image = FALSE
	if(!langchat_image_untranslated)
		new_image = TRUE
	. = ..()
	// Recenter for icons more than 32 wide
	if(new_image)
		langchat_image_untranslated.maptext_x += (icon_size - 32) / 2

/mob/abstract/ghost/langchat_make_image(override_color = null)
	if(!override_color)
		override_color = "#c51fb7"
	. = ..()
	langchat_image.appearance_flags |= RESET_ALPHA

/atom/proc/langchat_speech(message, list/listeners, datum/language/language, override_color, skip_language_check = FALSE, animation_style = LANGCHAT_DEFAULT_POP, list/additional_styles = list("langchat"))
	langchat_drop_images()
	langchat_make_image(override_color)

	langchat_listeners = listeners
	var/mob/listener

	to_chat(world, "message is [message]")
	to_chat(world, "language is [language.name]")

	for(listener in langchat_listeners)
		to_chat(world, "[listener]")
	// Listener list management.
	for(listener in langchat_listeners)
		// Remove those who have the langchat_client disabled or who are deaf.
		if(!langchat_client_enabled(listener) || listener.ear_deaf)
			langchat_listeners -= listener
		// Handle listeners who don't understand the language being spoken.
		if(!skip_language_check && !listener.say_understands(src, language))
			langchat_listeners_untranslated += listener
			langchat_listeners -= listener

	// Generate the translated langchat_image.
	langchat_image.maptext = generate_text_image(message, additional_styles = additional_styles)
	langchat_image.maptext_width = LANGCHAT_WIDTH
	langchat_image.maptext_x = get_maxptext_x_offset(langchat_image)
	for(var/mob/comprehending_listener in langchat_listeners)
		to_chat(world, "[comprehending_listener]")
		comprehending_listener.client.images += langchat_image

	// Generate the untranslated langchat_image. Note that we have to loop through confused listeners first here, as some
	// might know languages that confer partial comprehension, and that would result in a unique langchat image.
	for(var/mob/confused_listener in langchat_listeners_untranslated)
		to_chat(world, "[confused_listener]")
		langchat_image_untranslated.maptext = generate_text_image(message, language, additional_styles, confused_listener.languages)
		langchat_image_untranslated.maptext_width = LANGCHAT_WIDTH
		langchat_image_untranslated.maptext_x = get_maxptext_x_offset(langchat_image_untranslated)
		confused_listener.client.images += langchat_image_untranslated

	var/timer = (length(message) / LANGCHAT_LONGEST_TEXT) * 4 SECONDS + 2 SECONDS

	if(isturf(loc))
		langchat_image.loc = src
		if(langchat_image_untranslated)
			langchat_image_untranslated.loc = src
	else
		langchat_image.loc = recursive_holder_check(src)
		if(langchat_image_untranslated)
			langchat_image_untranslated.loc = recursive_holder_check(src)

	to_chat(world, "about to run animate_style")
	animate_style(langchat_image, animation_style)
	if(langchat_listeners_untranslated)
		animate_style(langchat_image_untranslated, animation_style)

	addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, langchat_drop_images), language), timer, TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_NO_HASH_WAIT)

/atom/proc/langchat_long_speech(message, list/listeners, datum/language/language, override_color, skip_language_check = FALSE)
	langchat_drop_images()
	langchat_make_image()

	var/text_left = null
	var/truncated_message = message

	langchat_listeners = listeners
	var/mob/listener
	// Listener list management.
	for(listener in langchat_listeners)
		// Remove those who have the langchat_client disabled or who are deaf.
		if(!langchat_client_enabled(listener) || listener.ear_deaf)
			langchat_listeners -= listener
		// Handle listeners who don't understand the language being spoken.
		if(!skip_language_check && !listener.say_understands(src, language))
			langchat_listeners_untranslated += listener
			langchat_listeners -= listener

	if(length(message) > LANGCHAT_LONGEST_TEXT)
		truncated_message = copytext_char(message, 1, LANGCHAT_LONGEST_TEXT - 5) + "..."
		text_left = "..." + copytext_char(message, LANGCHAT_LONGEST_TEXT - 5)
	var/timer = 6 SECONDS
	if(text_left)
		timer = 4 SECONDS
	truncated_message = "<span class='center [langchat_styles] langchat_announce langchat'>[truncated_message]</span>"

	// Generate the translated langchat_image.
	langchat_image.maptext = generate_text_image(truncated_message)
	langchat_image.maptext_width = LANGCHAT_WIDTH
	langchat_image.maptext_x = get_maxptext_x_offset(langchat_image)
	for(var/mob/comprehending_listener in langchat_listeners)
		comprehending_listener.client.images += langchat_image

	// Generate the untranslated langchat_image. Note that we have to loop through confused listeners first here, as some
	// might know languages that confer partial comprehension, and that would result in a unique langchat image.
	for(var/mob/confused_listener in langchat_listeners_untranslated)
		langchat_image_untranslated.maptext = confused_listener.generate_text_image(truncated_message, src)
		langchat_image_untranslated.maptext_width = LANGCHAT_WIDTH
		langchat_image_untranslated.maptext_x = get_maxptext_x_offset(langchat_image_untranslated)
		confused_listener.client.images += langchat_image_untranslated

	if(isturf(loc))
		langchat_image.loc = src
		if(langchat_image_untranslated)
			langchat_image_untranslated.loc = src
	else
		langchat_image.loc = recursive_holder_check(src)
		if(langchat_image_untranslated)
			langchat_image_untranslated.loc = recursive_holder_check(src)

	to_chat(world, "about to run animate_style")
	animate_style(langchat_image)
	if(langchat_listeners_untranslated)
		animate_style(langchat_image_untranslated)

	if(text_left)
		addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, langchat_long_speech), text_left, listeners, language), timer, TIMER_OVERRIDE|TIMER_UNIQUE|TIMER_NO_HASH_WAIT)
	else
		addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, langchat_drop_images), language), timer, TIMER_OVERRIDE|TIMER_UNIQUE|TIMER_NO_HASH_WAIT)

/**
 * Generates the maptext_image, translated or untranslated, for a given message.
 */
/atom/proc/generate_text_image(message, datum/language/language = null, list/additional_styles = list("langchat"), list/languages = null)
	to_chat(world, "running generate_text_image")
	var/text_to_display = message
	var/use_mob_style = TRUE
	var/image/r_icon

	if(language)
		message = language.scramble(message, languages)

	if(length(text_to_display) > LANGCHAT_LONGEST_TEXT)
		text_to_display = copytext_char(text_to_display, 1, LANGCHAT_LONGEST_TEXT + 1) + "..."
	if(additional_styles.Find("emote"))
		additional_styles.Remove("emote")
		use_mob_style = FALSE
		r_icon = image('icons/mob/chat_icons.dmi', icon_state = "emote")
	else if(additional_styles.Find("virtual-speaker"))
		additional_styles.Remove("virtual-speaker")
		r_icon = image('icons/mob/chat_icons.dmi', icon_state = "radio")
	if(r_icon)
		text_to_display = "\icon[r_icon]&zwsp;[text_to_display]"

	text_to_display = "<span class='center [additional_styles != null ? additional_styles.Join(" ") : ""] [use_mob_style ? langchat_styles : ""] langchat'>[text_to_display]</span>"
	to_chat(world, "[text_to_display]")
	return text_to_display

/**
 * Animate the given maptext_image.
 */
/atom/proc/animate_style(var/image/langchat_image, animation_style = LANGCHAT_DEFAULT_POP)
	to_chat(world, "running animate_style")
	if(langchat_image)
		switch(animation_style)
			if(LANGCHAT_DEFAULT_POP)
				langchat_image.alpha = 0
				animate(langchat_image, pixel_y = langchat_image.pixel_y + LANGCHAT_MESSAGE_POP_Y_SINK, alpha = LANGCHAT_MAX_ALPHA, time = LANGCHAT_MESSAGE_POP_TIME)
			if(LANGCHAT_PANIC_POP)
				langchat_image.alpha = LANGCHAT_MAX_ALPHA
				animate(langchat_image, pixel_y = langchat_image.pixel_y + LANGCHAT_MESSAGE_PANIC_POP_Y_SINK, time = LANGCHAT_MESSAGE_PANIC_POP_TIME)
				animate(pixel_x = langchat_image.pixel_x - LANGCHAT_MESSAGE_PANIC_SHAKE_SIZE, time = LANGCHAT_MESSAGE_PANIC_SHAKE_TIME_TAKEN, easing = CUBIC_EASING)
				for(var/i = 1 to LANGCHAT_MESSAGE_PANIC_SHAKE_TIMES)
					animate(pixel_x = langchat_image.pixel_x + 2*LANGCHAT_MESSAGE_PANIC_SHAKE_SIZE, time = 2*LANGCHAT_MESSAGE_PANIC_SHAKE_TIME_TAKEN, easing = CUBIC_EASING)
					animate(pixel_x = langchat_image.pixel_x - 2*LANGCHAT_MESSAGE_PANIC_SHAKE_SIZE, time = LANGCHAT_MESSAGE_PANIC_SHAKE_TIME_TAKEN, easing = CUBIC_EASING)
				animate(pixel_x = langchat_image.pixel_x + LANGCHAT_MESSAGE_PANIC_SHAKE_SIZE, time = LANGCHAT_MESSAGE_PANIC_SHAKE_TIME_TAKEN, easing = CUBIC_EASING)
			if(LANGCHAT_FAST_POP)
				langchat_image.alpha = 0
				animate(langchat_image, pixel_y = langchat_image.pixel_y + LANGCHAT_MESSAGE_FAST_POP_Y_SINK, alpha = LANGCHAT_MAX_ALPHA, time = LANGCHAT_MESSAGE_FAST_POP_TIME)

/** Displays image to a single listener after it was built above eg. for chaining different game logic than speech code
This does just that, doesn't check deafness or language! Do what you will in that regard **/
/atom/proc/langchat_display_image(mob/M)
	if(langchat_image)
		if(!langchat_client_enabled(M))
			return
		if(!langchat_listeners) // shouldn't happen
			langchat_listeners = list()
		langchat_listeners |= M
		M.client.images += langchat_image

/// Will attempt to find what's holding this item if it's being contained by something, ie if it's in a satchel held by a human, this'll return the human
/proc/recursive_holder_check(obj/item/held_item, recursion_limit = 3)
	if(recursion_limit <= 0)
		return held_item
	if(!held_item.loc || isturf(held_item.loc))
		return held_item
	recursion_limit--
	return recursive_holder_check(held_item.loc, recursion_limit)
