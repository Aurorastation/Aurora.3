/obj/item/organ/internal/machine/actuators
	name = "actuators"
	desc = "This mixture of electronic, pneumatic and hydraulic components allow a positronic chassis' arms to produce force and torque to allow them to move their artificial limbs."
	icon = 'icons/obj/organs/augments.dmi'
	icon_state = "suspension"

/obj/item/organ/internal/machine/actuators/left
	name = "left arm actuators"
	parent_organ = BP_L_ARM

/obj/item/organ/internal/machine/actuators/right
	name = "right arm actuators"
	parent_organ = BP_R_ARM

/obj/item/organ/internal/machine/actuators/high_integrity_damage(integrity)
	if(prob(get_integrity_damage_probability()))
		spark(owner, 5, GLOB.alldirs)
		to_chat(owner, SPAN_WARNING("Your [src] malfunction, making you drop what you're holding!"))
		switch(parent_organ)
			if(BP_L_ARM)
				owner.drop_l_hand()
			if(BP_R_ARM)
				owner.drop_r_hand()
	. = ..()
