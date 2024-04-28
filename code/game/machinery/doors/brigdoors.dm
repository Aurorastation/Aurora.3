#define CHARS_PER_LINE 5
#define FONT_SIZE "5pt"
#define FONT_COLOR "#09f"
#define FONT_STYLE "Arial Black"

//
// Brig Door Control Displays
//
/obj/machinery/door_timer
	name = "door timer"
	desc = "A remote control for a door."
	icon = 'icons/obj/status_display.dmi'
	icon_state = "frame"
	req_access = list(ACCESS_BRIG)
	layer = ABOVE_WINDOW_LAYER
	anchored = TRUE
	density = FALSE
	var/id = null     		// id of door it controls.
	var/releasetime = 0		// when world.timeofday reaches it - release the prisoner
	var/timing = TRUE    		// boolean, true/1 timer is on, false/0 means it's not timing
	var/picture_state		// icon_state of alert picture, if not displaying text/numbers
	var/list/obj/machinery/targets = list()
	var/timetoset = 0		// Used to set releasetime upon starting the timer

	var/datum/crime_incident/incident

	var/menu_mode = "menu_timer"

	maptext_height = 26
	maptext_width = 32

	var/datum/browser/menu = new(null, "brig_timer", "Brig Timer", 400, 300)

/obj/machinery/door_timer/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/door_timer/LateInitialize()
	for(var/obj/machinery/door/airlock/glass_security/D in SSmachinery.machinery)
		if(D.id_tag == src.id) // Airlocks use "id_tag" instead of "id".
			targets += D

	for(var/obj/machinery/door/window/brigdoor/D2 in SSmachinery.machinery)
		if(D2.id == src.id)
			targets += D2

	for(var/obj/machinery/flasher/F in SSmachinery.machinery)
		if(F.id == src.id)
			targets += F

	for(var/obj/structure/closet/secure_closet/brig/C in GLOB.brig_closets)
		if(C.id == src.id)
			targets += C

	if(targets.len==0)
		stat |= BROKEN
	update_icon()

/obj/machinery/door_timer/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if(stat & (NOPOWER|BROKEN))
		return

	if(src.timing)
		var/second = round(timeleft() % 60)
		var/minute = round((timeleft() - second) / 60)
		. += "Time remaining: [minute]:[second]"

//Main door timer loop, if it's timing and time is >0 reduce time by 1.
// if it's less than 0, open door, reset timer
// update the door_timer window and the icon
/obj/machinery/door_timer/process()
	if(stat & (NOPOWER|BROKEN))	return

	if(src.timing)
		// poorly done midnight rollover
		// (no seriously there's gotta be a better way to do this)
		var/timeleft = timeleft()
		if(timeleft > 1e5)
			src.releasetime = 0

		if(world.timeofday > src.releasetime)
			if(src.timer_end(broadcast = TRUE)) // Open doors, reset timer, and clear status screen.
				var/message = "Sentencing complete. The detainee is free to leave."
				ping("\The <b>[src]</b> pings, \"[message]\"")

		updateUsrDialog()
		update_icon()

	return

// has the door power situation changed, if so update icon.
/obj/machinery/door_timer/power_change()
	..()
	update_icon()
	return

// open/closedoor checks if door_timer has power, if so it checks if the
// linked door is open/closed (by density) then opens it/closes it.

// Closes and locks doors, power check
/obj/machinery/door_timer/proc/timer_start()
	if(stat & (NOPOWER|BROKEN))	return 0

	// Set releasetime
	releasetime = world.timeofday + timetoset

	// Airlocks
	for(var/obj/machinery/door/airlock/D in targets)
		if(D.density)
			continue
		spawn(0)
			D.close()

	// Windoors
	for(var/obj/machinery/door/window/D2 in targets)
		if(D2.density)
			continue
		spawn(0)
			D2.close()

	for(var/obj/structure/closet/secure_closet/brig/C in targets)
		if(C.broken)
			continue
		if(C.opened && !C.close())
			continue
		C.locked = TRUE
		C.update_icon()

	timing = TRUE

	return TRUE

// Opens and unlocks doors, power check
/obj/machinery/door_timer/proc/timer_end(var/early = 0, var/broadcast)
	if(stat & (NOPOWER|BROKEN))
		return FALSE

	timing = FALSE

	// Reset releasetime
	releasetime = 0
	timeset(0)

	// Airlocks
	for(var/obj/machinery/door/airlock/D in targets)
		if(!D.density)
			continue
		spawn(0)
			D.open()

	// Windoors
	for(var/obj/machinery/door/window/D2 in targets)
		if(!D2.density)
			continue
		spawn(0)
			D2.open()

	for(var/obj/structure/closet/secure_closet/brig/C in targets)
		if(C.broken)
			continue
		if(C.opened)
			continue
		C.locked = FALSE
		C.update_icon()

	if(broadcast)
		broadcast_security_hud_message("The timer for [id] has expired.", src)

	if(istype(incident))
		var/mob/living/carbon/human/C = incident.criminal.resolve()
		var/datum/record/general/R = SSrecords.find_record("name", C.name)
		if(istype(R) && istype(R.security))
			if(early == 1)
				R.security.criminal = "Parolled"
			else
				R.security.criminal = "Released"

	qdel(incident)
	incident = null

	src.updateUsrDialog()

	return 1


