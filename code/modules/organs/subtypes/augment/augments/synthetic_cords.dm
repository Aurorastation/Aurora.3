/obj/item/organ/internal/augment/synthetic_cords
	name = "synthetic vocal cords"
	desc = "An array of vocal cords loaded into an augment kit, allowing easy installation by a skilled technician."
	organ_tag = BP_AUG_CORDS
	parent_organ = BP_HEAD

/obj/item/organ/internal/augment/synthetic_cords/voice
	desc = "An array of vocal cords. These appears to have been modified with a specific accent."
	organ_tag = BP_AUG_ACC_CORDS
	var/accent = ACCENT_TTS

/obj/item/organ/internal/augment/synthetic_cords/replaced(var/mob/living/carbon/human/target, obj/item/organ/external/affected)
	. = ..()
	target.sdisabilities &= ~MUTE

/obj/item/organ/internal/augment/synthetic_cords/removed(var/mob/living/carbon/human/target, mob/living/user)
	target.sdisabilities |= MUTE
	..()
