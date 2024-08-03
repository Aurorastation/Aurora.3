/singleton/autolathe_recipe
	var/name = "object"
	var/path
	var/list/resources
	var/hidden
	var/category
	var/power_use = 0
	var/is_stack

	/// If true, the autolathe needs to be hacked before it can print this design
	var/hack_only

	/// If set, the ship needs to be at this alert level before autolathes on it can print this design. ignored if hacked
	var/security_level
