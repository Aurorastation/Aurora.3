/datum/bounty/item
	/**
	 * The amount of items that are required to complete the bounty
	 */
	var/required_count = 1

	/**
	 * The amount of items that were shipped, that satisfies the bounty
	 */
	var/shipped_count = 0

	/**
	 * A `/list` of types accepted for the bounty
	 *
	 * If `include_subtypes` is `TRUE`, subtypes will also be accepted
	 */
	var/list/wanted_types = list()

	/**
	 * Boolean, if `TRUE`, subtypes of the types listed in `wanted_types` will be accepted
	 */
	var/include_subtypes = TRUE

	/**
	 * A `/list` of types excluded from the bounty
	 */
	var/list/exclude_types = list()

	/**
	 * This will randomize required_count when initialized by picking a random amount of required_count + and - this number
	 *
	 * At least 1 will always be required count. Leave at 0 to not randomize.
	 */
	var/random_count = 0


/datum/bounty/item/New()
	..()
	wanted_types = typecacheof(wanted_types)
	exclude_types = typecacheof(exclude_types)
	if(random_count > 0)
		required_count = rand(max(1, required_count - random_count), required_count + random_count)
		//adjust the reward. If more than standard required_count, increase reward. If less, decrease.
		//Will make the reward more/less depending if it was randomized to require more/less, by 5% of the item's reward per difference. Not huge.
		reward += (required_count - initial(required_count)) * round(reward * 0.05, 10)

/datum/bounty/item/completion_string()
	return {"[shipped_count]/[required_count]"}

/datum/bounty/item/can_claim()
	return ..() && shipped_count >= required_count

/datum/bounty/item/applies_to(obj/O)
	if(!include_subtypes && !(O.type in wanted_types))
		return FALSE
	if(include_subtypes && (!is_type_in_typecache(O, wanted_types) || is_type_in_typecache(O, exclude_types)))
		return FALSE
	return shipped_count < required_count

/datum/bounty/item/ship(obj/O)
	if(!applies_to(O))
		return
	shipped_count += 1

/datum/bounty/item/compatible_with(var/datum/other_bounty)
	return type != other_bounty.type

