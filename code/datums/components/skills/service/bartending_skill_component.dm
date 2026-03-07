/datum/component/skill/bartending

/datum/moodlet/bartender_drink

/datum/component/drink_moodlet_provider
	var/moodlet_value = 0
	var/overwrite_moodlet = FALSE

/datum/component/drink_moodlet_provider/Initialize(var/value = 5.0, var/overwrite = FALSE)
	. = ..()
	if (!parent)
		return

	moodlet_value = value
	overwrite_moodlet = overwrite
	RegisterSignal(parent, COMSIG_CONTAINER_DRANK, PROC_REF(handle_drank), override = TRUE)

/datum/component/drink_moodlet_provider/Destroy()
	if (!parent)
		return ..()

	UnregisterSignal(parent, COMSIG_CONTAINER_DRANK)
	return ..()

/datum/component/drink_moodlet_provider/proc/handle_drank(var/obj/item/reagent_containers/owner, var/mob/user)
	if (QDELING(src))
		return

	if (!owner.reagents.total_volume)
		qdel(src)
		// No return here because total volume can be empty at this step (if the person drank the last of a cup)

	var/datum/component/morale/morale_comp = user.GetComponent(MORALE_COMPONENT)
	if (!morale_comp)
		return

	if (!overwrite_moodlet && astype(morale_comp.moodlets[/datum/moodlet/bartender_drink], /datum/moodlet)?.get_morale_modifier() > moodlet_value)
		// Return if they already have a better drink moodlet.
		return

	var/datum/moodlet/new_moodlet = morale_comp.load_moodlet(/datum/moodlet/bartender_drink, moodlet_value)
	new_moodlet.refresh_moodlet() // Reset the duration when they drink it.
	to_chat(user, SPAN_GOOD("You currently have [moodlet_value] morale points from consuming a skillfully prepared drink."))
