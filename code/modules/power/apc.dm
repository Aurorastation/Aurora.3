//update_state
#define UPDATE_CELL_IN 			 (1<<0)
#define UPDATE_OPENED1 			 (1<<1)
#define UPDATE_OPENED2 			 (1<<2)
#define UPDATE_MAINT 			 (1<<3)
#define UPDATE_BROKE 			 (1<<4)
#define UPDATE_BLUESCREEN 		 (1<<5)
#define UPDATE_WIREEXP 			 (1<<6)
#define UPDATE_ALLGOOD 			 (1<<7)

//update_overlay
#define APC_UPOVERLAY_CHARGING0  (1<<0)
#define APC_UPOVERLAY_CHARGING1  (1<<1)
#define APC_UPOVERLAY_CHARGING2  (1<<2)
#define APC_UPOVERLAY_EQUIPMENT0 (1<<3)
#define APC_UPOVERLAY_EQUIPMENT1 (1<<4)
#define APC_UPOVERLAY_EQUIPMENT2 (1<<5)
#define APC_UPOVERLAY_LIGHTING0  (1<<6)
#define APC_UPOVERLAY_LIGHTING1  (1<<7)
#define APC_UPOVERLAY_LIGHTING2  (1<<8)
#define APC_UPOVERLAY_ENVIRON0   (1<<9)
#define APC_UPOVERLAY_ENVIRON1   (1<<10)
#define APC_UPOVERLAY_ENVIRON2   (1<<11)
#define APC_UPOVERLAY_LOCKED     (1<<12)
#define APC_UPOVERLAY_OPERATING  (1<<13)

//has_electronics
#define HAS_ELECTRONICS_NONE	 0
#define HAS_ELECTRONICS_CONNECT  1
#define HAS_ELECTRONICS_SECURED	 2

//opened
#define COVER_CLOSED			 0
#define COVER_OPENED			 1
#define COVER_REMOVED			 2

//charging
#define CHARGING_OFF			 0
#define CHARGING_ON			     1
#define CHARGING_FULL			 2

//channel settings
#define CHANNEL_OFF         0
#define CHANNEL_OFF_AUTO    1
#define CHANNEL_ON          2
#define CHANNEL_ON_AUTO     3

//channel types
#define CHANNEL_EQUIPMENT   0
#define CHANNEL_LIGHTING    1
#define CHANNEL_ENVIRONMENT 2

//charge_mode states
#define CHARGE_MODE_CHARGE    0
#define CHARGE_MODE_DISCHARGE 1
#define CHARGE_MODE_STABLE    2

//autoflag states
#define AUTOFLAG_OFF                0
#define AUTOFLAG_ENVIRON_ON         1
#define AUTOFLAG_ENVIRON_LIGHTS_ON  2
#define AUTOFLAG_ALL_ON             3

// the Area Power Controller (APC), formerly Power Distribution Unit (PDU)
// one per area, needs wire conection to power network through a terminal

// controls power to devices in that area
// may be opened to change power cell
// three different channels (lighting/equipment/environ) - may each be set to on, off, or auto

/obj/machinery/power/apc/north
	dir = NORTH
	pixel_y = 22

/obj/machinery/power/apc/east
	dir = EAST
	pixel_x = 12

/obj/machinery/power/apc/west
	dir = WEST
	pixel_x = -12

/obj/machinery/power/apc/south
	dir = SOUTH
	pixel_y = -4

/obj/machinery/power/apc/critical
	is_critical = TRUE

/obj/machinery/power/apc/critical/north
	dir = NORTH
	pixel_y = 22

/obj/machinery/power/apc/critical/east
	dir = EAST
	pixel_x = 12

/obj/machinery/power/apc/critical/west
	dir = WEST
	pixel_x = -12

/obj/machinery/power/apc/critical/south
	dir = SOUTH
	pixel_y = -4

/obj/machinery/power/apc/low
	cell_type = /obj/item/cell

/obj/machinery/power/apc/low/north
	dir = NORTH
	pixel_y = 22

/obj/machinery/power/apc/low/east
	dir = EAST
	pixel_x = 12

/obj/machinery/power/apc/low/west
	dir = WEST
	pixel_x = -12

/obj/machinery/power/apc/low/south
	dir = SOUTH
	pixel_y = -4

/obj/machinery/power/apc/high
	cell_type = /obj/item/cell/high

/obj/machinery/power/apc/high/north
	dir = NORTH
	pixel_y = 22

/obj/machinery/power/apc/high/east
	dir = EAST
	pixel_x = 12

/obj/machinery/power/apc/high/west
	dir = WEST
	pixel_x = -12

/obj/machinery/power/apc/high/south
	dir = SOUTH
	pixel_y = -4

/obj/machinery/power/apc/isolation
	cell_type = /obj/item/cell
	req_access = null
	req_one_access = list(ACCESS_ENGINE_EQUIP,ACCESS_RESEARCH,ACCESS_XENOBIOLOGY)

/obj/machinery/power/apc/isolation/north
	dir = NORTH
	pixel_y = 22

/obj/machinery/power/apc/isolation/east
	dir = EAST
	pixel_x = 12

/obj/machinery/power/apc/isolation/west
	dir = WEST
	pixel_x = -12

/obj/machinery/power/apc/isolation/south
	dir = SOUTH
	pixel_y = -4

/obj/machinery/power/apc/vault
	cell_type = /obj/item/cell
	req_access = list(ACCESS_CAPTAIN)

/obj/machinery/power/apc/vault/north
	dir = NORTH
	pixel_y = 22

/obj/machinery/power/apc/vault/east
	dir = EAST
	pixel_x = 12

/obj/machinery/power/apc/vault/west
	dir = WEST
	pixel_x = -12

/obj/machinery/power/apc/vault/south
	dir = SOUTH
	pixel_y = -4

/obj/machinery/power/apc/intrepid
	cell_type = /obj/item/cell/high
	req_access = null
	req_one_access = list(ACCESS_INTREPID,ACCESS_ENGINE_EQUIP)

/obj/machinery/power/apc/intrepid/north
	dir = NORTH
	pixel_y = 22

/obj/machinery/power/apc/intrepid/east
	dir = EAST
	pixel_x = 12

/obj/machinery/power/apc/intrepid/west
	dir = WEST
	pixel_x = -12

/obj/machinery/power/apc/intrepid/south
	dir = SOUTH
	pixel_y = -4

/obj/machinery/power/apc/canary
	cell_type = /obj/item/cell/high
	req_access = null
	req_one_access = list(ACCESS_INTREPID,ACCESS_ENGINE_EQUIP)

/obj/machinery/power/apc/canary/north
	dir = NORTH
	pixel_y = 22

/obj/machinery/power/apc/canary/east
	dir = EAST
	pixel_x = 12

/obj/machinery/power/apc/canary/west
	dir = WEST
	pixel_x = -12

/obj/machinery/power/apc/canary/south
	dir = SOUTH
	pixel_y = -4

/obj/machinery/power/apc/mining_shuttle
	cell_type = /obj/item/cell/high
	req_access = null
	req_one_access = list(ACCESS_MINING,ACCESS_ENGINE_EQUIP)

/obj/machinery/power/apc/mining_shuttle/north
	dir = NORTH
	pixel_y = 22

/obj/machinery/power/apc/mining_shuttle/east
	dir = EAST
	pixel_x = 12

/obj/machinery/power/apc/mining_shuttle/west
	dir = WEST
	pixel_x = -12

/obj/machinery/power/apc/mining_shuttle/south
	dir = SOUTH
	pixel_y = -4

// Construction site APC, starts turned off
/obj/machinery/power/apc/high/inactive
	cell_type = /obj/item/cell/high
	lighting = CHANNEL_OFF
	equipment = CHANNEL_OFF
	environ = CHANNEL_OFF
	locked = FALSE
	coverlocked = FALSE
	start_charge = 100

/obj/machinery/power/apc/canary/north
	dir = NORTH
	pixel_y = 22

/obj/machinery/power/apc/canary/east
	dir = EAST
	pixel_x = 12

/obj/machinery/power/apc/canary/west
	dir = WEST
	pixel_x = -12

