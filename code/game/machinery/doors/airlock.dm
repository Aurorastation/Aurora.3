#define AIRLOCK_CRUSH_DIVISOR 8 // Damage caused by airlock crushing a mob is split into multiple smaller hits. Prevents things like cut off limbs, etc, while still having quite dangerous injury.
#define CYBORG_AIRLOCKCRUSH_RESISTANCE 4 // Damage caused to silicon mobs (usually cyborgs) from being crushed by airlocks is divided by this number. Unlike organics cyborgs don't have passive regeneration, so even one hit can be devastating for them.

#define BOLTS_FINE 0
#define BOLTS_EXPOSED 1
#define BOLTS_CUT 2

#define AIRLOCK_CLOSED	1
#define AIRLOCK_CLOSING	2
#define AIRLOCK_OPEN	3
#define AIRLOCK_OPENING	4
#define AIRLOCK_DENY	5
#define AIRLOCK_EMAG	6

/// The main airlock body is paintable.
#define AIRLOCK_PAINTABLE_MAIN 1
/// The stripe decal is paintable.
#define AIRLOCK_PAINTABLE_STRIPE 2
/// Other detailing is paintable.
#define AIRLOCK_PAINTABLE_DETAIL 4
/// The window is paintable.
#define AIRLOCK_PAINTABLE_WINDOW 8

/obj/machinery/door/airlock
	name = "airlock"
	icon = 'icons/obj/doors/basic/single/generic/door.dmi'
	icon_state = "preview"
	power_channel = ENVIRON

	explosion_resistance = 10
	autoclose = TRUE
	normalspeed = TRUE
	pixel_x = -16
	pixel_y = -16
	/// Boolean. Whether or not the AI control mechanism is disabled.
	var/ai_control_disabled = FALSE
	/// Boolean. If set, the door cannot by hacked or bypassed by the AI.
	var/hack_proof = FALSE
	/// Integer. World time when the door is no longer electrified. -1 if it is permanently electrified until someone fixes it.
	var/electrified_until = 0
	/// Integer. World time when the door was electrified.
	var/electrified_at = 0
	/// Integer. World time when main power is restored.
	var/main_power_lost_until = 0
	/// Integer. World time when main power was lost.
	var/main_power_lost_at = 0
	/// Integer. World time when backup power is restored. -1 if not using backup power or disabled.
	var/backup_power_lost_until = -1
	/// Integer. World time when backup power was lost.
	var/backup_power_lost_at = 0
	/// Integer. World time when we may next beep due to doors being blocked by mobs. Spam prevention.
	var/next_beep_at = 0
	/// Boolean. Whether or not the door is welded shut.
	var/welded = FALSE
	/// Boolean. Whether or not the door is locked/bolted.
	var/locked = FALSE
	/// Integer (One of `BOLTS_*`). The door's current lock/bolt cutting state.
	var/bolt_cut_state = BOLTS_FINE
	/// Boolean. Whether or not the airlock's lights are enabled. Tied to the bolt light wire.
	var/lights = TRUE
	/// Path. The assembly structure used to create this door. Used during disassembly steps.
	var/assembly_type = /obj/structure/door_assembly/door_assembly_generic
	/// Boolean. Whether or not the ID scanner is enabled. Tied to the ID scan wire.
	var/ai_disabled_id_scanner = FALSE
	/// Boolean. Whether or not the AI is currently hacking the door.
	var/ai_hacking = FALSE
	/// Boolean. Whether or not the AI can bolt the door.
	var/ai_bolting = TRUE
	/// Integer. How long it takes AIs to drop bolts (in seconds).
	var/ai_bolting_delay = 8
	/// Integer. How long it takes AIs to raise bolts (in seconds).
	var/ai_unbolt_delay = 4
	/// Timer object. Makes it so that the AI can only do one thing.
	var/ai_action_timer = null
	/// The connected door to close.
	var/obj/machinery/door/airlock/close_other
	/// The ID of the connected door to close.
	var/close_other_id
	/// String (One of `MATERIAL_*`). The material the door is made from. If not set, defaults to steel.
	var/mineral
	/// Boolean. Whether or not the door's safeties are enabled. Tied to the safety wire.
	var/safe = TRUE
	/// Airlock electronics.
	var/obj/item/airlock_electronics/electronics
	/// Boolean. Whether or not the door has just electrocuted someone.
	var/has_shocked = FALSE
	/// Boolean. Whether or not the door has secure wiring that scrambles the wire panel.
	var/secured_wires = FALSE
	/// Wires datum.
	var/datum/wires/airlock/wires
	/// Any active brace.
	var/obj/item/device/magnetic_lock/bracer
	/// If the panel is visible when open.
	var/panel_visible_while_open = FALSE

	/// Soundfile. The sound played when opening the door while powered.
	var/open_sound_powered = 'sound/machines/airlock/covert1o.ogg'
	/// Soundfile. The sound played when opening the door while unpowered.
	var/open_sound_unpowered = 'sound/machines/airlock_open_force.ogg'
	/// Soundfile. The sound played when the door refuses to open due to access.
	var/open_failure_access_denied = 'sound/machines/buzz-two.ogg'
	/// Soundfile. The sound played when the door closes while powered.
	var/close_sound_powered = 'sound/machines/airlock/covert1c.ogg'
	/// Soundfile. The sound played when the door closes while unpowered.
	var/close_sound_unpowered = 'sound/machines/airlock_close_force.ogg'
	/// Soundfile. The sound played when the door cannot close because it's blocked.
	var/close_failure_blocked = 'sound/machines/triple_beep.ogg'
	/// Soundfile. The sound played when the door is unlocked/unbolted.
	var/bolts_rising = 'sound/machines/boltsup.ogg'
	/// Soundfile. The sound played when the door is locked/bolted.
	var/bolts_dropping = 'sound/machines/boltsdown.ogg'

	var/frame_color_file = 'icons/obj/doors/basic/single/generic/frame_color.dmi'

	var/color_file = 'icons/obj/doors/basic/single/generic/color.dmi'
	var/color_fill_file = 'icons/obj/doors/basic/single/generic/fill_color.dmi'

	var/stripe_file = 'icons/obj/doors/basic/single/generic/stripe.dmi'
	var/stripe_fill_file = 'icons/obj/doors/basic/single/generic/fill_stripe.dmi'

	var/glass_file = 'icons/obj/doors/basic/single/generic/fill_glass.dmi'
	var/fill_file = 'icons/obj/doors/basic/single/generic/fill_steel.dmi'

	var/bolts_file = 'icons/obj/doors/basic/single/generic/lights_bolts.dmi'
	var/deny_file = 'icons/obj/doors/basic/single/generic/lights_deny.dmi'
	var/lights_file = 'icons/obj/doors/basic/single/generic/lights_green.dmi'
	var/panel_file = 'icons/obj/doors/basic/single/generic/panel.dmi'
	var/sparks_damaged_file = 'icons/obj/doors/basic/single/generic/sparks_damaged.dmi'
	var/sparks_broken_file = 'icons/obj/doors/basic/single/generic/sparks_broken.dmi'
	var/welded_file = 'icons/obj/doors/basic/single/generic/welded.dmi'
	var/emag_file = 'icons/obj/doors/basic/single/generic/emag.dmi'

	//Airlock 2.0 Aesthetics Properties
	//The variables below determine what color the airlock and decorative stripes will be -Cakey
	/// String. Partial icon state for generating the airlock appearance overlay.
	var/airlock_type = "Standard"
	/// Bitflag (Any of `AIRLOCK_PAINTABLE_*`). Determines what parts of the airlock can be recolored with paint.
	var/paintable = AIRLOCK_PAINTABLE_MAIN | AIRLOCK_PAINTABLE_STRIPE
	/// Color. The color of the main door body.
	var/door_color = "#909299"
	/// Frame color. The color of the door frame connecting it to walls if applicable.
	var/door_frame_color = COLOR_GRAY20
	/// Color. The color of the stripe detail.
	var/stripe_color = null
	/// Color. The color of the symbol detail.
	var/symbol_color = null
	/// Color. The color of the window.
	var/window_color = null
	/// String (One of `MATERIAL_*`). The material used for the door's window if `glass` is set. Used to set `window_material` during init.
	var/init_material_window = MATERIAL_GLASS
	/// The material of the door's window.
	var/material/window_material

	hashatch = TRUE

	var/_wifi_id
	var/datum/wifi/receiver/button/door/wifi_receiver
	var/has_set_boltlight = FALSE

	/// Boolean. If TRUE, the door will open when power runs out.
	var/insecure = TRUE
	var/securitylock = FALSE

	/// Override access by code level. This is an associative list that should only be set through /obj/effect/map_effect/door_helper/level_access.
	/// Structure example: "red" -> list(1, 2)
	/// Uses standard access if the current level is not on the list.
	var/list/access_by_level
	/// As above, but with req_one_access. Note that only one of these lists should ever be set.
	var/list/req_one_access_by_level

/obj/machinery/door/airlock/Initialize(mapload, dir, populate_components, obj/structure/door_assembly/assembly = null)
	var/on_admin_z = FALSE
	//wires & hatch - this needs to be done up here so the hatch isn't generated by the parent Initialize().
	if(loc && isAdminLevel(z))
		on_admin_z = TRUE
		hashatch = FALSE

	. = ..()

	//if assembly is given, create the new door from the assembly
	if (istype(assembly))
		assembly_type = assembly.type

		electronics = assembly.electronics
		electronics.forceMove(src)

		//update the door's access to match the electronics'
		secured_wires = electronics.secure
		if(electronics.one_access)
			req_access = null
			req_one_access = electronics.conf_access
		else
			req_one_access = null
			req_access = electronics.conf_access

		//get the name from the assembly
		if(assembly.created_name)
			name = assembly.created_name
		else
			name = "[istext(assembly.glass) ? "[assembly.glass] airlock" : assembly.base_name]"

		//get the dir from the assembly
		set_dir(assembly.dir)

		unres_dir = electronics.unres_dir

	if (on_admin_z)
		secured_wires = TRUE

	if (secured_wires)
		wires = new/datum/wires/airlock/secure(src)
	else
		wires = new/datum/wires/airlock(src)

	if(mapload && src.close_other_id != null)
		for (var/obj/machinery/door/airlock/A in SSmachinery.machinery)
			if(A.close_other_id == src.close_other_id && A != src)
				src.close_other = A
				break

	if (glass)
		paintable |= AIRLOCK_PAINTABLE_WINDOW
		window_material = SSmaterials.get_material_by_name(init_material_window)
		opacity = FALSE
	update_icon()

/obj/machinery/door/airlock/Destroy()
	QDEL_NULL(wires)
	QDEL_NULL(wifi_receiver)
	return ..()

/obj/machinery/door/airlock/Click(location, control, params)
	if(ishuman(usr))
		var/mob/living/carbon/human/H = usr
		var/list/modifiers = params2list(params)
		var/obj/item/device/paint_sprayer/paint_sprayer = H.get_active_hand()
		if(istype(paint_sprayer))
			if(!istype(H.buckled_to))
				H.face_atom(src)
			if(modifiers["ctrl"] && paint_sprayer.pick_color(src, H))
				return
			if(modifiers["shift"] && paint_sprayer.remove_paint(src, H))
				return
	. = ..()

