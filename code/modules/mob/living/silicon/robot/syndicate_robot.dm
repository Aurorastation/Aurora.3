//syndicate cyborgs, they aren't fully linked to the station, also are more combat oriented, for now only the regular assault module - alberyk

/mob/living/silicon/robot/syndicate
	lawupdate = 0
	scrambledcodes = 1
	modtype = "Syndicate"
	icon = 'icons/mob/robots.dmi'
	icon_state = "syndie_bloodhound"
	lawchannel = "State"
	lawpreset = /datum/ai_laws/syndicate_override
	idcard_type = /obj/item/weapon/card/id/syndicate
	spawn_module = /obj/item/weapon/robot_module/syndicate
	key_type = /obj/item/device/encryptionkey/syndicate
	spawn_sound = 'sound/mecha/nominalsyndi.ogg'
	cell_type = /obj/item/weapon/cell/super
	req_access = list(access_syndicate)
	faction = "syndicate"
	braintype = "Cyborg"

/mob/living/silicon/robot/syndicate/init()
	..()
	if(!jetpack)
		jetpack = new /obj/item/weapon/tank/jetpack/carbondioxide/synthetic(src)

/mob/living/silicon/robot/syndicate/updateicon() //because this was the only way I found out how to make their eyes and etc works
	overlays.Cut()
	if(stat == 0)
		overlays += "eyes-[icon_state]"

	if(opened)
		var/panelprefix = custom_sprite ? src.ckey : "ov"
		if(wiresexposed)
			overlays += "[panelprefix]-openpanel +w"
		else if(cell)
			overlays += "[panelprefix]-openpanel +c"
		else
			overlays += "[panelprefix]-openpanel -c"

	if(module_active && istype(module_active,/obj/item/borg/combat/shield))
		overlays += "[icon_state]-shield"

	if(modtype == "Combat")
		if(module_active && istype(module_active,/obj/item/borg/combat/mobility))
			icon_state = "[icon_state]-roll"
		else
			icon_state = module_sprites[icontype]
		return

/mob/living/silicon/robot/syndicate/death()
	..()
	src.visible_message("<span class='danger'>\The [src] starts beeping ominously!</span>")
	playsound(src, 'sound/effects/screech.ogg', 100, 1, 1)
	explosion(get_turf(src), 1, 2, 3, 5)
	qdel(src)

//syndicate borg gear

/obj/item/weapon/gun/energy/mountedsmg
	name = "mounted SMG"
	desc = "A cyborg mounted sub machine gun, it can print more bullets over time."
	icon_state = "lawgiver" //placeholder for now
	item_state = "lawgiver"
	fire_sound = 'sound/weapons/Gunshot_light.ogg'
	max_shots = 20
	charge_cost = 100
	projectile_type = /obj/item/projectile/bullet/pistol
	self_recharge = 1
	use_external_power = 1
	recharge_time = 5
	sel_mode = 1
	firemodes = list(
		list(mode_name="semiauto",       burst=1, fire_delay=0,    move_delay=null, burst_accuracy=null, dispersion=null),
		list(mode_name="3-round bursts", burst=3, fire_delay=null, move_delay=4,    burst_accuracy=list(0,-1,-1),       dispersion=list(0.0, 0.6, 1.0)),
		list(mode_name="short bursts",   burst=5, fire_delay=null, move_delay=4,    burst_accuracy=list(0,-1,-1,-2,-2), dispersion=list(0.6, 1.0, 1.0, 1.0, 1.2))
		)

/obj/item/weapon/gun/energy/crossbow/cyborg
	name = "mounted energy-crossbow"
	desc = "A weapon favored by mercenary infiltration teams, this one is suited to be used by cyborgs."
	max_shots = 4
	charge_cost = 200
	use_external_power = 1

/obj/item/weapon/gun/launcher/grenade/cyborg
	name = "grenade launcher"
	desc = "A bulky pump-action grenade launcher. Loaded with 3 frag grenades."

/obj/item/weapon/gun/launcher/grenade/cyborg/New()
	..()

	grenades = list(
			new /obj/item/weapon/grenade/frag(src),
			new /obj/item/weapon/grenade/frag(src),
			new /obj/item/weapon/grenade/frag(src)
			)
