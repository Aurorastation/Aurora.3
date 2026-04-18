/obj/item/organ/internal/machine/data
	name = "data core"
	organ_tag = "data core"
	parent_organ = BP_GROIN
	icon = 'icons/obj/cloning.dmi'
	icon_state = "harddisk"
	vital = FALSE
	emp_coeff = 0.1
	robotic_sprite = FALSE

	max_damage = 30

/obj/item/organ/internal/machine/data/Initialize()
	robotize()
	. = ..()
