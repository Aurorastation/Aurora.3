/obj/item/robot_module/aicontrol
	name = "ai controlled robot module"
	channels = list(CHANNEL_COMMAND = TRUE, CHANNEL_SCIENCE = TRUE, CHANNEL_MEDICAL = TRUE, CHANNEL_ENGINEERING = TRUE, CHANNEL_SECURITY = TRUE, CHANNEL_SUPPLY = TRUE, CHANNEL_SERVICE = TRUE, CHANNEL_AI_PRIVATE = TRUE, CHANNEL_HAILING = TRUE)
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

	sprites = list("Basic" = list(ROBOT_CHASSIS = "shell", ROBOT_PANEL = "shell", ROBOT_EYES = "shell"))
	all_access = TRUE

/obj/item/robot_module/aicontrol/Initialize()
	. = ..()
	modules += new /obj/item/crowbar/hydraulic_rescue_tool(src)
	modules += new /obj/item/wrench/robotic(src)
	modules += new /obj/item/device/healthanalyzer(src)
	modules += new /obj/item/extinguisher/mini(src)
	modules += new /obj/item/device/advanced_healthanalyzer/cyborg(src)
	modules += new /obj/item/tank/jetpack/carbondioxide/synthetic(src)
	modules += new /obj/item/inflatable_dispenser(src)
	modules += new /obj/item/device/gps(src)
	modules += new /obj/item/taperoll/medical(src)
	modules += new /obj/item/taperoll/engineering(src)
	modules += new /obj/item/taperoll/police(src)
	modules += new /obj/item/taperoll/science(src)
	modules += new /obj/item/pen/robopen(src)
	modules += new /obj/item/form_printer(src)
	modules += new /obj/item/gripper/paperwork(src)
	modules += new /obj/item/device/flash(src)

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

/mob/living/silicon/robot/shell/choose_icon()
	return