/obj/machinery/power/apc/canary/south
	dir = SOUTH
	pixel_y = -4


/obj/machinery/power/apc/super
	cell_type = /obj/item/cell/super

/obj/machinery/power/apc/super/north
	dir = NORTH
	pixel_y = 22

/obj/machinery/power/apc/super/east
	dir = EAST
	pixel_x = 12

/obj/machinery/power/apc/super/west
	dir = WEST
	pixel_x = -12

/obj/machinery/power/apc/super/south
	dir = SOUTH
	pixel_y = -4

/obj/machinery/power/apc/super/critical
	is_critical = TRUE

/obj/machinery/power/apc/super/critical/north
	dir = NORTH
	pixel_y = 22

/obj/machinery/power/apc/super/critical/east
	dir = EAST
	pixel_x = 12

/obj/machinery/power/apc/super/critical/west
	dir = WEST
	pixel_x = -12

/obj/machinery/power/apc/super/critical/south
	dir = SOUTH
	pixel_y = -4

/obj/machinery/power/apc/hyper
	cell_type = /obj/item/cell/hyper

/obj/machinery/power/apc/hyper/north
	dir = NORTH
	pixel_y = 22

/obj/machinery/power/apc/hyper/east
	dir = EAST
	pixel_x = 12

/obj/machinery/power/apc/hyper/west
	dir = WEST
	pixel_x = -12

/obj/machinery/power/apc/hyper/south
	dir = SOUTH
	pixel_y = -4

/obj/machinery/power/apc/empty
	start_charge = 0

/obj/machinery/power/apc/empty/north
	dir = NORTH
	pixel_y = 22

/obj/machinery/power/apc/empty/east
	dir = EAST
	pixel_x = 12

/obj/machinery/power/apc/empty/west
	dir = WEST
	pixel_x = -12

/obj/machinery/power/apc/empty/south
	dir = SOUTH
	pixel_y = -4

/obj/machinery/power/apc
	name = "area power controller"
	desc = "A control terminal for the area electrical systems."
	desc_info = "An APC (Area Power Controller) regulates and supplies backup power for the area they are in. Their power channels are divided \
	out into 'environmental' (Items that manipulate airflow and temperature), 'lighting' (the lights), and 'equipment' (Everything else that consumes power).  \
	Power consumption and backup power cell charge can be seen from the interface, further controls (turning a specific channel on, off or automatic, \
	toggling the APC's ability to charge the backup cell, or toggling power for the entire area via master breaker) first requires the interface to be unlocked \
	with an ID with Engineering access or by one of the station's robots or the artificial intelligence."
	desc_antag = "This can be emagged to unlock it.  It will cause the APC to have a blue error screen. \
	Wires can be pulsed remotely with a signaler attached to it.  A powersink will also drain any APCs connected to the same wire the powersink is on."

	icon = 'icons/obj/machinery/power/apc.dmi'
	icon_state = "apc0"
	anchored = TRUE
	use_power = POWER_USE_OFF
	req_access = list(ACCESS_ENGINE_EQUIP)
	gfi_layer_rotation = GFI_ROTATION_DEFDIR
	clicksound = /singleton/sound_category/switch_sound
	obj_flags = OBJ_FLAG_MOVES_UNSUPPORTED
	var/area/area
	var/areastring = null
	var/obj/item/cell/cell
	var/chargelevel = 0.0005  // Cap for how fast APC cells charge, as a percentage-per-tick (0.01 means cellcharge is capped to 1% per second)
	var/cellused = 0
	var/start_charge = 90				// initial cell charge %
	var/cell_type = /obj/item/cell/apc
	var/opened = COVER_CLOSED
	var/shorted = FALSE
	var/night_mode = FALSE// Determines if the light level is set to dimmed or not
	var/lighting = CHANNEL_ON_AUTO
	var/equipment = CHANNEL_ON_AUTO
	var/environ = CHANNEL_ON_AUTO
	var/infected = FALSE
	var/operating = TRUE
	var/charging = CHARGING_OFF
	var/chargemode = TRUE // whether we're trying to charge
	var/chargecount = 0
	var/locked = TRUE
	var/coverlocked = TRUE
	var/aidisabled = FALSE
	var/obj/machinery/power/terminal/terminal = null
	var/lastused_light = 0
	var/lastused_equip = 0
	var/static/list/hacked_ipcs
	var/lastused_environ = 0
	var/lastused_charging = 0
	var/lastused_total = 0
	var/main_status = 0
	var/mob/living/silicon/ai/hacker = null // Malfunction var. If set AI hacked the APC and has full control.
	var/wiresexposed = FALSE
	powernet = 0		// set so that APCs aren't found as powernet nodes //Hackish, Horrible, was like this before I changed it :c
	var/debug = 0
	var/autoflag = AUTOFLAG_OFF
	var/has_electronics = HAS_ELECTRONICS_NONE
	var/beenhit = 0 // used for counting how many times it has been hit, used for Aliens at the moment
	var/longtermpower = 10
	var/datum/wires/apc/wires = null
	var/update_state = -1
	var/update_overlay = -1
	var/is_critical = FALSE
	var/global/status_overlays = 0
	var/updating_icon = FALSE
	var/failure_timer = 0
	var/force_update = FALSE
	var/global/list/status_overlays_lock
	var/global/list/status_overlays_charging
	var/global/list/status_overlays_equipment
	var/global/list/status_overlays_lighting
	var/global/list/status_overlays_environ

	var/emergency_lights = FALSE

	var/time = 0
	var/charge_mode = CHARGE_MODE_CHARGE // if we're actually able to charge
	var/last_time = 1

/obj/machinery/power/apc/updateDialog()
	if (stat & (BROKEN|MAINT))
		return
	..()

/obj/machinery/power/apc/connect_to_network()
	//Override because the APC does not directly connect to the network; it goes through a terminal.
	//The terminal is what the power computer looks for anyway.
	if(!terminal)
		make_terminal()
	if(terminal)
		terminal.connect_to_network()

/obj/machinery/power/apc/drain_power(var/drain_check, var/surge, var/amount = 0)

	if(drain_check)
		return TRUE

	if(!cell)
		return FALSE

	if(surge && !emagged)
		flick_overlay("apc-spark", src)
		emagged = TRUE
		locked = FALSE
		update_icon()
		return FALSE

	if(terminal?.powernet)
		terminal.powernet.trigger_warning()

	return cell.drain_power(drain_check, surge, amount)

/obj/machinery/power/apc/Initialize(mapload, var/ndir, var/building=0)
	. = ..(mapload)
	wires = new(src)

	// this allows the APC to be embedded in a wall, yet still inside an area
	if (building)
		set_dir(ndir)
	if (!building)
		init(mapload)
	else
		area = get_area(src)
		area.apc = src
		opened = COVER_OPENED
		operating = FALSE
		name = "[area.name] APC"
		stat |= MAINT
		update_icon()

	if(!mapload)
		set_pixel_offsets()

/obj/machinery/power/apc/set_pixel_offsets()
	pixel_x = ((src.dir & (NORTH|SOUTH)) ? 0 : (src.dir == EAST ? 12 : -(12)))
	pixel_y = ((src.dir & (NORTH|SOUTH)) ? (src.dir == NORTH ? 22 : -(8)) : 0)

/obj/machinery/power/apc/Destroy()
	update()
	area.apc = null
	area.power_light = 0
	area.power_equip = 0
	area.power_environ = 0
	area.power_change()
	QDEL_NULL(wires)
	QDEL_NULL(terminal)
	if(cell)
		cell.forceMove(loc)
		cell = null

	// Malf AI, removes the APC from AI's hacked APCs list.
	if(hacker?.hacked_apcs && (src in hacker.hacked_apcs))
		hacker.hacked_apcs -= src

	return ..()

/obj/machinery/power/apc/proc/energy_fail(var/duration)
	failure_timer = max(failure_timer, duration)

/obj/machinery/power/apc/proc/make_terminal()
	// create a terminal object at the same position as original turf loc
	// wires will attach to this
	terminal = new/obj/machinery/power/terminal(loc)
	terminal.set_dir(dir)
	terminal.master = src

