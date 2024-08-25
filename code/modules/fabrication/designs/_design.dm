/singleton/fabricator_recipe
	/// Name to show in the fabricator for this recipe
	var/name = "object"
	var/path
	/// Whether the recipe needs the fabricator to be hacked
	var/hidden
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
