/obj/machinery/containment_field
	name = "containment field"
	desc = "An energy field."
	icon = 'icons/obj/machinery/field_generator.dmi'
	icon_state = "contain_f"
	anchored = 1
	density = 0
	unacidable = 1
	use_power = POWER_USE_OFF
	light_range = 4
	flags = PROXMOVE
	var/obj/machinery/field_generator/FG1 = null
	var/obj/machinery/field_generator/FG2 = null
	var/has_shocked = 0 //Used to add a delay between shocks. In some cases this used to crash servers by spawning hundreds of sparks every second.

/obj/machinery/containment_field/Destroy()
	if(FG1 && !FG1.clean_up)
		FG1.cleanup()
	if(FG2 && !FG2.clean_up)
		FG2.cleanup()
	return ..()

/obj/machinery/containment_field/attack_hand(mob/user as mob)
	if(get_dist(src, user) > 1)
		return 0
	else
		shock(user)
		return 1


/obj/machinery/containment_field/ex_act(severity)
	return 0

/obj/machinery/containment_field/HasProximity(atom/movable/AM as mob|obj)
	if(istype(AM,/mob/living/silicon) && prob(40))
		shock(AM)
		return 1
	if(istype(AM,/mob/living/carbon) && prob(50))
		shock(AM)
		return 1
	return 0



/obj/machinery/containment_field/shock(mob/living/user as mob)
	if(has_shocked)
		return 0
	if(!FG1 || !FG2)
		qdel(src)
		return 0
	if(isliving(user))
		has_shocked = 1
		var/shock_damage = min(rand(30,40),rand(30,40))
		user.electrocute_act(shock_damage, src)

		var/atom/target = get_edge_target_turf(user, get_dir(src, get_step_away(user, src)))
		user.throw_at(target, 200, 4)

		sleep(20)

		has_shocked = 0
	return

/obj/machinery/containment_field/proc/set_master(var/master1,var/master2)
	if(!master1 || !master2)
		return 0
	FG1 = master1
	FG2 = master2
	return 1
