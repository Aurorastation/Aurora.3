/obj/item/bee_smoker
	name = "bee smoker"
	desc = "An archaic contraption that slowly burns welding fuel to create thick clouds of smoke, and directs it with attached bellows, used to control angry bees and calm them before harvesting honey."
	icon = 'icons/obj/beekeeping.dmi'
	icon_state = "bee_smoker"
	item_state = "bee_smoker"
	contained_sprite = TRUE
	w_class = WEIGHT_CLASS_BULKY
	var/max_fuel = 60

/obj/item/bee_smoker/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "Use this to pacify bees before extracting frames from a hive!"

/obj/item/bee_smoker/antagonist_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "This device can be used to blind people in short range."

/obj/item/bee_smoker/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	if(is_adjacent)
		. += SPAN_NOTICE("It has <b>[get_fuel()]/[max_fuel]</b> welding fuel left.")

/obj/item/bee_smoker/Initialize()
	. = ..()
	var/datum/reagents/R = new /datum/reagents(max_fuel)
	reagents = R
	R.my_atom = src
	//Bee smoker intentionally spawns empty. Fill it at a weldertank before use

/obj/item/bee_smoker/resolve_attackby(atom/A, mob/user, var/click_parameters)
	if(istype(A, /obj/structure/reagent_dispensers/fueltank) && get_dist(src,A) <= 1)
		A.reagents.trans_to_obj(src, max_fuel)
		to_chat(user, SPAN_NOTICE("You refuel \the [src]."))
		playsound(get_turf(src), 'sound/effects/refill.ogg', 50, TRUE, -6)
	else if(istype(A, /obj/machinery/beehive))
		var/obj/machinery/beehive/B = A
		if(B.closed)
			to_chat(user, SPAN_WARNING("You need to open \the [B] with a crowbar before smoking the bees."))
			return TRUE
		if(!use(1, user))
			return TRUE
		user.visible_message(SPAN_NOTICE("\The [user] smokes the bees in \the [B]."), SPAN_NOTICE("You smoke the bees in \the [B], which seems to calm them down."))
		B.smoked = 30
		B.update_icon()
		return TRUE
	else
		smoke_at(A)
	..(A, user, click_parameters)
	return TRUE

//Afterattack can only be called for longdistance clicks, since those skip the attackby
/obj/item/bee_smoker/afterattack(atom/A, mob/user)
	..()
	smoke_at(A)

/obj/item/bee_smoker/proc/get_fuel()
	return REAGENT_VOLUME(reagents, /singleton/reagent/fuel)

/obj/item/bee_smoker/use(var/amount = 1, var/mob/M = null)
	if(get_fuel() >= amount)
		reagents.remove_reagent(/singleton/reagent/fuel, amount)
		return TRUE
	else
		if(M)
			to_chat(M, SPAN_WARNING("\The [src] doesn't have enough fuel to do this!"))
		return FALSE

/obj/item/bee_smoker/proc/smoke_at(var/atom/A)
	if(!istype(A, /turf) && !istype(A.loc, /turf) ) //Safety to prevent firing smoke at your own backpack
		return

	var/turf/T
	var/mob/owner = get_holding_mob()
	if(!use(1.5, owner))
		return
	var/direction = get_dir(get_turf(src), get_turf(A))

	if(owner)
		T = get_step(owner, direction)
	else
		T = get_turf(src)

	var/datum/effect/effect/system/smoke_spread/smoke = new
	smoke.set_up(10, 0, T, direction)
	playsound(T, 'sound/effects/smoke.ogg', 20, 1, -3)
	smoke.start()
