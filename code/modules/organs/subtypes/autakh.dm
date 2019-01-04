/obj/item/organ/external/head/autakh
	dislocated = -1
	encased = "support frame"
	robotize_type = PROSTHETIC_AUTAKH

/obj/item/organ/external/chest/autakh
	dislocated = -1
	encased = "support frame"
	robotize_type = PROSTHETIC_AUTAKH

/obj/item/organ/external/groin/autakh
	dislocated = -1
	encased = "support frame"
	robotize_type = PROSTHETIC_AUTAKH

/obj/item/organ/external/arm/autakh
	dislocated = -1
	encased = "support frame"
	robotize_type = PROSTHETIC_AUTAKH

/obj/item/organ/external/arm/right/autakh
	dislocated = -1
	encased = "support frame"
	robotize_type = PROSTHETIC_AUTAKH

/obj/item/organ/external/leg/autakh
	dislocated = -1
	encased = "support frame"
	robotize_type = PROSTHETIC_AUTAKH

/obj/item/organ/external/leg/right/autakh
	dislocated = -1
	encased = "support frame"
	robotize_type = PROSTHETIC_AUTAKH

/obj/item/organ/external/foot/autakh
	dislocated = -1
	encased = "support frame"
	robotize_type = PROSTHETIC_AUTAKH

/obj/item/organ/external/foot/right/autakh
	dislocated = -1
	encased = "support frame"
	robotize_type = PROSTHETIC_AUTAKH

/obj/item/organ/external/hand/autakh
	dislocated = -1
	encased = "support frame"
	robotize_type = PROSTHETIC_AUTAKH

/obj/item/organ/external/hand/right/autakh
	dislocated = -1
	encased = "support frame"
	robotize_type = PROSTHETIC_AUTAKH

//internal organs

/obj/item/organ/kidneys/autakh
	name = "toxin screen"
	robotic = 1

/obj/item/organ/anchor
	name = "soul anchor"
	icon_state = "brain-prosthetic"
	organ_tag = "anchor"
	parent_organ = "head"
	robotic = 2

/obj/item/organ/eyes/autakh
	name = "bionic eyeballs"
	icon_state = "eyes"
	singular_name = "bionic eye"

/obj/item/organ/eyes/autakh/flash_act()
	return

/obj/item/organ/adrenal
	name = "adrenal management system"
	icon_state = "brain-prosthetic"
	organ_tag = "adrenal"
	parent_organ = "chest"
	robotic = 2

/obj/item/organ/haemodynamic
	name = "haemodynamic control system"
	icon_state = "brain-prosthetic"
	organ_tag = "haemodynamic"
	parent_organ = "chest"
	robotic = 1
	action_button_name = "Activate Haemodynamic Control System"

/obj/item/organ/haemodynamic/refresh_action_button()
	. = ..()
	if(.)
		action.button_icon_state = "AAAAAAAAAAAUGH"
		if(action.button) action.button.UpdateIcon()

/obj/item/organ/haemodynamic/attack_self(var/mob/user)
	. = ..()

	if(.)

		if(owner.last_special > world.time)
			to_chat(owner, "<span class='danger'>Your \the [src] is still recharging!</span>")
			return

		if(owner.stat || owner.paralysis || owner.stunned || owner.weakened)
			to_chat(src, "<span class='danger'>You can not use your \the [src] in your current state!</span>")
			return

		owner.last_special = world.time + 250
		to_chat(src, "<span class='notice'>Insert message here!</span>")

		owner.adjustBruteLoss(rand(5,10))
		owner.adjustToxLoss(rand(10,20))

		if(owner.reagents)
			owner.reagents.add_reagent("tramadol", 5)
			owner.reagents.add_reagent("inaprovaline", 5)