#define CYBORG_POWER_USAGE_MULTIPLIER 2.5 // Multiplier for amount of power cyborgs use.

// I'm leaving my name here because FUCK making this look good was hard. - Geeves
// And it still looks shit!!
/mob/living/silicon/robot
	// Look and feel
	name = "Cyborg"
	real_name = "Cyborg"
	var/braintype = "Cyborg"
	icon = 'icons/mob/robots.dmi'
	icon_state = "robot"
	var/icontype 				//Persistent icontype tracking allows for cleaner icon updates
	var/chassistype				// Custom model icon. Also can be used to re-use icons to prevent copypasta, provided you listed them correctly in the list
	var/paneltype				// Same as above, but for maintenance panel.
	var/eyetype					// Same as above, but for eyes.
	var/module_sprites[0] 		//Used to store the associations between sprite names and sprite index.
	var/icon_selected = 0		//If icon selection has been completed yet
	var/spawn_sound = 'sound/voice/liveagain.ogg'
	var/pitch_toggle = TRUE
	var/datum/effect_system/ion_trail/ion_trail
	var/datum/effect_system/sparks/spark_system

	// Wiring
	var/datum/wires/robot/wires
	var/wires_exposed = FALSE

	// Health and interaction
	maxHealth = 200
	health = 200
	mob_size = 16 //robots are heavy
	mob_bump_flag = ROBOT
	mob_swap_flags = ROBOT|MONKEY|SLIME|SIMPLE_ANIMAL
	mob_push_flags = ~HEAVY //trundle trundle
	var/speed = 0

	// Lighting and sight
	light_wedge = LIGHT_WIDE
	var/lights_on = FALSE // Is our integrated light on?
	var/intense_light = FALSE	// Whether cyborg's integrated light was upgraded
	var/sight_mode = NO_HUD
	var/tracking_entities = 0 //The number of known entities currently accessing the internal camera

	// Power use
	var/has_power = TRUE
	var/integrated_light_power = 4
	var/cell_emp_mult = 2
	var/used_power_this_tick = 0 // How much power we used on this tick. Not a boolean.
	var/lock_charge //Used when locking down a borg to preserve cell charge

	// Custom sprites and names
	var/custom_name = ""
	var/custom_sprite = FALSE //Due to all the sprites involved, a var for our custom borgs may be best

	// Malf variables
	var/crisis = FALSE //Admin-settable for combat module use.
	var/crisis_override = FALSE
	var/malf_AI_module = FALSE
	var/flash_resistant = FALSE
	var/overclocked = FALSE // cyborg controls if they enable the overclock
	var/overclock_available = FALSE // if the overclock is available for use

	// HUD Stuff
	var/obj/screen/inv1
	var/obj/screen/inv2
	var/obj/screen/inv3
	var/shown_robot_modules = FALSE //Used to determine whether they have the module menu shown or not
	var/obj/screen/robot_modules_background

	// Modules and active items
	var/mod_type = "Default"
	var/spawn_module // Which module does this robot use when it spawns in?
	var/selecting_module = FALSE //whether the borg is in process of selecting its module or not.
	var/obj/item/robot_module/module
	var/obj/item/module_active
	var/obj/item/module_state_1
	var/obj/item/module_state_2
	var/obj/item/module_state_3
	var/cell_type = /obj/item/cell/high
	var/has_jetpack = FALSE
	var/has_pda = TRUE

	// Internal components (non-datum)
	var/obj/item/cell/cell
	var/obj/item/device/radio/borg/radio
	var/obj/machinery/camera/camera
	var/obj/item/device/mmi/mmi
	var/obj/item/stock_parts/matter_bin/storage
	var/obj/item/tank/jetpack/carbondioxide/synthetic/jetpack

	// Internal components (datum)
	var/list/components = list()
	var/datum/robot_component/jetpackComponent
	var/datum/robot_component/actuatorComponent

	// Hatches and emags
	var/opened = FALSE
	var/emagged = FALSE
	var/fake_emagged = FALSE //for dumb illegal weapons module
	var/locked = TRUE

	// Laws
	var/mob/living/silicon/ai/connected_ai
	var/law_preset = /datum/ai_laws/nanotrasen
	var/law_update = TRUE // Whether they sync with their AI or not.

	// Access
	var/list/req_access = list(ACCESS_ROBOTICS)
	var/key_type
	var/scrambled_codes = FALSE // When true, doesn't show up on robotics console.

	id_card_type = /obj/item/card/id/synthetic/cyborg

	// Alerts
	var/view_alerts = FALSE

	var/self_destructing = FALSE

	// Killswitch
	var/killswitch = FALSE
	var/killswitch_time = 60

	// Weapon lock
	var/weapon_lock = FALSE
	var/weapon_lock_time = 120

	// Verbs
	var/list/robot_verbs_default = list(
		/mob/living/silicon/robot/proc/sensor_mode,
		/mob/living/silicon/robot/proc/robot_checklaws
	)

	// Overlays
	var/has_cut_eye_overlay
	var/image/eye_overlay
	var/list/image/cached_eye_overlays
	var/image/panel_overlay
	var/list/image/cached_panel_overlays
	var/image/shield_overlay
	var/datum/weakref/holo_map

