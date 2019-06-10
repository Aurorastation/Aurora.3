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

/mob/living/silicon/robot/scrambled //should not stand linked to the station or the ai
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

/mob/living/silicon/robot/bluespace
	modtype = "Bluespace"
	spawn_module = /obj/item/weapon/robot_module/bluespace
	cell_type = /obj/item/weapon/cell/infinite
	overclocked = 1
	lawupdate = 0
	scrambledcodes = 1
	status_flags = GODMODE

/mob/living/silicon/robot/bluespace/verb/bstwalk()
	set name = "Ruin Everything"
	set desc = "Uses bluespace technology to phase through solid matter and move quickly."
	set category = "BST"
	set popup_menu = 0

	if(!src.incorporeal_move)
		src.incorporeal_move = 2
		to_chat(src, span("notice", "You will now phase through solid matter."))
	else
		src.incorporeal_move = 0
		to_chat(src, span("notice", "You will no-longer phase through solid matter."))
	return

/mob/living/silicon/robot/bluespace/verb/bstrecover()
	set name = "Rejuv"
	set desc = "Use the bluespace within you to restore your health"
	set category = "BST"
	set popup_menu = 0

	src.revive()

/mob/living/silicon/robot/bluespace/verb/bstquit()
	set name = "Teleport out"
	set desc = "Activate bluespace to leave and return to your original mob (if you have one)."
	set category = "BST"

	src.custom_emote(1,"politely beeps with all ligth starting to flash.")
	spark(src, 5, alldirs)
	addtimer(CALLBACK(GLOBAL_PROC, .proc/qdel, src), 10, TIMER_CLIENT_TIME)
	animate(src, alpha = 0, time = 9, easing = QUAD_EASING)

	if(key)
		if(client.holder && client.holder.original_mob)
			client.holder.original_mob.key = key
		else
			var/mob/abstract/observer/ghost = new(src)	//Transfer safety to observer spawning proc.
			ghost.key = key
			ghost.mind.name = "[ghost.key] BSTech"
			ghost.name = "[ghost.key] BSTech"
			ghost.real_name = "[ghost.key] BSTech"
			ghost.voice_name = "[ghost.key] BSTech"

/mob/living/silicon/robot/bluespace/verb/tgm()
	set name = "Toggle Godmode"
	set desc = "Enable or disable god mode. For testing things that require you to be vulnerable."
	set category = "BST"

	status_flags ^= GODMODE
	to_chat(src, span("notice", "God mode is now [status_flags & GODMODE ? "enabled" : "disabled"]"))