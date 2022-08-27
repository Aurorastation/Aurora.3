/datum/faction/admin
	name = "Admin Jobs"
	description = {"<p>
	This faction is used exclusively for administrative jobs used by Staff Roles
	</p>
	"}

	title_suffix = "SCC"

	allowed_role_types = ADMIN_ROLES

	allowed_species_types = list(
		/datum/species/human,
		/datum/species/skrell
	)

/datum/faction/admin/is_visible(var/user)
	return check_rights(R_CCIAA,FALSE,user)
