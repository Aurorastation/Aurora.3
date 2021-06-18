/obj/item/robot_module/aicontrol
	name = "ai controlled robot module"
	channels = list(CHANNEL_SERVICE = TRUE)
	networks = list(NETWORK_SERVICE)
	var/robot_remote_network = REMOTE_AI_ROBOT
	languages = list(
					LANGUAGE_SOL_COMMON =  TRUE,
					LANGUAGE_TRADEBAND =   TRUE,
					LANGUAGE_UNATHI =      TRUE,
					LANGUAGE_SIIK_MAAS =   TRUE,
					LANGUAGE_SKRELLIAN =   TRUE,
					LANGUAGE_GUTTER =      TRUE,
					LANGUAGE_VAURCESE =    FALSE,
					LANGUAGE_ROOTSONG =    TRUE,
					LANGUAGE_SIGN =        FALSE,
					LANGUAGE_SIGN_TAJARA = FALSE,
					LANGUAGE_SIIK_TAJR =   FALSE,
					LANGUAGE_AZAZIBA =     FALSE,
					LANGUAGE_DELVAHII =    FALSE,
					LANGUAGE_YA_SSA =      FALSE
					)

	sprites = list(
			"Basic" = "robotserv",
			)

/obj/item/robot_module/aicontrol/Initialize()
	. = ..()
	src.modules += new /obj/item/gripper/service(src)
	src.modules += new /obj/item/reagent_containers/glass/bucket(src)
	src.modules += new /obj/item/material/minihoe(src)
	src.modules += new /obj/item/material/hatchet(src)
	src.modules += new /obj/item/device/analyzer/plant_analyzer(src)
	src.modules += new /obj/item/storage/bag/plants(src)
	src.modules += new /obj/item/robot_harvester(src)
	src.modules += new /obj/item/material/kitchen/rollingpin(src)
	src.modules += new /obj/item/material/knife(src)
	src.modules += new /obj/item/soap/drone(src)
	src.modules += new /obj/item/pen/robopen(src)
	src.modules += new /obj/item/form_printer(src)
	src.modules += new /obj/item/gripper/paperwork(src)
	src.modules += new /obj/item/device/hand_labeler(src)
	src.modules += new /obj/item/tape_roll(src) //allows it to place flyers
	src.modules += new /obj/item/device/nanoquikpay(src)
	src.modules += new /obj/item/reagent_containers/glass/rag(src) // a rag for.. yeah.. the primary tool of bartender
	src.modules += new /obj/item/taperoll/engineering(src) // To enable 'borgs to telegraph danger visually.
	src.modules += new /obj/item/inflatable_dispenser(src) // To enable 'borgs to protect Crew from danger in direct hazards.
	src.modules += new /obj/item/device/gps(src) // For being located while disabled and coordinating with life sensor consoles.
	src.modules += new /obj/item/extinguisher/mini(src) // For navigating space and/or low grav, and just being useful.
	src.modules += new /obj/item/device/flash(src) // Non-lethal tool that prevents any 'borg from going lethal on Crew so long as it's an option according to laws.
	src.modules += new /obj/item/crowbar/robotic(src) // Base crowbar that all 'borgs should have access to.

	src.modules += new /obj/item/reagent_containers/dropper/industrial(src)

	var/obj/item/flame/lighter/zippo/L = new /obj/item/flame/lighter/zippo(src)
	L.lit = TRUE
	src.modules += L

	src.modules += new /obj/item/tray/robotray(src)
	src.modules += new /obj/item/reagent_containers/hypospray/borghypo/service(src)
	src.emag = new /obj/item/reagent_containers/food/drinks/bottle/small/beer(src)

	var/datum/reagents/RG = new /datum/reagents(50)
	src.emag.reagents = RG
	RG.my_atom = src.emag
	RG.add_reagent(/decl/reagent/polysomnine/beer2, 50)
	src.emag.name = "Mickey Finn's Special Brew"

/mob/living/silicon/robot/shell
	spawn_module = /obj/item/robot_module/aicontrol
	cell_type = /obj/item/cell/super