/obj/item/organ/internal/machine/actuators
	name = "actuators"
	desc = "This mixture of electronic, pneumatic and hydraulic components allow a positronic chassis' arms to produce force and torque to allow them to move their artificial limbs."

/obj/item/organ/internal/machine/actuators/left
	name = "right arm actuators"
	parent_organ = BP_L_ARM

/obj/item/organ/internal/machine/actuators/right
	name = "right arm actuators"
	parent_organ = BP_R_ARM

/obj/item/organ/internal/machine/actuators/high_integrity_damage(integrity)
	. = ..()
	if(!.)
		return

	if(prob(damage))
		spark(owner, 5, GLOB.alldirs)
		to_chat(owner, SPAN_WARNING("Your actuators malfunction and you drop what you're holding!"))
		owner.drop_item()
