/datum/faction/unaffiliated
	name = "Independent"
	description = {"
	For individuals not necessarily tied to any of the large mega corporations lording
	over human space, the mark of "independent" can open as many doors as it is likely to
	close. You would often see people lacking a concrete affiliation popping up as
	reporters, journalists, individual traders. Their presence, though often an inconvenience
	for the mega corporations, is often necessary to forward the facade of economic freedom
	that Tau Ceti reports to have.
	"}
	departments = list(DEPARTMENT_CIVILIAN)
	allowed_role_types = INDEP_ROLES

	title_suffix = "INDEP"

	ui_priority = INFINITY // bottom of the list