/obj/machinery/door/airlock/attack_generic(var/mob/user, var/damage)
	if(stat & (BROKEN|NOPOWER))
		if(damage >= 10)
			if(src.density)
				visible_message(SPAN_DANGER("\The [user] forces \the [src] open!"))
				open(1)
			else
				visible_message(SPAN_DANGER("\The [user] forces \the [src] closed!"))
				close(1)
		else
			visible_message(SPAN_NOTICE("\The [user] strains fruitlessly to force \the [src] [density ? "open" : "closed"]."))
		return
	..()

/obj/machinery/door/airlock/get_material()
	if(mineral)
		return SSmaterials.get_material_by_name(mineral)
	return SSmaterials.get_material_by_name(DEFAULT_WALL_MATERIAL)

/obj/machinery/door/airlock/external//External airlocks start here
	name = "external airlock"
	icon = 'icons/obj/doors/basic/single/external/door.dmi'
	icon_state = "preview"
	assembly_type = /obj/structure/door_assembly/door_assembly_ext
	paintable = AIRLOCK_PAINTABLE_MAIN
	door_frame_color = "#81838b"//Meant to connect to external scc spaceship walls like the horizon hull
	door_color = "#813c3c"
	hashatch = FALSE
	insecure = 0
	fill_file = 'icons/obj/doors/basic/single/external/fill_steel.dmi'
	color_file = 'icons/obj/doors/basic/single/external/color.dmi'
	color_fill_file = 'icons/obj/doors/basic/single/external/fill_color.dmi'

/obj/machinery/door/airlock/external/khaki
	door_frame_color = "#ac8b78"

/obj/machinery/door/airlock/external/merc
	door_frame_color = "#8b7d86"

/obj/machinery/door/airlock/external/red
	door_frame_color = "#c24f4f"

/obj/machinery/door/airlock/external/blue
	door_frame_color = "#6176a1"

/obj/machinery/door/airlock/external/purple
	door_frame_color = "#7846b1"

/obj/machinery/door/airlock/glass
	name = "glass airlock"
	icon_state = "preview_glass"
	glass = 1
	hitsound = 'sound/effects/glass_hit.ogg'
	maxhealth = 300
	explosion_resistance = 5
	opacity = FALSE
	panel_visible_while_open = TRUE
	door_color = COLOR_GRAY20
	door_frame_color = COLOR_GRAY20
	open_sound_powered = 'sound/machines/airlock/hall3o.ogg'
	close_sound_powered = 'sound/machines/airlock/hall3c.ogg'

/obj/machinery/door/airlock/service // Service Airlock
	icon_state = "ser"
	paintable = AIRLOCK_PAINTABLE_MAIN
	door_color = "#6f8751"

/obj/machinery/door/airlock/glass_service // Service Airlock (Glass)
	icon_state = "ser_glass"
	paintable = AIRLOCK_PAINTABLE_MAIN
	door_color = "#6f8751"
	glass = 1

/obj/machinery/door/airlock/command
	icon_state = "cmd"
	door_color = "#353c4b"

/obj/machinery/door/airlock/command/gold
	icon_state = "cmdgold"
	paintable = AIRLOCK_PAINTABLE_MAIN | AIRLOCK_PAINTABLE_STRIPE
	door_color = "#475057"
	stripe_color = "#ffc443"

/obj/machinery/door/airlock/security
	icon_state = "sec"
	paintable = AIRLOCK_PAINTABLE_MAIN | AIRLOCK_PAINTABLE_STRIPE
	door_color = "#2b4b68"
	stripe_color = "#ff4343"

/obj/machinery/door/airlock/security/gold
	icon_state = "sec"
	paintable = AIRLOCK_PAINTABLE_MAIN | AIRLOCK_PAINTABLE_STRIPE
	door_color = "#2b4b68"
	stripe_color = "#ffc443"

/obj/machinery/door/airlock/engineering
	icon_state = "eng"
	paintable = AIRLOCK_PAINTABLE_MAIN | AIRLOCK_PAINTABLE_STRIPE
	door_color = "#caa638"
	stripe_color = "#ff7f43"

/obj/machinery/door/airlock/medical
	door_color = "#A7A9A0"
	stripe_color = "#345731"

/obj/machinery/door/airlock/maintenance
	name = "maintenance access"
	icon_state = "maintenance"
	assembly_type = /obj/structure/door_assembly/door_assembly_mai
	paintable = AIRLOCK_PAINTABLE_MAIN | AIRLOCK_PAINTABLE_STRIPE
	door_color = "#4d4d4d"
	stripe_color = "#a88029"

/obj/machinery/door/airlock/generic/maintenance/external//for connecting to the horizons hull, duh
	door_frame_color = "#81838b"//Meant to connect to external scc spaceship walls like the horizon hull

/obj/machinery/door/airlock/external
	name = "external airlock"
	icon = 'icons/obj/doors/basic/single/external/door.dmi'
	assembly_type = /obj/structure/door_assembly/door_assembly_ext
	hashatch = FALSE
	insecure = 0
	ai_control_disabled = 1
	hack_proof = TRUE
	open_sound_powered = 'sound/machines/airlock/space1o.ogg'
	close_sound_powered = 'sound/machines/airlock/space1c.ogg'

/obj/machinery/door/airlock/glass_science
	name = "glass airlock"
	icon_state = "sci_glass"
	door_color = "#A18A9C"
	opacity = FALSE
	glass = 1
	open_sound_powered = 'sound/machines/airlock/hall3o.ogg'
	close_sound_powered = 'sound/machines/airlock/hall3c.ogg'

/obj/machinery/door/airlock/centcom
	opacity = TRUE
	hashatch = FALSE
	hack_proof = TRUE
	open_sound_powered = 'sound/machines/airlock/vault1o.ogg'
	close_sound_powered = 'sound/machines/airlock/vault1c.ogg'

/obj/machinery/door/airlock/centcom/attackby(obj/item/attacking_item, mob/user)
	if (operating)
		return TRUE

	if (allowed(user) && operable())
		if (density)
			open()
		else
			close()
	else
		do_animate("deny")
	return TRUE

/obj/machinery/door/airlock/centcom/attack_ai(mob/user)
	if(!ai_can_interact(user))
		return
	return attackby(null, user)

/obj/machinery/door/airlock/centcom/take_damage()
	return	// No.

/obj/machinery/door/airlock/centcom/emag_act()
	return NO_EMAG_ACT

/obj/machinery/door/airlock/centcom/ex_act()
	return

/obj/machinery/door/airlock/centcom/emp_act()
	. = ..()

	return

/obj/machinery/door/airlock/glass_centcom
	opacity = FALSE
	glass = 1
	hashatch = FALSE
	hack_proof = TRUE
	open_sound_powered = 'sound/machines/airlock/vault1o.ogg'
	close_sound_powered = 'sound/machines/airlock/vault1c.ogg'

/obj/machinery/door/airlock/glass_centcom/attackby(obj/item/attacking_item, mob/user)
	if (operating)
		return TRUE

	if (allowed(user) && operable())
		if (density)
			open()
		else
			close()
	else
		do_animate("deny")
	return TRUE

/obj/machinery/door/airlock/glass_centcom/attack_ai(mob/user)
	if(!ai_can_interact(user))
		return
	return attackby(null, user)

/obj/machinery/door/airlock/glass_centcom/take_damage()
	return	// No.

/obj/machinery/door/airlock/glass_centcom/emag_act()
	return NO_EMAG_ACT

/obj/machinery/door/airlock/glass_centcom/ex_act()
	return

/obj/machinery/door/airlock/glass_centcom/emp_act()
	. = ..()

	return

/obj/machinery/door/airlock/proc/paint_airlock(paint_color)
	door_color = paint_color
	update_icon()

/obj/machinery/door/airlock/proc/stripe_airlock(paint_color)
	stripe_color = paint_color
	update_icon()

/obj/machinery/door/airlock/proc/paint_window(paint_color)
	if (paint_color)
		window_color = paint_color
	else
		window_color = GLASS_COLOR
	update_icon()

/obj/machinery/door/airlock/vault
	name = "vault airlock"
	airlock_type = "Vault"
	icon = 'icons/obj/doors/basic/single/secure/door.dmi'
	color_file = 'icons/obj/doors/basic/single/secure/color.dmi'
	color_fill_file = 'icons/obj/doors/basic/single/secure/fill_color.dmi'
	icon_state = "preview"
	door_color = COLOR_GRAY40
	explosion_resistance = 20
	secured_wires = TRUE
	maxhealth = 600
	insecure = 0
	ai_bolting_delay = 10
	ai_unbolt_delay = 5
	open_sound_powered = 'sound/machines/airlock/secure1o.ogg'
	close_sound_powered = 'sound/machines/airlock/secure1c.ogg'

/obj/machinery/door/airlock/vault/bolted
	locked = TRUE

/obj/machinery/door/airlock/freezer
	name = "freezer airlock"
	door_color = "#b9b8b6"
	desc = "An extra thick, double-insulated door to preserve the cold atmosphere. Keep closed at all times."
	maxhealth = 800
	opacity = TRUE
	paintable = AIRLOCK_PAINTABLE_MAIN
	open_duration = 20

/obj/machinery/door/airlock/hatch
	name = "airtight hatch"
	airlock_type = "Hatch"
	explosion_resistance = 20
	opacity = TRUE
	paintable = AIRLOCK_PAINTABLE_MAIN | AIRLOCK_PAINTABLE_STRIPE
	icon = 'icons/obj/doors/basic/single/hatch/door.dmi'
	fill_file = 'icons/obj/doors/basic/single/hatch/fill_steel.dmi'
	color_file = 'icons/obj/doors/basic/single/hatch/color.dmi'
	color_fill_file = 'icons/obj/doors/basic/single/hatch/fill_color.dmi'
	stripe_file = 'icons/obj/doors/basic/single/hatch/stripe.dmi'
	stripe_fill_file = 'icons/obj/doors/basic/single/hatch/stripe.dmi'
	door_color = "#4e5170"
	stripe_color = "#ffc443"
	assembly_type = /obj/structure/door_assembly/door_assembly_hatch
	insecure = 0
	open_sound_powered = 'sound/machines/airlock/hatchopen.ogg'
	close_sound_powered = 'sound/machines/airlock/hatchclose.ogg'
	open_sound_unpowered = 'sound/machines/airlock/hatchforced.ogg'

/obj/machinery/door/airlock/maintenance_hatch
	name = "maintenance hatch"
	explosion_resistance = 20
	opacity = TRUE
	paintable = AIRLOCK_PAINTABLE_MAIN | AIRLOCK_PAINTABLE_STRIPE
	icon = 'icons/obj/doors/basic/single/hatch/door.dmi'
	fill_file = 'icons/obj/doors/basic/single/hatch/fill_steel.dmi'
	color_file = 'icons/obj/doors/basic/single/hatch/color.dmi'
	color_fill_file = 'icons/obj/doors/basic/single/hatch/fill_color.dmi'
	stripe_file = 'icons/obj/doors/basic/single/hatch/stripe.dmi'
	stripe_fill_file = 'icons/obj/doors/basic/single/hatch/stripe.dmi'
	door_color = "#4d4d4d"
	stripe_color = "#a88029"
	open_sound_powered = 'sound/machines/airlock/hatchopen.ogg'
	close_sound_powered = 'sound/machines/airlock/hatchclose.ogg'
	open_sound_unpowered = 'sound/machines/airlock/hatchforced.ogg'

