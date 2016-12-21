//syndicate cyborgs, they aren't fully linked to the station, also are more combat oriented, for now only the regular assault module - alberyk

/mob/living/silicon/robot/syndicate
	lawupdate = 0
	scrambledcodes = 1
	modtype = "Syndicate"
	icon = 'icons/mob/robots.dmi'
	icon_state = "syndie_bloodhound"
	lawchannel = "State"
	req_access = list(access_syndicate)
	faction = "syndicate"
	modtype = "syndicate"
	braintype = "Cyborg"

/mob/living/silicon/robot/syndicate/init()
	aiCamera = new/obj/item/device/camera/siliconcam/robot_camera(src)

	laws = new /datum/ai_laws/syndicate_override
	new /obj/item/weapon/robot_module/syndicate(src)

	radio.keyslot = new /obj/item/device/encryptionkey/syndicate(radio)
	radio.recalculateChannels()

	playsound(loc, 'sound/mecha/nominalsyndi.ogg', 75, 0)

/mob/living/silicon/robot/syndicate/New()
	if(!cell)
		cell = new /obj/item/weapon/cell(src)
		cell.maxcharge = 25000
		cell.charge = 25000
	if(!jetpack)
		jetpack = new /obj/item/weapon/tank/jetpack/carbondioxide/synthetic(src)

	..()

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
	list(mode_name="semiauto", burst=1, fire_delay=0),
	list(mode_name="3-round bursts", burst=3, move_delay=4, accuracy = list(0,-1,-1,-2,-2), dispersion = list(0.0, 0.6, 1.0)),
	list(mode_name="short bursts", 	burst=5, move_delay=4, accuracy = list(0,-1,-1,-2,-2), dispersion = list(0.6, 1.0, 1.0, 1.0, 1.2))
	)

/obj/item/weapon/gun/energy/crossbow/cyborg
	name = "mounted energy-crossbow"
	desc = "A weapon favored by mercenary infiltration teams, this one is suited to be used by cyborgs."
	max_shots = 4
	charge_cost = 200
	use_external_power = 1
