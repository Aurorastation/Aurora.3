/datum/map
	var/list/ut_environ_exempt_areas = list(/area/space)
	var/list/ut_apc_exempt_areas = list()
	var/list/ut_atmos_exempt_areas = list()
	var/list/ut_fire_exempt_areas = list()
	var/list/blacklisted_test_types = list()
	/// Use of the whitelist precludes all non-whitelisted unit tests from running.
	var/list/whitelisted_test_types = list()
