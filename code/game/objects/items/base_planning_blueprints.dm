/obj/item/base_planning_blueprints
	name = "base planning schematics"
	desc = "A blueprint, detailing the structure plans for off-site operations."
	icon = 'icons/obj/item/base_planning_blueprints.dmi'
	icon_state = "blueprints"
	attack_verb = list("attacked", "bapped", "hit")
	w_class = WEIGHT_CLASS_SMALL
	drop_sound = 'sound/items/drop/wrapper.ogg'
	pickup_sound = 'sound/items/pickup/wrapper.ogg'

	/// Whether the object is folded or not.
	var/folded = TRUE
	/// Z-levels that this object not allowed to function at, mainship Z-levels by default.
	var/list/invalid_z_levels = list()

/obj/item/base_planning_blueprints/mechanics_hints()
	. += ..()
	. += "You can Alt-Click this item on a table to unfold it."
	. += "These schematics can be used to plan away base structures, comes with pre-made room templates."

/obj/item/base_planning_blueprints/Initialize()
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/item/base_planning_blueprints/LateInitialize()
	invalid_z_levels = SSmapping.levels_by_trait(ZTRAIT_STATION)
	AddComponent(/datum/component/eye/base_planner)

/obj/item/base_planning_blueprints/AltClick(mob/user)
	if(folded)
		if(loc == user || !locate(/obj/structure/table) in get_turf(src))
			to_chat(user, SPAN_WARNING("\The [src] needs to be placed on top of a table in order to be unfolded!"))
			return

		folded = FALSE
		anchored = TRUE
		icon_state = "blueprints_unfolded"
	else
		folded = TRUE
		anchored = FALSE
		icon_state = "blueprints"

	playsound(loc, 'sound/items/bureaucracy/paperfold.ogg', 50, TRUE)

/obj/item/base_planning_blueprints/attack_hand(mob/user)
	if(folded)
		return ..()

	if(user.z in invalid_z_levels)
		to_chat(user, SPAN_WARNING("Upon inspection, these schematics contain only groundside architectural designs, which aren't useful for your whereabouts!"))
		return

	var/datum/component/eye/blueprints = GetComponent(/datum/component/eye)
	if(blueprints)
		if(blueprints.look(user))
			to_chat(user, SPAN_NOTICE("You lean forward, inspecting \the [src] attentively."))
			return
