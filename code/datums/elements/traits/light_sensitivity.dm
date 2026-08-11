/// Moodlet spawned by the Photosensitivity trait.
/datum/moodlet/light_sensitivity
	duration = 2 MINUTES

/// Element used by the Photosensitivity trait.
/datum/element/light_sensitivity
	element_flags = ELEMENT_DETACH_ON_HOST_DESTROY

	/// The set of messages to draw from for characters with the Photosensitivity trait.
	var/list/eye_sensitivity_messages = list(
		"Your eyes tire a bit from the brightness.",
		"Your eyes sting a little; it's too bright.",
		"The bright light leaves your vision strained."
	)

	/// How much this trait modifies morale when triggering.
	var/morale_modifier = -10.0

/datum/element/light_sensitivity/Attach(datum/target)
	. = ..()
	RegisterSignal(target, COMSIG_MOB_UPDATE_VISION, PROC_REF(handle_vision_update))
	RegisterSignal(target, COMSIG_GET_FLASH_PROTECTION_MODIFIERS, PROC_REF(handle_flash_protection))

/datum/element/light_sensitivity/Detach(datum/target)
	UnregisterSignal(target, COMSIG_MOB_UPDATE_VISION)
	UnregisterSignal(target, COMSIG_GET_FLASH_PROTECTION_MODIFIERS)
	return ..()

/datum/element/light_sensitivity/proc/handle_vision_update(mob/living/carbon/human/human)
	SIGNAL_HANDLER
	// First check the light level every once in awhile
	if (!prob(0.5) || astype(get_turf(human), /turf)?.get_lumcount() <= 0.95)
		return

	// Then check if they've got protection from bright lights
	if (human.get_flash_protection() <= 0 || !istype(human.glasses, /obj/item/clothing/glasses/fakesunglasses))
		return

	// And check if someone cut their eyes out.
	if(!human.get_eyes())
		return

	human.eye_blurry = max(human.eye_blurry, 6)
	to_chat(human, SPAN_WARNING(pick(eye_sensitivity_messages)))
	var/datum/component/morale/morale_comp = human.GetComponent(MORALE_COMPONENT)
	if (morale_comp)
		var/datum/moodlet/photosensitivity_moodlet = morale_comp.load_moodlet(/datum/moodlet/light_sensitivity, morale_modifier)
		photosensitivity_moodlet.refresh_moodlet()

	if(!prob(20))
		return

	// If your eyes are covered, people can see you squinting.
	var/list/protection = list(human.head, human.glasses, human.wear_mask)
	for(var/obj/item/I in protection)
		if(I?.body_parts_covered & EYES)
			return

	human.visible_message("<b>[human]</b> squints in discomfort.")

/datum/element/light_sensitivity/proc/handle_flash_protection(mob/living/carbon/human/human, base_flash_protection)
	SIGNAL_HANDLER
	*base_flash_protection = *base_flash_protection - 1
