//syndicate cyborgs, they aren't fully linked to the station, also are more combat oriented, for now only the regular assault module - alberyk

/mob/living/silicon/robot/syndicate
	// Laws and Interaction
	law_channel = "State"
	law_preset = /datum/ai_laws/syndicate_override
	law_update = FALSE
	scrambled_codes = TRUE

	// Modules
	mod_type = "Syndicate"
	spawn_module = /obj/item/robot_module/syndicate
	cell_type = /obj/item/cell/super
	has_pda = FALSE
	has_jetpack = TRUE
	flash_resistant = TRUE

	// Look and feel
	icon_state = "syndie_bloodhound"
	spawn_sound = 'sound/mecha/nominalsyndi.ogg'
	pitch_toggle = FALSE
	braintype = "Cyborg"

	// ID and Access
	req_access = list(access_syndicate)
	id_card_type = /obj/item/card/id/syndicate
	key_type = /obj/item/device/encryptionkey/syndicate
	var/datum/antagonist/assigned_antagonist

/mob/living/silicon/robot/syndicate/Initialize()
	. = ..()
	verbs += /mob/living/silicon/robot/proc/choose_icon
	var/datum/robot_component/C = components["surge"]
	C.installed = TRUE
	C.wrapped = new C.external_type

/mob/living/silicon/robot/syndicate/updateicon() //because this was the only way I found out how to make their eyes and etc works
	cut_overlays()

	if(stat == CONSCIOUS)
		if(a_intent == I_HELP)
			add_overlay(image(icon, "eyes-[module_sprites[icontype]]-help", layer = EFFECTS_ABOVE_LIGHTING_LAYER))
		else
			add_overlay(image(icon, "eyes-[module_sprites[icontype]]-harm", layer = EFFECTS_ABOVE_LIGHTING_LAYER))

	if(opened)
		var/panelprefix = custom_sprite ? src.ckey : "ov"
		if(wires_exposed)
			add_overlay("[panelprefix]-openpanel +w")
		else if(cell)
			add_overlay("[panelprefix]-openpanel +c")
		else
			add_overlay("[panelprefix]-openpanel -c")

	if(module_active && istype(module_active,/obj/item/borg/combat/shield))
		add_overlay("[icon_state]-shield")

	if(mod_type == "Combat")
		if(module_active && istype(module_active,/obj/item/borg/combat/mobility))
			icon_state = "[icon_state]-roll"
		else
			icon_state = module_sprites[icontype]

/mob/living/silicon/robot/syndicate/death()
	..()
	src.visible_message("<span class='danger'>\The [src] starts beeping ominously!</span>")
	playsound(src, 'sound/effects/screech.ogg', 100, 1, 1)
	explosion(get_turf(src), 1, 2, 3, 5)
	qdel(src)

/mob/living/silicon/robot/syndicate/proc/spawn_into_syndiborg(var/mob/user)
	if(src.ckey)
		return
	src.ckey = user.ckey
	SSghostroles.remove_spawn_atom("syndiborg", src)
	if(assigned_antagonist)
		assigned_antagonist.add_antagonist_mind(src.mind, TRUE)
		if(assigned_antagonist.get_antag_radio())
			module.channels[assigned_antagonist.get_antag_radio()] = TRUE
			radio.recalculateChannels()
	say("Boot sequence complete!")

//syndicate borg gear

/obj/item/gun/energy/mountedsmg
	name = "mounted submachine gun"
	desc = "A cyborg mounted submachine gun, it can print more bullets over time."
	icon = 'icons/obj/robot_items.dmi'
	icon_state = "smg"
	item_state = "smg"
	fire_sound = 'sound/weapons/gunshot/gunshot_light.ogg'
	charge_meter = 0
	max_shots = 20
	charge_cost = 100
	projectile_type = /obj/item/projectile/bullet/pistol
	self_recharge = 1
	use_external_power = 1
	recharge_time = 5
	sel_mode = 1
	needspin = FALSE
	firemodes = list(
		list(mode_name="semiauto",       burst=1, fire_delay=0,    move_delay=null, burst_accuracy=null, dispersion=list(0)),
		list(mode_name="3-round bursts", burst=3, fire_delay=null, move_delay=4,    burst_accuracy=list(0,-1,-1),       dispersion=list(0, 15, 15)),
		list(mode_name="short bursts",   burst=5, fire_delay=null, move_delay=4,    burst_accuracy=list(0,-1,-1,-2,-2), dispersion=list(0, 15, 15, 18, 18, 20))
		)
	has_safety = FALSE

/obj/item/gun/energy/crossbow/cyborg
	name = "mounted energy-crossbow"
	desc = "A weapon favored by mercenary infiltration teams, this one is suited to be used by cyborgs."
	max_shots = 4
	charge_cost = 200
	use_external_power = 1

/obj/item/gun/launcher/grenade/cyborg
	name = "grenade launcher"
	desc = "A bulky pump-action grenade launcher. Can be loaded with more grenades."
	has_safety = FALSE
	blacklisted_grenades = list()

/obj/item/gun/launcher/grenade/cyborg/Initialize()
	. = ..()

	grenades = list(
		new /obj/item/grenade/frag(src),
		new /obj/item/grenade/frag(src)
	)
	chambered = new /obj/item/grenade/frag(src)
	update_maptext()

/obj/item/robot_emag
	name = "cryptographic sequencer"
	desc = "It's a card with a magnetic strip attached to some circuitry, this one is modified to be used by a cyborg."
	desc_antag = "This emag has an unlimited number of uses, however, each use will drain a little bit of your power cell."
	icon = 'icons/obj/card.dmi'
	icon_state = "emag"

/obj/item/robot_emag/afterattack(var/atom/target, var/mob/living/user, proximity) //possible spaghetti code, but should work
	if(!target)
		return
	if(!proximity)
		return

	else if(isobj(target))
		var/obj/O = target
		O.add_fingerprint(user)
		O.emag_act(1,user,src)
		log_and_message_admins("emmaged \an [O].")
		if(isrobot(user))
			var/mob/living/silicon/robot/R = user
			if(R.cell)
				R.cell.use(350)
		return TRUE
	return FALSE