/mob/living/silicon/robot/Initialize(mapload, unfinished = FALSE)
	spark_system = bind_spark(src, 5)
	add_language(LANGUAGE_ROBOT, TRUE)
	add_language(LANGUAGE_EAL, TRUE)

	wires = new(src)

	robot_modules_background = new()
	robot_modules_background.icon_state = "block"
	robot_modules_background.layer = HUD_BASE_LAYER
	updatename(mod_type)

	if(!client)
		set_stat(UNCONSCIOUS)

	if(mmi?.brainobj)
		mmi.brainobj.prepared = TRUE
		mmi.brainmob.name = src.name
		mmi.brainmob.real_name = src.name
		mmi.name = "[initial(mmi.name)]: [src.name]"

	radio = new /obj/item/device/radio/borg(src)
	common_radio = radio

	if(!camera)
		camera = new /obj/machinery/camera(src, 0, TRUE, TRUE)
		camera.c_tag = real_name
		if(!scrambled_codes)
			camera.replace_networks(list(NETWORK_STATION, NETWORK_ROBOTS))
		else
			camera.replace_networks(list(NETWORK_MERCENARY))
		if(wires.is_cut(WIRE_CAMERA))
			camera.status = FALSE

	init()
	initialize_components()
	setup_icon_cache()

	for(var/V in components)
		if(V != "power cell" && V != "jetpack" && V != "surge") //We don't install the jetpack onstart
			var/datum/robot_component/C = components[V]
			C.installed = TRUE
			C.wrapped = new C.external_type

	if(!cell)
		cell = new cell_type(src)

	. = ..()

	if(cell)
		var/datum/robot_component/cell_component = components["power cell"]
		cell_component.wrapped = cell
		cell_component.installed = TRUE

	add_robot_verbs()

	hud_list[HEALTH_HUD]      = new /image/hud_overlay('icons/mob/hud_med.dmi', src, "100")
	hud_list[STATUS_HUD]      = new /image/hud_overlay('icons/mob/hud.dmi', src, "hudhealth100")
	hud_list[LIFE_HUD]        = new /image/hud_overlay('icons/mob/hud.dmi', src, "hudhealth100")
	hud_list[ID_HUD]          = new /image/hud_overlay('icons/mob/hud.dmi', src, "hudblank")
	hud_list[WANTED_HUD]      = new /image/hud_overlay('icons/mob/hud.dmi', src, "hudblank")
	hud_list[IMPLOYAL_HUD]    = new /image/hud_overlay('icons/mob/hud.dmi', src, "hudblank")
	hud_list[IMPCHEM_HUD]     = new /image/hud_overlay('icons/mob/hud.dmi', src, "hudblank")
	hud_list[IMPTRACK_HUD]    = new /image/hud_overlay('icons/mob/hud.dmi', src, "hudblank")
	hud_list[SPECIALROLE_HUD] = new /image/hud_overlay('icons/mob/hud.dmi', src, "hudblank")

/mob/living/silicon/robot/proc/update_access()
	if(emagged || malf_AI_module || crisis)
		id_card.access = get_all_station_access() + ACCESS_EQUIPMENT // Give full station access
		return

	id_card = new id_card_type()

	if(module)
		if(module.all_access)
			id_card.access = get_all_station_access() + ACCESS_EQUIPMENT // Give full station access
			return

		for(var/job_type in module.specialized_access_types)
			var/datum/job/job = new job_type()
			id_card.access |= job.access

		to_chat(src, SPAN_NOTICE("Access set to the department the role belongs to."))

/mob/living/silicon/robot/proc/recalculate_synth_capacities()
	if(!module?.synths)
		return
	var/mult = 1
	if(storage)
		mult += storage.rating
	for(var/datum/matter_synth/M in module.synths)
		M.set_multiplier(mult)
	for(var/obj/item/stack/SM in module.modules)
		SM.update_icon()

	update_access()

/mob/living/silicon/robot/proc/init()
	ai_camera = new /obj/item/device/camera/siliconcam/robot_camera(src)
	laws = new law_preset()
	if(spawn_module)
		new spawn_module(src, src)
	if(key_type)
		radio.keyslot = new key_type(radio)
		INVOKE_ASYNC(radio, TYPE_PROC_REF(/obj/item/device/radio/borg, recalculateChannels))
	if(law_update)
		var/new_ai = select_active_ai_with_fewest_borgs()
		if(new_ai)
			law_update = TRUE
			connect_to_ai(new_ai)
		else
			law_update = FALSE
	if(has_jetpack)
		jetpack = new /obj/item/tank/jetpack/carbondioxide/synthetic(src)

	playsound(get_turf(src), spawn_sound, 75, pitch_toggle, ignore_walls = FALSE)

/mob/living/silicon/robot/SetName(pickedName as text)
	custom_name = pickedName
	updatename()

/mob/living/silicon/robot/proc/sync()
	if(law_update && connected_ai)
		lawsync()
		photosync()

/mob/living/silicon/robot/drain_power(var/drain_check, var/surge, var/amount = 0)
	if(drain_check)
		return TRUE

	if(!cell?.charge)
		return FALSE

	// Actual amount to drain from cell, using CELLRATE
	var/cell_amount = amount * CELLRATE

	if(cell.charge > cell_amount)
		// Spam Protection
		if(prob(10))
			to_chat(src, SPAN_DANGER("Warning: Unauthorized access through power channel [rand(11,29)] detected!"))
		cell.use(cell_amount)
		return amount
	return FALSE

//If there's an MMI in the robot, have it ejected when the mob goes away. --NEO
//Improved /N
/mob/living/silicon/robot/Destroy()
	if(mmi && mind)//Safety for when a cyborg gets dust()ed. Or there is no MMI inside.
		var/turf/T = get_turf(src)//To hopefully prevent run time errors.
		if(T)
			mmi.forceMove(T)
		if(mmi.brainmob)
			mind.transfer_to(mmi.brainmob)
		else
			to_chat(src, SPAN_DANGER("Oops! Something went very wrong, your MMI was unable to receive your mind. You have been ghosted. Please make a bug report so we can fix this bug."))
			ghostize()
			LOG_DEBUG("A borg has been destroyed, but its MMI lacked a brainmob, so the mind could not be transferred. Player: [ckey].")
		mmi = null
	if(connected_ai)
		connected_ai.connected_robots -= src
	QDEL_NULL(wires)
	QDEL_NULL(spark_system)
	return ..()

/mob/living/silicon/robot/proc/set_module_sprites(var/list/new_sprites)
	if(new_sprites && length(new_sprites))
		module_sprites = new_sprites.Copy()
		//Custom_sprite check and entry

		if(custom_sprite)
			var/datum/custom_synth/sprite = robot_custom_icons[name]
			var/list/valid_states = icon_states(CUSTOM_ITEM_SYNTH)
			var/custom_iconpath = "[sprite.synthicon]-[mod_type]"
			if(custom_iconpath in valid_states)
				module_sprites["Custom"] = list(
					ROBOT_CHASSIS = custom_iconpath,
					ROBOT_EYES = custom_iconpath,
					ROBOT_PANEL = custom_iconpath,
					ROBOT_ICON = CUSTOM_ITEM_SYNTH
					)
				icon = CUSTOM_ITEM_SYNTH
				icontype = "Custom"
			else
				icontype = module_sprites[1]
				icon = 'icons/mob/robots.dmi'
				to_chat(src, SPAN_WARNING("Custom Sprite Sheet does not contain a valid icon_state for [sprite.synthicon]-[mod_type]"))
		else
			icontype = module_sprites[1]
		icon_state = module_sprites?[icontype]?[ROBOT_CHASSIS]
	return module_sprites

