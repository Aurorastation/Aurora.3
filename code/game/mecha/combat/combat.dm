/obj/mecha/combat
	force = 30
	var/melee_cooldown = 10
	var/melee_can_hit = 1
	var/list/destroyable_obj = list(/obj/mecha, /obj/structure/window, /obj/structure/grille, /turf/simulated/wall)
	internal_damage_threshold = 50
	maint_access = 0
	//add_req_access = 0
	//operation_req_access = list(access_hos)
	damage_absorption = list("brute"=0.7,"fire"=1,"bullet"=0.7,"laser"=0.85,"energy"=1,"bomb"=0.8)
	var/am = "d3c2fbcadca903a41161ccc9df9cf948"

/*
/obj/mecha/combat/range_action(target as obj|mob|turf)
	if(internal_damage&MECHA_INT_CONTROL_LOST)
		target = pick(view(3,target))
	if(selected_weapon)
		selected_weapon.fire(target)
	return
*/

/obj/mecha/combat/melee_action(target as obj|mob|turf)
	if(internal_damage&MECHA_INT_CONTROL_LOST)
		target = safepick(oview(1,src))
	if(!melee_can_hit || !istype(target, /atom)) return
	if(istype(target, /mob/living))
		var/mob/living/M = target
		if(src.occupant.a_intent == I_HURT)
			playsound(src, 'sound/weapons/punch4.ogg', 50, 1)
			if(damtype == "brute")
				step_away(M,src,15)
			/*
			if(M.stat>1)
				M.gib()
				melee_can_hit = 0
				if(do_after_mecha(melee_cooldown))
					melee_can_hit = 1
				return
			*/
			if(istype(target, /mob/living/carbon/human))
				var/mob/living/carbon/human/H = target
	//			if (M.health <= 0) return

				var/obj/item/organ/external/temp = H.get_organ(pick("chest", "chest", "chest", "head"))
				if(temp)
					var/update = 0
					switch(damtype)
						if("brute")
							H.Paralyse(1)
							update |= temp.take_damage(rand(force/2, force), 0)
						if("fire")
							update |= temp.take_damage(0, rand(force/2, force))
						if("tox")
							if(H.reagents)
								if(H.reagents.get_reagent_amount("carpotoxin") + force < force*2)
									H.reagents.add_reagent("carpotoxin", force)
								if(H.reagents.get_reagent_amount("cryptobiolin") + force < force*2)
									H.reagents.add_reagent("cryptobiolin", force)
						else
							return
					if(update)	H.UpdateDamageIcon()
				H.updatehealth()

			else
				switch(damtype)
					if("brute")
						M.Paralyse(1)
						M.take_overall_damage(rand(force/2, force))
					if("fire")
						M.take_overall_damage(0, rand(force/2, force))
					if("tox")
						if(M.reagents)
							if(M.reagents.get_reagent_amount("carpotoxin") + force < force*2)
								M.reagents.add_reagent("carpotoxin", force)
							if(M.reagents.get_reagent_amount("cryptobiolin") + force < force*2)
								M.reagents.add_reagent("cryptobiolin", force)
					else
						return
				M.updatehealth()
			src.occupant_message("You hit \the [target].")
			src.visible_message("<span class='danger'>\The [src] hits \the [target]!</span>")
		else
			step_away(M,src)
			src.occupant_message("You push \the [target] out of the way.")
			src.visible_message("\The [src] pushes \the [target] out of the way.")

		melee_can_hit = 0
		if(do_after_mecha(melee_cooldown))
			melee_can_hit = 1
		return

	else
		if(damtype == "brute")
			for(var/target_type in src.destroyable_obj)
				if(istype(target, target_type) && hascall(target, "attackby"))
					src.occupant_message("You hit \the [target].")
					src.visible_message("<span class='danger'>\The [src] hits \the [target]!</span>")
					if(!istype(target, /turf/simulated/wall))
						target:attackby(src,src.occupant)
					else if(prob(5))
						target:dismantle_wall(1)
						src.occupant_message("<span class='notice'>You smash through the wall.</span>")
						src.visible_message("<b>[src.name] smashes through the wall</b>")
						playsound(src, 'sound/weapons/smash.ogg', 50, 1)
					melee_can_hit = 0
					if(do_after_mecha(melee_cooldown))
						melee_can_hit = 1
					break
	return

/obj/mecha/combat/moved_inside(var/mob/living/carbon/human/H as mob)
	if(..())
		if(H.client)
			H.client.mouse_pointer_icon = file("icons/mecha/mecha_mouse.dmi")
		return 1
	else
		return 0

/obj/mecha/combat/go_out()
	if(src.occupant && src.occupant.client)
		src.occupant.client.mouse_pointer_icon = initial(src.occupant.client.mouse_pointer_icon)
	..()
	return

/obj/mecha/combat/Topic(href,href_list)
	..()
	var/datum/topic_input/old_filter = new (href,href_list)
	if(old_filter.get("close"))
		am = null
		return
	/*
	if(old_filter.get("saminput"))
		if(md5(old_filter.get("saminput")) == am)
			occupant_message("From the lies of the Antipath, Circuit preserve us.")
		am = null
	return
	*/
