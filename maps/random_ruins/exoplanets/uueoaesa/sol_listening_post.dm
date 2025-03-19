/datum/map_template/ruin/exoplanet/sol_listening_post
	name = "Solarian Listening Post"
	id = "sol_listening_post"
	description = "An abandoned Solarian listening post in the Uueoa-Esa system."
	sectors = list(SECTOR_UUEOAESA)
	prefix = "uueoaesa/"
	suffix = "sol_listening_post.dmm"
	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED

	unit_test_groups = list(1)

/area/sol_listening_post
	name = "Solarian Listening Post"
	icon_state = "bluenew"
	requires_power = TRUE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	base_turf = /turf/simulated/floor/exoplanet/barren
	area_flags = AREA_FLAG_RAD_SHIELDED|AREA_FLAG_INDESTRUCTIBLE_TURFS
	ambience = AMBIENCE_EXPOUTPOST

/obj/effect/landmark/corpse/sol_marine_husk
	name = "Decayed Solarian Marine"
	corpseuniform = /obj/item/clothing/under/rank/sol/marine
	corpsesuit = /obj/item/clothing/suit/space/void/sol
	corpsehelmet = /obj/item/clothing/head/helmet/space/void/sol
	corpseshoes = /obj/item/clothing/shoes/magboots
	corpseglasses = /obj/item/clothing/glasses/safety/goggles/tactical
	corpsebelt = /obj/item/gun/projectile/pistol/sol
	corpseid = FALSE
	species = SPECIES_HUMAN

/obj/effect/landmark/corpse/sol_marine_husk/do_extra_customization(mob/living/carbon/human/M)
	M.ChangeToSkeleton()
	M.adjustBruteLoss(rand(200,400))
	M.dir = pick(GLOB.cardinals)

/obj/effect/landmark/corpse/sol_officer_husk
	name = "Decayed Solarian Officer"
	corpseuniform = /obj/item/clothing/under/rank/sol/dress/subofficer
	corpseshoes = /obj/item/clothing/shoes/jackboots
	corpsehelmet = /obj/item/clothing/head/sol/dress
	corpseid = FALSE

/obj/effect/landmark/corpse/sol_officer_husk/do_extra_customization(mob/living/carbon/human/M)
	M.ChangeToSkeleton()
	M.adjustBruteLoss(rand(200,400))
	M.dir = pick(GLOB.cardinals)

/obj/effect/landmark/corpse/unathi_pirate
	name = "Unathi Pirate"
	corpseuniform = /obj/item/clothing/under/unathi/izharshan
	corpsesuit = /obj/item/clothing/suit/space/void/unathi_pirate
	corpseshoes = /obj/item/clothing/shoes/magboots
	corpsehelmet = /obj/item/clothing/head/helmet/space/void/unathi_pirate
	corpseid = FALSE

/obj/effect/landmark/corpse/unathi_pirate/do_extra_customization(mob/living/carbon/human/M)
	M.ChangeToSkeleton()
	M.adjustBruteLoss(rand(200,400))
	M.dir = pick(GLOB.cardinals)
	if(prob(10))
		M.equip_to_slot_or_del(new /obj/item/melee/energy/sword/pirate(M), slot_belt)

/obj/item/paper/fluff/sol_uueoa
	language = LANGUAGE_SOL_COMMON

/obj/item/paper/fluff/sol_uueoa/entry1
	name = "SAMS Sentinel Entry #1"
	info = "Lt. Lillian Crenshaw, personal log. July 12th, 2445. Fuck me. Who did I piss off to get this posting? I mean, when they brought me up in front of a tribunal I expected the Tenth Middle Ring or some other shitass assignment, but this?\
	A fucking miserable station on an equally miserable rock, watching some fucking lizards throwing nukes at each other and listening for... hell if I know. Making sure the Skrell or NT aren't up to something, \
	or that no pirates are trying to strike it rich out here. Six of us and a whole lot of fancy-ass equipment we're meant to keep running."

/obj/item/paper/fluff/sol_uueoa/entry2
	name = "SAMS Sentinel Entry #2"
	info = "Lt. Lillian Crenshaw, personal log. June 18th, 2446. It has been almost one fucking year. Do you know what these state of the art listening devices of ours have picked up? Jack and shit. The other day Cpl. Stevens managed to get one of his 'local friends'\
	to bring in some 'essential supplies'. Seems that pretty much all there is to do around here is drink, look at the consoles, and watch whatever dogshit movie someone has downloaded. Good news is that we can hear pretty much everything going on in this backwater, \
	bad news is that none of it's interesting. Lizards are still nuking each other, Skrell are doing some research on shit no one cares about over on Oueueue- the other fucking planet. The day the Alliance bails on this place is going to be the happiest day of my life."

/obj/item/paper/fluff/sol_uueoa/entry3
	name = "SAMS Sentinel Entry #3"
	info = "Lt. Lillian Crenshaw, personal log. August 9th, 2446. Some shit has actually been happening lately. Apparently some of the lizards have turned to piracy, and are causing problems in the nearby systems. So, we wind up cross-referencing energy emissions and ship IFFs, and \
	passing those off to the Navy proper to deal with. Not exactly riveting shit and serving my country or whatever but hey, something other than watching Stevens and Huang arm-wrestle for the eighteenth time this week, or counting the mold spots on the outer hull. God bless the fucking Alliance, ooh-rah.\
	Better get thanked for my goddamn service when I'm out of here."

/obj/item/paper/fluff/sol_uueoa/entry4
	name = "SAMS Sentinel, Personal Letter"
	info = "Dear Mom. I just arrived in Uueoa-Esa (don't ask me how long it took to spell that). There's not much to do around here, but the LT says that most people only stay on this posting for a few months, and then they usually get assigned to Ouerea.\
	That's another planet here, and it's where most of the humans in the system are. The locals, who are these lizard people called Unathi, are having a war on their homeworld, but I hear that it's still safe on Ouerea. I really hope I get posted there, I want to meet \
	an alien! There are Skrell there too, and the LT says that we're meant to make sure they're not up to anything, but it just looks like they're doing a lot of complicated research stuff from what we see. Looking forward to calling you and Dad next time I get leave. Love, Johnny."

/obj/item/paper/fluff/sol_uueoa/entry5
	name = "SAMS Sentinel Unsent Fax"
	info = "words"

/obj/item/paper/fluff/sol_uueoa/entry5/Initialize()
	. = ..()
	var/T = parsepencode(
			{"\[center\]\[flag_sol\]\[/center\]\[br\]
			\[lang=1\]\[center\]\[b\]SAMS Sentinel Emergency Transmission\[/b\]\[/center\]
			\[center\]\[b\]September 12th, 2446\[/b\]\[/center\]
			\[b\]TO:\[/b\] SAMV Yincheng
			\[b\]FROM:\[/b\] Lieutenant Lillian Crenshaw, SAMS Sentinel
			\[b\]MESSAGE:\[/b] Emergency transmission to SAMV Yincheng. The listening post SAMS Sentinel, located at the attached
			coordinates in the local asteroid belt, is under attack by pirates. Requesting backup immediately, they're almost through
			the airlock. My men are armed and preparing to repel but they have us outnumbered, sen-.\[/lang]"}
	)
	info = T
	icon_state = "paper_words"
