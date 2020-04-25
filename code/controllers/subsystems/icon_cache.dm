/var/datum/controller/subsystem/icon_cache/SSicon_cache

/datum/controller/subsystem/icon_cache
	name = "Icon Cache"
	flags = SS_NO_FIRE
	init_order = SS_INIT_MISC_FIRST

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
	// Cached limb icons, used by the damage health doll.
	var/list/limb_icons_cache = list()
	// Cached human damage icons.
	var/list/damage_icon_parts = list()
	// Cached human body markings.
	var/list/markings_cache = list()	// [icon]-[icon_state]-[limb_name]-[color]
	var/list/human_eye_cache = list()
	var/list/human_lip_cache = list()
	var/list/internal_organ_cache = list()
	// Cached composited human hair (beard & hair).
	// Key:
	//    hair+beard: [beard_style][r_facial][g_facial][b_facial]_[hair_style][r_hair][g_hair][b_hair]
	//    haironly:   nobeard_[hair_style][r_hair][g_hair][b_hair]
	//    beardonly:  [beard_style][r_facial][g_facial][b_facial]_nohair
	var/list/human_hair_cache = list()
	var/list/organ_keymap = list()
	var/current_organ_keymap_idex = 1
	// This is an assoc list of all icon states in `icons/mob/collar.dmi`, used by human update-icons.
	var/list/collar_states
	var/list/uniform_states

	// This is for the kitty ears item.
	var/list/kitty_ear_cache = list()

	var/list/ao_cache = list()

	var/list/light_fixture_cache = list()

	var/list/rgb_blend_cache = list()	// not an icon per-se, but this proc could be expensive so we might as well cache it.

	var/list/space_dust_cache = list()

	var/list/space_cache = list()
	var/list/crayon_cache = list()

	var/list/istate_cache = list()

/datum/controller/subsystem/icon_cache/New()
	NEW_SS_GLOBAL(SSicon_cache)

/datum/controller/subsystem/icon_cache/Initialize()
	build_dust_cache()
	build_space_cache()
	setup_collar_mappings()
	setup_uniform_mappings()
	..()

/datum/controller/subsystem/icon_cache/proc/setup_collar_mappings()
	collar_states = list()
	for (var/i in icon_states('icons/mob/collar.dmi'))
		collar_states[i] = TRUE

/datum/controller/subsystem/icon_cache/proc/get_organ_shortcode(obj/item/organ/external/organ)
	if (QDELETED(organ))
		return null

	var/key = organ.get_mob_cache_key(FALSE)
	. = organ_keymap[key]
	if (!.)
		organ_keymap[key] = "o[current_organ_keymap_idex++]"
		. = organ_keymap[key]

/datum/controller/subsystem/icon_cache/proc/setup_uniform_mappings()
	uniform_states = list()
	for (var/i in icon_states('icons/mob/uniform.dmi'))
		uniform_states[i] = TRUE

/datum/controller/subsystem/icon_cache/proc/generate_color_variant(icon/icon, icon_state, color)
	var/image/I = new(icon, icon_state)
	I.color = color
	return I

/datum/controller/subsystem/icon_cache/proc/build_dust_cache()
	for (var/i in 0 to 25)
		var/image/im = image('icons/turf/space_parallax1.dmi',"[i]")
		im.plane = PLANE_SPACE_DUST
		im.alpha = 80
		im.blend_mode = BLEND_ADD
		space_dust_cache["[i]"] = im

/datum/controller/subsystem/icon_cache/proc/build_space_cache()
	for (var/i in 0 to 25)
		var/image/I = new()
		I.appearance = /turf/space
		var/istr = "[i]"
		I.icon_state = istr
		I.overlays += space_dust_cache[istr]
		space_cache[istr] = I

/datum/controller/subsystem/icon_cache/proc/get_state(icon/I, state)	// returns an APPEARANCE, not an image!
	if (!isicon(I))
		CRASH("Expected icon.")

	if (!istext(state))
		// non-fatal, so just print a message then carry on.
		crash_with("Received non-text icon_state '[state || "(NULL)"]'; normalizing, but this shouldn't happen.")
		state = "[state]"

	var/list/cache = istate_cache[I]
	if (cache)
		if (cache[state])
			return cache[state]
	else
		cache = preload_icon(I)

	var/image/im = image(icon = I, icon_state = state)
	return cache[state] = im.appearance

// Loads all icon states in an icon into the istate cache.
/datum/controller/subsystem/icon_cache/proc/preload_icon(icon/I)
	log_debug("SSicon_cache: preloading '[I]'...")
	var/list/cache = list()
	var/image/im = new(icon = I)
	for (var/state in icon_states(I))
		im.icon_state = state
		cache[state] = im.appearance

	log_debug("SSicon_cache: preloaded [cache.len] states.")
	istate_cache[I] = cache
	return cache
