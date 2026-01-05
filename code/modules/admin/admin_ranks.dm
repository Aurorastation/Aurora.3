/datum/admin_rank
	var/rank_name
	var/group_id
	var/rights

/datum/admin_rank/New(raw_data)
	group_id = raw_data["role_id"]
	rank_name = raw_data["name"]
	rights = auths_to_rights(raw_data["auths"])

/datum/admin_rank/proc/auths_to_rights(list/auths)
	. = 0

	for (var/auth in auths)
		switch (lowertext(auth))
			if ("r_buildmode","r_build")
				. |= R_BUILDMODE
			if ("r_admin")
				. |= R_ADMIN
			if ("r_ban")
				. |= R_BAN
			if ("r_fun")
				. |= R_FUN
			if ("r_server")
				. |= R_SERVER
			if ("r_debug")
				. |= R_DEBUG
			if ("r_permissions","r_rights")
				. |= R_PERMISSIONS
			if ("r_possess")
				. |= R_POSSESS
			if ("r_stealth")
				. |= R_STEALTH
			if ("r_rejuv","r_rejuvenate")
				. |= R_REJUVENATE
			if ("r_varedit")
				. |= R_VAREDIT
			if ("r_sound","r_sounds")
				. |= R_SOUNDS
			if ("r_spawn","r_create")
				. |= R_SPAWN
			if ("r_moderator", "r_mod")
				. |= R_MOD
			if ("r_developer", "r_dev")
				. |= R_DEV
			if ("r_cciaa")
				. |= R_CCIAA
			if ("r_everything","r_host","r_all")
				. |= (R_BUILDMODE | R_ADMIN | R_BAN | R_FUN | R_SERVER | R_DEBUG | R_PERMISSIONS | R_POSSESS | R_STEALTH | R_REJUVENATE | R_VAREDIT | R_SOUNDS | R_SPAWN | R_MOD | R_CCIAA | R_DEV)
			else
				crash_with("Unknown rank in file: [auth]")



