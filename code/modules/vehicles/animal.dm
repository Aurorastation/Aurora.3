/obj/vehicle/bike/climber
	name = "climber"
	desc = "A rideable beast of burden, large enough for one adult rider only but perfectly adapted for the rough terrain on Adhomai. This one has a saddle mounted on it."
	icon = 'icons/mob/npc/adhomai_48.dmi'
	icon_state = "climber_s"
	bike_icon = "climber_s"
	desc_info = "Click-drag yourself onto the animal to climb onto it.<br>\
		- Click-drag it onto yourself to access its mounted storage.<br>"
	pixel_x = -8
	mob_offset_y = 8
	kickstand = FALSE
	on = TRUE
	land_speed = 2
	space_speed = 0

	health = 100

	can_hover = FALSE
	organic = TRUE

	storage_type = /obj/item/storage/toolbox/bike_storage/saddle
	corpse = /mob/living/simple_animal/climber/saddle
	spawns_with_key = FALSE
	key_type = null

/obj/vehicle/bike/climber/setup_vehicle()
	..()
	on = TRUE
	set_light(0)

/obj/vehicle/bike/climber/CtrlClick(var/mob/user)
	return

/obj/vehicle/bike/climber/toggle_engine(var/mob/user)
	return

/obj/vehicle/bike/climber/kickstand(var/mob/user)
	return

/obj/item/storage/toolbox/bike_storage/saddle
	name = "saddle storage"

/obj/item/saddle
	name = "saddle"
	desc = "A structure used to ride animals."
	icon = 'icons/obj/saddle.dmi'
	icon_state = "saddle"
	w_class = ITEMSIZE_NORMAL

/obj/vehicle/bike/threshbeast
	name = "threshbeast"
	desc = "Large herbivorous reptiles native to Moghes, the azkrazal or 'threshbeast' is commonly used as a mount, beast of burden, or convenient food source by Unathi. They are highly valued for their speed and strength, capable of running at 30-42 miles per hour at top speed. This one has been fitted with a saddle."
	icon = 'icons/mob/npc/moghes_64.dmi'
	icon_state = "threshbeast_s"
	bike_icon = "threshbeast_s"
	desc_info = "Click-drag yourself onto the animal to climb onto it.<br>\
		- Click-drag it onto yourself to access its mounted storage.<br>"
	pixel_x = -15
	mob_offset_y = 10
	kickstand = FALSE
	on = TRUE
	land_speed = 2
	land_speed_careful = 3
	space_speed = 0

	health = 100

	can_hover = FALSE
	organic = TRUE

	storage_type = /obj/item/storage/toolbox/bike_storage/saddle
	corpse = /mob/living/simple_animal/threshbeast/saddle
	spawns_with_key = FALSE
	key_type = null

/obj/vehicle/bike/threshbeast/setup_vehicle()
	..()
	on = TRUE
	set_light(0)

/obj/vehicle/bike/threshbeast/CtrlClick(var/mob/user)
	return

/obj/vehicle/bike/threshbeast/toggle_engine(var/mob/user)
	return

/obj/vehicle/bike/threshbeast/kickstand(var/mob/user)
	return

/obj/vehicle/bike/warmount
	name = "warmount"
	desc = "A large species of herbivorous horned reptiles native to Moghes, the hegeranzi or 'warmount' is commonly used as  mount or beast of war by the Unathi. They are highly valued for their speed, aggression, and fearsome horns. This one seems to have been fitted with a saddle."
	icon = 'icons/mob/npc/moghes_64.dmi'
	icon_state = "warmount_s_on"
	bike_icon = "warmount_s_on"
	desc_info = "Click-drag yourself onto the animal to climb onto it.<br>\
		- Click-drag it onto yourself to access its mounted storage.<br>"
	pixel_x = -14
	mob_offset_y = 12

	kickstand = FALSE
	on = TRUE
	land_speed = 1
	land_speed_careful = 2
	space_speed = 0

	health = 200

	can_hover = FALSE
	organic = TRUE

	storage_type = /obj/item/storage/toolbox/bike_storage/saddle
	corpse = /mob/living/simple_animal/hostile/retaliate/warmount/saddle
	spawns_with_key = FALSE
	key_type = null

/obj/vehicle/bike/warmount/setup_vehicle()
	..()
	on = TRUE
	set_light(0)

