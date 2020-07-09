/obj/item/borg/sight
	icon = 'icons/obj/decals.dmi'
	icon_state = "securearea"
	var/sight_mode = null

/obj/item/borg/sight/on_module_hotbar(mob/living/silicon/robot/R)
	R.sight_mode |= sight_mode

/obj/item/borg/sight/on_module_store(mob/living/silicon/robot/R)
	R.sight_mode &= ~sight_mode

/obj/item/borg/sight/xray
	name = "\proper x-ray vision"
	sight_mode = BORGXRAY

/obj/item/borg/sight/thermal
	name = "\proper thermal vision"
	desc_antag = "Having this device on your hotbar will allow you to see in enhanced thermal vision, which allows you to see heat signatures through solid walls."
	sight_mode = BORGTHERM
	icon_state = "thermal"
	icon = 'icons/obj/clothing/glasses.dmi'

/obj/item/borg/sight/meson
	name = "\proper meson vision"
	sight_mode = BORGMESON
	icon_state = "meson"
	icon = 'icons/obj/clothing/glasses.dmi'

/obj/item/borg/sight/material
	name = "\proper material scanner vision"
	sight_mode = BORGMATERIAL

/obj/item/borg/sight/hud
	name = "hud"
	var/obj/item/clothing/glasses/hud/hud = null


/obj/item/borg/sight/hud/med
	name = "medical hud"
	icon_state = "healthhud"
	icon = 'icons/obj/clothing/glasses.dmi'

/obj/item/borg/sight/hud/med/Initialize(mapload, ...)
	. = ..()
	hud = new /obj/item/clothing/glasses/hud/health(src)

/obj/item/borg/sight/hud/sec
	name = "security hud"
	icon_state = "securityhud"
	icon = 'icons/obj/clothing/glasses.dmi'

/obj/item/borg/sight/hud/sec/Initialize(mapload, ...)
	. = ..()
	hud = new /obj/item/clothing/glasses/hud/security(src)