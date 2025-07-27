/obj/item/organ/internal/eyes/optical_sensor
	name = "optical sensor"
	singular_name = "optical sensor"
	organ_tag = BP_EYES
	icon = 'icons/obj/organs/ipc_organs.dmi'
	icon_state = "ipc_eyes"
	robotic_sprite = FALSE
	possible_modifications = list("Mechanical")

/obj/item/organ/internal/eyes/optical_sensor/Initialize()
	robotize()
	. = ..()

/obj/item/organ/internal/eyes/optical_sensor/terminator
	emp_coeff = 0.5