/obj/machinery/door/airlock/glass_command
	name = "glass airlock"
	icon_state = "cmd_glass"
	hitsound = 'sound/effects/glass_hit.ogg'
	maxhealth = 300
	explosion_resistance = 5
	opacity = FALSE
	glass = 1
	door_color = "#516487"
	stripe_color = "#ffc443"
	open_sound_powered = 'sound/machines/airlock/hall3o.ogg'
	close_sound_powered = 'sound/machines/airlock/hall3c.ogg'
	paintable = AIRLOCK_PAINTABLE_MAIN | AIRLOCK_PAINTABLE_STRIPE

/obj/machinery/door/airlock/glass_engineering
	name = "glass airlock"
	icon_state = "eng_glass"
	hitsound = 'sound/effects/glass_hit.ogg'
	maxhealth = 300
	explosion_resistance = 5
	opacity = FALSE
	glass = 1
	paintable = AIRLOCK_PAINTABLE_MAIN | AIRLOCK_PAINTABLE_STRIPE
	door_color = "#caa638"
	stripe_color = "#ff7f43"
	open_sound_powered = 'sound/machines/airlock/hall3o.ogg'
	close_sound_powered = 'sound/machines/airlock/hall3c.ogg'

/obj/machinery/door/airlock/glass_security
	name = "glass airlock"
	icon_state = "sec_glass"
	paintable = AIRLOCK_PAINTABLE_MAIN | AIRLOCK_PAINTABLE_STRIPE
	door_color = "#2b4b68"
	glass = 1

/obj/machinery/door/airlock/glass_medical
	name = "glass airlock"
	hitsound = 'sound/effects/glass_hit.ogg'
	maxhealth = 300
	explosion_resistance = 5
	opacity = FALSE
	glass = 1
	paintable = AIRLOCK_PAINTABLE_MAIN | AIRLOCK_PAINTABLE_STRIPE
	door_color = "#A7A9A0"
	stripe_color = "#345731"
	open_sound_powered = 'sound/machines/airlock/hall3o.ogg'
	close_sound_powered = 'sound/machines/airlock/hall3c.ogg'

/obj/machinery/door/airlock/mining
	name = "mining airlock"
	icon_state = "ops"
	door_color = "#956F30"
	stripe_color = "#5E340B"
	paintable = AIRLOCK_PAINTABLE_MAIN | AIRLOCK_PAINTABLE_STRIPE

/obj/machinery/door/airlock/atmos
	name = "Atmospherics Airlock"
	icon_state = "eng"
	paintable = AIRLOCK_PAINTABLE_MAIN | AIRLOCK_PAINTABLE_STRIPE
	door_color = "#caa638"
	stripe_color = "#62ff43"

/obj/machinery/door/airlock/research
	name = "airlock"
	icon_state = "sci"
	paintable = AIRLOCK_PAINTABLE_MAIN | AIRLOCK_PAINTABLE_STRIPE
	door_color = "#A18A9C"
	stripe_color = "#e943ff"

/obj/machinery/door/airlock/glass_research
	name = "glass airlock"
	icon_state = "sci_glass"
	hitsound = 'sound/effects/glass_hit.ogg'
	maxhealth = 300
	explosion_resistance = 5
	opacity = FALSE
	glass = 1
	heat_proof = 1
	paintable = AIRLOCK_PAINTABLE_MAIN
	door_color = "#A18A9C"
	open_sound_powered = 'sound/machines/airlock/hall3o.ogg'
	close_sound_powered = 'sound/machines/airlock/hall3c.ogg'

/obj/machinery/door/airlock/glass_mining
	name = "glass airlock"
	door_color = "#956F30"
	stripe_color = "#5E340B"
	icon_state = "ops_glass"
	hitsound = 'sound/effects/glass_hit.ogg'
	maxhealth = 300
	explosion_resistance = 5
	opacity = FALSE
	glass = 1
	open_sound_powered = 'sound/machines/airlock/hall3o.ogg'
	close_sound_powered = 'sound/machines/airlock/hall3c.ogg'

/obj/machinery/door/airlock/glass_atmos
	name = "glass airlock"
	hitsound = 'sound/effects/glass_hit.ogg'
	maxhealth = 300
	explosion_resistance = 5
	opacity = FALSE
	glass = 1
	door_color = "#caa638"
	stripe_color = "#295773"
	open_sound_powered = 'sound/machines/airlock/hall3o.ogg'
	close_sound_powered = 'sound/machines/airlock/hall3c.ogg'

/obj/machinery/door/airlock/khaki
	paintable = AIRLOCK_PAINTABLE_MAIN | AIRLOCK_PAINTABLE_STRIPE
	door_color = "#364664"
	stripe_color = "#ff4343"
	door_frame_color = "#8d8078"

/obj/machinery/door/airlock/merc
	paintable = AIRLOCK_PAINTABLE_MAIN | AIRLOCK_PAINTABLE_STRIPE
	door_color = "#534663"
	stripe_color = "#fac826"
	door_frame_color = "#8b7d86"

/obj/machinery/door/airlock/red
	paintable = AIRLOCK_PAINTABLE_MAIN
	door_color = "#364664"
	door_frame_color = "#c24f4f"

/obj/machinery/door/airlock/purple
	paintable = AIRLOCK_PAINTABLE_MAIN
	door_color = "#596170"
	door_frame_color = "#7846b1"

/obj/machinery/door/airlock/blue
	paintable = AIRLOCK_PAINTABLE_MAIN
	door_color = "#63584a"
	door_frame_color = "#6176a1"

/obj/machinery/door/airlock/gold
	name = "Gold Airlock"
	door_color = COLOR_GOLD
	mineral = "gold"

/obj/machinery/door/airlock/silver
	name = "Silver Airlock"
	door_color = COLOR_SILVER
	mineral = "silver"

/obj/machinery/door/airlock/diamond
	name = "Diamond Airlock"
	door_color = COLOR_DIAMOND
	mineral = "diamond"
	maxhealth = 2000

/obj/machinery/door/airlock/sandstone
	name = "Sandstone Airlock"
	door_color = COLOR_BEIGE
	mineral = "sandstone"

/obj/machinery/door/airlock/palepurple
	name = "airlock"
	door_color = COLOR_PURPLE
	hashatch = FALSE

/obj/machinery/door/airlock/highsecurity
	name = "secure airlock"
	icon = 'icons/obj/doors/basic/single/secure/door.dmi'
	color_file = 'icons/obj/doors/basic/single/secure/color.dmi'
	color_fill_file = 'icons/obj/doors/basic/single/secure/fill_color.dmi'
	icon_state = "preview"
	door_color = COLOR_WALL_GUNMETAL
	explosion_resistance = 20
	secured_wires = TRUE
	assembly_type = /obj/structure/door_assembly/door_assembly_highsecurity
	maxhealth = 600
	insecure = 0
	ai_bolting_delay = 10
	ai_unbolt_delay = 5
	open_sound_powered = 'sound/machines/airlock/secure1o.ogg'
	close_sound_powered = 'sound/machines/airlock/secure1c.ogg'

/obj/machinery/door/airlock/skrell
	name = "airlock"
	door_color = COLOR_PURPLE_GRAY
	explosion_resistance = 20
	secured_wires = TRUE
	maxhealth = 600
	insecure = 0
	hashatch = FALSE

/obj/machinery/door/airlock/diona
	name = "biomass airlock"
	door_color = "#564A27"
	door_frame_color = "#7E6A40"
	explosion_resistance = 20
	secured_wires = TRUE
	maxhealth = 600
	insecure = FALSE
	hashatch = FALSE

/// Placeholder object until it gets new sprites.
/obj/machinery/door/airlock/diona/external
	name = "external biomass airlock"

//---Uranium doors
/obj/machinery/door/airlock/uranium
	name = "Uranium Airlock"
	desc = "And they said I was crazy."
	door_color = COLOR_GREEN
	mineral = "uranium"
	var/last_event = 0

/obj/machinery/door/airlock/uranium/process()
	if(world.time > last_event+20)
		if(prob(50))
			SSradiation.radiate(src, 50)
		last_event = world.time
	..()

//---Phoron door
/obj/machinery/door/airlock/phoron
	name = "Phoron Airlock"
	desc = "No way this can end badly."
	door_color = COLOR_VIOLET
	mineral = MATERIAL_PHORON

/obj/machinery/door/airlock/phoron/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > 300)
		PhoronBurn(exposed_temperature)

/obj/machinery/door/airlock/phoron/proc/ignite(exposed_temperature)
	if(exposed_temperature > 300)
		PhoronBurn(exposed_temperature)

/obj/machinery/door/airlock/phoron/proc/PhoronBurn(temperature)
	for(var/turf/simulated/floor/target_tile in range(2,loc))
		target_tile.assume_gas(GAS_PHORON, 35, 400+T0C)
		spawn (0) target_tile.hotspot_expose(temperature, 400)
	for(var/turf/simulated/wall/W in range(3,src))
		W.burn((temperature/4))//Added so that you can't set off a massive chain reaction with a small flame
	for(var/obj/machinery/door/airlock/phoron/D in range(3,src))
		D.ignite(temperature/4)
	new/obj/structure/door_assembly( src.loc )
	qdel(src)

//-------------------------

/*
About the new airlock wires panel:
*	An airlock wire dialog can be accessed by the normal way or by using wirecutters or a multitool on the door while the wire-panel is open. This would show the following wires, which you can either wirecut/mend or send a multitool pulse through. There are 9 types of wires.
*		one wire from the ID scanner. Sending a pulse through this flashes the red light on the door (if the door has power). If you cut this wire, the door will stop recognizing valid IDs. (If the door has 0000 access, it still opens and closes, though)
*		two wires for power. Sending a pulse through either one causes a breaker to trip, disabling the door for 10 seconds if backup power is connected, or 1 minute if not (or until backup power comes back on, whichever is shorter). Cutting either one disables the main door power, but unless backup power is also cut, the backup power re-powers the door in 10 seconds. While unpowered, the door may be open, but bolts-raising will not work. Cutting these wires may electrocute the user.
*		one wire for door bolts. Sending a pulse through this drops door bolts (whether the door is powered or not) or raises them (if it is). Cutting this wire also drops the door bolts, and mending it does not raise them. If the wire is cut, trying to raise the door bolts will not work.
*		two wires for backup power. Sending a pulse through either one causes a breaker to trip, but this does not disable it unless main power is down too (in which case it is disabled for 1 minute or however long it takes main power to come back, whichever is shorter). Cutting either one disables the backup door power (allowing it to be crowbarred open, but disabling bolts-raising), but may electocute the user.
*		one wire for opening the door. Sending a pulse through this while the door has power makes it open the door if no access is required.
*		one wire for AI control. If allowed by the door setup, sending a pulse through this toggles whether AI can bolt the door (shows as green light in dialogue if it can bolt, orange if it can't, red when emagged and thus inoperable by AI). Cutting this prevents the AI from controlling the door unless it has hacked the door through the power connection (which takes about a minute). If both main and backup power are cut, as well as this wire, then the AI cannot operate or hack the door at all.
*		one wire for electrifying the door. Sending a pulse through this electrifies the door for 30 seconds. Cutting this wire electrifies the door, so that the next person to touch the door without insulated gloves gets electrocuted. (Currently it is also STAYING electrified until someone mends the wire)
*		one wire for controling door safetys.  When active, door does not close on someone.  When cut, door will ruin someone's shit.  When pulsed, door will immedately ruin someone's shit.
*		one wire for controlling door speed.  When active, door closes at normal rate.  When cut, door does not close manually.  When pulsed, door attempts to close every tick.
*/