// Check for releasetime timeleft
/obj/machinery/door_timer/proc/timeleft()
	var/timeleft = timetoset

	if(src.timing)
		timeleft = releasetime - world.timeofday

	. = round(timeleft/10)
	if(. < 0)
		. = 0

// Set timetoset
/obj/machinery/door_timer/proc/timeset(var/seconds)
	timetoset = seconds * 10

	if(timetoset <= 0)
		timetoset = 0

	return

//Allows AIs to use door_timer, see human attack_hand function below
/obj/machinery/door_timer/attack_ai(var/mob/user)
	if(!ai_can_interact(user))
		return
	return src.attack_hand(user)

// Allows humans to use door_timer
// Opens dialog window when someone clicks on door timer
// Flasher activation limited to 150 seconds
/obj/machinery/door_timer/attack_hand(var/mob/user)
	if(..())
		return

	user.set_machine(src)

	. = ""

	switch(menu_mode)
		if("menu_charges")
			. = menu_charges()
		else
			. = menu_timer(user)

	menu.set_user(user)
	menu.set_content(.)
	menu.open()

	onclose(user, "brig_timer")

	return

/obj/machinery/door_timer/proc/menu_timer(var/mob/user)
	// Used for the 'time left' display
	var/second = round(timeleft() % 60)
	var/minute = round((timeleft() - second) / 60)
	. = "<h2>Timer System</h2>"
	. += "<b>[src]</b><hr>"

	if(!incident)
		. += "Insert a encoded SCC security incident report to start sentencing.<br>"
	else
		// Time Left display (uses releasetime)
		var/obj/item/card/id/card = incident.card.resolve()
		. += "<b>Detainee</b>: [card]\t"
		. += "<b>Charges:</b> <a href='?src=\ref[src];button=menu_mode;menu_choice=menu_charges'>CHARGES</a><br>"
		. += "<b>Sentence Length</b>: [add_zero("[minute]", 2)]:[add_zero("[second]", 2)]\t"
		// Start/Stop timer
		if(!src.timing)
			. += "<a href='?src=\ref[src];button=activate'>ACTIVATE</a><br>"
		else
			. += "<a href='?src=\ref[src];button=early_release'>(!) EARLY RELEASE</a><br>"


	// Mounted Flash Controls
	for(var/obj/machinery/flasher/F in targets)
		. += "<br><b>Cell Flash</b>: "
		if(F.last_flash && (F.last_flash + 150) > world.time)
			. += "Charging..."
		else
			. += "<A href='?src=\ref[src];button=flash'>(!) ACTIVATE</A>"

	. += "<br><hr>"
	. += "<center><a href='?src=\ref[user];mach_close=brig_timer'>CLOSE</a></center>"

	return .

/obj/machinery/door_timer/proc/menu_charges()
	. = ""

	if(!incident)
		. += "Insert a encoded SCC security incident report to start sentencing.<br>"
	else
		// Charges list
		. += "<table class='border'>"
		. += "<tr>"
		. += "<th colspan='3'>Charges</th>"
		. += "</tr>"
		for(var/datum/law/L in incident.charges)
			. += "<tr>"
			. += "<td><b>[L.name]</b></td>"
			. += "<td><i>[L.desc]</i></td>"
			. += "<td>[L.min_brig_time]-[L.max_brig_time] minutes</td>"
			. += "</tr>"
		. += "</table>"

	. += "<br><hr>"
	. += "<center><A href='?src=\ref[src];button=menu_mode;menu_choice=menu_timer'>RETURN</a></center>"

	return .

/obj/machinery/door_timer/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/paper/incident))
		if(!incident)
			if(import(attacking_item, user))
				ping("\The <b>[src]</b> states, \"Successfully imported incident report!\"")
				user.drop_from_inventory(attacking_item,get_turf(src))
				qdel(attacking_item)
				src.updateUsrDialog()
		else
			to_chat(user, SPAN_ALERT("\The <b>[src]</b> states, \"There's already an active sentence.\""))
		return TRUE
	else if(istype(attacking_item, /obj/item/paper))
		to_chat(user, SPAN_ALERT("\The <b>[src]</b> states, \"This console only accepts authentic incident reports. Copies are invalid.\""))
		return TRUE

	return ..()

