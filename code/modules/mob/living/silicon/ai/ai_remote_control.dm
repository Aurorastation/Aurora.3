/obj/item/robot_module/aicontrol
	name = "ai controlled robot module"
	channels = list(CHANNEL_COMMAND = TRUE, CHANNEL_SCIENCE = TRUE, CHANNEL_MEDICAL = TRUE, CHANNEL_ENGINEERING = TRUE, CHANNEL_SECURITY = TRUE, CHANNEL_SUPPLY = TRUE, CHANNEL_SERVICE = TRUE, CHANNEL_AI_PRIVATE = TRUE)
	networks = list(NETWORK_COMMAND)
	languages = list(
					LANGUAGE_SOL_COMMON =  TRUE,
					LANGUAGE_ELYRAN_STANDARD = TRUE,
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
		"Basic" = 	       list(ROBOT_CHASSIS = "robot", ROBOT_PANEL = "robot", ROBOT_EYES = "robot"),
		"Interrogator" =       list(ROBOT_CHASSIS = "interrogator", ROBOT_PANEL = "robot", ROBOT_EYES = "interrogator"),
		"Curator" =      list(ROBOT_CHASSIS = "curator", ROBOT_PANEL = "robot", ROBOT_EYES = "curator"),
		"Surveyor" =      list(ROBOT_CHASSIS = "surveyor", ROBOT_PANEL = "robot", ROBOT_EYES = "surveyor"),
		"Hunter" = 	   	   list(ROBOT_CHASSIS = "hunter", ROBOT_PANEL = "robot", ROBOT_EYES = "hunter"),
		"Protector" = list(ROBOT_CHASSIS = "protector", ROBOT_PANEL = "robot", ROBOT_EYES = "protector"),
		"Strider" =        list(ROBOT_CHASSIS = "strider", ROBOT_PANEL = "robot", ROBOT_EYES = "strider"),
		"Coordinator" =           list(ROBOT_CHASSIS = "coordinator", ROBOT_PANEL = "robot", ROBOT_EYES = "coordinator")
	)
	all_access = TRUE

/obj/item/robot_module/aicontrol/Initialize()
	. = ..()
	modules += new /obj/item/crowbar/robotic/jawsoflife(src)
	modules += new /obj/item/wrench/robotic(src)
	modules += new /obj/item/device/healthanalyzer(src)
	modules += new /obj/item/extinguisher/mini(src)
	modules += new /obj/item/device/advanced_healthanalyzer(src)

/mob/living/silicon/robot/shell
	spawn_module = /obj/item/robot_module/aicontrol
	cell_type = /obj/item/cell/super
	remote_network = REMOTE_AI_ROBOT
	scrambled_codes = TRUE

/mob/living/silicon/robot/shell/Initialize()
	. = ..()
	SSvirtualreality.add_bound(src, remote_network)
	name = "AI shell"

/mob/living/silicon/robot/shell/show_laws()
	return

/obj/item/crowbar/robotic/jawsoflife
	name = "jaws of life"
	desc = "A set of specialized tools that functions as both the ordinary crowbar, but is additionally capable of brute forcing bolted doors without power."
	icon = 'icons/obj/item/tools/jawsoflife.dmi'
	icon_state = "jawspry"
	flags = NOBLUDGEON
	force = 0
	sharp = FALSE
	edge = FALSE

/obj/item/crowbar/robotic/jawsoflife/attack(mob/living/carbon/M, mob/living/carbon/user)
	user.visible_message("\The [user] [pick("boops", "squeezes", "pokes", "prods", "strokes", "bonks")] \the [M] with \the [src]")
	return FALSE
