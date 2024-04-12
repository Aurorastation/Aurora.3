/*Energy Guns*/

/obj/item/mecha_equipment/mounted_system/combat
	name = "combat thing"
	desc = DESC_PARENT
	icon_state = "mecha_taser"
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND, HARDPOINT_LEFT_SHOULDER, HARDPOINT_RIGHT_SHOULDER)
	restricted_software = list(MECH_SOFTWARE_WEAPONS)

/obj/item/mecha_equipment/mounted_system/combat/CtrlClick(mob/user)
	if(owner && istype(holding, /obj/item/gun))
		var/obj/item/gun/G = holding
		G.iff_capable = !G.iff_capable
		to_chat(user, SPAN_NOTICE("You [G.iff_capable ? "en" : "dis"]able \the [src]'s IFF systems!"))
	else
		return ..()

/obj/item/mecha_equipment/mounted_system/combat/taser
	name = "mounted electrolaser carbine"
	desc = "A dual fire mode electrolaser system connected to the exosuit's targetting system."
	icon_state = "mecha_taser"
	holding_type = /obj/item/gun/energy/taser/mounted/mech

/obj/item/mecha_equipment/mounted_system/combat/ion
	name = "mounted ion rifle"
	desc = "An exosuit-mounted ion rifle. Handle with care."
	icon_state = "mecha_ion"
	holding_type = /obj/item/gun/energy/rifle/ionrifle/mounted/mech

/obj/item/mecha_equipment/mounted_system/combat/laser
	name = "\improper CH-PS \"Immolator\" laser"
	desc = "An exosuit-mounted laser rifle. Handle with care."
	icon_state = "mecha_laser"
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	holding_type = /obj/item/gun/energy/laser/mounted/mech

/obj/item/mecha_equipment/mounted_system/combat/smg
	name = "mounted submachinegun"
	desc = "An exosuit-mounted automatic weapon. Handle with care."
	icon_state = "mecha_ballistic"
	holding_type = /obj/item/gun/energy/mountedsmg/mech

/obj/item/mecha_equipment/mounted_system/combat/smg/attack_self(mob/user)
	if(owner && istype(holding, /obj/item/gun/energy/mountedsmg/mech))
		var/obj/item/gun/energy/mountedsmg/mech/R = holding
		R.toggle_firing_mode(user)

/obj/item/mecha_equipment/mounted_system/combat/smg/pra_egg
	icon_state = "pra_egg_smg"
	restricted_hardpoints = list(HARDPOINT_RIGHT_HAND)

/obj/item/mecha_equipment/mounted_system/combat/pulse
	name = "heavy pulse cannon"
	desc = "A weapon for combat exosuits. The eZ-13 mk2 heavy pulse rifle shoots powerful pulse-based beams, capable of destroying structures."
	icon_state = "pulse"
	holding_type = /obj/item/gun/energy/pulse/mounted/mech

/obj/item/mecha_equipment/mounted_system/combat/xray
	name = "xray gun"
	desc = "A weapon for combat exosuits. Shoots armor penetrating xray beams."
	icon_state = "mecha_xray"
	holding_type = /obj/item/gun/energy/xray/mounted/mech

/obj/item/mecha_equipment/mounted_system/combat/blaster
	name = "rapidfire blaster"
	desc = "A weapon for combat exosuits. Shoots armor penetrating blaster beams."
	icon_state = "mecha_blaster"
	holding_type = /obj/item/gun/energy/blaster/mounted/mech
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)

/obj/item/mecha_equipment/mounted_system/combat/gauss
	name = "heavy gauss cannon"
	desc = "A weapon for combat exosuits. Shoots high explosive gauss propelled projectiles."
	icon_state = "mecha_gauss"
	holding_type = /obj/item/gun/energy/gauss/mounted/mech
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)

/obj/item/gun/energy/taser/mounted/mech
	use_external_power = TRUE
	self_recharge = TRUE
	has_safety = FALSE

/obj/item/gun/energy/rifle/ionrifle/mounted/mech
	use_external_power = TRUE
	self_recharge = TRUE
	has_safety = FALSE

/obj/item/gun/energy/mountedsmg/mech
	max_shots = 30
	firemodes = list(
		list(mode_name = "semi-automatic", burst = 1, fire_delay = 0,    move_delay = null, burst_accuracy = null,                dispersion=list(0)),
		list(mode_name = "3-round burst",  burst = 3, fire_delay = null, move_delay = 4,    burst_accuracy = list(0,-1,-1),       dispersion=list(0, 15, 15))
	)

