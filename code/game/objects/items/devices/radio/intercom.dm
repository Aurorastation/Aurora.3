/obj/item/device/radio/intercom
	name = "intercom (general)"
	desc = "An intercom with buttons for transmitting, receiving, and for volume control."
	desc_extended = "Has a touch display for inputting a frequency, with proper authentication. Used to communicate when you have lost your radio. \
		Otherwise, you would likely just use a handheld shortwave radio instead."
	icon_state = "intercom"
	layer = 2.99
	anchored = TRUE
	appearance_flags = TILE_BOUND // prevents people from viewing the overlay through a wall
	w_class = ITEMSIZE_LARGE
	canhear_range = 2
	flags = CONDUCT | NOBLOODY
	obj_flags = OBJ_FLAG_MOVES_UNSUPPORTED
	var/number = 0
	var/obj/machinery/abstract/intercom_listener/power_interface
	var/global/list/screen_overlays
	var/radio_sound = null
	clickvol = 40

/obj/item/device/radio/intercom/ship
	channels = list()
	var/default_hailing = FALSE

/obj/item/device/radio/intercom/ship/Initialize()
	if(!current_map.use_overmap)
		return ..()

	var/turf/T = get_turf(src)
	var/obj/effect/overmap/visitable/V = map_sectors["[T.z]"]
	if(istype(V) && V.comms_support)
		if(V.comms_name)
			name = "intercom ([V.comms_name])"
		default_frequency = assign_away_freq(V.name)
		channels += list(
			V.name = TRUE,
			CHANNEL_HAILING = TRUE
		)

	. = ..()

	if (default_hailing)
		set_frequency(HAIL_FREQ)

/obj/item/device/radio/intercom/ship/hailing
	default_hailing = TRUE

/obj/item/device/radio/intercom/custom
	name = "intercom (custom)"

/obj/item/device/radio/intercom/custom/Initialize()
	. = ..()
	set_broadcasting(FALSE)
	set_listening(FALSE)

/obj/item/device/radio/intercom/hailing
	name = "intercom (hailing)"

/obj/item/device/radio/intercom/hailing/Initialize()
	. = ..()
	set_frequency(HAIL_FREQ)

/obj/item/device/radio/intercom/interrogation
	name = "intercom (interrogation)"

/obj/item/device/radio/intercom/interrogation/Initialize()
	. = ..()
	set_frequency(1449)

/obj/item/device/radio/intercom/interrogation/broadcasting/Initialize() // The detainee's side.
	. = ..()
	set_broadcasting(TRUE)
	set_listening(FALSE)

/obj/item/device/radio/intercom/private
	name = "intercom (private)"

/obj/item/device/radio/intercom/private/Initialize()
	. = ..()
	set_frequency(AI_FREQ)

/obj/item/device/radio/intercom/specops
	name = "intercom (spec ops)"

/obj/item/device/radio/intercom/specops/Initialize()
	. = ..()
	set_frequency(ERT_FREQ)

/obj/item/device/radio/intercom/department
	canhear_range = 5

/obj/item/device/radio/intercom/department/Initialize()
	. = ..()
	set_broadcasting(FALSE)
	set_listening(TRUE)

/obj/item/device/radio/intercom/department/medbay
	name = "intercom (medical)"

/obj/item/device/radio/intercom/department/medbay/Initialize()
	. = ..()
	set_frequency(MED_I_FREQ)
	internal_channels = default_medbay_channels.Copy()

/obj/item/device/radio/intercom/department/security
	name = "intercom (security)"

/obj/item/device/radio/intercom/department/security/Initialize()
	. = ..()
	set_frequency(SEC_I_FREQ)
	internal_channels = list(
		num2text(PUB_FREQ) = list(),
		num2text(SEC_I_FREQ) = list(access_security)
	)

/obj/item/device/radio/intercom/entertainment
	name = "intercom (entertainment)"
	canhear_range = 4

/obj/item/device/radio/intercom/entertainment/Initialize()
	. = ..()
	set_frequency(ENT_FREQ)
	internal_channels = list(
		num2text(PUB_FREQ) = list(),
		num2text(ENT_FREQ) = list()
	)

