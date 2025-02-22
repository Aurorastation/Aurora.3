/obj/item/organ/internal/machine
	name = "generic machine organ"
	parent_organ = BP_CHEST
	organ_tag = "generic machine organ"

	/// The wiring datum of this organ.
	var/datum/synthetic_internal/wiring/wiring
	/// The plating datum of this organ.
	var/datum/synthetic_internal/plating/plating
	/// The electronics datum of this organ.
	var/datum/synthetic_internal/electronics/electronics

/obj/item/organ/internal/machine/Initialize()
	robotize()
	. = ..()
	wiring = new(src)
	plating = new(src)
	electronics = new(src)
