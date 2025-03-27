#define PRESET_NORTH \
dir = NORTH; \
pixel_y = 20;

#define PRESET_SOUTH \
dir = SOUTH; \
pixel_y = -6;

#define PRESET_WEST \
dir = WEST; \
pixel_x = -8;

#define PRESET_EAST \
dir = EAST; \
pixel_x = 8;


/obj/item/device/radio/intercom
	name = "intercom (general)"
	desc = "An intercom with buttons for transmitting, receiving, and for volume control."
	desc_extended = "Has a touch display for inputting a frequency, with proper authentication. Used to communicate when you have lost your radio. \
		Otherwise, you would likely just use a handheld shortwave radio instead."
	icon = 'icons/obj/machinery/wall/terminals.dmi'
	icon_state = "intercom"
	layer = ABOVE_WINDOW_LAYER
	anchored = TRUE
	appearance_flags = TILE_BOUND // prevents people from viewing the overlay through a wall
	w_class = WEIGHT_CLASS_BULKY
	canhear_range = 2
	atom_flags = ATOM_FLAG_NO_BLOOD
	obj_flags = OBJ_FLAG_MOVES_UNSUPPORTED | OBJ_FLAG_CONDUCTABLE
	z_flags = ZMM_MANGLE_PLANES
	var/number = 0
	var/obj/machinery/abstract/intercom_listener/power_interface
	var/radio_sound = null
	clickvol = 40

/obj/item/device/radio/intercom/north
	PRESET_NORTH

/obj/item/device/radio/intercom/south
	PRESET_SOUTH

/obj/item/device/radio/intercom/west
	PRESET_WEST

/obj/item/device/radio/intercom/east
	PRESET_EAST

/obj/item/device/radio/intercom/ship
	channels = list()
	var/default_hailing = FALSE

/obj/item/device/radio/intercom/ship/north
	PRESET_NORTH

/obj/item/device/radio/intercom/ship/south
	PRESET_SOUTH

/obj/item/device/radio/intercom/ship/west
	PRESET_WEST

/obj/item/device/radio/intercom/ship/east
	PRESET_EAST

/obj/item/device/radio/intercom/ship/Initialize()
	if(!SSatlas.current_map.use_overmap)
		return ..()

	var/turf/T = get_turf(src)
	var/obj/effect/overmap/visitable/V = GLOB.map_sectors["[T.z]"]
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

/obj/item/device/radio/intercom/ship/north
	PRESET_NORTH

/obj/item/device/radio/intercom/ship/south
	PRESET_SOUTH

/obj/item/device/radio/intercom/ship/west
	PRESET_WEST

/obj/item/device/radio/intercom/ship/east
	PRESET_EAST


/obj/item/device/radio/intercom/custom
	name = "intercom (custom)"

/obj/item/device/radio/intercom/custom/north
	PRESET_NORTH

/obj/item/device/radio/intercom/custom/south
	PRESET_SOUTH

/obj/item/device/radio/intercom/custom/west
	PRESET_WEST

/obj/item/device/radio/intercom/custom/east
	PRESET_EAST

/obj/item/device/radio/intercom/custom/Initialize()
	. = ..()
	set_broadcasting(FALSE)
	set_listening(FALSE)

/obj/item/device/radio/intercom/hailing
	name = "intercom (hailing)"

/obj/item/device/radio/intercom/hailing/north
	PRESET_NORTH

/obj/item/device/radio/intercom/hailing/south
	PRESET_SOUTH

/obj/item/device/radio/intercom/hailing/west
	PRESET_WEST

/obj/item/device/radio/intercom/hailing/east
	PRESET_EAST

/obj/item/device/radio/intercom/hailing/Initialize()
	. = ..()
	set_frequency(HAIL_FREQ)

/obj/item/device/radio/intercom/interrogation
	name = "intercom (interrogation)"

/obj/item/device/radio/intercom/interrogation/north
	PRESET_NORTH

/obj/item/device/radio/intercom/interrogation/south
	PRESET_SOUTH

/obj/item/device/radio/intercom/interrogation/west
	PRESET_WEST

/obj/item/device/radio/intercom/interrogation/east
	PRESET_EAST

/obj/item/device/radio/intercom/interrogation/Initialize()
	. = ..()
	set_frequency(INT_FREQ)
	internal_channels = default_interrogation_channels

/obj/item/device/radio/intercom/interrogation/broadcasting/north
	PRESET_NORTH

/obj/item/device/radio/intercom/interrogation/broadcasting/south
	PRESET_SOUTH

/obj/item/device/radio/intercom/interrogation/broadcasting/west
	PRESET_WEST

/obj/item/device/radio/intercom/interrogation/broadcasting/east
	PRESET_EAST

/obj/item/device/radio/intercom/interrogation/broadcasting/Initialize() // The detainee's side.
	. = ..()
	set_broadcasting(TRUE)
	set_listening(FALSE)

/obj/item/device/radio/intercom/expedition
	name = "intercom (expeditionary)"