/obj/machinery/door/airlock/bumpopen(mob/living/user as mob) //Airlocks now zap you when you 'bump' them open when they're electrified. --NeoFite
	if(!issilicon(user))
		if(src.isElectrified())
			if(!has_shocked)
				if(src.shock(user, 100))
					src.has_shocked = TRUE
					spawn (10)
						src.has_shocked = FALSE
					return
			else
				return
	..(user)

/obj/machinery/door/airlock/proc/isElectrified()
	if(src.electrified_until != 0)
		return 1
	return 0

/obj/machinery/door/airlock/proc/isWireCut(var/wireIndex)
	// You can find the wires in the datum folder.
	return QDELETED(wires) ? FALSE : wires.is_cut(wireIndex)

/obj/machinery/door/airlock/proc/canAIControl()
	return ((src.ai_control_disabled!=1) && (!src.isAllPowerLoss()));

/obj/machinery/door/airlock/proc/canAIHack()
	return ((src.ai_control_disabled==1) && (!hack_proof) && (!src.isAllPowerLoss()));

/obj/machinery/door/airlock/proc/arePowerSystemsOn()
	if (stat & (NOPOWER|BROKEN))
		return FALSE
	return (src.main_power_lost_until==0 || src.backup_power_lost_until==0)

/obj/machinery/door/airlock/requiresID()
	return !(src.isWireCut(WIRE_IDSCAN) || ai_disabled_id_scanner)

/obj/machinery/door/airlock/proc/isAllPowerLoss()
	if(stat & (NOPOWER|BROKEN))
		return TRUE
	if(mainPowerCablesCut() && backupPowerCablesCut())
		return TRUE
	return FALSE

/obj/machinery/door/airlock/proc/mainPowerCablesCut()
	return src.isWireCut(WIRE_POWER1) || src.isWireCut(WIRE_POWER2)

/obj/machinery/door/airlock/proc/backupPowerCablesCut()
	return src.isWireCut(WIRE_BACKUP1) || src.isWireCut(WIRE_BACKUP2)

/obj/machinery/door/airlock/proc/loseMainPower()
	main_power_lost_until = mainPowerCablesCut() ? -1 : world.time + SecondsToTicks(60)
	main_power_lost_at = world.time
	if (main_power_lost_until > 0)
		addtimer(CALLBACK(src, PROC_REF(regainMainPower)), 60 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE | TIMER_NO_HASH_WAIT)

	// If backup power is permanently disabled then activate in 10 seconds if possible, otherwise it's already enabled or a timer is already running
	if(backup_power_lost_until == -1 && !backupPowerCablesCut())
		backup_power_lost_until = world.time + SecondsToTicks(10)
		backup_power_lost_at = world.time
		addtimer(CALLBACK(src, PROC_REF(regainBackupPower)), 10 SECONDS, TIMER_UNIQUE | TIMER_NO_HASH_WAIT)

	if(!arePowerSystemsOn() && !isnull(ai_action_timer)) // AI action timer gets reset if any
		deltimer(ai_action_timer)
		ai_action_timer = null
	if(isAllPowerLoss() && electrified_until) // Disable electricity if required
		electrify(0)

/obj/machinery/door/airlock/proc/loseBackupPower()
	backup_power_lost_until = backupPowerCablesCut() ? -1 : world.time + SecondsToTicks(60)
	backup_power_lost_at = world.time
	if (backup_power_lost_until > 0)
		addtimer(CALLBACK(src, PROC_REF(regainBackupPower)), 60 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE | TIMER_NO_HASH_WAIT)

	if(!arePowerSystemsOn() && !isnull(ai_action_timer)) // AI action timer gets reset if any
		deltimer(ai_action_timer)
		ai_action_timer = null
	if(isAllPowerLoss() && electrified_until) // Disable electricity if required
		electrify(0)

/obj/machinery/door/airlock/proc/regainMainPower()
	if(!mainPowerCablesCut())
		main_power_lost_until = 0
		// If backup power is currently active then disable, otherwise let it count down and disable itself later
		if(!backup_power_lost_until)
			backup_power_lost_until = -1
		update_icon()

/obj/machinery/door/airlock/proc/regainBackupPower()
	if(!backupPowerCablesCut())
		// Restore backup power only if main power is offline, otherwise permanently disable
		backup_power_lost_until = main_power_lost_until == 0 ? -1 : 0
		update_icon()

/obj/machinery/door/airlock/proc/electrify(var/duration, var/feedback = 0)
	var/message = ""
	if(isWireCut(WIRE_SHOCK) && arePowerSystemsOn())
		message = text("The electrification wire is cut - Door permanently electrified.")
		electrified_until = -1
	else if(duration && !arePowerSystemsOn())
		message = text("The door is unpowered - Cannot electrify the door.")
		electrified_until = 0
	else if(!duration && electrified_until != 0)
		message = "The door is now un-electrified."
		electrified_until = 0
	else if(duration)	//electrify door for the given duration seconds
		if(usr)
			LAZYADD(shockedby, "\[[time_stamp()]\] - [usr](ckey:[usr.ckey])")
			usr.attack_log += text("\[[time_stamp()]\] <span class='warning'>Electrified the [name] at [x] [y] [z]</span>")
		else
			LAZYADD(shockedby, "\[[time_stamp()]\] - EMP)")
		message = "The door is now electrified [duration == -1 ? "permanently" : "for [duration] second\s"]."
		electrified_until = duration == -1 ? -1 : world.time + SecondsToTicks(duration)
		electrified_at = world.time
		if (electrified_until > 0)
			addtimer(CALLBACK(src, PROC_REF(electrify), 0), duration SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE | TIMER_NO_HASH_WAIT)

	if(feedback && message)
		to_chat(usr, message)

/obj/machinery/door/airlock/proc/set_idscan(var/activate, var/feedback = 0)
	var/message = ""
	if(src.isWireCut(WIRE_IDSCAN))
		message = "The IDScan wire is cut - IdScan feature permanently disabled."
	else if(activate && src.ai_disabled_id_scanner)
		src.ai_disabled_id_scanner = FALSE
		message = "IDScan feature has been enabled."
	else if(!activate && !src.ai_disabled_id_scanner)
		src.ai_disabled_id_scanner = TRUE
		message = "IDScan feature has been disabled."

	if(feedback && message)
		to_chat(usr, message)

/obj/machinery/door/airlock/proc/set_safeties(var/activate, var/feedback = 0)
	var/message = ""
	// Safeties!  We don't need no stinking safeties!
	if (src.isWireCut(WIRE_SAFETY))
		message = text("The safety wire is cut - Cannot enable safeties.")
	else if (!activate && src.safe)
		safe = FALSE
	else if (activate && !src.safe)
		safe = TRUE

	if(feedback && message)
		to_chat(usr, message)

// shock user with probability prb (if all connections & power are working)
// returns 1 if shocked, 0 otherwise
// The preceding comment was borrowed from the grille's shock script
/obj/machinery/door/airlock/shock(mob/user, prb)
	if(!arePowerSystemsOn())
		return 0
	if(has_shocked)
		return 0	//Already shocked someone recently?
	if(..())
		has_shocked = TRUE
		sleep(10)
		has_shocked = FALSE
		return 1
	else
		return 0

// Only set_light() if there's a change, no need to waste processor cycles with lighting updates.
/obj/machinery/door/airlock/update_icon(var/state = 0)
	if (QDELING(src))
		return

	switch(state)
		if(0)
			if(density)
				icon_state = "closed"
				state = AIRLOCK_CLOSED
			else
				icon_state = "open"
				state = AIRLOCK_OPEN
		if(AIRLOCK_OPEN)
			icon_state = "open"
		if(AIRLOCK_CLOSED)
			icon_state = "closed"
		if(AIRLOCK_OPENING, AIRLOCK_CLOSING, AIRLOCK_EMAG, AIRLOCK_DENY)
			icon_state = ""

	set_airlock_overlays(state)

/obj/machinery/door/airlock/proc/set_airlock_overlays(state, force_compile)
	var/icon/color_overlay
	var/icon/frame_color_overlay
	var/icon/filling_overlay
	var/icon/stripe_overlay
	var/icon/stripe_filling_overlay
	var/icon/lights_overlay
	var/icon/panel_overlay
	var/icon/weld_overlay
	var/icon/damage_overlay
	var/icon/sparks_overlay
	var/icon/brace_overlay

	set_light(0)

	if(door_frame_color && !(door_frame_color == "none"))//frame
		var/ikey = "[airlock_type]-[door_frame_color]-framecolor"
		frame_color_overlay = SSicon_cache.airlock_icon_cache["[ikey]"]
		if(!frame_color_overlay)
			frame_color_overlay = new(frame_color_file)
			frame_color_overlay.Blend(door_frame_color, ICON_MULTIPLY)
			SSicon_cache.airlock_icon_cache["[ikey]"] = frame_color_overlay
	if(door_color && !(door_color == "none"))//door itself
		var/ikey = "[airlock_type]-[door_color]-doorcolor"
		color_overlay = SSicon_cache.airlock_icon_cache["[ikey]"]
		if(!color_overlay)
			color_overlay = new(color_file)
			color_overlay.Blend(door_color, ICON_MULTIPLY)
			SSicon_cache.airlock_icon_cache["[ikey]"] = color_overlay
	if(glass)
		if (window_color && window_color != "none")
			var/ikey = "[airlock_type]-[window_color]-windowcolor"
			filling_overlay = SSicon_cache.airlock_icon_cache["[ikey]"]
			if (!filling_overlay)
				filling_overlay = new(glass_file)
				filling_overlay.Blend(window_color, ICON_MULTIPLY)
				SSicon_cache.airlock_icon_cache["[ikey]"] = filling_overlay
		else
			filling_overlay = glass_file
	else
		if(door_color && !(door_color == "none"))
			var/ikey = "[airlock_type]-[door_color]-fillcolor"
			filling_overlay = SSicon_cache.airlock_icon_cache["[ikey]"]
			if(!filling_overlay)
				filling_overlay = new(color_fill_file)
				filling_overlay.Blend(door_color, ICON_MULTIPLY)
				SSicon_cache.airlock_icon_cache["[ikey]"] = filling_overlay
		else
			filling_overlay = fill_file
	if(stripe_color && !(stripe_color == "none"))
		var/ikey = "[airlock_type]-[stripe_color]-stripe"
		stripe_overlay = SSicon_cache.airlock_icon_cache["[ikey]"]
		if(!stripe_overlay)
			stripe_overlay = new(stripe_file)
			stripe_overlay.Blend(stripe_color, ICON_MULTIPLY)
			SSicon_cache.airlock_icon_cache["[ikey]"] = stripe_overlay
		if(!glass)
			var/ikey2 = "[airlock_type]-[stripe_color]-fillstripe"
			stripe_filling_overlay = SSicon_cache.airlock_icon_cache["[ikey2]"]
			if(!stripe_filling_overlay)
				stripe_filling_overlay = new(stripe_fill_file)
				stripe_filling_overlay.Blend(stripe_color, ICON_MULTIPLY)
				SSicon_cache.airlock_icon_cache["[ikey2]"] = stripe_filling_overlay

	if(arePowerSystemsOn())
		switch(state)
			if(AIRLOCK_CLOSED)
				if(lights && locked)
					lights_overlay = overlay_image(bolts_file, layer = EFFECTS_ABOVE_LIGHTING_LAYER)
					set_light(1, 2, COLOR_RED_LIGHT)

			if(AIRLOCK_DENY)
				if(lights)
					lights_overlay = overlay_image(deny_file, layer = EFFECTS_ABOVE_LIGHTING_LAYER)
					set_light(1, 2, COLOR_RED_LIGHT)

			if(AIRLOCK_EMAG)
				sparks_overlay = overlay_image(emag_file, layer = EFFECTS_ABOVE_LIGHTING_LAYER)

			if(AIRLOCK_CLOSING)
				if(lights)
					lights_overlay = overlay_image(lights_file, layer = EFFECTS_ABOVE_LIGHTING_LAYER)
					set_light(1, 2, COLOR_LIME)

			if(AIRLOCK_OPENING)
				if(lights)
					lights_overlay = overlay_image(lights_file, layer = EFFECTS_ABOVE_LIGHTING_LAYER)
					set_light(1, 2, COLOR_LIME)

		if(stat & BROKEN)
			damage_overlay = overlay_image(sparks_broken_file, layer = EFFECTS_ABOVE_LIGHTING_LAYER)
		else if (health < maxhealth * 3/4 && !(stat & NOPOWER))
			damage_overlay = overlay_image(sparks_damaged_file, layer = EFFECTS_ABOVE_LIGHTING_LAYER)

	if(welded)
		weld_overlay = welded_file

	if(p_open)
		panel_overlay = panel_file

	cut_overlays()

	add_overlay(frame_color_overlay)
	add_overlay(color_overlay)
	add_overlay(panel_overlay)
	add_overlay(filling_overlay)
	add_overlay(stripe_overlay)
	add_overlay(stripe_filling_overlay)
	add_overlay(weld_overlay)
	add_overlay(brace_overlay)
	add_overlay(lights_overlay)
	add_overlay(sparks_overlay)
	add_overlay(damage_overlay)

	if(force_compile)
		compile_overlays()