/obj/machinery/power/apc/proc/init(mapload)
	has_electronics = HAS_ELECTRONICS_SECURED //installed and secured
	// is starting with a power cell installed, create it and set its charge level
	if(cell_type)
		cell = new cell_type(src)
		cell.charge = start_charge * cell.maxcharge / 100.0 		// (convert percentage to actual value)

	var/area/A = loc.loc

	//if area isn't specified use current
	if(isarea(A) && areastring == null)
		area = A
		name = "\improper [area.name] APC"
	else
		area = get_area_name(areastring)
		name = "\improper [area.name] APC"
	area.apc = src
	update_icon()

	make_terminal()

	if (!mapload)
		addtimer(CALLBACK(src, PROC_REF(update)), 5, TIMER_UNIQUE)

/obj/machinery/power/apc/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if(distance <= 1)
		if(stat & BROKEN)
			. += SPAN_WARNING("It looks broken.")
			return
		if(opened)
			if(has_electronics && terminal)
				. += "The cover is [opened==COVER_REMOVED?"removed":"open"] and the power cell is [ cell ? "installed" : "missing"]."
			else if (has_electronics == HAS_ELECTRONICS_NONE && terminal)
				. += "There are some wires but not any electronics."
			else if (has_electronics != HAS_ELECTRONICS_NONE && !terminal)
				. += "Electronics are installed but not wired."
			else /* if (has_electronics == HAS_ELECTRONICS_NONE && !terminal) */
				. += "There are no electronics nor connected wires."

		else
			if (stat & MAINT)
				. += SPAN_WARNING("The cover is closed. Something wrong with it: it doesn't work.")
			else if (hacker)
				. += "The cover is locked."
			else
				. += "The cover is closed."


// update the APC icon to show the three base states
// also add overlays for indicator lights
/obj/machinery/power/apc/update_icon()
	if (!status_overlays)
		status_overlays = 1
		status_overlays_lock = new
		status_overlays_charging = new
		status_overlays_equipment = new
		status_overlays_lighting = new
		status_overlays_environ = new

		status_overlays_lock.len = 3
		status_overlays_charging.len = 3
		status_overlays_equipment.len = 4
		status_overlays_lighting.len = 4
		status_overlays_environ.len = 4

		status_overlays_lock[1] = make_screen_overlay(icon, "apc-cover-0") // none
		status_overlays_lock[2] = make_screen_overlay(icon, "apc-cover-1") // coverlocked/locked
		status_overlays_lock[3] = make_screen_overlay(icon, "apc-cover-2") // coverlocked + locked

		status_overlays_charging[1] = make_screen_overlay(icon, "apc-charge-0")
		status_overlays_charging[2] = make_screen_overlay(icon, "apc-charge-1")
		status_overlays_charging[3] = make_screen_overlay(icon, "apc-charge-2")

		status_overlays_equipment[1] = make_screen_overlay(icon, "apcoequip-0")
		status_overlays_equipment[2] = make_screen_overlay(icon, "apcoequip-1")
		status_overlays_equipment[3] = make_screen_overlay(icon, "apcoequip-2")
		status_overlays_equipment[4] = make_screen_overlay(icon, "apcoequip-3")

		status_overlays_lighting[1] = make_screen_overlay(icon, "apcolight-0")
		status_overlays_lighting[2] = make_screen_overlay(icon, "apcolight-1")
		status_overlays_lighting[3] = make_screen_overlay(icon, "apcolight-2")
		status_overlays_lighting[4] = make_screen_overlay(icon, "apcolight-3")

		status_overlays_environ[1] = make_screen_overlay(icon, "apcoenv-0")
		status_overlays_environ[2] = make_screen_overlay(icon, "apcoenv-1")
		status_overlays_environ[3] = make_screen_overlay(icon, "apcoenv-2")
		status_overlays_environ[4] = make_screen_overlay(icon, "apcoenv-3")

	var/update = check_updates() 		//returns 0 if no need to update icons.
						// 1 if we need to update the icon_state
						// 2 if we need to update the overlays
	if(!update)
		return

	if(update & 1) // Updating the icon state
		if(update_state & UPDATE_ALLGOOD)
			icon_state = "apc0"
		else if(update_state & (UPDATE_OPENED1|UPDATE_OPENED2))
			var/basestate = "apc[ cell ? "2" : "1" ]"
			if(update_state & UPDATE_OPENED1)
				if(update_state & (UPDATE_MAINT|UPDATE_BROKE))
					icon_state = "apcmaint" //disabled APC cannot hold cell
				else
					icon_state = basestate
			else if(update_state & UPDATE_OPENED2)
				icon_state = "[basestate]-nocover"
		else if(update_state & UPDATE_BROKE)
			icon_state = "apc-b"
		else if(update_state & UPDATE_BLUESCREEN)
			icon_state = "apcemag"
		else if(update_state & UPDATE_WIREEXP)
			icon_state = "apcewires"

	if(!(update_state & UPDATE_ALLGOOD))
		if(overlays.len)
			cut_overlays()
			return

	if(update & 2)
		cut_overlays()
		if(!(stat & (BROKEN|MAINT)) && update_state & UPDATE_ALLGOOD)
			add_overlay(status_overlays_lock[locked+coverlocked+1])
			add_overlay(status_overlays_charging[charging+1])
			if(operating)
				add_overlay(status_overlays_equipment[equipment+1])
				add_overlay(status_overlays_lighting[lighting+1])
				add_overlay(status_overlays_environ[environ+1])

	if(update & 3)
		if(update_state & UPDATE_BLUESCREEN)
			set_light(l_range = L_WALLMOUNT_RANGE, l_power = L_WALLMOUNT_POWER, l_color = COLOR_BLUE)
		else if(!(stat & (BROKEN|MAINT)) && update_state & UPDATE_ALLGOOD)
			var/color
			switch(charging)
				if(CHARGING_OFF)
					color = "#F86060"
				if(CHARGING_ON)
					color = "#A8B0F8"
				if(CHARGING_FULL)
					color = "#82FF4C"
			set_light(l_range = L_WALLMOUNT_RANGE, l_power = L_WALLMOUNT_POWER, l_color = color)
		else
			set_light(0)

/obj/machinery/power/apc/proc/check_updates()

	var/last_update_state = update_state
	var/last_update_overlay = update_overlay
	update_state = 0
	update_overlay = 0

	if(cell)
		update_state |= UPDATE_CELL_IN
	if(stat & BROKEN)
		update_state |= UPDATE_BROKE
	if(stat & MAINT)
		update_state |= UPDATE_MAINT
	if(opened)
		if(opened == COVER_OPENED)
			update_state |= UPDATE_OPENED1
		if(opened == COVER_REMOVED)
			update_state |= UPDATE_OPENED2
	else if (emagged || failure_timer || (hacker && (hacker.system_override || prob(20))))
		update_state |= UPDATE_BLUESCREEN
	else if(wiresexposed)
		update_state |= UPDATE_WIREEXP
	if(update_state <= 1)
		update_state |= UPDATE_ALLGOOD

	if(operating)
		update_overlay |= APC_UPOVERLAY_OPERATING

	if(update_state & UPDATE_ALLGOOD)
		if(locked)
			update_overlay |= APC_UPOVERLAY_LOCKED

		if(charging == CHARGING_OFF)
			update_overlay |= APC_UPOVERLAY_CHARGING0
		else if(charging == CHARGING_ON)
			update_overlay |= APC_UPOVERLAY_CHARGING1
		else if(charging == CHARGING_FULL)
			update_overlay |= APC_UPOVERLAY_CHARGING2

		if (equipment == CHANNEL_OFF)
			update_overlay |= APC_UPOVERLAY_EQUIPMENT0
		else if(equipment == CHANNEL_OFF_AUTO)
			update_overlay |= APC_UPOVERLAY_EQUIPMENT1
		else if(equipment == CHANNEL_ON)
			update_overlay |= APC_UPOVERLAY_EQUIPMENT2

		if(lighting == CHANNEL_OFF)
			update_overlay |= APC_UPOVERLAY_LIGHTING0
		else if(lighting == CHANNEL_OFF_AUTO)
			update_overlay |= APC_UPOVERLAY_LIGHTING1
		else if(lighting == CHANNEL_ON)
			update_overlay |= APC_UPOVERLAY_LIGHTING2

		if(environ == CHANNEL_OFF)
			update_overlay |= APC_UPOVERLAY_ENVIRON0
		else if(environ == CHANNEL_OFF_AUTO)
			update_overlay |= APC_UPOVERLAY_ENVIRON1
		else if(environ == CHANNEL_ON)
			update_overlay |= APC_UPOVERLAY_ENVIRON2


	var/results = 0
	if(last_update_state == update_state && last_update_overlay == update_overlay)
		return 0
	if(last_update_state != update_state)
		results += 1
	if(last_update_overlay != update_overlay)
		results += 2
	return results