/obj/item/device/radio/intercom/expedition/north
	PRESET_NORTH

/obj/item/device/radio/intercom/expedition/south
	PRESET_SOUTH

/obj/item/device/radio/intercom/expedition/west
	PRESET_WEST

/obj/item/device/radio/intercom/expedition/east
	PRESET_EAST

/obj/item/device/radio/intercom/expedition/Initialize()
	. = ..()
	set_frequency(EXP_FREQ)
	internal_channels = default_expedition_channels

/obj/item/device/radio/intercom/expedition/hailing/north
	PRESET_NORTH

/obj/item/device/radio/intercom/expedition/hailing/south
	PRESET_SOUTH

/obj/item/device/radio/intercom/expedition/hailing/west
	PRESET_WEST

/obj/item/device/radio/intercom/expedition/hailing/east
	PRESET_EAST

/obj/item/device/radio/intercom/expedition/hailing/Initialize()
	. = ..()
	set_frequency(HAIL_FREQ)
	internal_channels = default_expedition_channels

/obj/item/device/radio/intercom/private
	name = "intercom (private)"

/obj/item/device/radio/intercom/private/north
	PRESET_NORTH

/obj/item/device/radio/intercom/private/south
	PRESET_SOUTH

/obj/item/device/radio/intercom/private/west
	PRESET_WEST

/obj/item/device/radio/intercom/private/east
	PRESET_EAST

/obj/item/device/radio/intercom/private/Initialize()
	. = ..()
	set_frequency(AI_FREQ)

/obj/item/device/radio/intercom/specops
	name = "intercom (spec ops)"

/obj/item/device/radio/intercom/specops/north
	PRESET_NORTH

/obj/item/device/radio/intercom/specops/south
	PRESET_SOUTH

/obj/item/device/radio/intercom/specops/west
	PRESET_WEST

/obj/item/device/radio/intercom/specops/east
	PRESET_EAST

/obj/item/device/radio/intercom/specops/Initialize()
	. = ..()
	set_frequency(ERT_FREQ)

/obj/item/device/radio/intercom/department
	canhear_range = 5

/obj/item/device/radio/intercom/department/north
	PRESET_NORTH

/obj/item/device/radio/intercom/department/south
	PRESET_SOUTH

/obj/item/device/radio/intercom/department/west
	PRESET_WEST

/obj/item/device/radio/intercom/department/east
	PRESET_EAST

/obj/item/device/radio/intercom/department/Initialize()
	. = ..()
	set_broadcasting(FALSE)
	set_listening(TRUE)

/obj/item/device/radio/intercom/department/medbay
	name = "intercom (medical)"

/obj/item/device/radio/intercom/department/medbay/north
	PRESET_NORTH

/obj/item/device/radio/intercom/department/medbay/south
	PRESET_SOUTH

/obj/item/device/radio/intercom/department/medbay/west
	PRESET_WEST

/obj/item/device/radio/intercom/department/medbay/east
	PRESET_EAST

/obj/item/device/radio/intercom/department/medbay/Initialize()
	. = ..()
	set_frequency(MED_I_FREQ)
	internal_channels = default_medbay_channels.Copy()

/obj/item/device/radio/intercom/department/security
	name = "intercom (security)"

/obj/item/device/radio/intercom/department/security/north
	PRESET_NORTH

/obj/item/device/radio/intercom/department/security/south
	PRESET_SOUTH

/obj/item/device/radio/intercom/department/security/west
	PRESET_WEST

/obj/item/device/radio/intercom/department/security/east
	PRESET_EAST

/obj/item/device/radio/intercom/department/security/Initialize()
	. = ..()
	set_frequency(SEC_I_FREQ)
	internal_channels = list(
		num2text(PUB_FREQ) = list(),
		num2text(SEC_I_FREQ) = list(ACCESS_SECURITY)
	)

/obj/item/device/radio/intercom/entertainment
	name = "intercom (entertainment)"
	canhear_range = 4

/obj/item/device/radio/intercom/entertainment/north
	PRESET_NORTH

/obj/item/device/radio/intercom/entertainment/south
	PRESET_SOUTH

/obj/item/device/radio/intercom/entertainment/west
	PRESET_WEST

/obj/item/device/radio/intercom/entertainment/east
	PRESET_EAST

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
	update_icon()

/obj/item/device/radio/intercom/syndicate
	name = "illegally modified intercom"
	desc = "Talk through this. Evilly."
	subspace_transmission = TRUE
	syndie = TRUE

/obj/item/device/radio/intercom/syndicate/north
	PRESET_NORTH

/obj/item/device/radio/intercom/syndicate/south
	PRESET_SOUTH

/obj/item/device/radio/intercom/syndicate/west
	PRESET_WEST

/obj/item/device/radio/intercom/syndicate/east
	PRESET_EAST

/obj/item/device/radio/intercom/syndicate/Initialize()
	. = ..()
	set_frequency(SYND_FREQ)
	internal_channels[num2text(SYND_FREQ)] = list(ACCESS_SYNDICATE)

