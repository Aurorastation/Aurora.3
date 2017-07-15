/var/datum/controller/subsystem/icon_cache/SSicon_cache

/datum/controller/subsystem/icon_cache
	name = "Icon Cache"
	flags = SS_NO_FIRE | SS_NO_INIT

	var/list/bloody_cache = list()

	var/list/holo_multiplier_cache = list()
	var/list/holo_adder_cache = list()

	var/list/image/fluidtrack_cache = list()

	var/list/floor_decals = list()
	var/list/flooring_cache = list()

	var/list/mob_hat_cache = list()

	var/list/magazine_icondata_keys = list()
	var/list/magazine_icondata_states = list()

	var/list/stool_cache = list()
	var/list/floor_light_cache = list()
	var/list/ashtray_cache = list()

/*
	Global associative list for caching humanoid icons.
	Index format m or f, followed by a string of 0 and 1 to represent bodyparts followed by husk fat hulk skeleton 1 or 0.
	TODO: Proper documentation
	icon_key is [species.race_key][g][husk][fat][hulk][skeleton][s_tone]
*/
	var/list/human_icon_cache = list()
	var/list/tail_icon_cache = list()	//key is [species.race_key][r_skin][g_skin][b_skin]
	var/list/light_overlay_cache = list()
	var/list/body_hair_cache = list()
	var/list/damage_icon_parts = list()
	// [icon]-[icon_state]-[limb_name]-[color]
	var/list/markings_cache = list()

/datum/controller/subsystem/icon_cache/New()
	NEW_SS_GLOBAL(SSicon_cache)