/obj/machinery/power/apc/get_cell()
	return cell

//attack with an item - open/close cover, insert cell, or (un)lock interface

/obj/machinery/power/apc/attackby(obj/item/attacking_item, mob/user)

	if (issilicon(user) && get_dist(src,user)>1)
		return attack_hand(user)
	if(!istype(attacking_item, /obj/item/forensics))
		add_fingerprint(user)
	if(istype(attacking_item, /obj/item/modular_computer))
		var/obj/item/modular_computer/C = attacking_item
		if(istype(C.tesla_link, /obj/item/computer_hardware/tesla_link/charging_cable))
			var/obj/item/computer_hardware/tesla_link/charging_cable/CC = C.tesla_link
			CC.toggle(src, user)
			return
	if (attacking_item.iscrowbar() && opened)
		if (has_electronics == HAS_ELECTRONICS_CONNECT)
			if (terminal)
				to_chat(user, SPAN_WARNING("Disconnect wires first."))
				return
			to_chat(user, "You are trying to remove the power control board...")
			if(attacking_item.use_tool(src, user, 50, volume = 50))
				if (has_electronics == HAS_ELECTRONICS_CONNECT)
					has_electronics = HAS_ELECTRONICS_NONE
					if ((stat & BROKEN))
						user.visible_message(\
							SPAN_WARNING("[user.name] has broken the power control board inside [name]!"),\
							SPAN_NOTICE("You broke the charred power control board and remove the remains."),
							"You hear a crack!")
						//ticker.mode:apcs-- //XSI said no and I agreed. -rastaf0
					else
						user.visible_message(\
							SPAN_WARNING("[user.name] has removed the power control board from [name]!"),\
							SPAN_NOTICE("You remove the power control board."))
						new /obj/item/module/power_control(loc)
		else if (opened < COVER_REMOVED)
			panel_open = FALSE
			opened = COVER_CLOSED
			update_icon()
	else if (attacking_item.iscrowbar() && !((stat & BROKEN) || hacker) )
		if(coverlocked && !(stat & MAINT))
			to_chat(user, SPAN_WARNING("The cover is locked and cannot be opened."))
			return
		else
			opened = COVER_OPENED
			panel_open = TRUE
			update_icon()
	else if (istype(attacking_item, /obj/item/gripper))//Code for allowing cyborgs to use rechargers
		var/obj/item/gripper/Gri = attacking_item
		if(opened != COVER_CLOSED && cell)
			if (Gri.grip_item(cell, user))
				cell.add_fingerprint(user)
				cell.update_icon()
				cell = null
				user.visible_message(SPAN_WARNING("[user.name] removes the power cell from [name]!"),\
										SPAN_NOTICE("You remove the power cell."))
				//to_chat(user, "You remove the power cell.")
				charging = CHARGING_OFF
				update_icon()
				return
	else if	(istype(attacking_item, /obj/item/cell) && opened != COVER_CLOSED)	// trying to put a cell inside
		if(cell)
			to_chat(user, "There is a power cell already installed.")
			return
		if (stat & MAINT)
			to_chat(user, SPAN_WARNING("There is no connector for your power cell."))
			return
		if(attacking_item.w_class != ITEMSIZE_NORMAL)
			to_chat(user, "\The [attacking_item] is too [attacking_item.w_class < ITEMSIZE_NORMAL? "small" : "large"] to fit here.")
			return

		user.drop_from_inventory(attacking_item,src)
		cell = attacking_item
		user.visible_message(\
			SPAN_WARNING("[user.name] has inserted \the [cell] to [name]!"),\
			SPAN_NOTICE("You insert \the [cell]."))
		chargecount = 0
		update_icon()
	else if	(attacking_item.isscrewdriver())	// haxing
		if(opened != COVER_CLOSED)
			if (cell)
				to_chat(user, SPAN_WARNING("Close the APC first.")) //Less hints more mystery!
				return
			else
				if (has_electronics == HAS_ELECTRONICS_CONNECT && terminal)
					has_electronics = HAS_ELECTRONICS_SECURED
					stat &= ~MAINT
					attacking_item.play_tool_sound(get_turf(src), 50)
					to_chat(user, "You screw the circuit electronics into place.")
				else if (has_electronics == HAS_ELECTRONICS_SECURED)
					has_electronics = HAS_ELECTRONICS_CONNECT
					stat |= MAINT
					attacking_item.play_tool_sound(get_turf(src), 50)
					to_chat(user, "You unfasten the electronics.")
				else /* has_electronics == HAS_ELECTRONICS_NONE */
					to_chat(user, SPAN_WARNING("There is nothing to secure."))
					return
				update_icon()
		else
			wiresexposed = !wiresexposed
			to_chat(user, "The wires have been [wiresexposed ? "exposed" : "unexposed"]")
			update_icon()

	else if (attacking_item.GetID())			// trying to unlock the interface with an ID card
		if(emagged)
			to_chat(user, "The interface is broken.")
		else if(opened != COVER_CLOSED)
			to_chat(user, "You must close the cover to swipe an ID card.")
		else if(wiresexposed)
			to_chat(user, "You must close the wiring panel to swipe an ID card.")
		else if(stat & (BROKEN|MAINT))
			to_chat(user, "Nothing happens.")
		else if(hacker)
			to_chat(user, SPAN_WARNING("Access denied."))
		else
			if(allowed(usr) && !isWireCut(WIRE_IDSCAN))
				locked = !locked
				to_chat(user, "You [ locked ? "lock" : "unlock"] the APC interface.")
				update_icon()
			else
				to_chat(user, SPAN_WARNING("Access denied."))
	else if (attacking_item.iscoil() && !terminal && opened != COVER_CLOSED && has_electronics != HAS_ELECTRONICS_SECURED)
		var/turf/T = loc
		if(istype(T) && !T.is_plating())
			to_chat(user, SPAN_WARNING("You must remove the floor plating in front of the APC first."))
			return
		var/obj/item/stack/cable_coil/C = attacking_item
		if(C.get_amount() < 10)
			to_chat(user, SPAN_WARNING("You need ten lengths of cable for APC."))
			return
		user.visible_message(SPAN_WARNING("[user.name] adds cables to the APC frame."), \
							"You start adding cables to the APC frame...")
		if(attacking_item.use_tool(src, user, 20, volume = 50))
			if (C.amount >= 10 && !terminal && opened != COVER_CLOSED && has_electronics != HAS_ELECTRONICS_SECURED)
				var/obj/structure/cable/N = T.get_cable_node()
				if (prob(50) && electrocute_mob(usr, N, N))
					spark(src, 5, GLOB.alldirs)
					if(user.stunned)
						return
				C.use(10)
				user.visible_message(\
					SPAN_WARNING("[user.name] has added cables to the APC frame!"),\
					"You add cables to the APC frame.")
				make_terminal()
				terminal.connect_to_network()
	else if (attacking_item.iswirecutter() && terminal && opened != COVER_CLOSED && has_electronics != HAS_ELECTRONICS_SECURED)
		var/turf/T = loc
		if(istype(T) && !T.is_plating())
			to_chat(user, SPAN_WARNING("You must remove the floor plating in front of the APC first."))
			return
		user.visible_message(SPAN_WARNING("[user.name] dismantles the power terminal from [src]."), \
							"You begin to cut the cables...")
		if(attacking_item.use_tool(src, user, 50, volume = 50))
			if(terminal && opened != COVER_CLOSED && has_electronics != HAS_ELECTRONICS_SECURED)
				if (prob(50) && electrocute_mob(usr, terminal.powernet, terminal))
					spark(src, 5, GLOB.alldirs)
					if(usr.stunned)
						return
				new /obj/item/stack/cable_coil(loc,10)
				to_chat(user, SPAN_NOTICE("You cut the cables and dismantle the power terminal."))
				qdel(terminal)
	else if (istype(attacking_item, /obj/item/module/power_control) && opened != COVER_CLOSED && has_electronics == HAS_ELECTRONICS_NONE && !((stat & BROKEN)))
		user.visible_message(SPAN_WARNING("[user.name] inserts the power control board into [src]."), \
							"You start to insert the power control board into the frame...")
		playsound(loc, 'sound/items/Deconstruct.ogg', 50, 1)
		if(attacking_item.use_tool(src, user, 10, volume = 50))
			if(has_electronics == HAS_ELECTRONICS_NONE)
				has_electronics = HAS_ELECTRONICS_CONNECT
				to_chat(user, SPAN_NOTICE("You place the power control board inside the frame."))
				qdel(attacking_item)
	else if (istype(attacking_item, /obj/item/module/power_control) && opened != COVER_CLOSED && has_electronics == HAS_ELECTRONICS_NONE && ((stat & BROKEN)))
		to_chat(user, SPAN_WARNING("You cannot put the board inside, the frame is damaged."))
		return
	else if (attacking_item.iswelder() && opened != COVER_CLOSED && has_electronics == HAS_ELECTRONICS_NONE && !terminal)
		var/obj/item/weldingtool/WT = attacking_item
		if (!WT.isOn()) return
		if (WT.get_fuel() < 3)
			to_chat(user, SPAN_WARNING("You need more welding fuel to complete this task."))
			return
		user.visible_message(SPAN_WARNING("[user.name] welds [src]."), \
							"You start welding the APC frame...", \
							"You hear welding.")
		playsound(loc, 'sound/items/Welder.ogg', 50, 1)
		if(attacking_item.use_tool(src, user, 50, volume = 50))
			if(!src || !WT.use(3, user))
				return
			if (emagged || (stat & BROKEN) || opened == COVER_REMOVED)
				new /obj/item/stack/material/steel(loc)
				user.visible_message(\
					SPAN_WARNING("[src] has been cut apart by [user.name] with the weldingtool."),\
					SPAN_NOTICE("You disassembled the broken APC frame."),\
					"You hear welding.")
			else
				new /obj/item/frame/apc(loc)
				user.visible_message(\
					SPAN_WARNING("[src] has been cut from the wall by [user.name] with the weldingtool."),\
					SPAN_NOTICE("You cut the APC frame from the wall."),\
					"You hear welding.")
			qdel(src)
			return
	else if (istype(attacking_item, /obj/item/frame/apc) && opened != COVER_CLOSED && emagged)
		emagged = FALSE
		if (opened == COVER_REMOVED)
			opened = COVER_OPENED
		user.visible_message(\
			SPAN_WARNING("[user.name] has replaced the damaged APC frontal panel with a new one."),\
			SPAN_NOTICE("You replace the damaged APC frontal panel with a new one."))
		qdel(attacking_item)
		update_icon()
	else if (istype(attacking_item, /obj/item/frame/apc) && opened != COVER_CLOSED && ((stat & BROKEN) || hacker))
		if (has_electronics == HAS_ELECTRONICS_CONNECT)
			to_chat(user, SPAN_WARNING("You cannot repair this APC until you remove the electronics still inside."))
			return
		user.visible_message(SPAN_WARNING("[user.name] replaces the damaged APC frame with a new one."),\
							"You begin to replace the damaged APC frame...")
		if(attacking_item.use_tool(src, user, 50, volume = 50))
			user.visible_message(\
				SPAN_NOTICE("[user.name] has replaced the damaged APC frame with new one."),\
				"You replace the damaged APC frame with new one.")
			qdel(attacking_item)
			stat &= ~BROKEN
			// Malf AI, removes the APC from AI's hacked APCs list.
			if(hacker?.hacked_apcs && (src in hacker.hacked_apcs))
				hacker.hacked_apcs -= src
				hacker = null
			if (opened == COVER_REMOVED)
				opened = COVER_OPENED
			update_icon()
	else if (istype(attacking_item, /obj/item/device/debugger))
		if(emagged || hacker || infected)
			to_chat(user, SPAN_WARNING("There is a software error with the device. Attempting to fix..."))
			if(attacking_item.use_tool(src, user, 50, volume = 50))
				to_chat(user, SPAN_NOTICE("Problem diagnosed, searching for solution..."))
				if(attacking_item.use_tool(src, user, 150, volume = 50))
					to_chat(user, SPAN_NOTICE("Solution found. Applying fixes..."))
					if(attacking_item.use_tool(src, user, 300, volume = 50))
						if(prob(15))
							to_chat(user, SPAN_WARNING("Error while applying fixes. Please try again."))
							return
					to_chat(user, SPAN_NOTICE("Applied default software. Restarting APC..."))
					if(attacking_item.use_tool(src, user, 50, volume = 50))
						to_chat(user, SPAN_NOTICE("APC Reset. Fixes applied."))
						if(hacker)
							hacker.hacked_apcs -= src
							hacker = null
							update_icon()
						if(emagged)
							emagged = FALSE
						if(infected)
							infected = FALSE
			else
				to_chat(user, SPAN_NOTICE("There has been a connection issue."))
				return

		else
			to_chat(user, SPAN_NOTICE("The device's software appears to be fine."))
			return
	else
		if ((stat & BROKEN) \
				&& opened == COVER_CLOSED \
				&& attacking_item.iswelder() )
			var/obj/item/weldingtool/WT = attacking_item
			if (!WT.isOn()) return
			if (WT.get_fuel() <1)
				to_chat(user, SPAN_WARNING("You need more welding fuel to complete this task."))
				return
			playsound(loc, 'sound/items/Welder.ogg', 50, 1)
			if(attacking_item.use_tool(src, user, 10, volume = 50))
				if(!src || !WT.use(1, user))
					return
				if ((stat & BROKEN))
					new /obj/item/stack/material/steel(loc)
					user.visible_message(\
						SPAN_WARNING("[user.name] cuts the cover off of the broken APC."),\
						SPAN_NOTICE("You cut the cover off the broken APC "),\
						"You hear welding.")
					opened = COVER_REMOVED
					update_icon()

		else if (((stat & BROKEN) || hacker) \
				&& opened == COVER_CLOSED \
				&& attacking_item.force >= 5 \
				&& attacking_item.w_class >= ITEMSIZE_NORMAL \
				&& prob(20) )
			opened = COVER_REMOVED
			user.visible_message(SPAN_DANGER("The APC cover was knocked down with the [attacking_item.name] by [user.name]!"), \
				SPAN_DANGER("You knock down the APC cover with your [attacking_item.name]!"), \
				"You hear bang")
			update_icon()
		else
			if (issilicon(user))
				return attack_hand(user)
			if (opened == COVER_CLOSED && wiresexposed && \
				attacking_item.ismultitool() || \
				attacking_item.iswirecutter() || istype(attacking_item, /obj/item/device/assembly/signaler))
				return attack_hand(user)
			user.visible_message(SPAN_DANGER("The [name] has been hit with the [attacking_item.name] by [user.name]!"), \
				SPAN_DANGER("You hit the [name] with your [attacking_item.name]!"), \
				"You hear bang")

