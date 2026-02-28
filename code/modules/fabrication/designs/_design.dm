/singleton/fabricator_recipe
	/// Name to show in the fabricator for this recipe
	var/name = "object"
	/// Path of the object to print
	var/obj/path
	/// If true, the fabricator needs to be hacked before it can print this design
	var/hack_only
	/// If set, the ship needs to be at this alert level before fabricators on it can print this design. Ignored if hacked
	var/security_level
	/// What category will the recipe appear in?
	var/category
	/// What resources the recipe needs. Defaults to the amount of materials inside the object, multiplied by 1.25
	var/list/resources
	/// Whether to treat the object as a stack or not. Will show multipliers for building
	var/is_stack
	/// What types of fabricators will this recipe appear in?
	var/list/fabricator_types = list(
		FABRICATOR_CLASS_GENERAL
	)
	/// Build time for the recipe. Defaults to 5 SECONDS
	var/build_time = 5 SECONDS
	/// Set to explicit FALSE to cause n stacks to be created instead of 1 stack of n amount.
	/// Does not work for non-stacks being created as stacks, do not set to explicit TRUE for non-stacks.
	var/pass_multiplier_to_product_new

/singleton/fabricator_recipe/New()
	..()
	if(!path)
		return
	if(isnull(pass_multiplier_to_product_new))
		pass_multiplier_to_product_new = ispath(path, /obj/item/stack)

/singleton/fabricator_recipe/proc/get_resources()
	var/list/resources = list()
	for(var/material in path.matter)
		resources[material] = path.matter[material] * FABRICATOR_EXTRA_COST_FACTOR
	return resources

/singleton/fabricator_recipe/proc/build(turf/location, datum/fabricator_build_order/order)
	. = list()
	if(ispath(path, /obj/item/stack) && pass_multiplier_to_product_new)
		. += new path(location, order.multiplier)
	else
		for(var/i = 1, i <= order.multiplier, i++)
			. += new path(location)