/obj/vehicle/bike/warmount/CtrlClick(var/mob/user)
	return

/obj/vehicle/bike/warmount/toggle_engine(var/mob/user)
	return

/obj/vehicle/bike/warmount/kickstand(var/mob/user)
	return

/obj/vehicle/bike/warmount/RunOver(mob/living/carbon/human/H)
	var/mob/living/M
	if(!buckled)
		return
	if(istype(buckled, /mob/living))
		M = buckled
	if(M.m_intent == M_RUN)
		M.attack_log += "\[[time_stamp()]\]<font color='orange'> Was rammed by [src]</font>"
		M.attack_log += text("\[[time_stamp()]\] <span class='warning'>rammed[M.name] ([M.ckey]) rammed [H.name] ([H.ckey]) with the [src].</span>")
		msg_admin_attack("[src] crashed into [key_name(H)] at (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[H.x];Y=[H.y];Z=[H.z]'>JMP</a>)" )
		src.visible_message(SPAN_DANGER("\The [src] charges into \the [H]!"))
		playsound(src, 'sound/weapons/pierce.ogg', 50, 1)
		H.apply_damage(40, DAMAGE_BRUTE)
		if(H.species.mob_size < 16)
			playsound(M, 'sound/weapons/push_connect.ogg', 50, 1, -1)
			src.visible_message(SPAN_DANGER("\The [src] slams into \the [H], sending them flying!"))
			var/turf/target_turf = get_ranged_target_turf(H, M.dir, 4)
			H.throw_at(target_turf, 4, 1, src)
			H.apply_effect(4, WEAKEN)

/obj/vehicle/bike/warmount/collide_act(atom/movable/AM)
	var/mob/living/M
	if(!buckled)
		return
	if(istype(buckled, /mob/living))
		M = buckled
	if(M.m_intent == M_RUN)
		if (istype(AM, /obj/vehicle))
			M.setMoveCooldown(10)
			var/obj/vehicle/V = AM
			if(prob(50))
				if(V.buckled)
					if(ishuman(V.buckled))
						var/mob/living/carbon/human/I = V.buckled
						I.visible_message(SPAN_DANGER("\The [I] falls off from \the [V]"))
						V.unload(I)
						I.throw_at(get_edge_target_turf(V.loc, V.loc.dir), 5, 1)
						I.apply_effect(2, WEAKEN)
				if(prob(25))
					if(ishuman(buckled))
						var/mob/living/carbon/human/C = buckled
						C.visible_message(SPAN_DANGER ("\The [C] falls off from \the [src]!"))
						unload(C)
						C.throw_at(get_edge_target_turf(loc, loc.dir), 5, 1)
						C.apply_effect(2, WEAKEN)
		if(isliving(AM))
			if(ishuman(AM))
				var/mob/living/carbon/human/H = AM
				M.attack_log += "\[[time_stamp()]\]<font color='orange'> Was rammed by [src]</font>"
				M.attack_log += text("\[[time_stamp()]\] <span class='warning'>rammed[M.name] ([M.ckey]) rammed [H.name] ([H.ckey]) with the [src].</span>")
				msg_admin_attack("[src] crashed into [key_name(H)] at (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[H.x];Y=[H.y];Z=[H.z]'>JMP</a>)" )
				src.visible_message(SPAN_DANGER("\The [src] charges into \the [H]!"))
				playsound(src, 'sound/weapons/pierce.ogg', 50, 1)
				H.apply_damage(40, DAMAGE_BRUTE)
				if(H.species.mob_size < 16)
					playsound(M, 'sound/weapons/push_connect.ogg', 50, 1, -1)
					src.visible_message(SPAN_DANGER("\The [src] slams into \the [H], sending them flying!"))
					var/turf/target_turf = get_ranged_target_turf(H, M.dir, 4)
					H.throw_at(target_turf, 4, 1, src)
					H.apply_effect(4, WEAKEN)
				M.setMoveCooldown(10)
				return TRUE

			else
				var/mob/living/L = AM
				src.visible_message(SPAN_DANGER("\The [src] smashes into \the [L]!"))
				playsound(src, 'sound/weapons/pierce.ogg', 50, 1)
				L.throw_at(get_edge_target_turf(loc, loc.dir), 5, 1)
				L.apply_damage(40, DAMAGE_BRUTE)
				M.setMoveCooldown(10)
				return TRUE