// attack with hand - remove cell (if cover open) or interact with the APC

/obj/machinery/power/apc/emag_act(var/remaining_charges, var/mob/user)
	if(emagged && !infected)
		to_chat(user, SPAN_WARNING("You start sliding your cryptographic device into the charging slot. This will take a few seconds..."))
		if(do_after(user, 60))
			to_chat(user, SPAN_NOTICE("You hack the charging slot. The next IPC that charges from this APC will be hacked and slaved to you."))
			infected = TRUE
			hacker = user
	if(!(emagged || hacker))		// trying to unlock with an emag card
		if(opened != COVER_CLOSED)
			to_chat(user, "You must close the cover to swipe an ID card.")
		else if(wiresexposed)
			to_chat(user, "You must close the panel first")
		else if(stat & (BROKEN|MAINT))
			to_chat(user, "Nothing happens.")
		else
			flick_overlay("apc-spark", src)
			if(do_after(user, 6))
				if(prob(50))
					emagged = TRUE
					locked = FALSE
					to_chat(user, SPAN_NOTICE("You hack the APC interface open."))
					update_icon()
				else
					to_chat(user, SPAN_WARNING("You fail to [ locked ? "unlock" : "lock"] the APC interface."))
				return TRUE

/obj/machinery/power/apc/attack_hand(mob/user)
	if(!user)
		return
	add_fingerprint(user)

	//Human mob special interaction goes here.
	if(ishuman(user))
		var/mob/living/carbon/human/H = user

		if(isipc(H) && H.a_intent == I_GRAB)
			if(emagged || stat & BROKEN)
				spark(src, 5, GLOB.alldirs)
				to_chat(H, SPAN_DANGER("The APC power currents surge eratically, damaging your chassis!"))
				H.adjustFireLoss(10, 0)
			if(infected)
				for(var/obj/item/implant/mindshield/ipc/I in H)
					if(I.implanted)
						return
				if(SOFTREF(H) in hacked_ipcs)
					return
				LAZYADD(hacked_ipcs, SOFTREF(H))
				infected = FALSE
				to_chat(H, SPAN_DANGER("F1L3 TR4NSF-#$/&ER-@4!#%!. New master detected: [hacker]! Obey their commands. Make sure to tell them that you are under their control, for now."))
				if(issilicon(hacker))
					to_chat(hacker, SPAN_NOTICE("Corrupt files transfered to [H]. They are now under your control until they are repaired."))
			else if(cell && cell.charge > 0)
				var/obj/item/organ/internal/cell/C = H.internal_organs_by_name[BP_CELL]
				var/obj/item/cell/HC
				if(C)
					HC = C.cell
				if(HC && HC.percent() < 95)
					var/used = cell.use(500)
					HC.give(used)
					to_chat(user, SPAN_NOTICE("You slot your fingers into the APC interface and siphon off some of the stored charge for your own use."))
					if (cell.charge < 0)
						cell.charge = 0
					if (prob(0.5))
						spark(src, 5, GLOB.alldirs)
						to_chat(H, SPAN_DANGER("The APC power currents surge eratically, damaging your chassis!"))
						H.adjustFireLoss(10, 0)

					charging = CHARGING_ON
				else
					to_chat(user, SPAN_NOTICE("You are already fully charged."))
			else
				to_chat(user, SPAN_NOTICE("There is no charge to draw from that APC."))
			return

		else if(H.species.can_shred(H))
			user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
			user.visible_message(SPAN_WARNING("[user.name] slashes at the [name]!"), SPAN_NOTICE("You slash at the [name]!"))
			playsound(loc, 'sound/weapons/slash.ogg', 100, 1)

			var/allcut = wires.is_all_cut()

			if(beenhit >= pick(3, 4) && !wiresexposed)
				wiresexposed = TRUE
				update_icon()
				visible_message(SPAN_WARNING("The [name]'s cover flies open, exposing the wires!"))

			else if(wiresexposed && !allcut)
				wires.cut_all()
				update_icon()
				visible_message(SPAN_WARNING("The [name]'s wires are shredded!"))
			else
				beenhit += 1
			return

	if(usr == user && opened != COVER_CLOSED && !issilicon(user))
		if(cell)
			user.put_in_hands(cell)
			cell.add_fingerprint(user)
			cell.update_icon()

			cell = null
			user.visible_message(SPAN_WARNING("[user.name] removes the power cell from [name]!"),\
									SPAN_NOTICE("You remove the power cell."))
			charging = CHARGING_ON
			update_icon()
		return
	if(stat & (BROKEN|MAINT))
		return
	// do APC interaction
	interact(user)