/obj/item/device/radio/intercom/raider
	name = "illegally modified intercom"
	desc = "Pirate radio, but not in the usual sense of the word."
	subspace_transmission = TRUE
	syndie = TRUE

/obj/item/device/radio/intercom/raider/north
	PRESET_NORTH

/obj/item/device/radio/intercom/raider/south
	PRESET_SOUTH

/obj/item/device/radio/intercom/raider/west
	PRESET_WEST

/obj/item/device/radio/intercom/raider/east
	PRESET_EAST

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

	if((input_frequency in ANTAG_FREQS) && !syndie)
		return FALSE//Prevents broadcast of messages over devices lacking the encryption

	return TRUE

/obj/item/device/radio/intercom/proc/power_change(has_power)
	set_on(has_power) // has_power is given by our listener machinery
	update_icon()

/obj/item/device/radio/intercom/forceMove(atom/destination)
	power_interface.forceMove(destination)
	. = ..()

/obj/item/device/radio/intercom/update_icon()
	ClearOverlays()
	var/mutable_appearance/screen = overlay_image(icon, "intercom_screen")
	var/mutable_appearance/screen_hologram = overlay_image(icon, "intercom_screen")
	var/mutable_appearance/screen_emis = emissive_appearance(icon, "intercom_screen")
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
	if(!on)
		icon_state = initial(icon_state)
		set_light(FALSE)
		return
	else
		AddOverlays(screen_hologram)
		AddOverlays(screen)
		AddOverlays(screen_emis)
		AddOverlays("intercom_scanline")
		set_light(1.4, 1.3, COLOR_CYAN)
		if(broadcasting)
			var/mutable_appearance/screen_broadcasting = overlay_image(icon, "intercom_b")
			var/mutable_appearance/screen_broadcasting_hologram = overlay_image(icon, "intercom_b")
			screen_broadcasting_hologram.filters += filter(type="color", color=list(
			0, 0, 0, 0,
			0, 0, 0, 0,
			0, 0, 0, 0,
			HOLOSCREEN_MULTIPLICATION_FACTOR, HOLOSCREEN_MULTIPLICATION_FACTOR, HOLOSCREEN_MULTIPLICATION_FACTOR, HOLOSCREEN_MULTIPLICATION_OPACITY
			))
			screen_broadcasting.filters += filter(type="color", color=list(
				HOLOSCREEN_ADDITION_OPACITY, 0, 0, 0,
				0, HOLOSCREEN_ADDITION_OPACITY, 0, 0,
				0, 0, HOLOSCREEN_ADDITION_OPACITY, 0,
				0, 0, 0, 1
			))
			screen_broadcasting_hologram.blend_mode = BLEND_MULTIPLY
			screen_broadcasting.blend_mode = BLEND_ADD
			AddOverlays(list(screen_broadcasting_hologram, screen_broadcasting))
		if(listening)
			var/mutable_appearance/screen_listening = overlay_image(icon, "intercom_l")
			var/mutable_appearance/screen_listening_hologram = overlay_image(icon, "intercom_l")
			screen_listening_hologram.filters += filter(type="color", color=list(
			0, 0, 0, 0,
			0, 0, 0, 0,
			0, 0, 0, 0,
			HOLOSCREEN_MULTIPLICATION_FACTOR, HOLOSCREEN_MULTIPLICATION_FACTOR, HOLOSCREEN_MULTIPLICATION_FACTOR, HOLOSCREEN_MULTIPLICATION_OPACITY
			))
			screen_listening.filters += filter(type="color", color=list(
				HOLOSCREEN_ADDITION_OPACITY, 0, 0, 0,
				0, HOLOSCREEN_ADDITION_OPACITY, 0, 0,
				0, 0, HOLOSCREEN_ADDITION_OPACITY, 0,
				0, 0, 0, 1
			))
			screen_listening_hologram.blend_mode = BLEND_MULTIPLY
			screen_listening.blend_mode = BLEND_ADD
			AddOverlays(list(screen_listening_hologram, screen_listening))

/obj/item/device/radio/intercom/broadcasting/Initialize()
	SHOULD_CALL_PARENT(FALSE)

	if(flags_1 & INITIALIZED_1)
		stack_trace("Warning: [src]([type]) initialized multiple times!")
	flags_1 |= INITIALIZED_1

	set_broadcasting(TRUE)

	return INITIALIZE_HINT_NORMAL

/obj/item/device/radio/intercom/locked
	var/locked_frequency

/obj/item/device/radio/intercom/locked/north
	PRESET_NORTH

/obj/item/device/radio/intercom/locked/south
	PRESET_SOUTH

/obj/item/device/radio/intercom/locked/west
	PRESET_WEST

/obj/item/device/radio/intercom/locked/east
	PRESET_EAST

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

#undef PRESET_NORTH
#undef PRESET_SOUTH
#undef PRESET_WEST
#undef PRESET_EAST
