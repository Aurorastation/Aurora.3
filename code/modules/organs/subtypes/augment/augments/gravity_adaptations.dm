/obj/item/organ/internal/augment/bioaug/gravity_adaptations
	name = "gravity adaptations"
	desc = "A suite of chemical glands, tailored epigenetic therapies, and skeletal reinforcements that are aimed towards Galatean Off-worlders" \
	+ "These bioaugmentations serve to eliminate the weakness experienced by Off-worlders in standard terrestrial gravity."
	icon_state = "mind_blanker" //It's small and just looks like a little blob of flesh, so good enough for a placeholder for chemical glands.
	organ_tag = BP_AUG_GRAV_ADAPTATION
	parent_organ = BP_CHEST

/obj/item/organ/internal/augment/bioaug/gravity_adaptations/Initialize()
	. = ..()
	if(!owner)
		return

	RegisterSignal(owner, COMSIG_GRAVITY_WEAKNESS_EVENT, PROC_REF(negate_weakness), override = TRUE)

/obj/item/organ/internal/augment/bioaug/gravity_adaptations/replaced()
	. = ..()
	if(!owner)
		return

	RegisterSignal(owner, COMSIG_GRAVITY_WEAKNESS_EVENT, PROC_REF(negate_weakness), override = TRUE)

/obj/item/organ/internal/augment/bioaug/gravity_adaptations/removed()
	. = ..()
	if(!owner)
		return

	UnregisterSignal(owner, COMSIG_GRAVITY_WEAKNESS_EVENT)

/obj/item/organ/internal/augment/bioaug/gravity_adaptations/proc/negate_weakness(var/implantee, var/canceled)
	SIGNAL_HANDLER
	*canceled = TRUE //TODO: TCJ just make this a component I can shove onto anything.
