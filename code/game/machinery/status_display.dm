#define MAX_STATIC_WIDTH 24
#define FONT_STYLE "12pt 'TinyUnicode'"
#define SCROLL_RATE (0.04 SECONDS) // time per pixel
#define SCROLL_PADDING 2 // how many pixels we chop to make a smooth loop
#define LINE1_X 1
#define LINE1_Y -4
#define LINE2_X 1
#define LINE2_Y -11
#define STATUS_DISPLAY_FONT_DATUM /datum/font/tiny_unicode/size_12pt

// Status display
// (formerly Countdown timer display)

// Use to show shuttle ETA/ETD times
// Alert status
// And arbitrary messages set by comms computer
/obj/machinery/status_display
	name = "status display"
	icon = 'icons/obj/status_display.dmi'
	icon_state = "frame"
	layer = ABOVE_WINDOW_LAYER
	anchored = 1
	density = 0
	idle_power_usage = 10
	obj_flags = OBJ_FLAG_MOVES_UNSUPPORTED
	var/hears_arrivals = FALSE
	var/mode = 1	// 0 = Blank
					// 1 = Shuttle timer
					// 2 = Arbitrary message(s)
					// 3 = alert picture
					// 4 = Supply shuttle timer

	var/picture_state	// icon_state of alert picture

	var/obj/effect/overlay/status_display_text/message1_overlay
	var/obj/effect/overlay/status_display_text/message2_overlay
	var/message1 = ""
	var/message2 = ""

	var/frequency = 1435		// radio frequency

	var/friendc = 0      // track if Friend Computer mode
	var/ignore_friendc = 0

	var/const/STATUS_DISPLAY_BLANK = 0
	var/const/STATUS_DISPLAY_TRANSFER_SHUTTLE_TIME = 1
	var/const/STATUS_DISPLAY_MESSAGE = 2
	var/const/STATUS_DISPLAY_ALERT = 3
	var/const/STATUS_DISPLAY_TIME = 4
	var/const/STATUS_DISPLAY_CUSTOM = 99

	/// Normal text color
	var/text_color = COLOR_DISPLAY_BLUE
	/// Color for headers, eg. "- ETA -"
	var/header_text_color =  COLOR_DISPLAY_PURPLE

/obj/machinery/status_display/Destroy()
	SSmachinery.all_status_displays -= src
	SSradio.remove_object(src,frequency)
	return ..()

// register for radio system
/obj/machinery/status_display/Initialize()
	. = ..()
	SSmachinery.all_status_displays += src
	if (hears_arrivals)
		SSradio.add_object(src, frequency, RADIO_ARRIVALS)
	else
		SSradio.add_object(src, frequency)
	update_lighting()

// timed process
/obj/machinery/status_display/process()
	if(stat & NOPOWER)
		remove_display()
		update_lighting()
		return
	update()

/obj/machinery/status_display/emp_act(severity)
	. = ..()

	if(stat & (BROKEN|NOPOWER))
		return

	set_picture("ai_bsod")

// set what is displayed
/obj/machinery/status_display/proc/update()
	remove_display()
	if(friendc && !ignore_friendc)
		set_picture("ai_friend")
		AddOverlays(emissive_appearance(icon, "outline", src, alpha = src.alpha))
		return 1

	switch(mode)
		if(STATUS_DISPLAY_BLANK)	//blank
			remove_messages()
			return 1
		if(STATUS_DISPLAY_TRANSFER_SHUTTLE_TIME)				//emergency shuttle timer
			if(GLOB.evacuation_controller)
				if(GLOB.evacuation_controller.is_prepared())
					message1 = "-ETD-"
					if (GLOB.evacuation_controller.waiting_to_leave())
						message2 = "Launch"
					else
						message2 = get_shuttle_timer()
					set_messages(message1, message2)
					AddOverlays(emissive_appearance(icon, "outline", src, alpha = src.alpha))
				else if(GLOB.evacuation_controller.has_eta())
					message1 = "-ETA-"
					message2 = get_shuttle_timer()
					set_messages(message1, message2)
					AddOverlays(emissive_appearance(icon, "outline", src, alpha = src.alpha))
				return 1
		if(STATUS_DISPLAY_MESSAGE)	//custom messages
			var/line1_metric
			var/line2_metric
			var/line_pair
			var/datum/font/display_font = new STATUS_DISPLAY_FONT_DATUM()
			line1_metric = display_font.get_metrics(message1)
			line2_metric = display_font.get_metrics(message2)
			line_pair = (line1_metric > line2_metric ? line1_metric : line2_metric)
			var/overlay = update_message(message1_overlay, LINE1_Y, message1, LINE1_X, line_pair)
			if(overlay)
				message1_overlay = overlay
			overlay = update_message(message2_overlay, LINE2_Y, message2, LINE2_X, line_pair)
			if(overlay)
				message2_overlay = overlay
			if(message1 == "" && message2 == "")
				return 1
			else
				AddOverlays(emissive_appearance(icon, "outline", src, alpha = src.alpha))
				return 1
		if(STATUS_DISPLAY_ALERT)
			set_picture(picture_state)
			return 1
		if(STATUS_DISPLAY_TIME)
			message1 = "-Time-"
			message2 = worldtime2text()
			set_messages(message1, message2)
			var/line1_metric
			var/line2_metric
			var/line_pair
			var/datum/font/display_font = new STATUS_DISPLAY_FONT_DATUM()
			line1_metric = display_font.get_metrics(message1)
			line2_metric = display_font.get_metrics(message2)
			line_pair = (line1_metric > line2_metric ? line1_metric : line2_metric)
			var/overlay = update_message(message1_overlay, LINE1_Y, message1, LINE1_X, line_pair)
			if(overlay)
				message1_overlay = overlay
			overlay = update_message(message2_overlay, LINE2_Y, message2, LINE2_X, line_pair)
			if(overlay)
				message2_overlay = overlay
			if(message1 == "" && message2 == "")
				return 1
			else
				AddOverlays(emissive_appearance(icon, "outline", src, alpha = src.alpha))
			return 1
	return 0

