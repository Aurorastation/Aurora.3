//The bee smoker, a device that burns welder fuel to make lots of smoke that obscures vision
//Useful for dealing with angry bees, or for antagonist gardeners to confuse and flee from armed security.
/obj/item/weapon/bee_smoker
	name = "Bee smoker"
	desc = "An archaic contraption that slowly burns welding fuel to create thick clouds of smoke, and directs it with attached bellows, used to control angry bees and calm them before harvesting honey."
	icon = 'icons/obj/beekeeping.dmi'
	icon_state ="beesmoker"
	item_state = "beesmoker"
	contained_sprite = 1
	w_class = 4//Big clunky thing
	var/max_fuel = 60

/obj/item/weapon/bee_smoker/examine(mob/user)
	if(..(user, 0))
		user << text("\icon[] [] contains []/[] units of fuel!", src, src.name, get_fuel(),src.max_fuel )

/obj/item/weapon/bee_smoker/New()
	..()
	var/datum/reagents/R = new/datum/reagents(max_fuel)
	reagents = R
	R.my_atom = src
	//Bee smoker intentionally spawns empty. Fill it at a weldertank before use

//I would prefer to rename this to attack(), but that would involve touching hundreds of files.
/obj/item/weapon/bee_smoker/resolve_attackby(atom/A, mob/user)
	if (istype(A, /obj/structure/reagent_dispensers/fueltank) && get_dist(src,A) <= 1)
		A.reagents.trans_to_obj(src, max_fuel)
		user << "<span class='notice'>Smoker refilled!</span>"
		playsound(src.loc, 'sound/effects/refill.ogg', 50, 1, -6)
	else if (istype(A, /obj/machinery/beehive/))
		var/obj/machinery/beehive/B = A
		if(B.closed)
			user << "<span class='notice'>You need to open \the [B] with a crowbar before smoking the bees.</span>"
			return 1

		if (!remove_fuel(1,user))
			return 1
		user.visible_message("<span class='notice'>[user] smokes the bees in \the [B].</span>", "<span class='notice'>You smoke the bees in \the [B].</span>")
		B.smoked = 30
		B.update_icon()
		return 1
	else
		smoke_at(A)
	..()
	return 1


//Afterattack can only be called for longdistance clicks, since those skip the attackby
/obj/item/weapon/bee_smoker/afterattack(atom/A, mob/user)
	..()
	smoke_at(A)


/obj/item/weapon/bee_smoker/proc/get_fuel()
	return reagents.get_reagent_amount("fuel")


/obj/item/weapon/bee_smoker/proc/remove_fuel(var/amount = 1, var/mob/M = null)
	if(get_fuel() >= amount)
		reagents.remove_reagent("fuel", amount)
		return 1
	else
		if(M)
			M << "<span class='notice'>You need more welding fuel to complete this task.</span>"
		return 0

/obj/item/weapon/bee_smoker/proc/smoke_at(var/atom/A)
	if (!istype(A, /turf) && !istype(A.loc, /turf) )//Safety to prevent firing smoke at your own backpack
		return

	var/turf/T
	var/mob/owner = get_holding_mob()
	if (!remove_fuel(1.5, owner))
		return
	var/direction = get_dir(get_turf(src), get_turf(A))

	if (owner)
		T = get_step(owner, direction)
	else
		T = get_turf(src)



	var/datum/effect/effect/system/smoke_spread/smoke = new
	smoke.set_up(10, 0, T, direction)
	playsound(T, 'sound/effects/smoke.ogg', 20, 1, -3)
	smoke.start()