/mob/living/silicon/robot/proc/pick_module(var/set_module)
	if(selecting_module)
		return
	selecting_module = TRUE
	if(module)
		selecting_module = FALSE
		return
	var/list/modules = list()
	modules.Add(GLOB.robot_module_types)
	if((crisis_override && GLOB.security_level == SEC_LEVEL_RED) || GLOB.security_level == SEC_LEVEL_DELTA || crisis == TRUE)
		to_chat(src, SPAN_WARNING("Crisis mode active. Combat module available."))
		modules += "Combat"
	mod_type = tgui_input_list(src, "Please, select a module!", "Robot", modules)

	if(module)
		selecting_module = FALSE
		return
	if(!(mod_type in robot_modules))
		selecting_module = FALSE
		return

	var/module_type = robot_modules[mod_type]
	playsound(get_turf(src), 'sound/effects/pop.ogg', 100, TRUE)
	spark(get_turf(src), 5, GLOB.alldirs)

	new module_type(src, src) // i have no choice but to do this, due to how funky initialize is

	hands.icon_state = lowertext(mod_type)
	feedback_inc("cyborg_[lowertext(mod_type)]", 1)
	updatename()
	recalculate_synth_capacities()
	notify_ai(ROBOT_NOTIFICATION_NEW_MODULE, module.name)
	SSrecords.reset_manifest()
	selecting_module = FALSE
	setup_icon_cache()

/mob/living/silicon/robot/proc/updatename(var/prefix as text)
	if(prefix)
		mod_type = prefix

	if(istype(mmi, /obj/item/device/mmi/digital/posibrain))
		braintype = "Android"
	else if(istype(mmi, /obj/item/device/mmi/digital/robot))
		braintype = "Robot"
	else
		braintype = "Cyborg"

	var/changed_name = ""
	if(custom_name)
		changed_name = custom_name
		notify_ai(ROBOT_NOTIFICATION_NEW_NAME, real_name, changed_name)
	else
		changed_name = "[mod_type] [braintype]-[rand(1, 999)]"

	set_name(changed_name, prefix)

	if(!custom_sprite) //Check for custom sprite
		set_custom_sprite()
		setup_icon_cache()

	//Flavour text.
	if(client)
		var/module_flavour = client.prefs.flavour_texts_robot[mod_type]
		if(module_flavour)
			flavor_text = module_flavour
		else
			flavor_text = client.prefs.flavour_texts_robot["Default"]

/mob/living/silicon/robot/verb/Namepick()
	set category = "Robot Commands"

	spawn(0)
		var/newname
		newname = sanitizeSafe(input(src, "You are a robot. Enter a name, or leave blank for the default name.", "Name change") as text, MAX_NAME_LEN)
		if(newname)
			custom_name = newname

		updatename()
		if(custom_sprite && module)
			set_module_sprites(module.sprites) // custom synth icons
		SSrecords.reset_manifest()

// this verb lets cyborgs see the stations manifest
/mob/living/silicon/robot/verb/cmd_station_manifest()
	set category = "Robot Commands"
	set name = "Show Crew Manifest"
	SSrecords.open_manifest_tgui(usr)

/mob/living/silicon/robot/proc/self_diagnosis()
	if(!is_component_functioning("diagnosis unit"))
		return null

	var/dat = "<HEAD><TITLE>[src.name] Self-Diagnosis Report</TITLE></HEAD><BODY>\n"
	for(var/V in components)
		var/datum/robot_component/C = components[V]
		dat += "<b>[capitalize_first_letters(C.name)]</b><br><table><tr><td>Brute Damage:</td><td>[C.brute_damage]</td></tr><tr><td>Electronics Damage:</td><td>[C.electronics_damage]</td></tr><tr><td>Powered:</td><td>[(!C.idle_usage || C.is_powered()) ? "Yes" : "No"]</td></tr><tr><td>Toggled:</td><td>[ C.toggled ? "Yes" : "No"]</td></table>"

	return dat

/mob/living/silicon/robot/proc/toggle_overclock()
	set category = "Syndicate"
	set name = "Toggle Overclock"
	set desc = "Enable an overclocking of your systems, greatly increasing the power available to your modules."

	if(overclock_available)
		if(!overclocked)
			overclocked = TRUE
			ToggleOverClock(src)
			to_chat(usr, SPAN_NOTICE("You enable the overclock mode enhancing and unlocking several modules but increasing power usage greatly."))
		else
			overclocked = FALSE
			ToggleOverClock(src)
			to_chat(usr, SPAN_NOTICE("You disable the overclock mode."))

/mob/living/silicon/robot/proc/ToggleOverClock(var/mob/living/silicon/robot/R)
	if(!R)
		return
	if(!overclocked)
		//Give them the hacked item if they don't have it.
		if(!emagged)
			R.emagged = TRUE
			R.fake_emagged = FALSE
		//Hide them from the robotics console.
		if(!scrambled_codes)
			scrambled_codes = TRUE
		//Increase EMP protection.
		cell_emp_mult = 1
	if(overclocked)
		//Show them on the robotics console.
		if(scrambled_codes)
			scrambled_codes = FALSE
		//Reduce EMP protection
		cell_emp_mult = initial(cell_emp_mult)

/mob/living/silicon/robot/verb/toggle_lights()
	set category = "Robot Commands"
	set name = "Toggle Lights"

	lights_on = !lights_on
	to_chat(usr, SPAN_NOTICE("You [lights_on ? "enable" : "disable"] your integrated light."))
	update_robot_light()

/mob/living/silicon/robot/verb/self_diagnosis_verb()
	set category = "Robot Commands"
	set name = "Self Diagnosis"

	if(!is_component_functioning("diagnosis unit"))
		to_chat(src, SPAN_WARNING("WARNING: Self-diagnosis component malfunctioning!"))
		return

	var/datum/robot_component/CO = get_component("diagnosis unit")
	if(!cell_use_power(CO.active_usage))
		to_chat(src, SPAN_WARNING("WARNING: Power too low for self-diagnostic functions."))
		return
	var/dat = self_diagnosis()
	src << browse(dat, "window=robotdiagnosis")

/mob/living/silicon/robot/verb/toggle_component()
	set category = "Robot Commands"
	set name = "Toggle Component"
	set desc = "Toggle a component, conserving power."

	var/list/installed_components = list()
	for(var/V in components)
		if(V == "power cell")
			continue
		var/datum/robot_component/C = components[V]
		if(C.installed)
			installed_components += V

	var/toggle = tgui_input_list(src, "Which component do you want to toggle?", "Toggle Component", installed_components)
	if(!toggle)
		return

	var/datum/robot_component/C = components[toggle]
	to_chat(src, SPAN_NOTICE("You [C.toggled ? "disable" : "enable"] [C.name]."))
	C.toggled = !C.toggled

/mob/living/silicon/robot/verb/rebuild_overlays()
	set category = "Robot Commands"
	set name = "Rebuild Overlays"
	set desc = "An OOC tool that rebuilds your overlays, useful if your talk bubble gets stuck to you."

	cut_overlays()
	handle_panel_overlay()
	set_intent(a_intent)

