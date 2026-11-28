/datum/unit_test/access_unique_ids
	name = "ACCESS: All non-abstract /datum/access shall have a unique id"
	groups = list("generic")

/datum/unit_test/access_unique_ids/start_test()
	var/failures = 0
	/// id -> typepath that first claimed it
	var/list/seen_ids = list()

	for(var/datum/access/access_type as anything in subtypesof(/datum/access))
		if(is_abstract(access_type))
			continue

		var/access_id = access_type::id
		if(!isnum(access_id))
			TEST_FAIL("[access_type] has a non-numeric id: [access_id]")
			failures++
			continue

		var/key = "[access_id]"
		if(key in seen_ids)
			TEST_FAIL("[access_type] has id [access_id], which is already used by [seen_ids[key]]")
			failures++
			continue

		seen_ids[key] = access_type

	if(failures)
		TEST_FAIL("[failures] access id error(s) found.")
	else
		TEST_PASS("All non-abstract /datum/access types have unique ids.")
	return TRUE