/obj/item/gun/energy/laser/mounted/mech
	use_external_power = TRUE
	self_recharge = TRUE
	has_safety = FALSE
	projectile_type = /obj/item/projectile/beam/heavylaser/mech

/obj/item/gun/energy/pulse/mounted/mech
	use_external_power = TRUE
	self_recharge = TRUE
	has_safety = FALSE
	projectile_type = /obj/item/projectile/beam/pulse/mech

/obj/item/gun/energy/xray/mounted/mech
	use_external_power = TRUE
	self_recharge = TRUE
	has_safety = FALSE
	projectile_type = /obj/item/projectile/beam/xray/mech

/*Launchers*/

/obj/item/mecha_equipment/mounted_system/combat/missile
	name = "missile rack"
	desc = "The SRM-8 missile rack is loaded with explosive missiles."
	icon_state = "mech_missile_pod"
	holding_type = /obj/item/gun/launcher/mech/mountedrl
	restricted_hardpoints = list(HARDPOINT_BACK, HARDPOINT_LEFT_SHOULDER, HARDPOINT_RIGHT_SHOULDER)

/obj/item/mecha_equipment/mounted_system/combat/grenadefrag
	name = "frag grenade launcher"
	desc = "The SGL-6FR grenade launcher is designed to launch primed fragmentation grenades."
	icon_state = "mech_gl"
	holding_type = /obj/item/gun/launcher/mech/mountedgl
	restricted_hardpoints = list(HARDPOINT_LEFT_SHOULDER, HARDPOINT_RIGHT_SHOULDER)

/obj/item/mecha_equipment/mounted_system/combat/grenadeflash
	name = "flashbang launcher"
	desc = "The SGL-6FL grenade launcher is designated to launch primed flashbangs."
	icon_state = "mech_gl"
	holding_type = /obj/item/gun/launcher/mech/mountedgl/fl
	restricted_hardpoints = list(HARDPOINT_LEFT_SHOULDER, HARDPOINT_RIGHT_SHOULDER)

/obj/item/mecha_equipment/mounted_system/combat/grenadestinger
	name = "stinger grenade launcher"
	desc = "The SGL-6SG grenade launcher is designated to launch primed stinger grenades."
	icon_state = "mech_gl"
	holding_type = /obj/item/gun/launcher/mech/mountedgl/st
	restricted_hardpoints = list(HARDPOINT_LEFT_SHOULDER, HARDPOINT_RIGHT_SHOULDER)

/obj/item/mecha_equipment/mounted_system/combat/grenadetear
	name = "teargas launcher"
	desc = "The SGL-6TGL grenade launcher is designated to launch primed teargas grenades."
	icon_state = "mech_gl"
	holding_type = /obj/item/gun/launcher/mech/mountedgl/tg
	restricted_hardpoints = list(HARDPOINT_LEFT_SHOULDER, HARDPOINT_RIGHT_SHOULDER)

/obj/item/mecha_equipment/mounted_system/combat/grenadesmoke
	name = "smoke grenade launcher"
	desc = "The SGL-6SGL grenade launcher is designated to launch primed smoke grenades."
	icon_state = "mech_gl"
	holding_type = /obj/item/gun/launcher/mech/mountedgl/sm
	restricted_hardpoints = list(HARDPOINT_LEFT_SHOULDER, HARDPOINT_RIGHT_SHOULDER)

/obj/item/gun/launcher/mech
	name = "mounted mech launcher"
	desc = "Shouldn't be seeing this."
	icon = 'icons/obj/robot_items.dmi'
	icon_state = "smg"
	item_state = "smg"
	fire_sound = 'sound/weapons/rocketlaunch.ogg'

	var/last_regen = 0
	var/proj_gen_time = 100
	var/max_proj = 3
	var/proj = 3

	release_force = 0
	throw_distance = 10

	has_safety = FALSE

/obj/item/gun/launcher/mech/Initialize()
	. = ..()
	last_regen = world.time

/obj/item/gun/launcher/mech/Destroy()
	return ..()

/obj/item/gun/launcher/mech/mountedrl/process()
	if(proj < max_proj && world.time > last_regen + proj_gen_time)
		proj++
		last_regen = world.time

/obj/item/gun/launcher/mech/proc/regen_proj()
	proj++
	if (proj< max_proj)
		addtimer(CALLBACK(src, PROC_REF(regen_proj)), proj_gen_time, TIMER_UNIQUE)

