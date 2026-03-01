///List of all vars that will not be copied over when using duplicate_object()
GLOBAL_LIST_INIT(duplicate_forbidden_vars, list("actions",
	"_active_timers",
	"appearance",
	"area",
	"bodyparts",
	"ckey",
	"computer_id",
	"contents",
	"cooldowns",
	"_datum_components",
	"emissive_overlay",
	"group",
	"hud_list",
	"important_recursive_contents",
	"internal_organs",
	"internal_organs_by_name",
	"_listen_lookup",
	"organs",
	"organs_by_name",
	"key",
	"lastKnownIP",
	"loc",
	"locs",
	"overlays",
	"parent",
	"parent_type",
	"pixloc",
	"power_supply",
	"reagents",
	"_signal_procs",
	"status_traits",
	"stat",
	"tag",
	"tgui_shared_states",
	"type",
	"vars",
	"verbs",
	"x", "y", "z",
))
GLOBAL_PROTECT(duplicate_forbidden_vars)

/**
 * # duplicate_object
 *
 * Makes a copy of an item and transfers most vars over, barring GLOB.duplicate_forbidden_vars
 * Args:
 * original - Atom being duplicated
 * spawning_location - Turf where the duplicated atom will be spawned at.
 */
/proc/duplicate_object(atom/original, turf/spawning_location)
	RETURN_TYPE(original.type)
	if(!original)
		return

	var/atom/made_copy = new original.type(spawning_location)

	for(var/atom_vars in (original.vars - GLOB.duplicate_forbidden_vars))
		var/var_value = original.vars[atom_vars]
		if(isdatum(var_value))
			continue // this would reference the original's object, that will break when it is used or deleted.

		if(islist(var_value))
			var/list/var_list = var_value
			var_value = var_list.Copy()

		made_copy.vars[atom_vars] = var_value

	if(!iscarbon(made_copy))
		return made_copy

	var/mob/living/carbon/original_carbon = original
	var/mob/living/carbon/copied_carbon = made_copy
	var/obj/item/organ/internal/brain/original_brain = original_carbon.internal_organs_by_name[BP_BRAIN]
	original_brain.transfer_identity(copied_carbon)

	if(!ishuman(made_copy))
		return made_copy

	var/mob/living/carbon/human/original_human = original
	//transfer implants, we do this so the original's implants being removed won't destroy ours.
	for(var/obj/item/organ/external/limb in original_human.organs)
		var/list/implants = limb.implants
		for(var/obj/item/implant/original_implants as anything in implants)
			var/obj/item/implant/copied_implant = new original_implants.type
			copied_implant.implantInMob(made_copy)

	return made_copy