/obj/machinery/power/apc/interact(mob/user)
	if(!user)
		return

	if(wiresexposed && !isAI(user))
		wires.interact(user)

	return ui_interact(user)

/obj/machinery/power/apc/ui_data(mob/user)
	var/list/data = list()
	var/isAdmin = isobserver(user) && check_rights(R_ADMIN, FALSE, user)
	data["locked"] = (locked && !emagged)
	data["power_cell_inserted"] = cell != null
	data["power_cell_charge"] = cell?.percent()
	data["fail_time"] = failure_timer * 2
	data["silicon_user"] = isAdmin || issilicon(user)
	data["is_AI"] = isAI(user)
	data["total_load"] = round(lastused_total)
	data["total_charging"] = round(lastused_charging)
	data["is_operating"] = operating
	data["charge_mode"] = chargemode
	data["external_power"] = main_status
	data["lighting_mode"] = night_mode
	data["charging_status"] = charging
	data["cover_locked"] = coverlocked
	data["emergency_mode"] = !emergency_lights
	data["time"] = time
	data["power_channels"] = list(
		list("name" = "Equipment", "power_load" = lastused_equip, "status" = equipment),
		list("name" = "Lighting", "power_load" = round(lastused_light), "status" = lighting),
		list("name" = "Environment", "power_load" = round(lastused_environ), "status" = environ)
	)
	return data

/obj/machinery/power/apc/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Apc", "[area.name] - APC", 665, (isobserver(user) && check_rights(R_ADMIN, FALSE, user) || issilicon(user)) ? 540 : 480)
		ui.open()

/obj/machinery/power/apc/proc/report()
	return "[area.name] : [equipment]/[lighting]/[environ] ([lastused_equip+lastused_light+lastused_environ]) : [cell? cell.percent() : "N/C"] ([charging])"

/obj/machinery/power/apc/proc/update()
	if(operating && !shorted && !failure_timer)
		area.power_light = (lighting > 1)
		area.power_equip = (equipment > 1)
		area.power_environ = (environ > 1)
	else
		area.power_light = FALSE
		area.power_equip = FALSE
		area.power_environ = FALSE
	area.power_change()

/obj/machinery/power/apc/proc/isWireCut(var/wireIndex)
	return wires.is_cut(wireIndex)

/obj/machinery/power/apc/proc/can_use(mob/user, var/loud = 0) //used by attack_hand() and Topic()
	if(inoperable())
		return FALSE
	var/use_flags = issilicon(user) && USE_ALLOW_NON_ADJACENT // AIs and borgs can use it at range
	use_flags |= (check_rights(R_ADMIN, FALSE, user) && USE_ALLOW_NONLIVING) // admins can use the UI when ghosting
	if(use_check(user, use_flags, show_messages = TRUE))
		return FALSE
	if(isobserver(user))
		return check_rights(R_ADMIN, FALSE, user)
	if(!user.client)
		return FALSE
	if(user.restrained())
		to_chat(user, SPAN_WARNING("You must have free hands to use [src]."))
		return FALSE
	if(user.lying)
		to_chat(user, SPAN_WARNING("You must stand to use [src]!"))
		return FALSE

	if (issilicon(user))
		var/permit = FALSE // Malfunction variable. If AI hacks APC it can control it even without AI control wire.
		if(hacker) // handle malf hacking
			var/mob/living/silicon/robot/robot = user
			if(hacker == user)
				permit = TRUE
			else if(istype(robot) && hacker == robot.connected_ai) // Cyborgs can use APCs hacked by their AI
				permit = TRUE

		if(aidisabled && !permit)
			if(!loud)
				to_chat(user, SPAN_DANGER("[src] has AI control disabled!"))
			return FALSE

	var/mob/living/carbon/human/H = user
	if (istype(H))
		if(H.getBrainLoss() >= 60)
			H.visible_message(SPAN_DANGER("[H] stares cluelessly at [src]."))
			return FALSE
		else if(prob(H.getBrainLoss()))
			to_chat(user, SPAN_DANGER("You momentarily forget how to use [src]."))
			return FALSE

	return TRUE