/obj/item/gun/launcher/mech/mountedrl
	name = "mounted rocket launcher"
	desc = "The SRM-8 missile rack is loaded with explosive missiles."
	icon = 'icons/obj/robot_items.dmi'
	icon_state = "smg"
	item_state = "smg"
	fire_sound = 'sound/weapons/rocketlaunch.ogg'

	release_force = 15
	throw_distance = 30
	proj_gen_time = 500

/obj/item/gun/launcher/mech/mountedrl/consume_next_projectile()
	if(proj < 1) return null
	var/obj/item/missile/M = new (src)
	M.primed = 1
	proj--
	addtimer(CALLBACK(src, PROC_REF(regen_proj)), proj_gen_time, TIMER_UNIQUE)
	return M

/obj/item/gun/launcher/mech/mountedgl
	name = "mounted grenade launcher"
	desc = "The SGL-6FR grenade launcher is designed to launch primed fragmentation grenades."
	icon = 'icons/obj/robot_items.dmi'
	icon_state = "smg"
	item_state = "smg"
	fire_sound = 'sound/weapons/grenadelaunch.ogg'

	var/grenade_type = /obj/item/grenade/frag

	release_force = 5
	throw_distance = 7
	proj = 5
	max_proj = 5
	proj_gen_time = 300


/obj/item/gun/launcher/mech/mountedgl/consume_next_projectile()
	if(proj < 1)
		return null
	var/obj/item/grenade/g = new grenade_type(src)
	g.det_time = 10
	g.activate(null)
	proj--
	addtimer(CALLBACK(src, PROC_REF(regen_proj)), proj_gen_time, TIMER_UNIQUE)
	return g

/obj/item/gun/launcher/mech/mountedgl/fl
	desc = "The SGL-6FL grenade launcher is designated to launch primed flashbangs."
	grenade_type = /obj/item/grenade/flashbang
	proj_gen_time = 200

/obj/item/gun/launcher/mech/mountedgl/st
	desc = "The SGL-6SG grenade launcher is designated to launch primed stinger grenades."
	grenade_type = /obj/item/grenade/stinger
	proj_gen_time = 200

/obj/item/gun/launcher/mech/mountedgl/tg
	name = "mounted teargas launcher"
	desc = "The SGL-6TGL grenade launcher is designated to launch primed teargas grenades."
	grenade_type = /obj/item/grenade/chem_grenade/teargas
	proj_gen_time = 200

/obj/item/gun/launcher/mech/mountedgl/sm
	name = "mounted smoke launcher"
	desc = "The SGL-6SGL grenade launcher is designated to launch primed smoke grenades."
	grenade_type = /obj/item/grenade/smokebomb
	proj_gen_time = 200

/obj/item/gun/launcher/mech/mountedgl/cl
	name = "mounted cleaner launcher"
	desc = "The SGL-6CL grenade launcher is designed to launch primed cleaner grenades."
	grenade_type = /obj/item/grenade/chem_grenade/cleaner
	proj_gen_time = 200

/obj/item/gun/launcher/mech/get_hardpoint_maptext()
	return "[proj]/[max_proj]"

/obj/item/gun/energy/get_hardpoint_maptext()
	return "[round(power_supply.charge / charge_cost)]/[max_shots]"

/obj/item/gun/energy/get_hardpoint_status_value()
	var/obj/item/cell/C = get_cell()
	if(istype(C))
		return C.charge/C.maxcharge
	return null

/obj/item/mecha_equipment/shield
	name = "exosuit shield droid"
	desc = "The Hephaestus Armature system is a well liked energy deflector system designed to stop any projectile before it has a chance to become a threat."
	icon_state = "shield_droid"
	var/obj/aura/mechshield/aura
	var/max_charge = 150
	var/charge = 150
	var/last_recharge = 0
	var/charging_rate = 7500 * CELLRATE
	var/cooldown = 3.5 SECONDS // Time until we can recharge again after a blocked impact
	restricted_hardpoints = list(HARDPOINT_BACK)
	restricted_software = list(MECH_SOFTWARE_WEAPONS)

/obj/item/mecha_equipment/shield/installed(mob/living/heavy_vehicle/_owner)
	. = ..()
	aura = new /obj/aura/mechshield(_owner)
	aura.added_to(_owner)
	aura.set_holder(src)

/obj/item/mecha_equipment/shield/uninstalled()
	QDEL_NULL(aura)
	. = ..()

