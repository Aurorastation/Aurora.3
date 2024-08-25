/singleton/autolathe_recipe
	var/name = "object"
	var/path
	var/hidden
	var/category
	var/list/resources
	var/power_use = 0
	var/is_stack
	var/list/fabricator_types = list(
		FABRICATOR_CLASS_GENERAL
	)
	var/build_time = 5 SECONDS