/obj/machinery/status_display/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if(mode != STATUS_DISPLAY_BLANK && mode != STATUS_DISPLAY_ALERT)
		if(message1_overlay || message2_overlay)
			. += "The display says:"
			if(message1_overlay.message)
				. += "<br>\t<tt>[html_encode(message1_overlay.message)]</tt>"
			if(message2_overlay.message)
				. += "<br>\t<tt>[html_encode(message2_overlay.message)]</tt>"

/obj/machinery/status_display/proc/set_picture(state)
	remove_display()
	picture_state = state
	AddOverlays(picture_state)
	update_lighting()

/obj/machinery/status_display/proc/set_messages(line1, line2)
	var/message_changed = FALSE
	if(line1 != message1)
		message1 = line1
		message_changed = TRUE

	if(line2 != message2)
		message2 = line2
		message_changed = TRUE

	if(message_changed)
		update_lighting()

/**
 * Remove both message objs and null the fields.
 * Don't call this in subclasses.
 */
/obj/machinery/status_display/proc/remove_messages()
	if(message1_overlay)
		QDEL_NULL(message1_overlay)
	if(message2_overlay)
		QDEL_NULL(message2_overlay)

/**
 * Create/update message overlay.
 * They must be handled as real objects for the animation to run.
 * Don't call this in subclasses.
 * Arguments:
 * * overlay - the current /obj/effect/overlay/status_display_text instance
 * * line_y - The Y offset to render the text.
 * * x_offset - Used to offset the text on the X coordinates, not usually needed.
 * * message - the new message text.
 * Returns new /obj/effect/overlay/status_display_text or null if unchanged.
 */
/obj/machinery/status_display/proc/update_message(obj/effect/overlay/status_display_text/overlay, line_y, message, x_offset, line_pair)
	if(overlay && message == overlay.message)
		return null

	if(overlay)
		qdel(overlay)

	var/obj/effect/overlay/status_display_text/new_status_display_text = new(src, line_y, message, text_color, header_text_color, x_offset, line_pair)
	// Draw our object visually "in front" of this display, taking advantage of sidemap
	new_status_display_text.pixel_y = -32
	new_status_display_text.pixel_z = 32
	vis_contents += new_status_display_text
	return new_status_display_text

/obj/machinery/status_display/proc/update_lighting()
	if( \
		(stat & (NOPOWER|BROKEN)) || \
		(mode == STATUS_DISPLAY_BLANK) || \
		(mode != STATUS_DISPLAY_ALERT && message1 == "" && message2 == "") \
	)
		set_light(0)
		return
	set_light(1.5, 0.7, LIGHT_COLOR_FAINT_CYAN) // blue light

/obj/machinery/status_display/proc/get_shuttle_timer()
	var/timeleft = GLOB.evacuation_controller.get_eta()
	if(timeleft < 0)
		return ""
	return "[add_zero(num2text((timeleft / 60) % 60),2)]:[add_zero(num2text(timeleft % 60), 2)]"

/obj/machinery/status_display/proc/get_supply_shuttle_timer()
	var/datum/shuttle/autodock/ferry/supply/shuttle = SScargo.shuttle
	if (!shuttle)
		return "Error"

	if(shuttle.has_arrive_time())
		var/timeleft = round((shuttle.arrive_time - world.time) / 10,1)
		if(timeleft < 0)
			return "Late"
		return "[add_zero(num2text((timeleft / 60) % 60),2)]:[add_zero(num2text(timeleft % 60), 2)]"
	return ""