/obj/machinery/door_timer/proc/import(var/obj/item/paper/incident/I, var/user)
	if(!istype(I))
		to_chat(user, SPAN_ALERT("\The <b>[src]</b> states, \"Could not import the incident report.\""))
		return FALSE

	if(!istype(I.incident))
		to_chat(user, SPAN_ALERT("\The <b>[src]</b> states, \"Report has no incident encoded.\""))
		return FALSE

	if(!I.sentence)
		to_chat(user, SPAN_ALERT("\The <b>[src]</b> states, \"Report does not contain a guilty sentence.\""))
		return FALSE

	var/datum/crime_incident/crime = I.incident

	if(!istype(crime.criminal))
		to_chat(user, SPAN_ALERT("\The <b>[src]</b> states, \"Report has no detainee encoded.\""))
		return FALSE

	if(!crime.brig_sentence)
		to_chat(user, SPAN_ALERT("\The <b>[src]</b> states, \"Report has no brig sentence.\""))
		return FALSE

	if(crime.brig_sentence >= PERMABRIG_SENTENCE)
		to_chat(user, SPAN_ALERT("\The <b>[src]</b> states, \"The detainee has a HuT sentence and needs to be detained until transfer.\""))
		return FALSE

	var/addtime = timetoset
	addtime += crime.brig_sentence MINUTES
	addtime = min(max(round(addtime), 0), PERMABRIG_SENTENCE MINUTES)
	addtime = addtime/10

	timeset(addtime)
	incident = crime

	return timetoset

//Function for using door_timer dialog input, checks if user has permission
// href_list to
//  "timing" turns on timer
//  "tp" value to modify timer
//  "fc" activates flasher
// 	"change" resets the timer to the timetoset amount while the timer is counting down
// Also updates dialog window and timer icon
/obj/machinery/door_timer/Topic(href, href_list)
	if(..())
		return
	if(!src.allowed(usr))
		return

	usr.set_machine(src)

	switch(href_list["button"])
		if("menu_mode")
			menu_mode = href_list["menu_choice"]

		if("activate")
			src.timer_start()
			var/mob/living/carbon/human/C = incident.criminal.resolve()
			var/datum/record/general/R = SSrecords.find_record("name", C.name)
			if(R && R.security)
				R.security.criminal = "Incarcerated"

		if("early_release")
			src.timer_end(1)

		if("flash")
			for(var/obj/machinery/flasher/F in targets)
				F.flash()

	src.add_fingerprint(usr)
	src.updateUsrDialog()
	src.update_icon()

	return


//icon update function
// if NOPOWER, display blank
// if BROKEN, display blue screen of death icon AI uses
// if timing=true, run update display function
/obj/machinery/door_timer/update_icon()
	if(stat & (NOPOWER))
		icon_state = "frame"
		return
	if(stat & (BROKEN))
		set_picture("ai_bsod")
		return
	if(src.timing)
		var/disp1 = src
		var/timeleft = timeleft()
		var/disp2 = "[add_zero(num2text((timeleft / 60) % 60),2)]:[add_zero(num2text(timeleft % 60), 2)]"
		if(length(disp2) > CHARS_PER_LINE)
			disp2 = "ERROR"
		update_display(disp1, disp2)
	else
		if(maptext)	maptext = ""
	return


// Adds an icon in case the screen is broken/off, stolen from status_display.dm
/obj/machinery/door_timer/proc/set_picture(var/state)
	picture_state = state
	cut_overlays()
	add_overlay(picture_state)

//Checks to see if there's 1 line or 2, adds text-icons-numbers/letters over display
// Stolen from status_display
/obj/machinery/door_timer/proc/update_display(var/line1, var/line2)
	var/new_text = {"<div style="font-size:[FONT_SIZE];color:[FONT_COLOR];font:'[FONT_STYLE]';text-align:center;" valign="top">[line1]<br>[line2]</div>"}
	if(maptext != new_text)
		maptext = new_text


//Actual string input to icon display for loop, with 5 pixel x offsets for each letter.
//Stolen from status_display
/obj/machinery/door_timer/proc/texticon(var/tn, var/px = 0, var/py = 0)
	var/image/I = image('icons/obj/status_display.dmi', "blank")
	var/len = length(tn)

	for(var/d = 1 to len)
		var/char = copytext(tn, len-d+1, len-d+2)
		if(char == " ")
			continue
		var/image/ID = image('icons/obj/status_display.dmi', icon_state=char)
		ID.pixel_x = -(d-1)*5 + px
		ID.pixel_y = py
		I.add_overlay(ID)
	return I

// Door Timers
/obj/machinery/door_timer/cell_1
	name = "Cell A"
	id = "cell_1"

/obj/machinery/door_timer/cell_2
	name = "Cell B"
	id = "cell_2"

/obj/machinery/door_timer/cell_3
	name = "Cell C"
	id = "cell_3"

/obj/machinery/door_timer/cell_4
	name = "Cell D"
	id = "cell_4"

/obj/machinery/door_timer/cell_5
	name = "Cell E"
	id = "cell_5"

/obj/machinery/door_timer/cell_6
	name = "Cell F"
	id = "cell_6"

/obj/machinery/door_timer/isolation_cell
	name = "Isolation Cell"
	id = "cell_isolation"

#undef FONT_SIZE
#undef FONT_COLOR
#undef FONT_STYLE
#undef CHARS_PER_LINE
