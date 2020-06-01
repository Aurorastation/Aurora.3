/datum/faction/unaffiliated
	name = "Independent"
	description = {"<p>
	For individuals not necessarily tied to any of the large mega corporations lording
	over human space, the mark of "independent" can open as many doors as it is likely to
	close. You would often see people lacking a concrete affiliation popping up as
	reporters, journalists, individual traders. Their presence, though often an inconvenience
	for the mega corporations, is often necessary to forward the facade of economic freedom
	that Tau Ceti reports to have.
	</p>"}

	allowed_role_types = list(
		/datum/job/visitor,
		/datum/job/journalist,
		/datum/job/merchant,
		/datum/job/representative
	)

/datum/faction/unaffiliated/get_logo_name()
	return "faction_unaffiliated.png"
