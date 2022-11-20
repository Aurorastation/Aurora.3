/obj/item/device/radio/intercom
	name = "station intercom (General)"
	desc = "Talk through this."
	icon_state = "intercom"
	layer = 2.99
	anchored = TRUE
	appearance_flags = TILE_BOUND // prevents people from viewing the overlay through a wall
	w_class = ITEMSIZE_LARGE
	canhear_range = 2
	flags = CONDUCT | NOBLOODY
	var/number = 0
	var/obj/machinery/abstract/intercom_listener/power_interface
	var/global/list/screen_overlays
	var/radio_sound = null
	clickvol = 40

/obj/item/device/radio/intercom/custom
	name = "station intercom (Custom)"

/obj/item/device/radio/intercom/custom/Initialize()
	. = ..()
	set_broadcasting(FALSE)
	set_listening(FALSE)

/obj/item/device/radio/intercom/interrogation
	name = "station intercom (Interrogation)"

/obj/item/device/radio/intercom/interrogation/Initialize()
	. = ..()
	set_frequency(1449)

/obj/item/device/radio/intercom/private
	name = "station intercom (Private)"

/obj/item/device/radio/intercom/private/Initialize()
	. = ..()
	set_frequency(AI_FREQ)

/obj/item/device/radio/intercom/specops
	name = "\improper Spec Ops intercom"

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
	name = "station intercom (Medbay)"

/obj/item/device/radio/intercom/department/medbay/Initialize()
	. = ..()
	set_frequency(MED_I_FREQ)
	internal_channels = default_medbay_channels.Copy()

/obj/item/device/radio/intercom/department/security
	name = "station intercom (Security)"

/obj/item/device/radio/intercom/department/security/Initialize()
	. = ..()
	set_frequency(SEC_I_FREQ)
	internal_channels = list(
		num2text(PUB_FREQ) = list(),
		num2text(SEC_I_FREQ) = list(access_security)
	)

/obj/item/device/radio/intercom/entertainment
	name = "entertainment intercom"
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
	name = "illicit intercom"
	desc = "Talk through this. Evilly"
	subspace_transmission = TRUE
	syndie = TRUE

/obj/item/device/radio/intercom/syndicate/Initialize()
	. = ..()
	set_frequency(SYND_FREQ)
	internal_channels[num2text(SYND_FREQ)] = list(access_syndicate)

/obj/item/device/radio/intercom/raider
	name = "illicit intercom"
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
	INVOKE_ASYNC(src, /obj/item/.proc/attack_self, user)

/obj/item/device/radio/intercom/attack_hand(mob/user as mob)
	src.add_fingerprint(user)
	INVOKE_ASYNC(src, /obj/item/.proc/attack_self, user)

/obj/item/device/radio/intercom/can_receive(input_frequency, list/levels)
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
	name = "\improper AI intercom"

/obj/item/device/radio/intercom/locked/ai_private/Initialize()
	. = ..()
	set_frequency(AI_FREQ)
	set_broadcasting(TRUE)
	set_listening(TRUE)

/obj/item/device/radio/intercom/locked/confessional
	name = "confessional intercom"

/obj/item/device/radio/intercom/locked/confessional/Initialize()
	. = ..()
	set_frequency(1480)
