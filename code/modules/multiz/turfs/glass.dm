/turf/simulated/glass
	name = "glass flooring"
	gender = PLURAL
	desc = "A somewhat flimsy section of glass some madman thought would work well as flooring."
	icon = 'icons/turf/smooth/glass.dmi'
	icon_state = "floor_glass"
	smooth = SMOOTH_TRUE
	smoothing_hints = SMOOTHHINT_ONLY_MATCH_TURF | SMOOTHHINT_TARGETS_NOT_UNIQUE
	flags = MIMIC_BELOW
	var/max_health = 100
	var/health
	var/last_dmg_overlay
	var/reinf = FALSE

/turf/simulated/glass/reinforced
	name = "reinforced glass flooring"
	desc = "A reasonably strong section of glass being used as flooring."
	icon = 'icons/turf/smooth/glass_reinf.dmi'
	max_health = 300
	reinf = TRUE

/turf/simulated/glass/Initialize()
	. = ..()
	health = max_health

/turf/simulated/glass/update_icon()
	var/new_state
	var/value = (health/max_health)*100

	if (value >= 100)
		new_state = null
	else if (value > 66)
		new_state = "damage75"
	else if (value > 33)
		new_state = "damage50"
	else
		new_state = "damage25"

	if (new_state != last_dmg_overlay)
		if (last_dmg_overlay)
			cut_overlay(last_dmg_overlay, TRUE)
		last_dmg_overlay = new_state
		if (new_state)
			add_overlay(new_state, TRUE)

/turf/simulated/glass/proc/check_health()
	if (health > 0)
		update_icon()
		return

	playsound(src, "shatter", 70, 1)

	new /obj/item/weapon/material/shard(src)
	if (prob(25))
		new /obj/item/weapon/material/shard(src)
	if (reinf)
		new /obj/item/stack/rods(src)

	ChangeToOpenturf()

/turf/simulated/glass/fall_impact(atom/movable/other, distance, stopped_early = FALSE)
	. = ..()
	if (.)
		var/list/specs = other.fall_get_specs(distance)
		var/weight = specs[1]
		var/fall_force = specs[2]

		health -= weight * fall_force

		check_health()