/obj/machinery/status_display/proc/get_arrivals_shuttle_timer()
	var/datum/shuttle/autodock/ferry/arrival/shuttle = SSarrivals.shuttle
	if (!shuttle)
		return "Error"

	if(shuttle.has_arrive_time())
		var/timeleft = round((shuttle.arrive_time - world.time) / 10,1)
		if(timeleft < 0)
			return ""
		return "[add_zero(num2text((timeleft / 60) % 60),2)]:[add_zero(num2text(timeleft % 60), 2)]"
	return ""

/obj/machinery/status_display/proc/get_arrivals_shuttle_timer2()
	if (!SSarrivals)
		return "Error"

	if(SSarrivals.launch_time)
		var/timeleft = round((SSarrivals.launch_time - world.time) / 10,1)
		if(timeleft < 0)
			return ""
		return "[add_zero(num2text((timeleft / 60) % 60),2)]:[add_zero(num2text(timeleft % 60), 2)]"
	else
		return "Launch"

/obj/machinery/status_display/proc/remove_display()
	ClearOverlays()
	vis_contents.Cut()
	if(message1_overlay)
		QDEL_NULL(message1_overlay)
	if(message2_overlay)
		QDEL_NULL(message2_overlay)

/**
 * Nice overlay to make text smoothly scroll with no client updates after setup.
 */
/obj/effect/overlay/status_display_text
	icon = 'icons/obj/status_display.dmi'
	vis_flags = VIS_INHERIT_LAYER | VIS_INHERIT_PLANE | VIS_INHERIT_ID

	/// The message this overlay is displaying.
	var/message

	// If the line is short enough to not marquee, and it matches this, it's a header.
	var/static/regex/header_regex = regex("^-.*-$")

/obj/effect/overlay/status_display_text/Initialize(mapload, yoffset, line, text_color, header_text_color, xoffset = 0, line_pair)
	. = ..()

	maptext_y = yoffset
	message = line

	var/datum/font/display_font = new STATUS_DISPLAY_FONT_DATUM()
	var/line_width = display_font.get_metrics(line)

	if(line_width > MAX_STATIC_WIDTH)
		// Marquee text
		var/marquee_message = "[line]    [line]    [line]"

		// Width of full content. Must of these is never revealed unless the user inputted a single character.
		var/full_marquee_width = display_font.get_metrics("[marquee_message]    ")
		// We loop after only this much has passed.
		var/looping_marquee_width = (display_font.get_metrics("[line]    ]") - SCROLL_PADDING)

		maptext = generate_text(marquee_message, center = FALSE, text_color = text_color)
		maptext_width = full_marquee_width
		maptext_x = 0

		// Mask off to fit in screen.
		add_filter("mask", 1, list(type = "alpha", icon = icon(icon, "outline")))

		// Scroll.
		var/time = line_pair * SCROLL_RATE
		animate(src, maptext_x = (-looping_marquee_width) + MAX_STATIC_WIDTH, time = time, loop = -1)
		animate(maptext_x = MAX_STATIC_WIDTH, time = 0)
	else
		// Centered text
		var/color = header_regex.Find(line) ? header_text_color : text_color
		maptext = generate_text(line, center = TRUE, text_color = color)
		maptext_x = xoffset //Defaults to 0, this would be centered unless overided

/**
 * Generate the actual maptext.
 * Arguments:
 * * text - the text to display
 * * center - center the text if TRUE, otherwise right-align (the direction the text is coming from)
 * * text_color - the text color
 */
/obj/effect/overlay/status_display_text/proc/generate_text(text, center, text_color)
	return {"<div style="color:[text_color];font:[FONT_STYLE][center ? ";text-align:center" : "text-align:right"]" valign="top">[text]</div>"}

/obj/machinery/status_display/receive_signal(datum/signal/signal)
	switch(signal.data["command"])
		if("blank")
			mode = STATUS_DISPLAY_BLANK

		if("shuttle")
			mode = STATUS_DISPLAY_TRANSFER_SHUTTLE_TIME

		if("message")
			message1 = signal.data["msg1"]
			message2 = signal.data["msg2"]
			mode = STATUS_DISPLAY_MESSAGE
			set_messages(message1, message2)

		if("alert")
			mode = STATUS_DISPLAY_ALERT
			set_picture(signal.data["picture_state"])

		if("time")
			mode = STATUS_DISPLAY_TIME
	update()

#undef MAX_STATIC_WIDTH
#undef FONT_STYLE
#undef SCROLL_RATE
#undef LINE1_X
#undef LINE1_Y
#undef LINE2_X
#undef LINE2_Y
#undef STATUS_DISPLAY_FONT_DATUM

#undef SCROLL_PADDING