/obj/machinery/door/airlock/do_animate(animation)
	cut_overlays()

	switch(animation)
		if("opening")
			set_airlock_overlays(AIRLOCK_OPENING, TRUE)
			flick("opening", src)//[stat ? "_stat":]
			update_icon(AIRLOCK_OPEN)
		if("closing")
			set_airlock_overlays(AIRLOCK_CLOSING, TRUE)
			flick("closing", src)
			update_icon(AIRLOCK_CLOSED)
		if("deny")
			set_airlock_overlays(AIRLOCK_DENY, TRUE)
			if(density && arePowerSystemsOn())
				flick("denied", src)
				if(secured_wires)
					playsound(src.loc, open_failure_access_denied, 50, extrarange = SHORT_RANGE_SOUND_EXTRARANGE)
			update_icon(AIRLOCK_CLOSED)
		if("emag")
			set_airlock_overlays(AIRLOCK_EMAG, TRUE)
			if(density && arePowerSystemsOn())
				flick("denied", src)
				playsound(src.loc, open_failure_access_denied, 50, extrarange = SHORT_RANGE_SOUND_EXTRARANGE)
		if ("braced")
			set_airlock_overlays(AIRLOCK_DENY, TRUE)
			if (arePowerSystemsOn())
				flick("denied", src)
				playsound(src.loc, 'sound/machines/hydraulic_short.ogg', 50, extrarange = SHORT_RANGE_SOUND_EXTRARANGE)
		else
			update_icon()

/obj/machinery/door/airlock/attack_ai(mob/user as mob)
	if(!ai_can_interact(user))
		return
	ui_interact(user)