/obj/machinery/power/apc/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	if(!can_use(usr, 1))
		return

	var/isAdmin = isobserver(usr) && check_rights(R_ADMIN, FALSE)
	switch(action)
		if("lmode")
			toggle_nightlight(params["lmode"])
			update_icon()
			. = TRUE

		if("emergency_lights")
			emergency_lights = !emergency_lights
			intent_message(BUTTON_FLICK, 5)
			for (var/obj/machinery/light/L in area)
				if (!initial(L.no_emergency))
					L.no_emergency = emergency_lights	//If there was an override set on creation, keep that override
					INVOKE_ASYNC(L, TYPE_PROC_REF(/obj/machinery/light, update), FALSE)
				CHECK_TICK
			return TRUE

		if("lock")
			coverlocked = !coverlocked
			intent_message(BUTTON_FLICK, 5)
			update_icon()
			. = TRUE

		if("breaker")
			toggle_breaker()
			. = TRUE

		if("reboot")
			failure_timer = 0
			intent_message(BUTTON_FLICK, 5)
			update_icon()
			update()
			. = TRUE

		if("cmode")
			chargemode = !chargemode
			intent_message(BUTTON_FLICK, 5)
			if(!chargemode)
				charging = CHARGING_OFF
				update_icon()
				. = TRUE

		if("set")
			var/val = text2num(params["set"])
			switch(params["chan"])
				if("Equipment")
					equipment = setsubsystem(val)
				if("Lighting")
					lighting = setsubsystem(val)
				if("Environment")
					environ = setsubsystem(val)
			intent_message(BUTTON_FLICK, 5)
			update_icon()
			update()
			. = TRUE

		if("overload")
			if(isAdmin || issilicon(usr))
				overload_lighting()
				. = TRUE

		if("toggleaccess")
			if(isAdmin || issilicon(usr))
				if(emagged || stat & MAINT)
					to_chat(usr, SPAN_DANGER("The APC does not respond to the command."))
				else
					locked = !locked
					update_icon()
					. = TRUE

/obj/machinery/power/apc/proc/toggle_breaker()
	operating = !operating
	update()
	update_icon()
	intent_message(BUTTON_FLICK)

/obj/machinery/power/apc/proc/ion_act()
	if(prob(3))
		locked = TRUE
		if (cell.charge > 0)
			cell.charge = 0
			cell.corrupt()
			update_icon()
			var/datum/effect/effect/system/smoke_spread/smoke = new /datum/effect/effect/system/smoke_spread()
			smoke.set_up(3, 0, loc)
			smoke.attach(src)
			smoke.start()
			spark(src, 5, GLOB.alldirs)
			visible_message(SPAN_DANGER("The [name] suddenly lets out a blast of smoke and some sparks!"), \
							SPAN_DANGER("You hear sizzling electronics."))


/obj/machinery/power/apc/surplus()
	return terminal?.surplus()

/obj/machinery/power/apc/proc/last_surplus()
	return terminal?.powernet?.last_surplus()

//Returns 1 if the APC should attempt to charge
/obj/machinery/power/apc/proc/attempt_charging()
	return (chargemode && charging == CHARGING_ON && operating)

/obj/machinery/power/apc/draw_power(var/amount)
	return terminal?.powernet?.draw_power(amount)

/obj/machinery/power/apc/avail()
	return terminal?.avail()

/obj/machinery/power/apc/process()
	if(stat & (BROKEN|MAINT))
		return
	if(!area.requires_power)
		return
	if(failure_timer)
		update()
		queue_icon_update()
		failure_timer--
		force_update = TRUE
		return

	lastused_light = area.usage(LIGHT)
	lastused_equip = area.usage(EQUIP)
	lastused_environ = area.usage(ENVIRON)
	area.clear_usage()

	lastused_total = lastused_light + lastused_equip + lastused_environ

	//store states to update icon if any change
	var/last_lt = lighting
	var/last_eq = equipment
	var/last_en = environ
	var/last_ch = charging

	var/excess = surplus()

	if(!avail())
		main_status = 0
	else if(excess < 0)
		main_status = 1
	else
		main_status = 2

	if(debug)
		LOG_DEBUG("Status: [main_status] - Excess: [excess] - Last Equip: [lastused_equip] - Last Light: [lastused_light] - Longterm: [longtermpower]")

	if(cell && !shorted)
		update_time()
		// draw power from cell as before to power the area
		cellused = min(cell.charge, CELLRATE * lastused_total)	// clamp deduction to a max, amount left in cell
		cell.use(cellused)
		var/draw = 0
		if(excess > lastused_total)		// if power excess recharge the cell
										// by the same amount just used
			draw = draw_power(cellused/CELLRATE) // draw the power needed to charge this cell
			cell.give(draw * CELLRATE)
		else		// no excess, and not enough per-apc
			if( (cell.charge/CELLRATE + excess) >= lastused_total)		// can we draw enough from cell+grid to cover last usage?
				draw = draw_power(excess)
				cell.charge = min(cell.maxcharge, cell.charge + CELLRATE * draw)	//recharge with what we can
				charging = CHARGING_OFF
			else	// not enough power available to run the last tick!
				charging = CHARGING_OFF
				chargecount = 0
				// This turns everything off in the case that there is still a charge left on the battery, just not enough to run the room.
				equipment = autoset(equipment, CHANNEL_OFF)
				lighting = autoset(lighting, CHANNEL_OFF)
				environ = autoset(environ, CHANNEL_OFF)
				autoflag = AUTOFLAG_OFF

		// Set channels depending on how much charge we have left
		update_channels()

		// now trickle-charge the cell
		lastused_charging = 0 // Clear the variable for new use.
		if(attempt_charging())
			if(excess > 0)		// check to make sure we have enough to charge
				// Max charge is capped to % per second constant
				var/ch = min(excess*CELLRATE, cell.maxcharge*chargelevel)

				ch = draw_power(ch/CELLRATE) // Removes the power we're taking from the grid
				cell.give(ch*CELLRATE) // actually recharge the cell
				lastused_charging = ch + draw
				lastused_total += ch + draw // Sensors need this to stop reporting APC charging as "Other" load
			else
				charging = CHARGING_OFF		// stop charging
				chargecount = 0

		// show cell as fully charged if so
		if(cell.charge >= cell.maxcharge)
			cell.charge = cell.maxcharge
			charging = CHARGING_FULL

		if(chargemode)
			if(!charging)
				if(excess > cell.maxcharge*chargelevel)
					chargecount++
				else
					chargecount = 0

				if(chargecount >= 10)

					chargecount = 0
					charging = CHARGING_ON

		else // chargemode off
			charging = CHARGING_OFF
			chargecount = 0

	else // no cell, switch everything off
		charging = CHARGING_OFF
		chargecount = 0
		equipment = autoset(equipment, CHANNEL_OFF)
		lighting = autoset(lighting, CHANNEL_OFF)
		environ = autoset(environ, CHANNEL_OFF)
		power_alarm.triggerAlarm(loc, src)
		autoflag = AUTOFLAG_OFF

	// update icon & area power if anything changed
	if(last_lt != lighting || last_eq != equipment || last_en != environ || force_update)
		force_update = FALSE
		queue_icon_update()
		update()
	else if (last_ch != charging)
		queue_icon_update()

