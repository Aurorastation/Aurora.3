/**
 * Synthetic organ presets are a way to allow us to have customizable and easily expandable presets for different organs.
 * This is partly due to the limitations of the organ modification system, which does not support manually selecting different types,
 * but also to allow the creation of different presets to do different things in a modular and easily expandable way.
 */
/singleton/synthetic_organ_preset
	/// The name the synthetic organ will have.
	var/name = "epic synthetic organ"
	/// The description synthetic organ will get.
	var/desc = "It is super epic and cool."
	/// Replacement icon state. Leave null if you don't want to replace the original state.
	var/icon_state

/singleton/synthetic_organ_preset/proc/apply_preset(obj/item/organ/internal/machine/organ)
	SHOULD_CALL_PARENT(TRUE)
	if(!istype(organ))
		crash_with("Synthetic organ preset called with invalid organ [organ]")

	organ.name = name
	organ.desc = desc
	if(icon_state)
		organ.icon_state = icon_state
