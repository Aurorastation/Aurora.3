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

	// Look and feel
	icon_state = "syndie_bloodhound"
	spawn_sound = 'sound/mecha/nominalsyndi.ogg'
	pitch_toggle = FALSE
	braintype = "Cyborg"

	// ID and Access
	req_access = list(access_syndicate)
	id_card_type = /obj/item/card/id/syndicate
	key_type = /obj/item/device/encryptionkey/syndicate

/mob/living/silicon/robot/syndicate/Initialize()
	. = ..()
	verbs += /mob/living/silicon/robot/proc/choose_icon

/mob/living/silicon/robot/syndicate/updateicon() //because this was the only way I found out how to make their eyes and etc works
	cut_overlays()
	if(stat == 0)
		add_overlay("eyes-[icon_state]")

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

/obj/item/gun/energy/crossbow/cyborg
	name = "mounted energy-crossbow"
	desc = "A weapon favored by mercenary infiltration teams, this one is suited to be used by cyborgs."
	max_shots = 4
	charge_cost = 200
	use_external_power = 1

/obj/item/gun/launcher/grenade/cyborg
	name = "grenade launcher"
	desc = "A bulky pump-action grenade launcher. Loaded with 3 frag grenades."

/obj/item/gun/launcher/grenade/cyborg/Initialize()
	. = ..()

	grenades = list(
		new /obj/item/grenade/frag(src),
		new /obj/item/grenade/frag(src),
		new /obj/item/grenade/frag(src)
	)

/obj/item/robot_emag
	desc = "It's a card with a magnetic strip attached to some circuitry, this one is modified to be used by a cyborg."
	name = "cryptographic sequencer"
	icon = 'icons/obj/card.dmi'
	icon_state = "emag"

/obj/item/robot_emag/afterattack(var/atom/target, var/mob/living/user, proximity) //possible spaghetti code, but should work
	if(!target)
		return
	if(!proximity)
		return

	else if(istype(target,/obj/))
		var/obj/O = target
		O.add_fingerprint(user)
		O.emag_act(1,user,src)
		log_and_message_admins("emmaged \an [O].")
		if(isrobot(user))
			var/mob/living/silicon/robot/R = user
			if(R.cell)
				R.cell.use(350)
		return 1

	return 0