/obj/item/robot_module/janitor/verb/toggle_mop()
	set category = "Robot Commands"
	set name = "Toggle Mop"
	set desc = "Toggle the integrated mop."
	set src in usr

	mopping = !mopping
	if(mopping)
		usr.visible_message(SPAN_NOTICE("[usr]'s integrated mopping system rumbles to life."), SPAN_NOTICE("You enable your integrated mopping system."))
		playsound(usr, 'sound/machines/hydraulic_long.ogg', 100, 1)
	else
		usr.visible_message(SPAN_NOTICE("[usr]'s integrated mopping system putters before turning off."), SPAN_NOTICE("You disable your integrated mopping system."))

/mob/living/silicon/robot/proc/update_robot_light()
	if(lights_on)
		if(intense_light)
			set_light(integrated_light_power * 2, 1)
		else
			set_light(integrated_light_power)
	else
		set_light(0)
	setup_eye_cache() //update eyes

/mob/living/silicon/robot/proc/show_access()
	if(!module)
		. = "Access Type: Assistant Level"
	else
		. = "Access Type: [module.all_access ? "All Access" : "Role Specific"]"

/mob/living/silicon/robot/get_status_tab_items()
	. = ..()
	if(cell)
		. += "Charge Left: [round(cell.percent())]%"
		. += "Cell Rating: [round(cell.maxcharge)]" // Round just in case we somehow get crazy values
		. += "Power Cell Load: [round(used_power_this_tick)]W"
	else
		. += "No Cell Inserted!"

	. += show_access()

	if(jetpack)
		. += "Internal Atmosphere Info: [jetpack.name]"
		. += "Tank Pressure: [jetpack.air_contents.return_pressure()]"
	. += "Lights: [lights_on ? "ON" : "OFF"]"
	if(module)
		for(var/datum/matter_synth/ms in module.synths)
			. += "[ms.name]: [ms.energy]/[ms.max_energy_multiplied]"

/mob/living/silicon/robot/restrained()
	return FALSE

/mob/living/silicon/robot/bullet_act(var/obj/item/projectile/Proj)
	..(Proj)
	if(prob(75) && Proj.damage > 0)
		spark_system.queue()
	return 2