/obj/item/mecha_equipment/shield/attack_self(mob/user)
	. = ..()
	if(.)
		toggle()

/obj/item/mecha_equipment/shield/proc/stop_damage(var/damage)
	var/difference = damage - charge
	charge = Clamp(charge - damage, 0, max_charge)

	last_recharge = world.time

	if(difference > 0)
		for(var/mob/pilot in owner.pilots)
			to_chat(pilot, FONT_LARGE(SPAN_WARNING("Warning: Deflector shield failure detected, shutting down.")))
		toggle()
		playsound(get_turf(owner),'sound/mecha/internaldmgalarm.ogg', 35, TRUE)
		return difference
	else
		return FALSE

/obj/item/mecha_equipment/shield/proc/toggle()
	if(!aura)
		return
	aura.toggle()
	aura.dir = owner.dir
	if(aura.dir == NORTH)
		aura.layer = MOB_LAYER
	else
		aura.layer = ABOVE_HUMAN_LAYER
	playsound(owner,'sound/weapons/flash.ogg', 35, TRUE)
	update_icon()
	if(aura.active)
		START_PROCESSING(SSprocessing, src)
	else
		STOP_PROCESSING(SSprocessing, src)
	active = aura.active
	passive_power_use = active ? 1 KILOWATTS : 0
	owner.update_icon()

/obj/item/mecha_equipment/shield/deactivate()
	if(active)
		toggle()
	..()

/obj/item/mecha_equipment/shield/update_icon()
	. = ..()
	if(!aura)
		return
	if(aura.active)
		icon_state = "shield_droid_a"
	else
		icon_state = "shield_droid"

/obj/item/mecha_equipment/shield/process()
	if(charge >= max_charge)
		return
	if((world.time - last_recharge) < cooldown)
		return

	var/actual_required_power = Clamp(max_charge - charge, 0, charging_rate)
	owner.use_cell_power(actual_required_power)

/obj/item/mecha_equipment/shield/get_hardpoint_status_value()
	return charge / max_charge

/obj/item/mecha_equipment/shield/get_hardpoint_maptext()
	return "[(aura && aura.active) ? "ONLINE" : "OFFLINE"]: [round((charge / max_charge) * 100)]%"

/obj/aura/mechshield
	icon = 'icons/mecha/shield.dmi'
	name = "mechshield"
	var/obj/item/mecha_equipment/shield/shields
	var/active = FALSE
	layer = ABOVE_HUMAN_LAYER
	pixel_x = 8
	pixel_y = 4
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/aura/mechshield/added_to(mob/living/target)
	..()
	target.add_vis_contents(src)
	dir = target.dir

/obj/aura/mechshield/proc/set_holder(var/obj/item/mecha_equipment/shield/holder)
	shields = holder

/obj/aura/mechshield/Destroy()
	if(user)
		user.remove_vis_contents(src)
	shields = null
	. = ..()

/obj/aura/mechshield/proc/toggle()
	active = !active

	update_icon()

	if(active)
		flick("shield_raise", src)
	else
		flick("shield_drop", src)


/obj/aura/mechshield/update_icon()
	. = ..()
	if(active)
		icon_state = "shield"
	else
		icon_state = "shield_null"

/obj/aura/mechshield/bullet_act(obj/item/projectile/P, var/def_zone)
	if(!active)
		return
	if(shields?.charge)
		P.damage = shields.stop_damage(P.damage)
		user.visible_message(SPAN_WARNING("\The [shields.owner]'s shields flash and crackle."))
		flick("shield_impact", src)
		playsound(user, 'sound/effects/basscannon.ogg', 35, TRUE)
		//light up the night.
		new /obj/effect/effect/smoke/illumination(get_turf(src), 5, 4, 1, "#ffffff")
		if(P.damage <= 0)
			return AURA_FALSE|AURA_CANCEL

		spark(get_turf(src), 5, GLOB.alldirs)
		playsound(get_turf(src), /singleton/sound_category/spark_sound, 25, TRUE)

/obj/aura/mechshield/hitby(atom/movable/M, var/speed)
	. = ..()
	if(!active)
		return
	if(shields.charge && speed <= 5)
		user.visible_message(SPAN_WARNING("\The [shields.owner]'s shields flash briefly as they deflect \the [M]."))
		flick("shield_impact", src)
		playsound(user, 'sound/effects/basscannon.ogg', 10, TRUE)
		return AURA_FALSE|AURA_CANCEL
	//Too fast!
