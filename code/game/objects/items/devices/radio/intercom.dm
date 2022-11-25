/obj/item/device/radio/intercom
	name = "ship intercom (General)"
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
	name = "ship intercom (Custom)"
	broadcasting = FALSE
	listening = FALSE

/obj/item/device/radio/intercom/interrogation
	name = "ship intercom (Interrogation)"
	frequency  = 1449

/obj/item/device/radio/intercom/private
	name = "ship intercom (Private)"
	frequency = AI_FREQ

/obj/item/device/radio/intercom/specops
	name = "\improper Spec Ops intercom"
	frequency = ERT_FREQ

/obj/item/device/radio/intercom/department
	canhear_range = 5
	broadcasting = FALSE
	listening = TRUE

/obj/item/device/radio/intercom/department/medbay
	name = "ship intercom (Medbay)"
	frequency = MED_I_FREQ

/obj/item/device/radio/intercom/department/security
	name = "ship intercom (Security)"
	frequency = SEC_I_FREQ

/obj/item/device/radio/intercom/entertainment
	name = "entertainment intercom"
	frequency = ENT_FREQ
	canhear_range = 4

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

/obj/item/device/radio/intercom/department/medbay/Initialize()
	. = ..()
	internal_channels = default_medbay_channels.Copy()

/obj/item/device/radio/intercom/department/security/Initialize()
	. = ..()
	internal_channels = list(
		num2text(PUB_FREQ) = list(),
		num2text(SEC_I_FREQ) = list(access_security)
	)

/obj/item/device/radio/intercom/entertainment/Initialize()
	. = ..()
	internal_channels = list(
		num2text(PUB_FREQ) = list(),
		num2text(ENT_FREQ) = list()
	)

/obj/item/device/radio/intercom/syndicate
	name = "illicit intercom"
	desc = "Talk through this. Evilly"
	frequency = SYND_FREQ
	subspace_transmission = 1
	syndie = 1

/obj/item/device/radio/intercom/syndicate/Initialize()
	. = ..()
	internal_channels[num2text(SYND_FREQ)] = list(access_syndicate)

/obj/item/device/radio/intercom/raider
	name = "illicit intercom"
	desc = "Pirate radio, but not in the usual sense of the word."
	frequency = RAID_FREQ
	subspace_transmission = 1
	syndie = 1

/obj/item/device/radio/intercom/syndicate/Initialize()
	. = ..()
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

/obj/item/device/radio/intercom/receive_range(freq, level)
	if (!on)
		return -1
	if(!(0 in level))
		var/turf/position = get_turf(src)
		if(isnull(position) || !(position.z in level))
			return -1
	if (!src.listening)
		return -1
	if(freq in ANTAG_FREQS)
		if(!(src.syndie))
			return -1//Prevents broadcast of messages over devices lacking the encryption

	return canhear_range

/obj/item/device/radio/intercom/proc/power_change(has_power)
	if (!src.loc)
		on = 0
	else
		on = has_power

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

/obj/item/device/radio/intercom/broadcasting
	broadcasting = TRUE

/obj/item/device/radio/intercom/locked
    var/locked_frequency

/obj/item/device/radio/intercom/locked/set_frequency(var/frequency)
	if(frequency == locked_frequency)
		..(locked_frequency)

/obj/item/device/radio/intercom/locked/list_channels()
	return ""

/obj/item/device/radio/intercom/locked/ai_private
	name = "\improper AI intercom"
	frequency = AI_FREQ
	broadcasting = TRUE
	listening = TRUE

/obj/item/device/radio/intercom/locked/confessional
	name = "confessional intercom"
	frequency = 1480
