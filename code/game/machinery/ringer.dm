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
	z_flags = ZMM_MANGLE_PLANES

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

/obj/machinery/ringer/update_icon()
	ClearOverlays()
	var/mutable_appearance/screen = overlay_image(icon, "bell-standby")
	var/mutable_appearance/screen_hologram = overlay_image(icon, "bell-standby")
	var/mutable_appearance/screen_emis = emissive_appearance(icon, "bell-standby")
	screen_hologram.filters += filter(type="color", color=list(
		0, 0, 0, 0,
		0, 0, 0, 0,
		0, 0, 0, 0,
		HOLOSCREEN_MULTIPLICATION_FACTOR, HOLOSCREEN_MULTIPLICATION_FACTOR, HOLOSCREEN_MULTIPLICATION_FACTOR, HOLOSCREEN_MULTIPLICATION_OPACITY
	))
	screen.filters += filter(type="color", color=list(
		HOLOSCREEN_ADDITION_OPACITY, 0, 0, 0,
		0, HOLOSCREEN_ADDITION_OPACITY, 0, 0,
		0, 0, HOLOSCREEN_ADDITION_OPACITY, 0,
		0, 0, 0, 1
	))
	screen_hologram.blend_mode = BLEND_MULTIPLY
	screen.blend_mode = BLEND_ADD
	if(!on || stat & NOPOWER)
		icon_state = initial(icon_state)
		set_light(FALSE)
		return
	if(rings_pdas || rings_pdas.len)
		screen = overlay_image(icon, "bell-active")
		set_light(1.4, 1, COLOR_CYAN)
	if(pinged)
		screen = overlay_image(icon, "bell-alert")
		set_light(1.4, 1, COLOR_CYAN)
	if(on)
		AddOverlays("bell-scanline")
	else
		screen = overlay_image(icon, "bell-standby")
		set_light(1.4, 1, COLOR_CYAN)
	AddOverlays(screen_hologram)
	AddOverlays(screen)
	AddOverlays(screen_emis)

/obj/machinery/ringer/attackby(obj/item/attacking_item, mob/user)
	if(stat & (BROKEN|NOPOWER) || !istype(user,/mob/living))
		return TRUE

	if (istype(attacking_item, /obj/item/modular_computer))
		if(!check_access(attacking_item))
			to_chat(user, SPAN_WARNING("Access denied."))
			return TRUE
		else if (attacking_item in rings_pdas)
			to_chat(user, SPAN_NOTICE("You unlink \the [attacking_item] from \the [src]."))
			remove_pda(attacking_item)
			return TRUE
		to_chat(user, SPAN_NOTICE("You link \the [attacking_item] to \the [src], it will now ring upon someone using \the [src]."))
		rings_pdas += attacking_item
		UnregisterSignal(attacking_item, COMSIG_QDELETING)
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
		to_chat(user, SPAN_NOTICE("You turn \the [src] on, now all PDAs linked to it will be notified."))
		on = TRUE

	else
		to_chat(user, SPAN_NOTICE("You turn \the [src] off."))
		on = FALSE

	update_icon()

/obj/machinery/ringer/proc/ring_pda()

	if (!on || pinged)
		return

	pinged = TRUE
	update_icon()

	playsound(src.loc, 'sound/machines/ringer.ogg', 50, TRUE, ignore_walls = FALSE)

	for (var/obj/item/modular_computer/P in rings_pdas)
		var/message = "Attention required!"
		P.get_notification(message, 1, "[capitalize(department)]")

	addtimer(CALLBACK(src, PROC_REF(unping)), 45 SECONDS)

/obj/machinery/ringer/proc/unping()
	pinged = FALSE
	update_icon()

/obj/machinery/ringer/proc/remove_pda(obj/item/modular_computer/P)
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

	flick("ringer_on", src)

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
