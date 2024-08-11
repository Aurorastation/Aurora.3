/**
 * tgui state: human_adjacent_state
 *
 * In addition to default checks, only allows interaction for a
 * human adjacent user.
 */

GLOBAL_DATUM_INIT(human_adjacent_loc_state, /datum/ui_state/human_adjacent_loc_state, new)

/datum/ui_state/human_adjacent_loc_state/can_use_topic(src_object, mob/user)
	var/turf/src_object_turf = get_turf(src_object)

	. = user.default_can_use_topic(src_object_turf)

	var/dist = get_dist(src_object_turf, user)
	if((dist > 1) || (!ishuman(user)))
		// Can't be used unless adjacent and human, even with TK
		. = min(., UI_UPDATE)