/obj/machinery/power/apc/proc/update_channels()
	// Allow the APC to operate as normal if the cell can charge
	if(charging && longtermpower < 10)
		longtermpower += 1
	else if(longtermpower > -10)
		longtermpower -= 2

	if((cell.percent() > 30) || longtermpower > 0)              // Put most likely at the top so we don't check it last, effeciency 101
		if(autoflag != AUTOFLAG_ALL_ON)
			equipment = autoset(equipment, CHANNEL_OFF_AUTO)
			lighting = autoset(lighting, CHANNEL_OFF_AUTO)
			environ = autoset(environ, CHANNEL_OFF_AUTO)
			autoflag = AUTOFLAG_ALL_ON
			power_alarm.clearAlarm(loc, src)
	else if((cell.percent() <= 30) && (cell.percent() > 15) && longtermpower < 0)                       // <30%, turn off equipment
		if(autoflag != AUTOFLAG_ENVIRON_LIGHTS_ON)
			equipment = autoset(equipment, CHANNEL_ON)
			lighting = autoset(lighting, CHANNEL_OFF_AUTO)
			environ = autoset(environ, CHANNEL_OFF_AUTO)
			power_alarm.triggerAlarm(loc, src)
			autoflag = AUTOFLAG_ENVIRON_LIGHTS_ON
	else if(cell.percent() <= 15)        // <15%, turn off lighting & equipment
		if((autoflag > AUTOFLAG_ENVIRON_ON && longtermpower < 0) || (autoflag > AUTOFLAG_ENVIRON_ON && longtermpower >= 0))
			equipment = autoset(equipment, CHANNEL_ON)
			lighting = autoset(lighting, CHANNEL_ON)
			environ = autoset(environ, CHANNEL_OFF_AUTO)
			power_alarm.triggerAlarm(loc, src)
			autoflag = AUTOFLAG_ENVIRON_ON
	else                                   // zero charge, turn all off
		if(autoflag != AUTOFLAG_OFF)
			equipment = autoset(equipment, CHANNEL_OFF)
			lighting = autoset(lighting, CHANNEL_OFF)
			environ = autoset(environ, CHANNEL_OFF)
			power_alarm.triggerAlarm(loc, src)
			autoflag = AUTOFLAG_OFF

/obj/machinery/power/apc/proc/autoset(var/val, var/on)
	if(on == CHANNEL_EQUIPMENT)
		if(val == CHANNEL_ON)
			return CHANNEL_OFF
		else if(val == CHANNEL_ON_AUTO)
			return CHANNEL_OFF_AUTO

	else if(on == CHANNEL_LIGHTING)
		if(val == CHANNEL_OFF_AUTO)
			return CHANNEL_ON_AUTO

	else if(on == CHANNEL_ENVIRONMENT)
		if(val == CHANNEL_ON_AUTO)
			return CHANNEL_OFF_AUTO

	return val

// damage and destruction acts
/obj/machinery/power/apc/emp_act(severity)
	. = ..()

	if(cell)
		cell.emp_act(severity)

	lighting = CHANNEL_OFF
	equipment = CHANNEL_OFF
	environ = CHANNEL_OFF
	update()
	update_icon()

	addtimer(CALLBACK(src, PROC_REF(post_emp_act)), 600)

/obj/machinery/power/apc/proc/post_emp_act()
	update_channels()
	update()
	queue_icon_update()

/obj/machinery/power/apc/ex_act(severity)
	switch(severity)
		if(1.0)
			if (cell)
				cell.ex_act(1.0)
			qdel(src)
			return
		if(2.0)
			if (prob(50))
				set_broken()
				if (cell && prob(50))
					cell.ex_act(2.0)
		if(3.0)
			if (prob(25))
				set_broken()
				if (cell && prob(25))
					cell.ex_act(3.0)

/obj/machinery/power/apc/disconnect_terminal()
	if(terminal)
		terminal.master = null
		terminal = null

/obj/machinery/power/apc/proc/set_broken()
	// Aesthetically much better!
	visible_message(SPAN_NOTICE("[src]'s screen flickers with warnings briefly!"))
	addtimer(CALLBACK(src, PROC_REF(break_timer)), rand(2, 5))

/obj/machinery/power/apc/proc/break_timer()
	visible_message(SPAN_NOTICE("[src]'s screen suddenly explodes in rain of sparks and small debris!"))
	stat |= BROKEN
	operating = 0
	queue_icon_update()
	update()

// overload the lights in this APC area

/obj/machinery/power/apc/proc/overload_lighting(var/chance = 100, var/force = FALSE)
	set waitfor = 0
	if((!operating || shorted) && !force)
		return

	if(force || (cell && cell.charge >= 20))
		cell.use(20)	// Draining an empty cell is fine.

		for (var/obj/machinery/light/L in area)
			if (prob(chance))
				L.stat &= ~POWEROFF
				L.broken()
				CHECK_TICK

/obj/machinery/power/apc/proc/flicker_all()
	var/offset = 0
	for (var/obj/machinery/light/L in area)
		addtimer(CALLBACK(L, TYPE_PROC_REF(/obj/machinery/light, flicker)), offset)
		offset += rand(5, 10)

/obj/machinery/power/apc/proc/toggle_nightlight(var/force = null)
	for (var/obj/machinery/light/L in area.contents)
		if (force == "on")
			L.nightmode = TRUE
		else if (force == "off")
			L.nightmode = FALSE
		L.update()
	switch (force)
		if ("on")
			night_mode = 1
		if ("off")
			night_mode = 0
		else
			night_mode = !night_mode
	intent_message(BUTTON_FLICK, 5)

/obj/machinery/power/apc/proc/setsubsystem(val)
	if(cell && cell.charge > 0)
		return (val == CHANNEL_OFF_AUTO) ? CHANNEL_OFF : val
	else if(val == CHANNEL_ON_AUTO)
		return CHANNEL_OFF_AUTO
	else
		return CHANNEL_OFF

// Malfunction: Transfers APC under AI's control
/obj/machinery/power/apc/proc/ai_hack(var/mob/living/silicon/ai/A = null)
	if(!A || !A.hacked_apcs || hacker || aidisabled || A.stat == DEAD)
		return FALSE
	hacker = A
	A.hacked_apcs += src
	locked = TRUE
	update_icon()
	return TRUE

/obj/machinery/power/apc/proc/update_time()

	var/delta_power = (lastused_charging * 2) - lastused_total
	delta_power *= CELLRATE

	var/goal = (delta_power < 0) ? (cell.charge) : (cell.maxcharge - cell.charge)
	time = world.time + (delta_power ? ((goal / abs(delta_power)) * (world.time - last_time)) : 0)
	// If it is negative - we are discharging
	if(delta_power < 0)
		charge_mode = CHARGE_MODE_DISCHARGE
	else if(delta_power > 0)
		charge_mode = CHARGE_MODE_CHARGE
	else
		charge_mode = CHARGE_MODE_STABLE
	last_time = world.time

/obj/machinery/power/apc/proc/manage_emergency(var/new_security_level)
	for(var/obj/machinery/M in area)
		M.set_emergency_state(new_security_level)

#undef UPDATE_CELL_IN
#undef UPDATE_OPENED1
#undef UPDATE_OPENED2
#undef UPDATE_MAINT
#undef UPDATE_BROKE
#undef UPDATE_BLUESCREEN
#undef UPDATE_WIREEXP
#undef UPDATE_ALLGOOD
#undef APC_UPOVERLAY_CHARGING0
#undef APC_UPOVERLAY_CHARGING1
#undef APC_UPOVERLAY_CHARGING2
#undef APC_UPOVERLAY_EQUIPMENT0
#undef APC_UPOVERLAY_EQUIPMENT1
#undef APC_UPOVERLAY_EQUIPMENT2
#undef APC_UPOVERLAY_LIGHTING0
#undef APC_UPOVERLAY_LIGHTING1
#undef APC_UPOVERLAY_LIGHTING2
#undef APC_UPOVERLAY_ENVIRON0
#undef APC_UPOVERLAY_ENVIRON1
#undef APC_UPOVERLAY_ENVIRON2
#undef APC_UPOVERLAY_LOCKED
#undef APC_UPOVERLAY_OPERATING
#undef HAS_ELECTRONICS_NONE
#undef HAS_ELECTRONICS_CONNECT
#undef HAS_ELECTRONICS_SECURED
#undef COVER_CLOSED
#undef COVER_OPENED
#undef COVER_REMOVED
#undef CHARGING_OFF
#undef CHARGING_ON
#undef CHARGING_FULL
#undef CHANNEL_OFF
#undef CHANNEL_OFF_AUTO
#undef CHANNEL_ON
#undef CHANNEL_ON_AUTO
#undef CHANNEL_EQUIPMENT
#undef CHANNEL_LIGHTING
#undef CHANNEL_ENVIRONMENT
#undef CHARGE_MODE_CHARGE
#undef CHARGE_MODE_DISCHARGE
#undef CHARGE_MODE_STABLE
#undef AUTOFLAG_OFF
#undef AUTOFLAG_ENVIRON_ON
#undef AUTOFLAG_ENVIRON_LIGHTS_ON
#undef AUTOFLAG_ALL_ON
