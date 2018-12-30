//cyborgs presets, mostly used for events/admin bus

/mob/living/silicon/robot/combat
	modtype = "Combat"
	spawn_module = /obj/item/weapon/robot_module/combat
	cell_type = /obj/item/weapon/cell/super

/mob/living/silicon/robot/combat/ert
	scrambledcodes = 1
	lawupdate = 0
	lawpreset = /datum/ai_laws/nanotrasen_aggressive
	idcard_type = /obj/item/weapon/card/id/ert
	key_type = /obj/item/device/encryptionkey/ert

/mob/living/silicon/robot/combat/ert/init()
	..()
	if(!jetpack)
		jetpack = new /obj/item/weapon/tank/jetpack/carbondioxide/synthetic(src)

/mob/living/silicon/robot/combat/scrambled //should not stand linked to the station or the ai
	scrambledcodes = 1
	lawupdate = 0

/mob/living/silicon/robot/hunter_seeker //added for events, at the request of the lore people
	maxHealth = 300
	health = 300
	scrambledcodes = 1
	lawupdate = 0
	cell_type = /obj/item/weapon/cell/super
	overclocked = 1
	speed = -3
	req_access = list(access_syndicate)
	idcard_type = /obj/item/weapon/card/id/syndicate
	key_type = /obj/item/device/encryptionkey/syndicate
	spawn_module = /obj/item/weapon/robot_module/hunter_seeker
	no_pda = TRUE
	light_color = LIGHT_COLOR_EMERGENCY
	light_power = 15
	light_range  = 15
	integrated_light_power = 15
	light_wedge = 10

/mob/living/silicon/robot/hunter_seeker/init()
	..()
	if(!jetpack)
		jetpack = new /obj/item/weapon/tank/jetpack/carbondioxide/synthetic(src)

	var/obj/item/robot_parts/robot_component/surge/S = new(src)
	for(var/V in components)
		var/datum/robot_component/C = components[V]
		if(!C.installed && istype(S, C.external_type))
			C.wrapped = S
			C.install()
			S.loc = null

/mob/living/silicon/robot/hunter_seeker/updateicon() //because this was the only way I found out how to make their eyes and etc works
	cut_overlays()
	if(stat == 0)
		add_overlay("eyes-[icon_state]")

	if(opened)
		var/panelprefix = custom_sprite ? src.ckey : "ov"
		if(wiresexposed)
			add_overlay("[panelprefix]-openpanel +w")
		else if(cell)
			add_overlay("[panelprefix]-openpanel +c")
		else
			add_overlay("[panelprefix]-openpanel -c")

	if(module_active && istype(module_active,/obj/item/borg/combat/shield))
		add_overlay("[icon_state]-shield")

	if(modtype == "Combat")
		if(module_active && istype(module_active,/obj/item/borg/combat/mobility))
			icon_state = "[icon_state]-roll"
		else
			icon_state = module_sprites[icontype]