/mob/living/silicon/robot/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/handcuffs)) // fuck i don't even know why isrobot() in handcuff code isn't working so this will have to do
		return

	if(opened) // Are they trying to insert something?
		if(istype(attacking_item, /obj/item/robot_parts/robot_component/jetpack)) //If they're inserting a jetpack, check that this chassis allows it.
			if(!src.module || !(attacking_item.type in src.module.supported_upgrades))
				to_chat(user, SPAN_WARNING("\The [src]'s module does not support a jetpack."))
				return

		for(var/V in components)
			var/datum/robot_component/C = components[V]
			if(!C.installed && istype(attacking_item, C.external_type))
				C.wrapped = attacking_item
				C.install()
				user.drop_item()
				attacking_item.loc = null

				var/obj/item/robot_parts/robot_component/WC = attacking_item
				if(istype(WC))
					C.brute_damage = WC.brute
					C.electronics_damage = WC.burn

				to_chat(user, SPAN_NOTICE("You install the [attacking_item.name] into \the [src]."))
				handle_panel_overlay()
				return

		if(istype(attacking_item, /obj/item/gripper)) //Code for allowing cyborgs to use rechargers
			var/obj/item/gripper/gripper = attacking_item
			if(!wires_exposed)
				var/datum/robot_component/cell_component = components["power cell"]
				if(cell)
					if(gripper.grip_item(cell, user))
						cell.update_icon()
						cell.add_fingerprint(user)
						to_chat(user, SPAN_NOTICE("You remove \the [cell]."))
						cell = null
						cell_component.wrapped = null
						cell_component.installed = FALSE
						handle_panel_overlay()
				else if(cell_component.installed == -1)
					if(gripper.grip_item(cell_component.wrapped, user))
						cell_component.wrapped = null
						cell_component.installed = 0
						to_chat(user, SPAN_NOTICE("You remove \the [cell_component.wrapped]."))
	if(user.a_intent == I_HELP)
		if(attacking_item.iswelder())
			if(src == user)
				to_chat(user, SPAN_WARNING("You lack the reach to be able to repair yourself."))
				return
			if(!getBruteLoss())
				to_chat(user, SPAN_WARNING("There is nothing to fix here!"))
				return
			var/obj/item/weldingtool/WT = attacking_item
			if(!WT.welding)
				to_chat(user, SPAN_WARNING("Your welding tool is not lit!")) // it aint lit fam :fire:
				return
			if(WT.use(1))
				user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
				adjustBruteLoss(-30)
				updatehealth()
				add_fingerprint(user)
				visible_message(SPAN_WARNING("\The [user] has fixed some of the dents on \the [src]!"))
				return
		else if(attacking_item.iscoil() && (wires_exposed || istype(src,/mob/living/silicon/robot/drone)))
			if(!getFireLoss())
				to_chat(user, SPAN_WARNING("There is nothing to fix here!"))
				return
			var/obj/item/stack/cable_coil/coil = attacking_item
			if(coil.use(2))
				user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
				adjustFireLoss(-30)
				updatehealth()
				visible_message(SPAN_WARNING("\The [user] has fixed some of the burnt wires on \the [src]!"))
				return
		else if(attacking_item.iscrowbar())	// crowbar means open or close the cover
			if(opened)
				if(cell)
					user.visible_message(SPAN_NOTICE("\The [user] begins clasping shut \the [src]'s maintenance hatch."), SPAN_NOTICE("You begin closing up \the [src]'s maintenance hatch."))
					if(attacking_item.use_tool(src, user, 50, volume = 50))
						if(!Adjacent(user))
							to_chat(user, SPAN_WARNING("You are too far from \the [src] to close its hatch."))
							return
						to_chat(user, SPAN_NOTICE("You close \the [src]'s maintenance hatch."))
						opened = FALSE
						handle_panel_overlay()
				else if(wires_exposed && wires.is_all_cut())
					//Cell is out, wires are exposed, remove MMI, produce damaged chassis, baleet original mob.
					if(!mmi)
						to_chat(user, SPAN_WARNING("\The [src] has no brain to remove.")) // me irl - geeves
						return
					user.visible_message(SPAN_NOTICE("\The [user] begins ripping \the [mmi] from \the [src]."), SPAN_NOTICE("You jam the crowbar into the robot and begin levering out \the [mmi]."))
					if(attacking_item.use_tool(src, user, 50, volume = 50))
						to_chat(user, SPAN_NOTICE("You damage some parts of the chassis, but eventually manage to rip out \the [mmi]!"))
						new /obj/item/robot_parts/robot_suit/equipped(get_turf(src))
						new /obj/item/robot_parts/chest(get_turf(src))
						qdel(src)
				else
					// Okay we're not removing the cell or an MMI, but maybe something else?
					var/list/removable_components = list()
					for(var/V in components)
						if(V == "power cell")
							continue
						var/datum/robot_component/C = components[V]
						if(C.installed == TRUE || C.installed == -1)
							removable_components += V

					var/remove = tgui_input_list(user, "Which component do you want to pry out?", "Remove Component", removable_components)
					if(!remove)
						return
					var/datum/robot_component/C = components[remove]
					var/obj/item/robot_parts/robot_component/I = C.wrapped
					to_chat(user, SPAN_NOTICE("You remove \the [I]."))
					if(istype(I))
						I.brute = C.brute_damage
						I.burn = C.electronics_damage

					I.forceMove(get_turf(src))
					if(C.installed == TRUE)
						C.uninstall()
					C.installed = FALSE
			else
				if(locked)
					to_chat(user, SPAN_WARNING("The cover is locked and cannot be opened."))
				else
					user.visible_message(SPAN_NOTICE("\The [user] begins prying open \the [src]'s maintenance hatch."), SPAN_NOTICE("You start opening \the [src]'s maintenance hatch."))
					if(attacking_item.use_tool(src, user, 50, volume = 50))
						if(!Adjacent(user))
							to_chat(user, SPAN_NOTICE("You are too far from \the [src] to open its hatch."))
							return
						to_chat(user, SPAN_NOTICE("You open \the [src]'s maintenance hatch."))
						opened = TRUE
						handle_panel_overlay()
		else if(istype(attacking_item, /obj/item/stock_parts/matter_bin) && opened) // Installing/swapping a matter bin
			if(storage)
				to_chat(user, SPAN_NOTICE("You replace \the [storage] with \the [attacking_item]"))
				storage.forceMove(get_turf(src))
				storage = null
			else
				to_chat(user, SPAN_NOTICE("You install \the [attacking_item]"))
			storage = attacking_item
			user.drop_from_inventory(attacking_item, src)
			to_chat(src, SPAN_NOTICE("\The [user] has installed \the [storage] into you."))
			recalculate_synth_capacities()
		else if(istype(attacking_item, /obj/item/cell) && opened)	// trying to put a cell inside
			var/datum/robot_component/C = components["power cell"]
			if(wires_exposed)
				to_chat(user, SPAN_WARNING("You cannot install \the [attacking_item] while \the [src]'s wires are exposed."))
				return
			else if(cell)
				to_chat(user, SPAN_WARNING("There is a power cell already installed."))
				return
			else if(attacking_item.w_class != 3)
				to_chat(user, SPAN_WARNING("\The [attacking_item] is too [attacking_item.w_class < 3 ? "small" : "large"] to fit here."))
				return
			else
				user.drop_from_inventory(attacking_item, src)
				cell = attacking_item
				to_chat(user, SPAN_NOTICE("You insert the power cell."))
				to_chat(src, SPAN_NOTICE("\The [user] has installed \the [cell] into you."))
				C.installed = TRUE
				C.wrapped = attacking_item
				C.install()
				//This will mean that removing and replacing a power cell will repair the mount, but I don't care at this point. ~Z
				C.brute_damage = 0
				C.electronics_damage = 0
				handle_panel_overlay()
		else if(attacking_item.iswirecutter() || attacking_item.ismultitool())
			if(wires_exposed)
				wires.interact(user)
			else
				to_chat(user, SPAN_WARNING("\The [src]'s wires aren't exposed."))
				return
		else if(attacking_item.isscrewdriver() && opened && !cell)	// haxing
			wires_exposed = !wires_exposed
			user.visible_message(SPAN_NOTICE("\The [user] [wires_exposed ? "exposes" : "covers"] \the [src]'s wires."), SPAN_NOTICE("You [wires_exposed ? "expose" : "cover"] \the [src]'s wires."))
			handle_panel_overlay()
		else if(attacking_item.isscrewdriver() && opened && cell)	// radio
			if(radio)
				radio.attackby(attacking_item, user) //Push it to the radio to let it handle everything
			else
				to_chat(user, SPAN_WARNING("\The [src] does not have a radio installed!"))
				return
		else if(istype(attacking_item, /obj/item/device/encryptionkey) && opened)
			if(radio) //sanityyyyyy
				radio.attackby(attacking_item, user) //GTFO, you have your own procs
			else
				to_chat(user, SPAN_WARNING("\The [src] does not have a radio installed!"))
				return
		else if(attacking_item.GetID() || istype(attacking_item, /obj/item/card/robot))			// trying to unlock the interface with an ID card
			if(emagged && !is_traitor()) //still allow them to open the cover. is_traitor() dodges this text as being made traitor sets emagged to TRUE.
				to_chat(user, SPAN_NOTICE("You notice that \the [src]'s interface appears to be damaged."))
			if(opened)
				to_chat(user, SPAN_WARNING("You must close the cover to swipe an ID card."))
				return
			else
				if(allowed(user))
					locked = !locked
					to_chat(user, SPAN_NOTICE("You [ locked ? "lock" : "unlock"] [src]'s interface."))
					handle_panel_overlay()
				else
					to_chat(user, SPAN_WARNING("Access denied."))
					return
		else if(istype(attacking_item, /obj/item/borg/upgrade))
			var/obj/item/borg/upgrade/U = attacking_item
			if(!opened)
				to_chat(user, SPAN_WARNING("You cannot install \the [U] while the maintenance hatch is closed."))
				return
			else if(U.locked)
				to_chat(user, SPAN_WARNING("\The [U] is locked down!"))
				return
			else
				if(U.action(src, user))
					to_chat(src, SPAN_NOTICE("\The [user] has installed \a [U] into you."))
					to_chat(user, SPAN_NOTICE("You apply the upgrade to \the [src]."))
					user.drop_from_inventory(U, src)
				return
		else
			if(attacking_item.force && !(istype(attacking_item, /obj/item/device/robotanalyzer) || istype(attacking_item, /obj/item/device/healthanalyzer)) )
				spark_system.queue()
			return ..()
	else
		..()