/obj/machinery/door/airlock/ui_interact(mob/user, var/datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Doors", "Door Control", 480, 500)
		ui.open()

/obj/machinery/door/airlock/ui_data(mob/user)
	var/list/data = list()
	data["doorArea"] = loc.loc?.name
	data["doorName"] = name
	data["open"] = !density
	data["plu_main"] = main_power_lost_until
	data["plua_main"] = main_power_lost_at
	data["plu_back"] = backup_power_lost_until
	data["plua_back"] = backup_power_lost_at
	data["ele"] = electrified_until
	data["elea"] = electrified_at
	data["aiCanBolt"] = ai_bolting
	data["idscan"] = !ai_disabled_id_scanner
	data["bolts"] = !locked
	data["lights"] = lights
	data["safeties"] = safe
	data["timing"] = normalspeed
	data["wtime"] = world.time

	var/antag = player_is_antag(user.mind)
	var/isAdmin = isobserver(user) && check_rights(R_ADMIN, FALSE, user)
	data["isAi"] = issilicon(user) && !antag
	data["boltsOverride"] = antag || isAdmin
	data["isAdmin"] = isAdmin

	return data

/obj/machinery/door/airlock/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return TRUE

	var/isAdmin = isobserver(usr) && check_rights(R_ADMIN, show_msg = FALSE)
	var/activate = text2num(params["activate"])
	var/antag = player_is_antag(usr.mind)
	switch(action)
		if("idscan")
			set_idscan(activate, 1)
		if("main_power")
			if(!main_power_lost_until)
				src.loseMainPower()
		if("backup_power")
			if(!backup_power_lost_until)
				src.loseBackupPower()
		if("bolts")
			bolts_interact(usr, activate, isAdmin, antag)
		if("bolts_override")
			bolts_override(usr, activate, antag)
		if("electrify_temporary")
			if(!isAdmin && issilicon(usr) && !antag)
				to_chat(usr, SPAN_WARNING("Your programming prevents you from electrifying the door."))
			else
				electrify(30 * activate, 1)
		if("electrify_permanently")
			if(!isAdmin && issilicon(usr) && !antag && (electrified_until == 0))
				to_chat(usr, SPAN_WARNING("Your programming prevents you from electrifying the door."))
			else
				electrify(-1 * activate, 1)
		if("open")
			open_interact(usr, activate)
		if("safeties")
			if(!isAdmin && safe && issilicon(usr) && !antag)
				to_chat(usr, SPAN_WARNING("Your programming prevents you from disabling the door safeties."))
			else
				set_safeties(!activate, 1)
		if("timing")
			// Door speed control
			if(src.isWireCut(WIRE_TIMING))
				to_chat(usr, text("The timing wire is cut - Cannot alter timing."))
			else if (activate && src.normalspeed)
				normalspeed = FALSE
			else if (!activate && !src.normalspeed)
				normalspeed = TRUE
		if("lights")
			// Bolt lights
			if(src.isWireCut(WIRE_BOLTLIGHT))
				to_chat(usr, "The bolt lights wire is cut - The door bolt lights are permanently disabled.")
			else if (!activate && src.lights)
				lights = FALSE
				to_chat(usr, "The door bolt lights have been disabled.")
			else if (activate && !src.lights)
				lights = TRUE
				to_chat(usr, "The door bolt lights have been enabled.")
	update_icon()
	return TRUE

/obj/machinery/door/airlock/proc/bolts_interact(var/mob/user, var/activate, var/isAdmin, var/antag)
	if(isrobot(user) && !Adjacent(user))
		to_chat(user, SPAN_WARNING("Your frame does not allow long distance wireless bolt control, you will need be adjacent the door."))
		return
	if(isWireCut(WIRE_BOLTLIGHT)) // cut wire is noop
		to_chat(user, SPAN_WARNING("The door bolt control wire is cut - Door bolts permanently dropped."))
	else if(isAdmin || issilicon(user)) // controls for silicons, "stealthy" antag silicons and "stealthy" admins
		if(!arePowerSystemsOn()) // cannot queue actions or "speak" from unpowered doors
			to_chat(user, SPAN_WARNING("The door is unpowered - Cannot [activate ? "drop" : "raise"] bolts."))
		else if(!ai_bolting)
			to_chat(user, SPAN_WARNING("The door is configured not to allow remote bolt operation."))
		else if(!isnull(ai_action_timer))
			to_chat(user, SPAN_WARNING("An action is already queued. Please wait for it to complete."))
		else if(activate)
			to_chat(user, SPAN_NOTICE("The door bolts should drop in [ai_bolting_delay] seconds."))
			audible_message("[icon2html(icon, viewers(get_turf(src)))] <b>[src]</b> announces, <span class='notice'>\"Bolts set to drop in <strong>[ai_bolting_delay] seconds</strong>.\"</span>")
			ai_action_timer = addtimer(CALLBACK(src, PROC_REF(lock)), ai_bolting_delay SECONDS, TIMER_UNIQUE|TIMER_NO_HASH_WAIT|TIMER_STOPPABLE)
		else
			to_chat(user, SPAN_NOTICE("The door bolts should raise in [ai_unbolt_delay] seconds."))
			audible_message("[icon2html(icon, viewers(get_turf(src)))] <b>[src]</b> announces, <span class='notice'>\"Bolts set to raise in <strong>[ai_unbolt_delay] seconds</strong>.\"</span>")
			ai_action_timer = addtimer(CALLBACK(src, PROC_REF(unlock)), ai_unbolt_delay SECONDS, TIMER_UNIQUE|TIMER_NO_HASH_WAIT|TIMER_STOPPABLE)
	else // everyone else
		if(activate)
			if(lock())
				to_chat(user, SPAN_NOTICE("The door bolts have been dropped."))
		else
			if(unlock())
				to_chat(user, SPAN_NOTICE("The door bolts have been raised."))

/obj/machinery/door/airlock/proc/bolts_override(var/mob/user, var/activate, var/isAdmin, var/antag)
	if(isAdmin || (issilicon(user) && antag)) // admin and silicon antag can override
		if(!isAdmin && src.isWireCut(WIRE_BOLTLIGHT)) // cut wire is noop, except for admins
			to_chat(user, SPAN_WARNING("The door bolt control wire is cut - Door bolts permanently dropped."))
		else if(!isAdmin && !arePowerSystemsOn()) // door must be powered - display friendly message if not (admins can magically skip this)
			to_chat(user, SPAN_WARNING("The door is unpowered - Cannot [activate ? "drop" : "raise"] bolts."))
		else if(activate)
			if(lock())
				to_chat(user, SPAN_NOTICE("The door bolts have been dropped."))
		else
			if(unlock())
				to_chat(user, SPAN_NOTICE("The door bolts have been raised."))

/obj/machinery/door/airlock/proc/open_interact(var/mob/user, var/activate)
	if(welded)
		to_chat(usr, SPAN_WARNING("The airlock has been welded shut!"))
	else if(locked)
		to_chat(usr, SPAN_WARNING("The door bolts are down!"))
	else if(!arePowerSystemsOn() && issilicon(usr)) // AIs get a nice notice that the door is unpowered
		to_chat(usr, SPAN_WARNING("The door is unpowered, its motors do not respond to your commands."))
	else if(activate && density)
		open()
		if (isAI(usr))
			SSstatistics.IncrementSimpleStat("AI_DOOR")
	else if(!activate && !density)
		close()

/obj/machinery/door/airlock/proc/hack(mob/user as mob)
	if(src.ai_hacking==0)
		src.ai_hacking=1
		spawn(20)
			//TODO: Make this take a minute
			to_chat(user, "Airlock AI control has been blocked. Beginning fault-detection.")
			sleep(50)
			if(src.canAIControl())
				to_chat(user, "Alert cancelled. Airlock control has been restored without our assistance.")
				src.ai_hacking=0
				return
			else if(!src.canAIHack(user))
				to_chat(user, "We've lost our connection! Unable to hack airlock.")
				src.ai_hacking=0
				return
			to_chat(user, "Fault confirmed: airlock control wire disabled or cut.")
			sleep(20)
			to_chat(user, "Attempting to hack into airlock. This may take some time.")
			sleep(200)
			if(src.canAIControl())
				to_chat(user, "Alert cancelled. Airlock control has been restored without our assistance.")
				src.ai_hacking=0
				return
			else if(!src.canAIHack(user))
				to_chat(user, "We've lost our connection! Unable to hack airlock.")
				src.ai_hacking=0
				return
			to_chat(user, "Upload access confirmed. Loading control program into airlock software.")
			sleep(170)
			if(src.canAIControl())
				to_chat(user, "Alert cancelled. Airlock control has been restored without our assistance.")
				src.ai_hacking=0
				return
			else if(!src.canAIHack(user))
				to_chat(user, "We've lost our connection! Unable to hack airlock.")
				src.ai_hacking=0
				return
			to_chat(user, "Transfer complete. Forcing airlock to execute program.")
			sleep(50)
			//disable blocked control
			src.ai_control_disabled = 2
			to_chat(user, "Receiving control information from airlock.")
			sleep(10)
			//bring up airlock dialog
			src.ai_hacking = FALSE
			if (user)
				src.attack_ai(user)

/obj/machinery/door/airlock/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if (src.isElectrified())
		if (istype(mover, /obj/item))
			var/obj/item/i = mover
			if (i.matter && (DEFAULT_WALL_MATERIAL in i.matter) && i.matter[DEFAULT_WALL_MATERIAL] > 0)
				spark(src, 5, GLOB.alldirs)
	return ..()

/obj/machinery/door/airlock/attack_hand(mob/user as mob)
	if(!istype(usr, /mob/living/silicon))
		if(src.isElectrified())
			if(src.shock(user, 100))
				return
	if(ishuman(user))
		var/mob/living/carbon/human/H = user

		if(H.getBrainLoss() >= 50)
			if(prob(40) && src.density)
				playsound(src.loc, 'sound/effects/bang.ogg', 25, TRUE, extrarange = SHORT_RANGE_SOUND_EXTRARANGE)
				if(!istype(H.head, /obj/item/clothing/head/helmet))
					user.visible_message(SPAN_WARNING("[user] headbutts the airlock."))
					var/obj/item/organ/external/affecting = H.get_organ(BP_HEAD)
					H.Stun(8)
					H.Weaken(5)
					if(affecting.take_damage(10, 0))
						H.UpdateDamageIcon()
				else
					user.visible_message(SPAN_WARNING("[user] headbutts the airlock. Good thing they're wearing a helmet."))
				return

		if(H.a_intent == I_HURT)
			var/shredding = H.species.can_shred(H)
			var/can_crowbar = H.default_attack?.crowbar_door && (stat & (BROKEN|NOPOWER))
			if(shredding || can_crowbar)
				if(!density)
					return

				H.visible_message("<b>[H]</b> begins to pry open \the [src]!", SPAN_NOTICE("You begin to pry open \the [src]!"), SPAN_WARNING("You hear the sound of an airlock being forced open."))

				if(!do_after(H, 12 SECONDS, src, DO_UNIQUE))
					return

				var/check = src.open(1)

				if(shredding)
					src.do_animate("spark")
					src.stat |= BROKEN
					H.visible_message("<b>[H]</b> slices \the [src]'s controls, [check ? "ripping it open" : "breaking it"]!", SPAN_NOTICE("You slice \the [src]'s controls, [check ? "ripping it open" : "breaking it"]!"), SPAN_WARNING("You hear something sparking."))
				return
			if(H.default_attack?.attack_door && !(stat & (BROKEN|NOPOWER)))
				user.visible_message(SPAN_DANGER("\The [user] forcefully strikes \the [src] with their [H.default_attack.attack_name]!"))
				user.do_attack_animation(src, null)
				playsound(loc, hitsound, 60, TRUE)
				take_damage(H.default_attack.attack_door)
				user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
				return
	if(src.p_open)
		user.set_machine(src)
		wires.interact(user)
	else
		..(user)
	return

//returns 1 on success, 0 on failure
/obj/machinery/door/airlock/proc/cut_bolts(var/obj/item/tool, var/mob/user)
	var/cut_delay = 200
	var/cut_verb
	var/cut_sound
	var/cutting = FALSE

	if(tool.iswelder())
		var/obj/item/weldingtool/WT = tool
		if(!WT.isOn())
			return
		if(!WT.use(0,user))
			to_chat(user, SPAN_NOTICE("You need more welding fuel to complete this task."))
			return
		cut_verb = "cutting"
		cut_sound = 'sound/items/Welder.ogg'
		cut_delay *= 1.5/WT.toolspeed
		cutting = TRUE
	else if(istype(tool,/obj/item/gun/energy/plasmacutter))
		cut_verb = "cutting"
		cut_sound = 'sound/items/Welder.ogg'
		cut_delay *= 1
		cutting = TRUE
	else if(istype(tool,/obj/item/melee/energy/blade) || istype(tool,/obj/item/melee/energy/sword))
		cut_verb = "slicing"
		cut_sound = /singleton/sound_category/spark_sound
		cut_delay *= 1
		cutting = TRUE
	else if(istype(tool,/obj/item/surgery/circular_saw))
		cut_verb = "sawing"
		cut_sound = 'sound/weapons/saw/circsawhit.ogg'
		cut_delay *= 2
		cutting = TRUE
	else if(istype(tool,/obj/item/material/twohanded/fireaxe))
		//fireaxe can smash open the bolt cover instantly
		var/obj/item/material/twohanded/fireaxe/F = tool
		if (!F.wielded)
			return FALSE
		if(bolt_cut_state == BOLTS_FINE)
			to_chat(user, SPAN_WARNING("You smash the bolt cover open!"))
			playsound(src, 'sound/weapons/smash.ogg', 100, TRUE, extrarange = MEDIUM_RANGE_SOUND_EXTRARANGE)
			bolt_cut_state = BOLTS_EXPOSED
		else if(bolt_cut_state != BOLTS_FINE)
			cut_verb = "smashing"
			cut_sound = 'sound/weapons/smash.ogg'
			cut_delay *= 1
			cutting = TRUE
	else if(istype(tool, /obj/item/crowbar/robotic/jawsoflife))
		if(bolt_cut_state == BOLTS_FINE)
			to_chat(user, SPAN_WARNING("You force the bolt cover open!"))
			playsound(src, 'sound/weapons/smash.ogg', 100, extrarange = SHORT_RANGE_SOUND_EXTRARANGE)
			bolt_cut_state = BOLTS_EXPOSED
		else if(bolt_cut_state != BOLTS_FINE)
			cut_verb = "smashing"
			cut_sound = 'sound/weapons/smash.ogg'
			cut_delay *= 1
			cutting = TRUE
	if(cutting)
		cut_procedure(user, cut_delay, cut_verb, cut_sound)
	else
		return FALSE

/obj/machinery/door/airlock/proc/cut_procedure(var/mob/user, var/cut_delay, var/cut_verb, var/cut_sound)
	var/initial_state = bolt_cut_state
	if(initial_state == BOLTS_FINE)
		to_chat(user, "You begin [cut_verb] through the bolt panel.")
	else if(initial_state == BOLTS_EXPOSED)
		to_chat(user, "You begin [cut_verb] through the door bolts.")

	cut_delay *= 0.25

	if(do_after(user, cut_delay, src, DO_REPAIR_CONSTRUCT))
		to_chat(user, SPAN_NOTICE("You're a quarter way through."))
		playsound(src, cut_sound, 100, TRUE, extrarange = SHORT_RANGE_SOUND_EXTRARANGE)

		if(do_after(user, cut_delay, src, DO_REPAIR_CONSTRUCT))
			to_chat(user, SPAN_NOTICE("You're halfway through."))
			playsound(src, cut_sound, 100, TRUE, extrarange = SHORT_RANGE_SOUND_EXTRARANGE)

			if(do_after(user, cut_delay, src, DO_REPAIR_CONSTRUCT))
				to_chat(user, SPAN_NOTICE("You're three quarters through."))
				playsound(src, cut_sound, 100, TRUE, extrarange = SHORT_RANGE_SOUND_EXTRARANGE)

				if(do_after(user, cut_delay, src, DO_REPAIR_CONSTRUCT))
					playsound(src, cut_sound, 100, TRUE, extrarange = SHORT_RANGE_SOUND_EXTRARANGE)

					if(initial_state != bolt_cut_state)
						return
					if(initial_state == BOLTS_FINE)
						to_chat(user, SPAN_NOTICE("You remove the cover and expose the door bolts."))
						bolt_cut_state = BOLTS_EXPOSED
					else if(initial_state == BOLTS_EXPOSED)
						to_chat(user, SPAN_NOTICE("You sever the door bolts, unlocking the door."))
						bolt_cut_state = BOLTS_CUT
						unlock(TRUE) //force it

/obj/machinery/door/airlock/CanUseTopic(var/mob/user)
	if(isobserver(user) && check_rights(R_ADMIN, FALSE, user))
		return ..()
	if(emagged == 1)
		to_chat(user, SPAN_WARNING("Unable to interface: Internal error."))
		return STATUS_CLOSE
	if(issilicon(user) && !src.canAIControl())
		if(src.canAIHack(user))
			src.hack(user)
		else
			if (src.isAllPowerLoss()) //don't really like how this gets checked a second time, but not sure how else to do it.
				to_chat(user, SPAN_WARNING("Unable to interface: Connection timed out."))
			else
				to_chat(user, SPAN_WARNING("Unable to interface: Connection refused."))
		return STATUS_CLOSE

	return ..()

/obj/machinery/door/airlock/Topic(href, href_list)
	if(..())
		return 1

	var/isAdmin = isobserver(usr) && check_rights(R_ADMIN, show_msg = FALSE)
	var/activate = text2num(href_list["activate"])
	var/antag = player_is_antag(usr.mind)
	switch (href_list["command"])
		if("idscan")
			set_idscan(activate, 1)
		if("main_power")
			if(!main_power_lost_until)
				src.loseMainPower()
		if("backup_power")
			if(!backup_power_lost_until)
				src.loseBackupPower()
		if("bolts")
			if(isrobot(usr) && !Adjacent(usr))
				to_chat(usr, SPAN_WARNING("Your frame does not allow long distance wireless bolt control, you will need be adjacent the door."))
				return
			if(src.isWireCut(WIRE_BOLTLIGHT)) // cut wire is noop
				to_chat(usr, SPAN_WARNING("The door bolt control wire is cut - Door bolts permanently dropped."))
			else if(isAdmin || issilicon(usr)) // controls for silicons, "stealthy" antag silicons and "stealthy" admins
				if(!src.arePowerSystemsOn()) // cannot queue actions or "speak" from unpowered doors
					to_chat(usr, SPAN_WARNING("The door is unpowered - Cannot [activate ? "drop" : "raise"] bolts."))
				else if(!ai_bolting)
					to_chat(usr, SPAN_WARNING("The door is configured not to allow remote bolt operation."))
				else if(!isnull(src.ai_action_timer))
					to_chat(usr, SPAN_WARNING("An action is already queued. Please wait for it to complete."))
				else if(activate)
					to_chat(usr, SPAN_NOTICE("The door bolts should drop in [src.ai_bolting_delay] seconds."))
					src.audible_message("[icon2html(src.icon, viewers(get_turf(src)))] <b>[src]</b> announces, <span class='notice'>\"Bolts set to drop in <strong>[src.ai_bolting_delay] seconds</strong>.\"</span>")
					src.ai_action_timer = addtimer(CALLBACK(src, PROC_REF(lock)), src.ai_bolting_delay SECONDS, TIMER_UNIQUE|TIMER_NO_HASH_WAIT|TIMER_STOPPABLE)
				else
					to_chat(usr, SPAN_NOTICE("The door bolts should raise in [src.ai_unbolt_delay] seconds."))
					src.audible_message("[icon2html(src.icon, viewers(get_turf(src)))] <b>[src]</b> announces, <span class='notice'>\"Bolts set to raise in <strong>[src.ai_unbolt_delay] seconds</strong>.\"</span>")
					src.ai_action_timer = addtimer(CALLBACK(src, PROC_REF(unlock)), src.ai_unbolt_delay SECONDS, TIMER_UNIQUE|TIMER_NO_HASH_WAIT|TIMER_STOPPABLE)
			else // everyone else
				if(activate)
					if(src.lock())
						to_chat(usr, SPAN_NOTICE("The door bolts have been dropped."))
				else
					if(src.unlock())
						to_chat(usr, SPAN_NOTICE("The door bolts have been raised."))
		if("bolts_override")
			if(isAdmin || (issilicon(usr) && antag)) // admin and silicon antag can override
				if(!isAdmin && src.isWireCut(WIRE_BOLTLIGHT)) // cut wire is noop, except for admins
					to_chat(usr, SPAN_WARNING("The door bolt control wire is cut - Door bolts permanently dropped."))
				else if(!isAdmin && !src.arePowerSystemsOn()) // door must be powered - display friendly message if not (admins can magically skip this)
					to_chat(usr, SPAN_WARNING("The door is unpowered - Cannot [activate ? "drop" : "raise"] bolts."))
				else if(activate)
					if(src.lock())
						to_chat(usr, SPAN_NOTICE("The door bolts have been dropped."))
				else
					if(src.unlock())
						to_chat(usr, SPAN_NOTICE("The door bolts have been raised."))
		if("electrify_temporary")
			if(!isAdmin && issilicon(usr) && !antag)
				to_chat(usr, SPAN_WARNING("Your programming prevents you from electrifying the door."))
			else
				electrify(30 * activate, 1)
		if("electrify_permanently")
			if(!isAdmin && issilicon(usr) && !antag && (electrified_until == 0))
				to_chat(usr, SPAN_WARNING("Your programming prevents you from electrifying the door."))
			else
				electrify(-1 * activate, 1)
		if("open")
			if(src.welded)
				to_chat(usr, SPAN_WARNING("The airlock has been welded shut!"))
			else if(src.locked)
				to_chat(usr, SPAN_WARNING("The door bolts are down!"))
			else if(!src.arePowerSystemsOn() && issilicon(usr)) // AIs get a nice notice that the door is unpowered
				to_chat(usr, SPAN_WARNING("The door is unpowered, its motors do not respond to your commands."))
			else if(activate && density)
				open()
				if (isAI(usr))
					SSstatistics.IncrementSimpleStat("AI_DOOR")
			else if(!activate && !density)
				close()
		if("safeties")
			if(!isAdmin && safe && issilicon(usr) && !antag)
				to_chat(usr, SPAN_WARNING("Your programming prevents you from disabling the door safeties."))
			else
				set_safeties(!activate, 1)
		if("timing")
			// Door speed control
			if(src.isWireCut(WIRE_TIMING))
				to_chat(usr, text("The timing wire is cut - Cannot alter timing."))
			else if (activate && src.normalspeed)
				normalspeed = FALSE
			else if (!activate && !src.normalspeed)
				normalspeed = TRUE
		if("lights")
			// Bolt lights
			if(src.isWireCut(WIRE_BOLTLIGHT))
				to_chat(usr, "The bolt lights wire is cut - The door bolt lights are permanently disabled.")
			else if (!activate && src.lights)
				lights = FALSE
				to_chat(usr, "The door bolt lights have been disabled.")
			else if (activate && !src.lights)
				lights = TRUE
				to_chat(usr, "The door bolt lights have been enabled.")
	update_icon()
	return 1

/obj/machinery/door/airlock/proc/CreateAssembly()
	var/obj/structure/door_assembly/da = new assembly_type(src.loc)
	if (istype(da, /obj/structure/door_assembly/multi_tile))
		da.set_dir(src.dir)

	da.anchored = 1
	if(mineral)
		da.glass = mineral
	else if(glass && !da.glass)
		da.glass = 1
	da.state = 1
	da.created_name = src.name
	da.update_state()
	if((stat & BROKEN))
		new /obj/item/trash/broken_electronics(src.loc)
		operating = FALSE
	else
		if (!electronics) create_electronics()
		electronics.forceMove(src.loc)
		electronics = null
	qdel(src)


/obj/machinery/door/airlock/proc/CanChainsaw(var/obj/item/material/twohanded/chainsaw/ChainSawVar)
	return (ChainSawVar.powered && density && hashatch)

/obj/machinery/door/airlock/attackby(obj/item/attacking_item, mob/user)
	if(!istype(usr, /mob/living/silicon))
		if(src.isElectrified())
			if(src.shock(user, 75))
				return TRUE
	if(istype(attacking_item, /obj/item/taperoll) || istype(attacking_item, /obj/item/rfd))
		return
	if(!istype(attacking_item, /obj/item/forensics))
		src.add_fingerprint(user)
	if (!repairing && (stat & BROKEN) && src.locked) //bolted and broken
		if (!cut_bolts(attacking_item,user))
			return ..()
		return TRUE
	if (istype(attacking_item, /obj/item/device/magnetic_lock))
		if (bracer)
			to_chat(user, SPAN_NOTICE("There is already a [bracer] on [src]!"))
			return TRUE
		var/obj/item/device/magnetic_lock/newbracer = attacking_item
		newbracer.attachto(src, user)
		return TRUE
	if(!repairing && (attacking_item.iswelder() && !( src.operating > 0 ) && src.density))
		var/obj/item/weldingtool/WT = attacking_item
		if(WT.isOn())
			user.visible_message(
				SPAN_WARNING("[user] begins welding [src] [welded ? "open" : "shut"]."),
				SPAN_NOTICE("You begin welding [src] [welded ? "open" : "shut"]."),
				"You hear a welding torch on metal."
			)
			playsound(src, 'sound/items/Welder.ogg', 50, TRUE, extrarange = SILENCED_SOUND_EXTRARANGE)
			if(!WT.use_tool(src, user, 20, volume = 50, extra_checks = CALLBACK(src, PROC_REF(is_open), src.density)))
				return TRUE
			if(!WT.use(0,user))
				to_chat(user, SPAN_NOTICE("You need more welding fuel to complete this task."))
				return TRUE
			playsound(src, 'sound/items/welder_pry.ogg', 50, TRUE, extrarange = SILENCED_SOUND_EXTRARANGE)
			welded = !welded
			update_icon()
		return TRUE
	else if(attacking_item.isscrewdriver())
		if (src.p_open)
			if (stat & BROKEN)
				to_chat(user, SPAN_WARNING("The panel is broken and cannot be closed."))
			else
				src.p_open = FALSE
				to_chat(user, SPAN_NOTICE("You tightly screw the panel on \the [src] closed."))
		else
			src.p_open = TRUE
			to_chat(user, SPAN_NOTICE("You carefully unscrew the panel on \the [src]"))
		src.update_icon()
		return TRUE
	else if(attacking_item.iswirecutter())
		return src.attack_hand(user)
	else if(attacking_item.ismultitool())
		return src.attack_hand(user)
	else if(istype(attacking_item, /obj/item/device/assembly/signaler))
		return src.attack_hand(user)
	else if(istype(attacking_item, /obj/item/device/paint_sprayer))
		return FALSE
	else if(istype(attacking_item, /obj/item/pai_cable))	// -- TLE
		var/obj/item/pai_cable/cable = attacking_item
		cable.plugin(src, user)
		return TRUE
	else if(!repairing && attacking_item.iscrowbar())
		if(istype(attacking_item, /obj/item/melee/arm_blade))
			if(arePowerSystemsOn() &&!(stat & BROKEN))
				..()
				return
		if(p_open && !operating && welded)
			if(locked)
				to_chat(user, SPAN_WARNING("The airlock bolts are in the way of the electronics, you need to raise them before you can reach them."))
				return
			user.visible_message("<b>[user]</b> starts removing the electronics from the airlock assembly.", SPAN_NOTICE("You start removing the electronics from the airlock assembly."))
			if(attacking_item.use_tool(src, user, 40, volume = 50))
				user.visible_message("<b>[user]</b> removes the electronics from the airlock assembly.", SPAN_NOTICE("You remove the electronics from the airlock assembly."))
				CreateAssembly()
				return
		else if(arePowerSystemsOn())
			to_chat(user, SPAN_NOTICE("The airlock's motors resist your efforts to force it."))
		else if(locked)
			if (istype(attacking_item, /obj/item/crowbar/robotic/jawsoflife))
				cut_bolts(attacking_item, user)
			else
				to_chat(user, SPAN_NOTICE("The airlock's bolts prevent it from being forced."))
		else
			if(density)
				open(1)
			else
				close(1)
		return TRUE
	else if(istype(attacking_item, /obj/item/material/twohanded/fireaxe) && !arePowerSystemsOn())
		if(locked && user.a_intent != I_HURT)
			to_chat(user, SPAN_NOTICE("The airlock's bolts prevent it from being forced."))
		else if(locked && user.a_intent == I_HURT)
			..()
		else if(!welded && !operating)
			if(density)
				var/obj/item/material/twohanded/fireaxe/F = attacking_item
				if(F.wielded)
					open(1)
				else
					to_chat(user, SPAN_WARNING("You need to be wielding \the [attacking_item] to do that."))
			else
				var/obj/item/material/twohanded/fireaxe/F = attacking_item
				if(F.wielded)
					close(1)
				else
					to_chat(user, SPAN_WARNING("You need to be wielding \the [attacking_item] to do that."))
		return TRUE
	else if(attacking_item.ishammer() && !arePowerSystemsOn())
		if(locked && user.a_intent != I_HURT)
			to_chat(user, SPAN_NOTICE("The airlock's bolts prevent it from being forced."))
		else if(locked && user.a_intent == I_HURT)
			..()
		else if(!welded && !operating)
			if(density)
				open(1)
			else
				close(1)
		return TRUE
	else if(density && istype(attacking_item, /obj/item/material/twohanded/chainsaw))
		var/obj/item/material/twohanded/chainsaw/ChainSawVar = attacking_item
		if(!ChainSawVar.wielded)
			to_chat(user, SPAN_NOTICE("Cutting the airlock requires the strength of two hands."))
		else if(ChainSawVar.cutting)
			to_chat(user, SPAN_NOTICE("You are already cutting an airlock open."))
		else if(!ChainSawVar.powered)
			to_chat(user, SPAN_NOTICE("The [attacking_item] needs to be on in order to open this door."))
		else if(bracer) //Has a magnetic lock
			to_chat(user, SPAN_NOTICE("The bracer needs to be removed in order to cut through this door."))
		else if(!arePowerSystemsOn())
			ChainSawVar.cutting = 1
			user.visible_message(\
				SPAN_DANGER("[user.name] starts cutting the control pannel of the airlock with the [attacking_item]!"),\
				SPAN_WARNING("You start cutting the airlock control panel..."),\
				SPAN_NOTICE("You hear a loud buzzing sound and metal grinding on metal...")\
			)
			if(do_after(user, ChainSawVar.opendelay SECONDS, extra_checks = CALLBACK(src, PROC_REF(CanChainsaw), attacking_item)))
				user.visible_message(\
					SPAN_WARNING("[user.name] finishes cutting the control pannel of the airlock with the [attacking_item]."),\
					SPAN_WARNING("You finish cutting the airlock control panel."),\
					SPAN_NOTICE("You hear a metal clank and some sparks.")\
				)
				set_broken()
				sleep(1 SECONDS)
				CreateAssembly()
			ChainSawVar.cutting = 0
			take_damage(50)
		else if(locked)
			ChainSawVar.cutting = 1
			user.visible_message(\
				SPAN_DANGER("[user.name] starts cutting below the airlock with the [attacking_item]!"),\
				SPAN_WARNING("You start cutting below the airlock..."),\
				SPAN_NOTICE("You hear a loud buzzing sound and metal grinding on metal...")\
			)
			if(do_after(user, ChainSawVar.opendelay SECONDS, extra_checks = CALLBACK(src, PROC_REF(CanChainsaw), attacking_item)))
				user.visible_message(\
					SPAN_WARNING("[user.name] finishes cutting below the airlock with the [attacking_item]."),\
					SPAN_NOTICE("You finish cutting below the airlock."),\
					SPAN_NOTICE("You hear a metal clank and some sparks.")\
				)
				unlock(1)
			ChainSawVar.cutting = 0
			take_damage(50)
		else
			ChainSawVar.cutting = 1
			user.visible_message(\
				SPAN_DANGER("[user.name] starts cutting between the airlock with the [attacking_item]!"),\
				SPAN_WARNING("You start cutting between the airlock..."),\
				SPAN_NOTICE("You hear a loud buzzing sound and metal grinding on metal...")\
			)
			if(do_after(user, ChainSawVar.opendelay SECONDS, extra_checks = CALLBACK(src, PROC_REF(CanChainsaw), attacking_item)))
				user.visible_message(\
					SPAN_WARNING("[user.name] finishes cutting between the airlock."),\
					SPAN_WARNING("You finish cutting between the airlock."),\
					SPAN_NOTICE("You hear a metal clank and some sparks.")\
				)
				open(1)
				take_damage(50)
			ChainSawVar.cutting = 0
		return TRUE
	else
		return ..()

/obj/machinery/door/airlock/phoron/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item)
		ignite(is_hot(attacking_item))
	return ..()

