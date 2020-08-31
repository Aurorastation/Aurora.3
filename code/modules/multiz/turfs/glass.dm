/turf/simulated/glass
	name = "glass flooring"
	gender = PLURAL
	desc = "A somewhat flimsy section of glass some madman thought would work well as flooring."
	icon = 'icons/turf/smooth/glass.dmi'
	icon_state = "floor_glass"
	smooth = SMOOTH_TRUE
	smoothing_hints = SMOOTHHINT_ONLY_MATCH_TURF | SMOOTHHINT_TARGETS_NOT_UNIQUE
	z_flags = ZM_MIMIC_BELOW
	var/max_health = 100
	var/health
	var/last_dmg_overlay
	var/reinf = FALSE
	var/secured = TRUE
	var/opaque = FALSE

/turf/simulated/glass/reinforced
	name = "reinforced glass flooring"
	desc = "A reasonably strong section of glass being used as flooring."
	icon = 'icons/turf/smooth/glass_reinf.dmi'
	max_health = 300
	reinf = TRUE

/turf/simulated/glass/proc/update_opacity(opaqueness = !opaque)
	opaque = opaqueness
	if(!opaque)
		disable_zmimic()
	else
		enable_zmimic()

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
	shatter()

/turf/simulated/glass/proc/shatter()
	playsound(src, "shatter", 70, 1)

	new /obj/item/material/shard(src)
	if (prob(25))
		new /obj/item/material/shard(src)
	if (reinf)
		new /obj/item/stack/rods(src)

	ChangeToOpenturf()

/turf/simulated/glass/proc/dismantle(var/newloc = src)
	if(reinf)
		new /obj/item/stack/material/glass/reinforced(src, 4)
	else
		new /obj/item/stack/material/glass(src, 4)
	ChangeToOpenturf()
	new /obj/structure/lattice(newloc)

/turf/simulated/glass/proc/take_damage(var/force)
	playsound(loc, 'sound/effects/glass_hit.ogg', 100, 1)
	health -= force
	check_health()

/turf/simulated/glass/on_fall_impact(atom/movable/other, distance, stopped_early = FALSE)
	. = ..()
	if (.)
		var/list/specs = other.fall_get_specs(distance)
		var/weight = specs[1]
		var/fall_force = specs[2]

		take_damage(weight * fall_force)
		check_health()

/turf/simulated/glass/attackby(obj/item/I, mob/user)
	if(I.isscrewdriver())
		user.visible_message(SPAN_NOTICE("[user] begins to [secured ? "unscrew" : "screw in"] [src]'s screws with [I]!"))
		if(do_after(user, 1 SECOND))
			secured = !secured
			user.visible_message(SPAN_NOTICE("[user] has [secured ? "screwed in" : "unscrewed"] [src]'s screws with [I]."))
			return
		user.visible_message(SPAN_NOTICE("[user] stops [secured ? "unscrewing" : "screwing in"] [src]'s screws with [I]."))
		return
	if(!secured && I.iscrowbar())
		user.visible_message(SPAN_DANGER("[user] is prying up [src] with [I]!"))
		if(do_after(user, 2 SECONDS))
			dismantle(get_turf(user))
		user.visible_message(SPAN_DANGER("[user] stops prying up [src] with [I]."))
	if(I.iswelder())
		var/obj/item/weldingtool/WT = I
		if (!WT.isOn())
			to_chat(user, SPAN_DANGER("[WT] must be turned on!"))
			return
		else if (health == max_health)
			to_chat(user, SPAN_NOTICE("[src] is fully repaired."))
			return
		else if (WT.remove_fuel(3, user))
			to_chat(user, SPAN_NOTICE("You repair [src]."))
			if(do_after(user, 0.5 SECONDS))
				if(QDELETED(src) || !WT.isOn())
					return
				playsound(src.loc, 'sound/items/welder_pry.ogg', 50, 1)
				health += min(health - max_health, max_health / 3)
				return
			else
				to_chat(user, SPAN_NOTICE("You fail to complete the welding."))
		else
			to_chat(user, SPAN_WARNING("You need more welding fuel to complete this task."))
			return 1
	else
		//if the floor was attacked with the intention of harming it:
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		take_damage(I.force * (1 - secured/2)) // the screws make it absorb a bit of force
		. = ..()