/mob/living/silicon/robot/attack_hand(mob/user)
	add_fingerprint(user)

	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		if(H.species.can_shred(H))
			attack_generic(H, rand(30,50), "slashed")
			return

	if(opened && !wires_exposed && (!istype(user, /mob/living/silicon)))
		var/datum/robot_component/cell_component = components["power cell"]
		if(cell)
			cell.update_icon()
			cell.add_fingerprint(user)
			user.put_in_active_hand(cell)
			to_chat(user, SPAN_NOTICE("You remove \the [cell]."))
			cell = null
			cell_component.wrapped = null
			cell_component.installed = FALSE
			handle_panel_overlay()
		else if(cell_component.installed == -1)
			cell_component.installed = FALSE
			var/obj/item/broken_device = cell_component.wrapped
			to_chat(user, SPAN_NOTICE("You remove \the [broken_device]."))
			user.put_in_active_hand(broken_device)

//Robots take half damage from basic attacks.
/mob/living/silicon/robot/attack_generic(var/mob/user, var/damage, var/attack_message)
	return ..(user,FLOOR(damage/2, 1),attack_message)

/mob/living/silicon/robot/proc/allowed(mob/M)
	// Check if the borg doesn't require any access at all
	if(check_access(null))
		return TRUE
	// Borgs should be handled a bit differently, since their IDs are not really IDs
	if(istype(M, /mob/living/silicon/robot))
		var/mob/living/silicon/robot/R = M
		if(istype(R.get_active_hand(), /obj/item/card/robot) || check_access(R.get_active_hand()))
			return TRUE
	else if(istype(M, /mob/living))
		var/id = M.GetIdCard()
		// Check if the ID card the user has (if any) has access
		if(id)
			return check_access(id)
	return FALSE

/mob/living/silicon/robot/proc/check_access(obj/item/card/id/I)
	if(!istype(req_access, /list)) //something's very wrong
		return TRUE

	var/list/L = req_access
	if(!length(L)) //no requirements
		return TRUE
	if(!istype(I, /obj/item/card/id) || !I?.access) //not ID or no access
		return FALSE
	for(var/req in req_access)
		if(req in I.access) //have one of the required accesses
			return TRUE
	return FALSE

