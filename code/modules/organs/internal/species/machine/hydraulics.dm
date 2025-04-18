// Hydraulics effects are mainly in /datum/species/machine/handle_sprint_cost.
/obj/item/organ/internal/machine/hydraulics
	name = "hydraulics system"
	desc = "A byzantine system of pumps and other hydraulic components to allow a positronic chassis to stand on both its feet, and do complex tricks such as kicking you in the shins."
	organ_tag = BP_HYDRAULICS
	parent_organ = BP_GROIN

/obj/item/organ/internal/machine/actuators/high_integrity_damage(integrity)
	. = ..()
	if(!.)
		return

	if(prob(damage))
		spark(owner, 2, GLOB.alldirs)
		to_chat(owner, SPAN_WARNING("Your hydraulics malfunction and you trip!"))
		owner.Weaken(1)
