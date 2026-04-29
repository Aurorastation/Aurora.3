/datum/element/dark_afraid
	element_flags = ELEMENT_DETACH_ON_HOST_DESTROY

	/// The set of messages to draw from for characters with the Nyctophobia trait.
	var/list/afraid_of_the_dark_messages = list(
		"You feel a bit afraid...",
		"You feel somewhat nervous...",
		"You could use a little light here...",
		"It's dark enough that you feel a little anxious..."
	)

/datum/element/dark_afraid/Attach(datum/target)
	. = ..()
	RegisterSignal(target, COMSIG_MOB_UPDATE_VISION, PROC_REF(handle_vision_update))

/datum/element/dark_afraid/Detach(datum/target)
	. = ..()
	UnregisterSignal(target, COMSIG_MOB_UPDATE_VISION)

/datum/element/dark_afraid/proc/handle_vision_update(mob/living/carbon/human/human)
	SIGNAL_HANDLER
	if (!prob(2) || astype(get_turf(human), /turf)?.get_lumcount() >= 0.2)
		return

	to_chat(human, SPAN_WARNING(pick(afraid_of_the_dark_messages)))
