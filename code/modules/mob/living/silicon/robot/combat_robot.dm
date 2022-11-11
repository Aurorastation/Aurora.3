//
// Combat Robot
//

/mob/living/silicon/robot/combat
	// Laws and Interaction
	law_channel = "State"
	law_preset = /datum/ai_laws/syndicate_override
	law_update = FALSE
	scrambled_codes = TRUE

	// Modules
	mod_type = "Combat"
	spawn_module = /obj/item/robot_module/combat
	cell_type = /obj/item/cell/super
	has_pda = FALSE
	has_jetpack = TRUE
	flash_resistant = TRUE

	// Look and Feel
	icon_state = "syndie_bloodhound"
	spawn_sound = 'sound/mecha/nominalsyndi.ogg'
	pitch_toggle = FALSE
	braintype = "Android" // Posibrain.

	// ID and Access
	req_access = list(access_syndicate)
	id_card_type = /obj/item/card/id/syndicate
	key_type = /obj/item/device/encryptionkey/syndicate
	var/datum/antagonist/assigned_antagonist

/mob/living/silicon/robot/combat/Initialize()
	. = ..()
	verbs += /mob/living/silicon/robot/proc/choose_icon
	var/datum/robot_component/C = components["surge"]
	C.installed = TRUE
	C.wrapped = new C.external_type
	setup_icon_cache()

/mob/living/silicon/robot/combat/assign_player(var/mob/user)
	if(src.ckey)
		return
	src.ckey = user.ckey
	if(assigned_antagonist)
		assigned_antagonist.add_antagonist_mind(src.mind, TRUE)
		if(assigned_antagonist.get_antag_radio())
			module.channels[assigned_antagonist.get_antag_radio()] = TRUE
			radio.recalculateChannels()
	say("Boot sequence complete!")
	return src

// Syndicate Borg Gear
/obj/item/gun/energy/mountedsmg
	name = "mounted submachine gun"
	desc = "A mounted submachine gun. It synthesizes more ammunition over time."
	icon = 'icons/obj/robot_items.dmi'
	icon_state = "smg"
	item_state = "smg"
	fire_sound = 'sound/weapons/gunshot/gunshot_pistol.ogg'
	charge_meter = 0
	max_shots = 20
	charge_cost = 100
	projectile_type = /obj/item/projectile/bullet/pistol/medium/ap
	self_recharge = 1
	use_external_power = 1
	recharge_time = 5
	sel_mode = 1
	needspin = FALSE
	firemodes = list(
		list(mode_name = "semi-automatic", burst = 1, fire_delay = 0,    move_delay = null, burst_accuracy = null,                dispersion=list(0)),
		list(mode_name = "3-round burst",  burst = 3, fire_delay = null, move_delay = 4,    burst_accuracy = list(0,-1,-1),       dispersion=list(0, 15, 15)),
		list(mode_name = "5-round burst",  burst = 5, fire_delay = null, move_delay = 4,    burst_accuracy = list(0,-1,-1,-2,-2), dispersion=list(0, 15, 15, 18, 18, 20))
	)
	has_safety = FALSE

/obj/item/gun/energy/crossbow/cyborg
	name = "mounted energy crossbow"
	desc = "A weapon favored by mercenary infiltration teams, this one is suited to be used by robots."
	max_shots = 4
	charge_cost = 200
	use_external_power = 1

/obj/item/gun/launcher/grenade/cyborg
	name = "mounted grenade launcher"
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
	desc = "It's a card with a magnetic strip attached to some circuitry. This one is modified to be used by a robot."
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