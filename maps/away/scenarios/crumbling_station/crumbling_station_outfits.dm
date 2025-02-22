// Generic crew uniform.
/obj/outfit/admin/generic/crumbling_station_crew
	name = "Commercial Installation Crew"
	l_ear = /obj/item/device/radio/headset/ship
	id = /obj/item/card/navy
	l_pocket = /obj/item/device/radio/hailing
	r_pocket = /obj/item/portable_map_reader
	r_hand = list(
		/obj/item/device/flashlight/on,
		/obj/item/device/flashlight/lantern/on,
		/obj/item/device/flashlight/maglight/on,
		/obj/item/device/flashlight/heavy/on,
	)

/obj/outfit/admin/generic/cryo_outpost_crew/get_id_access()
	return list(
		ACCESS_EXTERNAL_AIRLOCKS
	)

// Crew engineer.
/obj/outfit/admin/generic/crumbling_station_cre1w/engineer
	name = "Commercial Installation Engineer"

// Crew medic.
/obj/outfit/admin/generic/crumbling_station_crew/medic
	name = "Commercial Installation Medic"

// Highsec covers all roles that should have command access on the station.
ABSTRACT_TYPE(/obj/outfit/admin/generic/crumbling_station_crew/highsec)

/obj/outfit/admin/generic/cryo_outpost_crew/highsec/get_id_access()
	return list(
		ACCESS_EXTERNAL_AIRLOCKS, ACCESS_CRUMBLING_STATION_COMMAND
	)

// Crew security guard.
/obj/outfit/admin/generic/crumbling_station_crew/highsec/security
	name = "Commercial Installation Security Guard"

// Crew administrator.
/obj/outfit/admin/generic/crumbling_station_crew/highsec/administrator
	name = "Commercial Installation Administrator"

// Civilian visitor role. May include any kind of visitor, intended to be on the proper side of the law. Not a member of the station's crew.
/obj/outfit/admin/generic/crumbling_station_crew/legal_visitor
	name = "Independent Spacer"

// Criminal visitor role - lightly armed, may possess contraband. Not a member of the station's crew.
/obj/outfit/admin/generic/crumbling_station_crew/illegal_visitor
	name = "Independent Spacer"
