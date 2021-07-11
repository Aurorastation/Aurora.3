/obj/item/robot_module/aicontrol
	name = "ai controlled robot module"
	channels = list(CHANNEL_SERVICE = TRUE)
	networks = list(NETWORK_SERVICE)
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

	sprites = list("Basic" = "shell")

/obj/item/robot_module/aicontrol/Initialize()
	. = ..()
	src.modules += new /obj/item/crowbar/robotic/jawsoflife(src)
	src.modules += new /obj/item/wrench/robotic(src)
	src.modules += new /obj/item/device/healthanalyzer(src)
	src.modules += new /obj/item/extinguisher/mini(src)

/mob/living/silicon/robot/shell
	spawn_module = /obj/item/robot_module/aicontrol
	cell_type = /obj/item/cell/super
	remote_network = REMOTE_AI_ROBOT
	scrambled_codes = TRUE

/mob/living/silicon/robot/shell/Initialize()
	. = ..()
	SSvirtualreality.add_robot(src, remote_network)

/obj/item/crowbar/robotic/jawsoflife
	name = "jaws of life"
	desc = "A set of specialized tools that functions as both the ordinary crowbar, but is additionally capable of brute forcing bolted doors."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "jawspry"
	flags = NOBLUDGEON
	force = 0
	sharp = FALSE
	edge = FALSE

/obj/item/crowbar/robotic/jawsoflife/attack(mob/living/carbon/M, mob/living/carbon/user)
	user.visible_message("\The [user] [pick("boops", "squeezes", "pokes", "prods", "strokes", "bonks")] \the [M] with \the [src]")
	return FALSE