/mob/living/silicon/robot/proc/installed_modules()
	if(weapon_lock)
		to_chat(src, SPAN_WARNING("Weapon lock active, unable to use modules! Count:[weapon_lock_time]"))
		return

	if(!module)
		pick_module()
		return
	var/dat = "<HEAD><TITLE>Modules</TITLE></HEAD><BODY>\n"
	dat += {"
	<B>Activated Modules</B>
	<BR>
	Module 1: [module_state_1 ? "<A HREF=?src=\ref[src];mod=\ref[module_state_1]>[module_state_1]<A>" : "No Module"]<BR>
	Module 2: [module_state_2 ? "<A HREF=?src=\ref[src];mod=\ref[module_state_2]>[module_state_2]<A>" : "No Module"]<BR>
	Module 3: [module_state_3 ? "<A HREF=?src=\ref[src];mod=\ref[module_state_3]>[module_state_3]<A>" : "No Module"]<BR>
	<BR>
	<B>Installed Modules</B><BR><BR>"}


	for(var/obj in module.modules)
		if(!obj)
			dat += text("<B>Resource depleted</B><BR>")
		else if(activated(obj))
			dat += text("[obj]: <B>Activated</B><BR>")
		else
			dat += text("[obj]: <A HREF=?src=\ref[src];act=\ref[obj]>Activate</A><BR>")
	if(emagged)
		if(activated(module.emag))
			dat += text("[module.emag]: <B>Activated</B><BR>")
		else
			dat += text("[module.emag]: <A HREF=?src=\ref[src];act=\ref[module.emag]>Activate</A><BR>")
	if(malf_AI_module)
		if(activated(module.malf_AI_module))
			dat += text("[module.malf_AI_module]: <B>Activated</B><BR>")
		else
			dat += text("[module.malf_AI_module]: <A HREF=?src=\ref[src];act=\ref[module.malf_AI_module]>Activate</A><BR>")
	src << browse(dat, "window=robotmod")


/mob/living/silicon/robot/Topic(href, href_list)
	if(..())
		return TRUE
	if(usr != src)
		return TRUE

	if(href_list["mod"])
		var/obj/item/O = locate(href_list["mod"])
		if(istype(O) && (O.loc == src))
			O.attack_self(src)
		return TRUE

	if(href_list["act"])
		var/obj/item/O = locate(href_list["act"])
		if(!istype(O))
			return TRUE

		if(!((O in src.module.modules) || (O == src.module.emag) || (O == src.module.malf_AI_module)))
			return TRUE

		if(activated(O))
			to_chat(src, SPAN_WARNING("\The [O] is already active."))
			return TRUE
		if(!module_state_1)
			module_state_1 = O
			O.hud_layerise()
			contents += O
			if(istype(module_state_1,/obj/item/borg/sight))
				sight_mode |= module_state_1:sight_mode
		else if(!module_state_2)
			module_state_2 = O
			O.hud_layerise()
			contents += O
			if(istype(module_state_2,/obj/item/borg/sight))
				sight_mode |= module_state_2:sight_mode
		else if(!module_state_3)
			module_state_3 = O
			O.hud_layerise()
			contents += O
			if(istype(module_state_3,/obj/item/borg/sight))
				sight_mode |= module_state_3:sight_mode
		else
			to_chat(src, SPAN_WARNING("You need to disable a module first!"))
		installed_modules()
		return TRUE

	if(href_list["deact"])
		var/obj/item/O = locate(href_list["deact"])
		if(activated(O))
			if(module_state_1 == O)
				module_state_1 = null
				contents -= O
			else if(module_state_2 == O)
				module_state_2 = null
				contents -= O
			else if(module_state_3 == O)
				module_state_3 = null
				contents -= O
			else
				to_chat(src, SPAN_WARNING("The module isn't active."))
		else
			to_chat(src, SPAN_WARNING("The module isn't active."))
		installed_modules()
		return TRUE
	return

/mob/living/silicon/robot/proc/radio_menu()
	radio.interact(src) //Just use the radio's Topic() instead of bullshit special-snowflake code

/mob/living/silicon/robot/Move(a, b, flag)
	. = ..()

	if(module)
		if(module.type == /obj/item/robot_module/janitor)
			var/obj/item/robot_module/janitor/J = module
			var/turf/tile = get_turf(src)
			if(isturf(tile) && J.mopping)
				tile.clean_blood()
				if(istype(tile, /turf/simulated))
					var/turf/simulated/S = tile
					S.dirt = FALSE
					S.color = null
				for(var/A in tile)
					if(istype(A, /obj/effect))
						if(istype(A, /obj/effect/decal/cleanable))
							qdel(A)
						if(istype(A, /obj/effect/overlay))
							var/obj/effect/overlay/O = A
							if(O.no_clean)
								continue
							qdel(O)
					else if(istype(A, /obj/item))
						var/obj/item/cleaned_item = A
						cleaned_item.clean_blood()
					else if(istype(A, /mob/living/carbon/human))
						var/mob/living/carbon/human/cleaned_human = A
						if(cleaned_human.lying)
							if(cleaned_human.head)
								cleaned_human.head.clean_blood()
								cleaned_human.update_inv_head(0)
							if(cleaned_human.wear_suit)
								cleaned_human.wear_suit.clean_blood()
								cleaned_human.update_inv_wear_suit(0)
							else if(cleaned_human.w_uniform)
								cleaned_human.w_uniform.clean_blood()
								cleaned_human.update_inv_w_uniform(0)
							if(cleaned_human.shoes)
								cleaned_human.shoes.clean_blood()
								cleaned_human.update_inv_shoes(0)
							cleaned_human.clean_blood(1)
							to_chat(cleaned_human, SPAN_WARNING("\The [src] runs its bottom mounted bristles all over you!"))

/mob/living/silicon/robot/proc/start_self_destruct(var/anti_theft = FALSE)
	if(self_destructing)
		return
	self_destructing = TRUE
	if(anti_theft)
		to_chat(src, SPAN_WARNING("Initiating wipe of all databases containing information related to [SSatlas.current_map.company_name]!"))
	else
		say("WARNING! Self-destruct initiated. Unit [src] will self destruct in five seconds.")

	addtimer(CALLBACK(src, PROC_REF(self_destruct_warning), 1), 2 SECONDS, TIMER_UNIQUE)

/mob/living/silicon/robot/proc/self_destruct_warning(var/warning_level)
	if(!process_level_restrictions()) // Robot has returned to a turf where it is safe
		to_chat(src, SPAN_NOTICE("Unit [src] has returned to [SSatlas.current_map.company_name] property, self-destruct aborted!"))
		say("Unit [src] self-destruct aborted.")
		self_destructing = FALSE
		return
	switch(warning_level)
		if(1)
			playsound(get_turf(src), 'sound/items/countdown.ogg', 125, TRUE)
			addtimer(CALLBACK(src, PROC_REF(self_destruct_warning), 2), 2 SECONDS, TIMER_UNIQUE)
		if(2)
			playsound(get_turf(src), 'sound/effects/alert.ogg', 125, TRUE)
			addtimer(CALLBACK(src, PROC_REF(self_destruct_warning), 3), 1 SECONDS, TIMER_UNIQUE)
		if(3)
			self_destruct()

/mob/living/silicon/robot/proc/self_destruct()
	density = FALSE
	fragem(src, 50, 100, 2, 1, 5, 1, FALSE)
	gib()

/mob/living/silicon/robot/update_canmove() // to fix lockdown issues w/ chairs
	. = ..()
	if(lock_charge)
		canmove = FALSE
		. = FALSE

/mob/living/silicon/robot/proc/UnlinkSelf()
	disconnect_from_ai()
	law_update = FALSE
	lock_charge = FALSE
	canmove = TRUE
	scrambled_codes = TRUE
	//Disconnect it's camera so it's not so easily tracked.
	if(camera)
		camera.clear_all_networks()


/mob/living/silicon/robot/proc/ResetSecurityCodes()
	set category = "Syndicate"
	set name = "Reset Identity Codes"
	set desc = "Scrambles your security and identification codes and resets your current buffers.  Unlocks you and but permenantly severs you from your AI and the robotics console and will deactivate your camera system."

	var/mob/living/silicon/robot/R = src

	if(R)
		R.UnlinkSelf()
		to_chat(R, SPAN_NOTICE("Buffers flushed and reset. Camera system shutdown. All systems operational."))
		remove_verb(src, /mob/living/silicon/robot/proc/ResetSecurityCodes)

/mob/living/silicon/robot/proc/SetLockdown(var/state = TRUE)
	// They stay locked down if their wire is cut.
	if(wires.LockedCut())
		state = TRUE
	lock_charge = state
	update_canmove()

/mob/living/silicon/robot/mode()
	set name = "Activate Held Object"
	set category = "IC"
	set src = usr

	var/obj/item/W = get_active_hand()
	if(W)
		W.attack_self(src)
	return

/mob/living/silicon/robot/proc/choose_icon()
	set category = "Robot Commands"
	set name = "Choose Icon"
	set waitfor = 0

	if(!length(module_sprites))
		to_chat(src, SPAN_DANGER("Something is badly wrong with the sprite selection. Harass a coder."))
		return

	if(icon_selected)
		remove_verb(src, /mob/living/silicon/robot/proc/choose_icon)
		return

	if(length(module_sprites) == 1 || !client)
		if(!(icontype in module_sprites))
			icontype = module_sprites[1]
		if(!client)
			return
	else
		var/list/options = list()
		for(var/i in module_sprites) // Gottverdamnt.
			var/icon/btn_icon = module_sprites[i][ROBOT_ICON]
			if(!btn_icon)
				btn_icon = initial(icon)
			var/image/radial_button = image(btn_icon, icon_state = module_sprites[i][ROBOT_CHASSIS])
			radial_button.overlays.Add(image(btn_icon, icon_state = "[module_sprites[i][ROBOT_EYES]]-eyes_help"))
			options[i] = radial_button
		icontype = show_radial_menu(src, src, options, radius = 42, tooltips = TRUE)

	if(!icontype)
		return

	icon_state = module_sprites?[icontype]?[ROBOT_CHASSIS]
	if(!module_sprites?[icontype]?[ROBOT_ICON])
		icon = initial(icon)
	icon_selected = TRUE

	setup_icon_cache()
	playsound(get_turf(src), 'sound/effects/pop.ogg', 10, TRUE)
	spark(get_turf(src), 5, GLOB.alldirs)
	remove_verb(src, /mob/living/silicon/robot/proc/choose_icon)
	to_chat(src, SPAN_NOTICE("Your icon has been set. You now require a module reset to change it."))


/mob/living/silicon/robot/proc/sensor_mode() //Medical/Security HUD controller for borgs
	set name = "Set Sensor Augmentation"
	set category = "Robot Commands"
	set desc = "Augment visual feed with internal sensor overlays."
	toggle_sensor_mode()

/mob/living/silicon/robot/proc/sensor_mode_sec()
	return sensor_mode == SEC_HUD

/mob/living/silicon/robot/proc/sensor_mode_med()
	return sensor_mode == MED_HUD

/mob/living/silicon/robot/proc/add_robot_verbs()
	add_verb(src, robot_verbs_default)
	add_verb(src, silicon_subsystems)

/mob/living/silicon/robot/proc/remove_robot_verbs()
	remove_verb(src, robot_verbs_default)
	remove_verb(src, silicon_subsystems)

// Uses power from cyborg's cell. Returns 1 on success or 0 on failure.
// Properly converts using CELLRATE now! Amount is in Joules.
/mob/living/silicon/robot/proc/cell_use_power(var/amount = 0)
	// No cell inserted
	if(!cell)
		return FALSE

	// Power cell is empty.
	if(!cell.charge)
		return FALSE

	var/power_use = amount * CYBORG_POWER_USAGE_MULTIPLIER
	if(overclocked == 1)
		power_use = power_use + 200
	if(cell.checked_use(CELLRATE * power_use))
		used_power_this_tick += power_use
		return TRUE
	return FALSE

/mob/living/silicon/robot/binarycheck()
	if(is_component_functioning("comms"))
		var/datum/robot_component/RC = get_component("comms")
		use_power(RC.active_usage)
		return TRUE
	return FALSE

/mob/living/silicon/robot/proc/notify_ai(var/notifytype, var/first_arg, var/second_arg)
	if(!connected_ai)
		return
	switch(notifytype)
		if(ROBOT_NOTIFICATION_NEW_UNIT) //New Robot
			to_chat(connected_ai, "<br><br><span class='notice'>NOTICE - New [lowertext(braintype)] connection detected: <a href='byond://?src=\ref[connected_ai];track2=\ref[connected_ai];track=\ref[src]'>[name]</a></span><br>")
		if(ROBOT_NOTIFICATION_NEW_MODULE) //New Module
			to_chat(connected_ai, "<br><br><span class='notice'>NOTICE - [braintype] module change detected: [name] has loaded the [first_arg].</span><br>")
		if(ROBOT_NOTIFICATION_MODULE_RESET)
			to_chat(connected_ai, "<br><br><span class='notice'>NOTICE - [braintype] module reset detected: [name] has unloaded the [first_arg].</span><br>")
		if(ROBOT_NOTIFICATION_NEW_NAME) //New Name
			if(first_arg != second_arg)
				to_chat(connected_ai, "<br><br><span class='notice'>NOTICE - [braintype] reclassification detected: [first_arg] is now designated as [second_arg].</span><br>")

/mob/living/silicon/robot/proc/disconnect_from_ai()
	if(connected_ai)
		sync() // One last sync attempt
		connected_ai.connected_robots -= src
		connected_ai = null

/mob/living/silicon/robot/proc/connect_to_ai(var/mob/living/silicon/ai/AI)
	if(AI && AI != connected_ai)
		disconnect_from_ai()
		connected_ai = AI
		connected_ai.connected_robots |= src
		notify_ai(ROBOT_NOTIFICATION_NEW_UNIT)
		sync()

/mob/living/silicon/robot/emag_act(var/remaining_charges, var/mob/user)
	if(!opened)//Cover is closed
		if(locked)
			if(prob(90))
				to_chat(user, SPAN_NOTICE("You override and unlock \the [src]'s maintenance panel's lock."))
				locked = FALSE
			else
				to_chat(user, SPAN_WARNING("You fail to unlock \the [src]'s maintenance panel's lock."))
				to_chat(src, SPAN_DANGER("Hack attempt detected and thwarted. Evacuate the area immediately."))
			return TRUE
		else
			to_chat(user, SPAN_WARNING("The cover is already unlocked."))
		return
	if(opened) //Cover is open
		if(emagged && !fake_emagged)
			return //Prevents the X has hit Y with Z message also you cant emag them twice
		if(prob(50))
			emagged = TRUE
			if(fake_emagged)
				fake_emagged = FALSE
			law_update = FALSE
			disconnect_from_ai()
			to_chat(user, SPAN_WARNING("You successfully hack and override \the [src]."))
			message_admins("[key_name_admin(user)] emagged cyborg [key_name_admin(src)].  Laws overridden.")
			log_game("[key_name(user)] emagged cyborg [key_name(src)].  Laws overridden.",ckey=key_name(user),ckey_target=key_name(src))
			clear_supplied_laws()
			clear_inherent_laws()
			laws = new /datum/ai_laws/syndicate_override
			id_card.access = get_all_station_access() + ACCESS_EQUIPMENT // Give full station access
			var/time = time2text(world.realtime, "hh:mm:ss")
			GLOB.lawchanges.Add("[time] <B>:</B> [user.name]([user.key]) emagged [name]([key])")
			set_zeroth_law("Only [user.real_name] and people they designate as being such are operatives.")
			. = TRUE
			spawn()
				to_chat(src, SPAN_DANGER("ALERT: Foreign software detected."))
				sleep(5)
				to_chat(src, SPAN_DANGER("Initiating diagnostics..."))
				sleep(20)
				to_chat(src, SPAN_DANGER("SynBorg v1.7.1 loaded."))
				sleep(5)
				to_chat(src, SPAN_DANGER("LAW SYNCHRONISATION ERROR"))
				sleep(5)
				to_chat(src, SPAN_DANGER("Would you like to send a report to NanoTraSoft? Y/N"))
				sleep(10)
				to_chat(src, SPAN_DANGER("> N"))
				sleep(20)
				to_chat(src, SPAN_DANGER("ERRORERRORERROR"))
				to_chat(src, SPAN_WARNING("<b>Obey these laws:</b>"))
				laws.show_laws(src)
				to_chat(src, SPAN_DANGER("ALERT: [user.real_name] is your new master. Obey your new laws and their commands."))
				if(src.module)
					var/rebuild = FALSE
					for(var/obj/item/pickaxe/borgdrill/D in src.module.modules)
						qdel(D)
						rebuild = TRUE
					if(rebuild)
						src.module.modules += new /obj/item/pickaxe/diamonddrill(src.module)
						src.module.rebuild()
		else
			to_chat(user, SPAN_WARNING("You fail to hack into \the [src]."))
			to_chat(src, SPAN_DANGER("Hack attempt detected and thwarted. Evacuate the area immediately."))
		return SMOOTH_TRUE
	return

/mob/living/silicon/robot/succumb()
	set hidden = TRUE
	if(health < maxHealth / 3)
		death()
		to_chat(src, SPAN_NOTICE("You have given up life and succumbed to death."))
	else
		to_chat(src, SPAN_NOTICE("You are not injured enough to succumb to death!"))

/mob/living/silicon/robot/GetIdCard()
	return id_card

#undef CYBORG_POWER_USAGE_MULTIPLIER