/obj/machinery/door/airlock/set_broken()
	src.p_open = TRUE
	stat |= BROKEN
	if (secured_wires)
		lock()
	for (var/mob/O in viewers(src, null))
		if ((O.client && !( O.blinded )))
			O.show_message("[src.name]'s control panel bursts open, sparks spewing out!")

	spark(src, 5, GLOB.alldirs)

	update_icon()
	return

/obj/machinery/door/airlock/open(var/forced=0)
	if(!can_open(forced))

		return 0
	use_power_oneoff(360)	//360 W seems much more appropriate for an actuator moving an industrial door capable of crushing people

	//if the door is unpowered then it doesn't make sense to hear the woosh of a pneumatic actuator
	if(!forced && arePowerSystemsOn())
		playsound(src.loc, open_sound_powered, 50, FALSE, extrarange = SHORT_RANGE_SOUND_EXTRARANGE)
	else
		playsound(src.loc, open_sound_unpowered, 70, FALSE, extrarange = SHORT_RANGE_SOUND_EXTRARANGE)

	if(src.close_other != null && istype(src.close_other, /obj/machinery/door/airlock/) && !src.close_other.density)
		src.close_other.close()
	return ..()

/obj/machinery/door/airlock/can_open(var/forced=0)
	if(!forced)
		if(!arePowerSystemsOn() || isWireCut(WIRE_OPEN))
			return 0
	if (bracer)
		do_animate("brace")
		visible_message(SPAN_WARNING("[src]'s actuators whirr, but the door does not open."))
		return 0
	if(locked || welded)
		return 0
	return ..()

