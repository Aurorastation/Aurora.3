/*
 * Contains
 * /obj/item/rig_module/vision
 * /obj/item/rig_module/vision/multi
 * /obj/item/rig_module/vision/meson
 * /obj/item/rig_module/vision/thermal
 * /obj/item/rig_module/vision/nvg
 * /obj/item/rig_module/vision/medhud
 * /obj/item/rig_module/vision/sechud
 */

/datum/rig_vision
	var/mode
	var/obj/item/clothing/glasses/glasses

/datum/rig_vision/nvg
	mode = "night vision"

/datum/rig_vision/nvg/New()
	glasses = new /obj/item/clothing/glasses/night

/datum/rig_vision/thermal
	mode = "thermal scanner"

/datum/rig_vision/thermal/New()
	glasses = new /obj/item/clothing/glasses/thermal

/datum/rig_vision/meson
	mode = "meson scanner"

/datum/rig_vision/meson/New()
	glasses = new /obj/item/clothing/glasses/meson

/datum/rig_vision/material
	mode = "meson scanner"

/datum/rig_vision/material/New()
	glasses = new /obj/item/clothing/glasses/material

/datum/rig_vision/sechud
	mode = "security HUD"

/datum/rig_vision/sechud/New()
	glasses = new /obj/item/clothing/glasses/hud/security

/datum/rig_vision/medhud
	mode = "medical HUD"

/datum/rig_vision/medhud/New()
	glasses = new /obj/item/clothing/glasses/hud/health

/obj/item/rig_module/vision
	name = "hardsuit visor"
	desc = "A layered, translucent visor system for a hardsuit."
	icon_state = "optics"

	interface_name = "optical scanners"
	interface_desc = "An integrated multi-mode vision system."

	engage_on_activate = FALSE
	usable = TRUE
	toggleable = TRUE
	disruptive = FALSE
	confined_use = TRUE

	engage_string = "Cycle Visor Mode"
	activate_string = "Enable Visor"
	deactivate_string = "Disable Visor"

	var/datum/rig_vision/vision
	var/list/vision_modes = list(
		/datum/rig_vision/nvg,
		/datum/rig_vision/thermal,
		/datum/rig_vision/meson
		)

	var/vision_index

	category = MODULE_GENERAL

/obj/item/rig_module/vision/multi
	name = "hardsuit optical package"
	desc = "A complete visor system of optical scanners and vision modes."
	icon_state = "fulloptics"

	interface_name = "multi optical visor"
	interface_desc = "An integrated multi-mode vision system."

	vision_modes = list(
		/datum/rig_vision/meson,
		/datum/rig_vision/nvg,
		/datum/rig_vision/thermal,
		/datum/rig_vision/sechud,
		/datum/rig_vision/medhud
		)
	
	category = MODULE_SPECIAL

/obj/item/rig_module/vision/meson
	name = "hardsuit meson/material scanner"
	desc = "A layered, translucent visor system for a hardsuit."
	icon_state = "meson"

	usable = FALSE

	construction_cost = list(DEFAULT_WALL_MATERIAL = 1500, MATERIAL_GLASS = 5000)
	construction_time = 300

	interface_name = "meson/material scanner"
	interface_desc = "An integrated meson/material scanner."

	vision_modes = list(
		/datum/rig_vision/meson,
		/datum/rig_vision/material
		)
	
/obj/item/rig_module/vision/thermal
	name = "hardsuit thermal scanner"
	desc = "A layered, translucent visor system for a hardsuit."
	icon_state = "thermal"

	usable = FALSE

	interface_name = "thermal scanner"
	interface_desc = "An integrated thermal scanner."

	vision_modes = list(/datum/rig_vision/thermal)

	category = MODULE_LIGHT_COMBAT

/obj/item/rig_module/vision/nvg
	name = "hardsuit night vision interface"
	desc = "A multi input night vision system for a hardsuit."
	icon_state = "night"

	usable = FALSE

	construction_cost = list(DEFAULT_WALL_MATERIAL = 1500, MATERIAL_GLASS = 5000, MATERIAL_URANIUM = 5000)
	construction_time = 300

	interface_name = "night vision interface"
	interface_desc = "An integrated night vision system."

	vision_modes = list(/datum/rig_vision/nvg)

	category = MODULE_LIGHT_COMBAT

/obj/item/rig_module/vision/sechud
	name = "hardsuit security hud"
	desc = "A simple tactical information system for a hardsuit."
	icon_state = "securityhud"

	usable = FALSE

	construction_cost = list(DEFAULT_WALL_MATERIAL = 1500, MATERIAL_GLASS = 5000)
	construction_time = 300

	interface_name = "security HUD"
	interface_desc = "An integrated security heads up display."

	vision_modes = list(/datum/rig_vision/sechud)

	category = MODULE_LIGHT_COMBAT

/obj/item/rig_module/vision/medhud
	name = "hardsuit medical hud"
	desc = "A simple medical status indicator for a hardsuit."
	icon_state = "healthhud"

	usable = FALSE

	construction_cost = list(DEFAULT_WALL_MATERIAL = 1500, MATERIAL_GLASS = 5000)
	construction_time = 300

	interface_name = "medical HUD"
	interface_desc = "An integrated medical heads up display."

	vision_modes = list(/datum/rig_vision/medhud)

	category = MODULE_MEDICAL

// There should only ever be one vision module installed in a suit.
/obj/item/rig_module/vision/installed()
	..()
	holder.visor = src

/obj/item/rig_module/vision/engage(atom/target, mob/user)
	if(!..() || !vision_modes)
		return FALSE
	if(!active)
		to_chat(user, SPAN_WARNING("\The [src] isn't activated!"))
		return FALSE

	if(vision_modes.len > 1)
		vision_index++
		if(vision_index > vision_modes.len)
			vision_index = 1
		vision = vision_modes[vision_index]

		message_user(user, SPAN_NOTICE("You cycle \the [src] to <b>[vision.mode]</b> mode."), SPAN_NOTICE("\The [user] cycles \the [src] to <b>[vision.mode]</b> mode."))
	else
		to_chat(user, SPAN_WARNING("\The [src] only has one mode."))
	return TRUE

/obj/item/rig_module/vision/New()
	..()

	if(!vision_modes)
		return

	vision_index = 1
	var/list/processed_vision = list()

	for(var/vision_mode in vision_modes)
		var/datum/rig_vision/vision_datum = new vision_mode
		if(!vision) vision = vision_datum
		processed_vision += vision_datum

	vision_modes = processed_vision