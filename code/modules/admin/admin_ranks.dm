/datum/admin_rank
	var/rank_name
	var/group_id
	var/rights

/datum/admin_rank/New(raw_data)
	group_id = raw_data["role_id"]
	rank_name = raw_data["name"]
	rights = SSauth.auths_to_rights(raw_data["auths"])
