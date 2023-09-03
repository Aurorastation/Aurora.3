#define PRESET_NORTH \
dir = NORTH; \
pixel_y = 24;

#define PRESET_SOUTH \
dir = SOUTH; \
pixel_y = -24;

#define PRESET_WEST \
dir = WEST; \
pixel_x = -8;

#define PRESET_EAST \
dir = EAST; \
pixel_x = 8;

/obj/machinery/ringer
	name = "ringer terminal"
	desc = "A ringer terminal, PDAs can be linked to it."
	icon = 'icons/obj/machinery/wall/terminals.dmi'
	icon_state = "bell"
	anchored = TRUE
	appearance_flags = TILE_BOUND // prevents people from viewing the overlay through a wall

	req_access = list() //what access it needs to link your pda

	var/id = null

	///A list of PDAs to alert upon someone touching the machine
	var/list/obj/item/modular_computer/rings_pdas = list()

	var/listener/ringers
	var/on = TRUE

	///Whatever department/desk you put this thing
	var/department = "Somewhere"

	///If the pinging is in cooldown, boolean
	var/pinged = FALSE

	var/global/list/screen_overlays

/obj/machinery/ringer/north
	PRESET_NORTH

/obj/machinery/ringer/south
	PRESET_SOUTH

/obj/machinery/ringer/west
	PRESET_WEST

/obj/machinery/ringer/east
	PRESET_EAST

/obj/machinery/ringer/Initialize(mapload)
	. = ..()
	if(id)
		ringers = new(id, src)

	if(src.dir & NORTH)
		alpha = 127
	generate_overlays()
	update_icon()

	if(!mapload)
		set_pixel_offsets()

/obj/machinery/ringer/power_change()
	..()
	update_icon()

/obj/machinery/ringer/set_pixel_offsets()
	pixel_x = DIR2PIXEL_X(dir)
	pixel_y = DIR2PIXEL_Y(dir)

/obj/machinery/ringer/Destroy()
	QDEL_NULL(ringers)
	return ..()

/obj/machinery/ringer/proc/generate_overlays(var/force = 0)
	if(LAZYLEN(screen_overlays) && !force)
		return
	LAZYINITLIST(screen_overlays)
	screen_overlays["bell-active"] = make_screen_overlay(icon, "bell-active")
	screen_overlays["bell-alert"] = make_screen_overlay(icon, "bell-alert")
	screen_overlays["bell-scanline"] = make_screen_overlay(icon, "bell-scanline")
	screen_overlays["bell-standby"] = make_screen_overlay(icon, "bell-standby")

/obj/machinery/ringer/update_icon()
	cut_overlays()
	if(!on || stat & NOPOWER)
		icon_state = initial(icon_state)
		set_light(FALSE)
		return
	if(rings_pdas || rings_pdas.len)
		add_overlay(screen_overlays["bell-active"])
		set_light(1.4, 1, COLOR_CYAN)
	if(pinged)
		add_overlay(screen_overlays["bell-alert"])
		set_light(1.4, 1, COLOR_CYAN)
	if(on)
		add_overlay(screen_overlays["bell-scanline"])
	else
		add_overlay(screen_overlays["bell-standby"])
		set_light(1.4, 1, COLOR_CYAN)

/obj/machinery/ringer/attackby(obj/item/C as obj, mob/living/user as mob)
	if(stat & (BROKEN|NOPOWER) || !istype(user,/mob/living))
		return TRUE

	if (istype(C, /obj/item/modular_computer))
		if(!check_access(C))
			to_chat(user, "<span class='warning'>Access Denied.</span>")
			return TRUE
		else if (C in rings_pdas)
			to_chat(user, "<span class='notice'>You unlink \the [C] from \the [src].</span>")
			remove_pda(C)
			return TRUE
		to_chat(user, "<span class='notice'>You link \the [C] to \the [src], it will now ring upon someone using \the [src].</span>")
		rings_pdas += C
		// WONT FIX: This requires callbacks fuck my dick.
		destroyed_event.register(C, src, PROC_REF(remove_pda))
		update_icon()
		return TRUE
	else
		return ..()

/obj/machinery/ringer/attack_hand(mob/user as mob)
	if(..())
		return

	add_fingerprint(user)

	if(stat & (BROKEN|NOPOWER) || !istype(usr,/mob/living))
		return

	if(!on)
		to_chat(user, "<span class='notice'>You turn \the [src] on, now all PDAs linked to it will be notified.</span>")
		on = TRUE

	else
		to_chat(user, "<span class='notice'>You turn \the [src] off.</span>")
		on = FALSE

	update_icon()

/obj/machinery/ringer/proc/ring_pda()

	if (!on || pinged)
		return

	pinged = TRUE
	update_icon()

	playsound(src.loc, 'sound/machines/ringer.ogg', 50, 1)

	for (var/obj/item/modular_computer/P in rings_pdas)
		var/message = "Attention required!"
		P.get_notification(message, 1, "[capitalize(department)]")

	addtimer(CALLBACK(src, PROC_REF(unping)), 45 SECONDS)

/obj/machinery/ringer/proc/unping()
	pinged = FALSE
	update_icon()

/obj/machinery/ringer/proc/remove_pda(var/obj/item/modular_computer/P)
	if (istype(P))
		rings_pdas -= P

/obj/machinery/ringer_button
	name = "ringer button"
	desc = "Use this to get someone's attention, or to annoy them."
	icon = 'icons/obj/machinery/wall/terminals.dmi'
	icon_state = "ringer"
	anchored = TRUE
	var/id = ""

/obj/machinery/ringer_button/Initialize(mapload, newid)
	. = ..()
	if(!id)
		id = newid
	update_icon()

/obj/machinery/ringer_button/power_change()
	..()
	update_icon()

/obj/machinery/ringer_button/update_icon()
	if(stat & NOPOWER)
		icon_state = "ringer_off"
	else
		icon_state = "ringer"

/obj/machinery/ringer_button/attack_hand(mob/living/user)

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)

	flick(src, "ringer_on")

	if(use_power)
		use_power_oneoff(active_power_usage)

	for (var/thing in GET_LISTENERS(id))
		var/listener/L = thing
		var/obj/machinery/ringer/C = L.target
		if (istype(C))
			C.ring_pda()

#undef PRESET_NORTH
#undef PRESET_SOUTH
#undef PRESET_WEST
#undef PRESET_EAST