/obj/item/device/radio/intercom/Initialize()
	. = ..()
	power_interface = new(loc, src)
	generate_overlays()
	update_icon()

/obj/item/device/radio/intercom/proc/generate_overlays(var/force = 0)
	if(LAZYLEN(screen_overlays) && !force)
		return
	LAZYINITLIST(screen_overlays)
	screen_overlays["intercom_screen"] = make_screen_overlay(icon, "intercom_screen")
	screen_overlays["intercom_scanline"] = make_screen_overlay(icon, "intercom_scanline")
	screen_overlays["intercom_b"] = make_screen_overlay(icon, "intercom_b")
	screen_overlays["intercom_l"] = make_screen_overlay(icon, "intercom_l")

/obj/item/device/radio/intercom/syndicate
	name = "illegally modified intercom"
	desc = "Talk through this. Evilly."
	subspace_transmission = TRUE
	syndie = TRUE

/obj/item/device/radio/intercom/syndicate/Initialize()
	. = ..()
	set_frequency(SYND_FREQ)
	internal_channels[num2text(SYND_FREQ)] = list(access_syndicate)

/obj/item/device/radio/intercom/raider
	name = "illegally modified intercom"
	desc = "Pirate radio, but not in the usual sense of the word."
	subspace_transmission = TRUE
	syndie = TRUE

/obj/item/device/radio/intercom/syndicate/Initialize()
	. = ..()
	set_frequency(RAID_FREQ)
	internal_channels[num2text(RAID_FREQ)] = list(access_syndicate)

/obj/item/device/radio/intercom/Destroy()
	QDEL_NULL(power_interface)
	return ..()

/obj/item/device/radio/intercom/attack_ai(mob/user as mob)
	if(!ai_can_interact(user))
		return
	src.add_fingerprint(user)
	INVOKE_ASYNC(src, TYPE_PROC_REF(/obj/item, attack_self), user)

/obj/item/device/radio/intercom/attack_hand(mob/user as mob)
	src.add_fingerprint(user)
	INVOKE_ASYNC(src, TYPE_PROC_REF(/obj/item, attack_self), user)

/obj/item/device/radio/intercom/can_receive(input_frequency, list/levels)
	if(!listening)
		return FALSE

	if(levels != RADIO_NO_Z_LEVEL_RESTRICTION)
		var/turf/position = get_turf(src)
		if(!istype(position) || !(position.z in levels))
			return FALSE

	if(input_frequency in ANTAG_FREQS && !syndie)
		return FALSE//Prevents broadcast of messages over devices lacking the encryption

	return TRUE

/obj/item/device/radio/intercom/proc/power_change(has_power)
	set_on(has_power) // has_power is given by our listener machinery
	update_icon()

/obj/item/device/radio/intercom/forceMove(atom/dest)
	power_interface.forceMove(dest)
	..(dest)

/obj/item/device/radio/intercom/update_icon()
	cut_overlays()
	if(!on)
		icon_state = initial(icon_state)
		set_light(FALSE)
		return
	else
		add_overlay(screen_overlays["intercom_screen"])
		add_overlay(screen_overlays["intercom_scanline"])
		set_light(1.4, 1.3, COLOR_CYAN)
		if(broadcasting)
			add_overlay(screen_overlays["intercom_b"])
		if(listening)
			add_overlay(screen_overlays["intercom_l"])

/obj/item/device/radio/intercom/broadcasting/Initialize()
	set_broadcasting(TRUE)

/obj/item/device/radio/intercom/locked
    var/locked_frequency

/obj/item/device/radio/intercom/locked/set_frequency(var/frequency)
	if(frequency == locked_frequency)
		..(locked_frequency)

/obj/item/device/radio/intercom/locked/list_channels()
	return ""

/obj/item/device/radio/intercom/locked/ai_private
	name = "intercom (AI private)"

/obj/item/device/radio/intercom/locked/ai_private/Initialize()
	. = ..()
	set_frequency(AI_FREQ)
	set_broadcasting(TRUE)
	set_listening(TRUE)

/obj/item/device/radio/intercom/locked/confessional
	name = "intercom (confessional)"

/obj/item/device/radio/intercom/locked/confessional/Initialize()
	. = ..()
	set_frequency(1480)
