/datum/component/skill/bartending

/datum/moodlet/bartender_drink

/datum/component/drink_moodlet_provider
	/// The morale boosting value of the moodlet this drink will provide.
	var/moodlet_value = 0

	/// Whether the DrinkMoodletProvider is allowed to overwrite stronger moodlets with weaker moodlets.
	var/overwrite_moodlet = FALSE

	/// Original name of the drink before the component changed it.
	var/initial_name

/datum/component/drink_moodlet_provider/Initialize(value = 5.0, overwrite = FALSE, drink_quality)
	. = ..()
	if (!parent)
		return

	moodlet_value = value
	overwrite_moodlet = overwrite
	RegisterSignal(parent, COMSIG_CONTAINER_DRANK, PROC_REF(handle_drank), override = TRUE)

	if (!isatom(parent))
		return

	var/atom/owner = parent
	initial_name = owner.name
	switch (drink_quality)
		if (-INFINITY to 5)
			owner.name = "inferior " + initial_name
		if (5 to 10)
			owner.name = "cheap " + initial_name
		if (10 to 15)
			owner.name = "finely-mixed " + initial_name
		if (15 to 20)
			owner.name = "superior quality " + initial_name
		if (20 to INFINITY)
			owner.name = "masterful " + initial_name

/datum/component/drink_moodlet_provider/Destroy()
	if (!parent)
		return ..()

	UnregisterSignal(parent, COMSIG_CONTAINER_DRANK)
	if (initial_name && istype(parent, /atom))
		parent:name = initial_name

	return ..()

/datum/component/drink_moodlet_provider/proc/handle_drank(obj/item/reagent_containers/owner, mob/user)
	SIGNAL_HANDLER
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
