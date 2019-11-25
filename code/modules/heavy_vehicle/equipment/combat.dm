/*Energy Guns*/

/obj/item/mecha_equipment/mounted_system/taser
	name = "mounted electrolaser carbine"
	desc = "A dual fire mode electrolaser system connected to the exosuit's targetting system."
	icon_state = "mecha_taser"
	holding_type = /obj/item/gun/energy/taser/mounted/mech
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND, HARDPOINT_LEFT_SHOULDER, HARDPOINT_RIGHT_SHOULDER)
	restricted_software = list(MECH_SOFTWARE_WEAPONS)

/obj/item/mecha_equipment/mounted_system/taser/ion
	name = "mounted ion rifle"
	desc = "An exosuit-mounted ion rifle. Handle with care."
	icon_state = "mecha_ion"
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	holding_type = /obj/item/gun/energy/rifle/ionrifle/mounted/mech

/obj/item/mecha_equipment/mounted_system/taser/laser
	name = "\improper CH-PS \"Immolator\" laser"
	desc = "An exosuit-mounted laser rifle. Handle with care."
	icon_state = "mecha_laser"
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	holding_type = /obj/item/gun/energy/laser/mounted/mech

/obj/item/mecha_equipment/mounted_system/taser/smg
	name = "mounted machinegun"
	desc = "An exosuit-mounted automatic weapon. Handle with care."
	icon_state = "mecha_ballistic"
	holding_type = /obj/item/gun/energy/mountedsmg

/obj/item/mecha_equipment/mounted_system/pulse
	name = "heavy pulse cannon"
	desc = "A weapon for combat exosuits. The eZ-13 mk2 heavy pulse rifle shoots powerful pulse-based beams, capable of destroying structures."
	icon_state = "railauto"
	holding_type = /obj/item/gun/energy/pulse/mounted/mech
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND, HARDPOINT_LEFT_SHOULDER, HARDPOINT_RIGHT_SHOULDER)
	restricted_software = list(MECH_SOFTWARE_ADVWEAPONS)

/obj/item/mecha_equipment/mounted_system/xray
	name = "xray gun"
	desc = "A weapon for combat exosuits. Shoots armor penetrating xray beams."
	icon_state = "mecha_xray"
	holding_type = /obj/item/gun/energy/xray/mounted/mech
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	restricted_software = list(MECH_SOFTWARE_ADVWEAPONS)

/obj/item/gun/energy/taser/mounted/mech
	use_external_power = TRUE
	self_recharge = TRUE

/obj/item/gun/energy/rifle/ionrifle/mounted/mech
	use_external_power = TRUE
	self_recharge = TRUE

/obj/item/gun/energy/laser/mounted/mech
	use_external_power = TRUE
	self_recharge = TRUE

/obj/item/gun/energy/pulse/mounted/mech
	use_external_power = TRUE
	self_recharge = TRUE

/obj/item/gun/energy/xray/mounted/mech
	use_external_power = TRUE
	self_recharge = TRUE

/*Launchers*/

/obj/item/mecha_equipment/mounted_system/missile
	name = "missile rack"
	desc = "The SRM-8 missile rack is loaded with explosive missiles."
	icon_state = "mech_missile_pod"
	holding_type = /obj/item/gun/launcher/mech/mountedrl
	restricted_hardpoints = list(HARDPOINT_BACK, HARDPOINT_LEFT_SHOULDER, HARDPOINT_RIGHT_SHOULDER)
	restricted_software = list(MECH_SOFTWARE_ADVWEAPONS)

/obj/item/mecha_equipment/mounted_system/grenadefrag
	name = "frag grenade launcher"
	desc = "The SGL-6FR grenade launcher is designed to launch primed fragmentation grenades."
	icon_state = "mecha_fraglnchr"
	holding_type = /obj/item/gun/launcher/mech/mountedgl
	restricted_hardpoints = list(HARDPOINT_LEFT_SHOULDER, HARDPOINT_RIGHT_SHOULDER)
	restricted_software = list(MECH_SOFTWARE_ADVWEAPONS)

/obj/item/mecha_equipment/mounted_system/grenadeflash
	name = "flashbang launcher"
	desc = "The SGL-6FL grenade launcher is designated to launch primed flashbangs."
	icon_state = "mecha_grenadelnchr"
	holding_type = /obj/item/gun/launcher/mech/mountedfl
	restricted_hardpoints = list(HARDPOINT_LEFT_SHOULDER, HARDPOINT_RIGHT_SHOULDER)
	restricted_software = list(MECH_SOFTWARE_WEAPONS)

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
		addtimer(CALLBACK(src, .proc/regen_proj), proj_gen_time, TIMER_UNIQUE)

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
	addtimer(CALLBACK(src, .proc/regen_proj), proj_gen_time, TIMER_UNIQUE)
	return M

/obj/item/gun/launcher/mech/mountedgl
	name = "mounted grenade launcher"
	desc = "The SGL-6FR grenade launcher is designed to launch primed fragmentation grenades."
	icon = 'icons/obj/robot_items.dmi'
	icon_state = "smg"
	item_state = "smg"
	fire_sound = 'sound/weapons/grenadelaunch.ogg'

	release_force = 5
	throw_distance = 7
	proj = 5
	max_proj = 5
	proj_gen_time = 300


/obj/item/gun/launcher/mech/mountedgl/consume_next_projectile()
	if(proj < 1) return null
	var/obj/item/grenade/frag/g = new (src)
	g.det_time = 10
	g.activate(null)
	proj--
	addtimer(CALLBACK(src, .proc/regen_proj), proj_gen_time, TIMER_UNIQUE)
	return g

/obj/item/gun/launcher/mech/mountedfl
	name = "mounted grenade launcher"
	desc = "The SGL-6FL grenade launcher is designated to launch primed flashbangs."
	icon = 'icons/obj/robot_items.dmi'
	icon_state = "smg"
	item_state = "smg"
	fire_sound = 'sound/weapons/grenadelaunch.ogg'

	release_force = 5
	throw_distance = 7
	proj = 5
	max_proj = 5
	proj_gen_time = 200


/obj/item/gun/launcher/mech/mountedfl/consume_next_projectile()
	if(proj < 1) return null
	var/obj/item/grenade/flashbang/g = new (src)
	g.det_time = 10
	g.activate(null)
	proj--
	addtimer(CALLBACK(src, .proc/regen_proj), proj_gen_time, TIMER_UNIQUE)
	return g

/obj/item/gun/launcher/mech/get_hardpoint_maptext()
	return "[proj]/[max_proj]"

/obj/item/gun/energy/get_hardpoint_maptext()
	return "[round(power_supply.charge / charge_cost)]/[max_shots]"

/obj/item/gun/energy/get_hardpoint_status_value()
	var/obj/item/cell/C = get_cell()
	if(istype(C))
		return C.charge/C.maxcharge
	return null
