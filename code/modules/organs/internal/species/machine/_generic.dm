/obj/item/organ/internal/machine
	name = "generic machine organ"
	parent_organ = BP_CHEST
	organ_tag = "generic machine organ"

/obj/item/organ/internal/machine/Initialize()
	robotize()
	. = ..()