/obj/machinery/door/airlock/can_close(var/forced=0)
	if(locked || welded)
		return 0
	if(!forced)
		//despite the name, this wire is for general door control.
		if(!arePowerSystemsOn() || isWireCut(WIRE_OPEN))
			return	0
	return ..()

/atom/movable/proc/blocks_airlock()
	return density

/obj/machinery/door/blocks_airlock()
	return 0

/obj/structure/window/blocks_airlock()
	return 0

/obj/machinery/mech_sensor/blocks_airlock()
	return 0

/mob/living/blocks_airlock()
	// if this returns false, a mob can be crushed by airlock
	// cat is 2.5, corgi is 3.5, fox is 4, human is 9
	return mob_size > 2.4

/atom/movable/proc/airlock_crush(var/crush_damage)
	return 0

/obj/structure/window/airlock_crush(var/crush_damage)
	return 0

/obj/machinery/portable_atmospherics/canister/airlock_crush(var/crush_damage)
	. = ..()
	health -= crush_damage
	healthcheck()

/obj/effect/energy_field/airlock_crush(var/crush_damage)
	Stress(crush_damage)

/obj/structure/closet/airlock_crush(var/crush_damage)
	..()
	damage(crush_damage)
	for(var/atom/movable/AM in src)
		AM.airlock_crush()
	return 1

/mob/living/airlock_crush(var/crush_damage)
	. = ..()
	for(var/i = 1, i <= AIRLOCK_CRUSH_DIVISOR, i++)
		apply_damage((crush_damage / AIRLOCK_CRUSH_DIVISOR), DAMAGE_BRUTE)

	SetStunned(5)
	SetWeakened(5)
	visible_message(SPAN_DANGER("[src] is crushed in the airlock!"), SPAN_DANGER("You are crushed in the airlock!"), SPAN_NOTICE("You hear airlock actuators momentarily struggle."))

	var/turf/T = loc
	if(istype(T))
		var/list/valid_turfs = list()
		for(var/dir_to_test in GLOB.cardinal)
			var/turf/new_turf = get_step(T, dir_to_test)
			if(!new_turf.contains_dense_objects())
				valid_turfs |= new_turf

		while(valid_turfs.len)
			T = pick(valid_turfs)
			valid_turfs -= T

			if(src.forceMove(T))
				return

/mob/living/carbon/airlock_crush(var/crush_damage)
	. = ..()
	emote("scream")

/mob/living/silicon/robot/airlock_crush(var/crush_damage)
	return ..(round(crush_damage / CYBORG_AIRLOCKCRUSH_RESISTANCE))

/obj/machinery/door/airlock/close(var/forced=0)
	if(!can_close(forced))
		return 0
	if(safe)
		for(var/turf/turf in locs)
			for(var/atom/movable/AM in turf)
				if(AM.blocks_airlock())
					if(world.time > next_beep_at)
						playsound(src.loc, close_failure_blocked, 30, FALSE, extrarange = SHORT_RANGE_SOUND_EXTRARANGE)
						next_beep_at = world.time + SecondsToTicks(20)
					close_door_in(6)
					return
	var/has_opened_hatch = FALSE
	for(var/turf/turf in locs)
		for(var/atom/movable/AM in turf)
			if(hashatch && AM.checkpass(PASSDOORHATCH))
				if(!has_opened_hatch)
					open_hatch(AM)
				has_opened_hatch = TRUE
			else if(AM.airlock_crush(DOOR_CRUSH_DAMAGE))
				take_damage(DOOR_CRUSH_DAMAGE)
	use_power_oneoff(360)	//360 W seems much more appropriate for an actuator moving an industrial door capable of crushing people
	if(arePowerSystemsOn())
		playsound(src.loc, close_sound_powered, 100, TRUE, extrarange = SHORT_RANGE_SOUND_EXTRARANGE)
	else
		playsound(src.loc, close_sound_unpowered, 100, TRUE, extrarange = SHORT_RANGE_SOUND_EXTRARANGE)

	..()

/obj/machinery/door/airlock/proc/lock(var/forced=0)
	if(!isnull(src.ai_action_timer)) // reset AI action timer no matter if it finished
		deltimer(src.ai_action_timer)
		src.ai_action_timer = null
	if(locked)
		return 0
	if (operating && !forced) return 0
	if (bolt_cut_state == BOLTS_CUT) return 0 //what bolts?
	src.locked = TRUE
	playsound(src, bolts_dropping, 30, 0, extrarange = SILENCED_SOUND_EXTRARANGE)
	update_icon()
	return 1

/obj/machinery/door/airlock/proc/unlock(var/forced=0)
	if(!isnull(src.ai_action_timer)) // reset AI action timer no matter if it finished
		deltimer(src.ai_action_timer)
		src.ai_action_timer = null
	if(!src.locked)
		return
	if (!forced)
		if(operating || !src.arePowerSystemsOn() || isWireCut(WIRE_BOLTS)) return
	src.locked = FALSE
	playsound(src, bolts_rising, 30, 0, extrarange = SILENCED_SOUND_EXTRARANGE)
	update_icon()
	return 1

/obj/machinery/door/airlock/allowed(mob/M)
	if(locked)
		return 0
	return ..(M)

// Most doors will never be deconstructed over the course of a round,
// so as an optimization defer the creation of electronics until
// the airlock is deconstructed
/obj/machinery/door/airlock/proc/create_electronics()
	//create new electronics
	if (secured_wires)
		src.electronics = new/obj/item/airlock_electronics/secure( src.loc )
	else
		src.electronics = new/obj/item/airlock_electronics( src.loc )

	//update the electronics to match the door's access
	if(!src.req_access)
		src.check_access()
	if(LAZYLEN(req_access))
		electronics.conf_access = src.req_access
	else if (LAZYLEN(req_one_access))
		electronics.conf_access = src.req_one_access
		electronics.one_access = 1

/obj/machinery/door/airlock/emp_act(var/severity)
	. = ..()

	if(prob(40/severity))
		var/duration = SecondsToTicks(30 / severity)
		if(electrified_until > -1 && (duration + world.time) > electrified_until)
			electrify(duration)

/obj/machinery/door/airlock/power_change() //putting this is obj/machinery/door itself makes non-airlock doors turn invisible for some reason
	..()
	if(stat & NOPOWER)
		// If we lost power, disable electrification
		// Keeping door lights on, runs on internal battery or something.
		electrified_until = 0
		//if we lost power open 'er up
		if(insecure)
			INVOKE_ASYNC(src, TYPE_PROC_REF(/obj/machinery/door, open), 1)
			securitylock = TRUE
	else if(securitylock)
		INVOKE_ASYNC(src, TYPE_PROC_REF(/obj/machinery/door, close), 1)
		securitylock = FALSE
	update_icon()

/obj/machinery/door/airlock/proc/prison_open()
	if(bracer)
		return

	if(arePowerSystemsOn())
		src.unlock()
		src.open()
		src.lock()
	return

/obj/machinery/door/airlock/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if (bolt_cut_state == BOLTS_EXPOSED)
		. += SPAN_WARNING("The bolt cover has been cut open.")
	if (bolt_cut_state == BOLTS_CUT)
		. += SPAN_WARNING("The door bolts have been cut.")
	if(bracer)
		. += SPAN_WARNING("\The [bracer] is installed on \the [src], preventing it from opening.")
		. +=  bracer.health
	if(p_open)
		. += SPAN_NOTICE("\The [src]'s maintenance panel has been unscrewed and is hanging open.")
	if(islist(access_by_level) || islist(req_one_access_by_level))
		. +=  SPAN_NOTICE("This airlock changes access requirements depending on the level.")

/obj/machinery/door/airlock/emag_act(var/remaining_charges)
	. = ..()
	lock(1)

#undef AIRLOCK_CRUSH_DIVISOR
#undef CYBORG_AIRLOCKCRUSH_RESISTANCE
#undef BOLTS_FINE
#undef BOLTS_EXPOSED
#undef BOLTS_CUT
