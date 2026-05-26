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
	module_type = MODULETYPE_TOGGLE
	interface_name = "optical scanners"
	interface_desc = "An integrated multi-mode vision system."

	disruptive = FALSE
	confined_use = TRUE

	engage_string = "Cycle Visor Mode"
	activate_string = "Enable Visor"
	deactivate_string = "Disable Visor"

	active_power_cost = 2

	var/datum/rig_vision/vision_mode
	var/list/vision_modes = list(
		/datum/rig_vision/nvg,
		/datum/rig_vision/thermal
		)

	var/vision_index

	category = MODULE_GENERAL

/// There should only ever be one vision module installed in a suit.
/obj/item/rig_module/vision/installed()
	..()
	holder.visor = src

/obj/item/rig_module/vision/New()
	..()

	if(!vision_modes)
		return

	var/list/processed_vision = list()
	for(var/new_vision_mode in vision_modes)
		var/datum/rig_vision/vision_datum = new new_vision_mode
		processed_vision += vision_datum

	vision_modes = processed_vision

	vision_index = 1
	vision_mode = length(vision_modes) ? vision_modes[vision_index] : null

/obj/item/rig_module/vision/get_configuration(mob/user)
	. = ..()
	if(!vision_modes || length(vision_modes) <= 1)
		return .

	var/list/modes = list()
	for(var/datum/rig_vision/added_mode in vision_modes)
		modes += added_mode.mode

	.["vision_mode"] = add_ui_configuration("Visor mode", "list", vision_mode.mode, modes)

/obj/item/rig_module/vision/configure_edit(key, value, mob/user)
	switch(key)
		if("vision_mode")
			set_vision_mode(user, value)

/obj/item/rig_module/vision/proc/set_vision_mode(mob/user, var/new_mode)
	if(!new_mode || new_mode == "")
		return FALSE

	if(!active)
		to_chat(user, SPAN_WARNING("\The [src] isn't activated!"))
		return FALSE

	var/i = 1
	for(var/datum/rig_vision/V in vision_modes)
		if(V.mode == new_mode)
			vision_index = i
			vision_mode = V
			sound_to(user, 'sound/machines/terminal/terminal_select.ogg')
			return TRUE
		i++

	return FALSE

/obj/item/rig_module/vision/activate(mob/user)
	. = ..()
	sound_to(user, 'sound/items/goggles_charge.ogg')

/obj/item/rig_module/vision/deactivate(mob/user)
	. = ..()
	sound_to(user, 'sound/effects/pop.ogg')

/obj/item/rig_module/vision/multi
	name = "hardsuit optical package"
	desc = "A complete visor system of optical scanners and vision modes."
	icon_state = "fulloptics"

	active_power_cost = 3

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

	construction_cost = list(DEFAULT_WALL_MATERIAL = 1500, MATERIAL_GLASS = 5000)
	construction_time = 300

	active_power_cost = 2

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

	active_power_cost = 2

	interface_name = "thermal scanner"
	interface_desc = "An integrated thermal scanner."

	vision_modes = list(/datum/rig_vision/thermal)

	category = MODULE_LIGHT_COMBAT

/obj/item/rig_module/vision/nvg
	name = "hardsuit night vision interface"
	desc = "A multi input night vision system for a hardsuit."
	icon_state = "night"

	construction_cost = list(DEFAULT_WALL_MATERIAL = 1500, MATERIAL_GLASS = 5000, MATERIAL_URANIUM = 5000)
	construction_time = 300

	active_power_cost = 2

	interface_name = "night vision interface"
	interface_desc = "An integrated night vision system."

	vision_modes = list(/datum/rig_vision/nvg)

	category = MODULE_LIGHT_COMBAT

/obj/item/rig_module/vision/sechud
	name = "hardsuit security hud"
	desc = "A simple tactical information system for a hardsuit."
	icon_state = "securityhud"

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

	construction_cost = list(DEFAULT_WALL_MATERIAL = 1500, MATERIAL_GLASS = 5000)
	construction_time = 300

	interface_name = "medical HUD"
	interface_desc = "An integrated medical heads up display."

	vision_modes = list(/datum/rig_vision/medhud)

	category = MODULE_MEDICAL
