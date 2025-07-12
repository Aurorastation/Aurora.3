/// Apply basic contextual screentips when the user hovers over this item with an empty hand.
/// A "Type B" interaction.
/// This stacks with other contextual screentip elements, though you may want to register the signal/flag manually at that point for performance.
/datum/element/contextual_screentip_bare_hands
	element_flags = ELEMENT_BESPOKE | ELEMENT_DETACH_ON_HOST_DESTROY // Detach for turfs
	argument_hash_start_idx = 2

	/// If set, the text to show for LMB. Default 'help mode'
	var/lmb_text

	/// If set, the text to show for RMB. Default 'help mode'
	var/rmb_text

	/// If set, the text to show for LMB when in disarm mode. Otherwise, defaults to lmb_text.
	var/lmb_text_disarm_mode
	/// If set, the text to show for LMB when in grab mode. Otherwise, defaults to lmb_text.
	var/lmb_text_grab_mode
	/// If set, the text to show for LMB when in hurt mode. Otherwise, defaults to lmb_text.
	var/lmb_text_hurt_mode

	/// If set, the text to show for rmb when in disarm mode. Otherwise, defaults to rmb_text.
	var/rmb_text_disarm_mode
	/// If set, the text to show for rmb when in grab mode. Otherwise, defaults to rmb_text.
	var/rmb_text_grab_mode
	/// If set, the text to show for rmb when in hurt mode. Otherwise, defaults to rmb_text.
	var/rmb_text_hurt_mode

// If you're curious about `use_named_parameters`, it's because you should use named parameters!
// AddElement(/datum/element/contextual_screentip_bare_hands, rmb_text = "Do the thing")
/datum/element/contextual_screentip_bare_hands/Attach(
	datum/target,
	use_named_parameters,
	lmb_text,
	rmb_text,
	lmb_text_disarm_mode,
	rmb_text_disarm_mode,
	lmb_text_grab_mode,
	rmb_text_grab_mode,
	lmb_text_hurt_mode,
	rmb_text_hurt_mode,
)
	. = ..()
	if (!isatom(target))
		return ELEMENT_INCOMPATIBLE

	if (!isnull(use_named_parameters))
		CRASH("Use named parameters instead of positional ones.")

	src.lmb_text = lmb_text
	src.rmb_text = rmb_text
	src.lmb_text_disarm_mode = lmb_text_disarm_mode || lmb_text
	src.rmb_text_disarm_mode = rmb_text_disarm_mode || rmb_text
	src.lmb_text_grab_mode = lmb_text_grab_mode || lmb_text
	src.rmb_text_grab_mode = rmb_text_grab_mode || rmb_text
	src.lmb_text_hurt_mode = lmb_text_hurt_mode || lmb_text
	src.rmb_text_hurt_mode = rmb_text_hurt_mode || rmb_text

	var/atom/atom_target = target
	atom_target.flags_1 |= HAS_CONTEXTUAL_SCREENTIPS_1
	RegisterSignal(atom_target, COMSIG_ATOM_REQUESTING_CONTEXT_FROM_ITEM, PROC_REF(on_requesting_context_from_item))

/datum/element/contextual_screentip_bare_hands/Detach(datum/source, ...)
	UnregisterSignal(source, COMSIG_ATOM_REQUESTING_CONTEXT_FROM_ITEM)

	// We don't remove HAS_CONTEXTUAL_SCREENTIPS_1, since there could be other stuff still hooked to it,
	// and being set without signals is not dangerous, just less performant.
	// A lot of things don't do this, perhaps make a proc that checks if any signals are still set, and if not,
	// remove the flag.

	return ..()

/datum/element/contextual_screentip_bare_hands/proc/on_requesting_context_from_item(
	datum/source,
	list/context,
	obj/item/held_item,
	mob/user,
)
	SIGNAL_HANDLER

	if(!isliving(user))
		return .

	if (!isnull(held_item))
		return NONE

	var/mob/living/living_user = user
	var/intent = living_user.a_intent
	if (!isnull(lmb_text))
		switch(intent)
			if(I_DISARM)
				context[SCREENTIP_CONTEXT_LMB] = lmb_text_disarm_mode ? lmb_text_disarm_mode : lmb_text
			else if(I_GRAB)
				context[SCREENTIP_CONTEXT_LMB] = lmb_text_grab_mode ? lmb_text_grab_mode : lmb_text
			else if(I_HURT)
				context[SCREENTIP_CONTEXT_LMB] = lmb_text_hurt_mode ? lmb_text_hurt_mode : lmb_text

	if (!isnull(rmb_text))
		switch(intent)
			if(I_DISARM)
				context[SCREENTIP_CONTEXT_RMB] = rmb_text_disarm_mode ? rmb_text_disarm_mode : rmb_text
			else if(I_GRAB)
				context[SCREENTIP_CONTEXT_RMB] = rmb_text_grab_mode ? rmb_text_grab_mode : rmb_text
			else if(I_HURT)
				context[SCREENTIP_CONTEXT_RMB] = rmb_text_hurt_mode ? rmb_text_hurt_mode : rmb_text

	return CONTEXTUAL_SCREENTIP_SET
