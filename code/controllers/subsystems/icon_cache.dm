/var/datum/controller/subsystem/icon_cache/SSicon_cache

/datum/controller/subsystem/icon_cache
	name = "Icon Cache"
	flags = SS_NO_FIRE | SS_NO_INIT

	// Cached bloody overlays, key is object type.
	var/list/bloody_cache = list()

	// Cached holo effect multiplier images.
	var/list/holo_multiplier_cache = list() // 2-layer list: icon -> icon_state -> /image
	// Cached holo effect adder images.
	var/list/holo_adder_cache = list() // 2-layer list: icon -> icon_state -> /image

	var/list/floor_decals = list()
	var/list/flooring_cache = list()

	var/list/mob_hat_cache = list()

	var/list/magazine_icondata_keys = list()
	var/list/magazine_icondata_states = list()

	var/list/stool_cache = list()
	var/list/floor_light_cache = list()
	var/list/ashtray_cache = list()

	var/list/uristrunes = list()

/*
	Global associative list for caching humanoid icons.
	Index format m or f, followed by a string of 0 and 1 to represent bodyparts followed by husk fat hulk skeleton 1 or 0.
	TODO: Proper documentation
	icon_key is [species.race_key][g][husk][fat][hulk][skeleton][s_tone]
*/
	var/list/human_icon_cache = list()
	var/list/tail_icon_cache = list()	//key is [species.race_key][r_skin][g_skin][b_skin]
	var/list/light_overlay_cache = list()
	// Cached body hair icons, used by resomi.
	var/list/body_hair_cache = list()
	// Cached human damage icons.
	var/list/damage_icon_parts = list()
	// Cached human body markings.
	var/list/markings_cache = list()	// [icon]-[icon_state]-[limb_name]-[color]
	var/list/human_eye_cache = list()
	var/list/human_lip_cache = list()
	// Cached composited human hair (beard & hair).
	// Key:
	//    hair+beard: [beard_style][r_facial][g_facial][b_facial]_[hair_style][r_hair][g_hair][b_hair]
	//    haironly:   nobeard_[hair_style][r_hair][g_hair][b_hair]
	//    beardonly:  [beard_style][r_facial][g_facial][b_facial]_nohair
	var/list/human_hair_cache = list()
	var/list/human_underwear_cache = list()
	var/list/human_undershirt_cache = list()
	var/list/human_socks_cache = list()

	// This is for the kitty ears item.
	var/list/kitty_ear_cache = list()

/datum/controller/subsystem/icon_cache/New()
	NEW_SS_GLOBAL(SSicon_cache)
