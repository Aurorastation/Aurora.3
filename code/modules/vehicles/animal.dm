/obj/vehicle/animal
	name = "animal"
	desc = "Base type of rideable animals - you shouldn't be seeing this!"
	desc_info = "Click-drag yourself onto the animal to climb onto it.<br>\
		- Click-drag it onto yourself to access its mounted storage.<br>"
	load_item_visible = 1
	mob_offset_y = 5
	health = 100
	maxhealth = 100

	fire_dam_coeff = 0.6
	brute_dam_coeff = 0.5
	dir = SOUTH
	anchored = FALSE //so you can drag animals around
	///The chance of blocking a projectile aimed at the user. Nothing by default.
	var/block_chance = 0

	/// Speed on land. Higher is slower.
	/// If 0 it can't go on land turfs at all.
	var/land_speed = 5
	/// Speed if walk intent is on.
	/// Should be slower, but does not crash into other bikes or people at this speed.
	/// If land speed is 0, still can't go on land turfs at all.
	var/land_speed_careful = 6
	/// Same as land speed, but for space turfs.
	var/space_speed = 0
	/// Same as land speed if walk intent is on, but for space turfs.
	var/space_speed_careful = 0

	var/storage_type = /obj/item/storage/toolbox/bike_storage/saddle
	var/obj/item/storage/storage_compartment
	organic = TRUE
	on = TRUE
	var/list/armor_values = list( //some default values that seem about right for an average animal
		melee = ARMOR_MELEE_MEDIUM,
		bullet = ARMOR_BALLISTIC_MINOR,
		bomb = ARMOR_BOMB_MINOR
	)

/obj/vehicle/animal/setup_vehicle()
	..()
	on = TRUE
	set_light(0)
	add_overlay(image(icon, "[icon_state]_overlay", MOB_LAYER + 1))
	if(storage_type)
		storage_compartment = new storage_type(src)
	if(LAZYLEN(armor_values))
		AddComponent(/datum/component/armor, armor_values)

/obj/vehicle/animal/load(var/atom/movable/C)
	var/mob/living/M = C
	if(!istype(C)) return FALSE
	if(M.buckled_to || M.restrained() || !Adjacent(M) || !M.Adjacent(src))
		return FALSE
	return ..(M)

/obj/vehicle/animal/MouseDrop(atom/over)
	if(use_check_and_message(usr))
		return

	if(usr == over && ishuman(over))
		var/mob/living/carbon/human/H = over
		storage_compartment.open(H)

/obj/vehicle/animal/MouseDrop_T(atom/dropping, mob/user)
	if(use_check_and_message(user))
		return

	if(!load(dropping))
		to_chat(user, SPAN_WARNING("You were unable to load \the [dropping] onto \the [src]."))
		return

/obj/vehicle/animal/attack_hand(var/mob/user as mob)
	if(use_check_and_message(user))
		return
	if(user == load)
		unload(load)
		to_chat(user, "You unbuckle yourself from \the [src]")
	if(user != load && load)
		user.visible_message ("[user] starts to unbuckle [load] from \the [src]!")
		if(do_after(user, 8 SECONDS, src))
			unload(load)
			to_chat(user, "You unbuckle [load] from \the [src]")
			to_chat(load, "You were unbuckled from \the [src] by [user]")

/obj/vehicle/animal/bullet_act(var/obj/item/projectile/Proj)
	var/datum/component/armor/armor_component = GetComponent(/datum/component/armor)
	if(buckled && prob((1 - armor_component.get_blocked(Proj.damage_type, Proj.damage_flags, Proj.armor_penetration))*100))
		buckled.bullet_act(Proj)
		return
	..()

/obj/vehicle/animal/relaymove(mob/user, direction)
	if(user != load || user.incapacitated())
		return
	return Move(get_step(src, direction))

/obj/vehicle/animal/proc/check_destination(var/turf/destination)
	var/static/list/types = typecacheof(list(/turf/space))
	if(is_type_in_typecache(destination,types) || pulledby)
		return TRUE
	else
		return FALSE

/obj/vehicle/animal/Move(var/turf/destination)
	var/mob/living/rider = buckled
	if(!istype(buckled))
		return

	var/is_careful = (rider.m_intent != M_RUN)
	var/is_on_space = check_destination(destination)

	if(is_on_space) //IDK when we will ever need space-flying animals but may as well leave the possibility open
		if(!space_speed)
			return FALSE
		move_delay = (is_careful ? space_speed_careful : space_speed)
	else
		if(!land_speed)
			return FALSE
		move_delay = (is_careful ? land_speed_careful : land_speed)

	return ..()

/obj/vehicle/animal/Collide(var/atom/movable/AM)
	. = ..()
	collide_act(AM)

/obj/vehicle/animal/proc/collide_act(var/atom/movable/AM)
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
				src.visible_message(SPAN_DANGER("\The [src] smashes into \the [H]!"))
				playsound(src, /singleton/sound_category/swing_hit_sound, 50, 1)
				H.apply_damage(20, DAMAGE_BRUTE)
				H.throw_at(get_edge_target_turf(loc, loc.dir), 5, 1)
				H.apply_effect(4, WEAKEN)
				M.setMoveCooldown(10)
				return TRUE

			else
				var/mob/living/L = AM
				src.visible_message(SPAN_DANGER("\The [src] smashes into \the [L]!"))
				playsound(src, /singleton/sound_category/swing_hit_sound, 50, 1)
				L.throw_at(get_edge_target_turf(loc, loc.dir), 5, 1)
				L.apply_damage(20, DAMAGE_BRUTE)
				M.setMoveCooldown(10)
				return TRUE

/obj/vehicle/animal/climber
	name = "climber"
	desc = "A rideable beast of burden, large enough for one adult rider only but perfectly adapted for the rough terrain on Adhomai. This one has a saddle mounted on it."
	icon = 'icons/mob/npc/adhomai_48.dmi'
	icon_state = "climber_s"
	desc_info = "Click-drag yourself onto the animal to climb onto it.<br>\
		- Click-drag it onto yourself to access its mounted storage.<br>"
	pixel_x = -8
	mob_offset_y = 8
	land_speed = 2
	land_speed_careful = 4

	health = 100

	storage_type = /obj/item/storage/toolbox/bike_storage/saddle
	corpse = /mob/living/simple_animal/climber/saddle


/obj/item/storage/toolbox/bike_storage/saddle
	name = "saddle storage"

/obj/item/saddle
	name = "saddle"
	desc = "A structure used to ride animals."
	icon = 'icons/obj/saddle.dmi'
	icon_state = "saddle"
	w_class = ITEMSIZE_NORMAL

/obj/vehicle/animal/threshbeast
	name = "threshbeast"
	desc = "Large herbivorous reptiles native to Moghes, the azkrazal or 'threshbeast' is commonly used as a mount, beast of burden, or convenient food source by Unathi. They are highly valued for their speed and strength, capable of running at 30-42 miles per hour at top speed. This one has been fitted with a saddle."
	icon = 'icons/mob/npc/moghes_64.dmi'
	icon_state = "threshbeast_s"
	desc_info = "Click-drag yourself onto the animal to climb onto it.<br>\
		- Click-drag it onto yourself to access its mounted storage.<br>"
	pixel_x = -15
	mob_offset_y = 10
	land_speed = 2
	land_speed_careful = 4

	health = 100

	organic = TRUE

	storage_type = /obj/item/storage/toolbox/bike_storage/saddle
	corpse = /mob/living/simple_animal/threshbeast/saddle

/obj/vehicle/animal/hegeranzi
	name = "hegeranzi"
	desc = "A large species of herbivorous horned reptiles native to Moghes, the hegeranzi or 'warmount' is commonly used as  mount or beast of war by the Unathi. They are highly valued for their speed, aggression, and fearsome horns. This one seems to have been fitted with a saddle."
	icon = 'icons/mob/npc/moghes_64.dmi'
	icon_state = "warmount_s"
	desc_info = "Click-drag yourself onto the animal to climb onto it.<br>\
		- Click-drag it onto yourself to access its mounted storage.<br>"
	pixel_x = -14
	mob_offset_y = 12

	on = TRUE
	land_speed = 1
	land_speed_careful = 4

	health = 200

	organic = TRUE

	storage_type = /obj/item/storage/toolbox/bike_storage/saddle
	corpse = /mob/living/simple_animal/hostile/retaliate/hegeranzi/saddle
	armor_values = list( //big tough war beast, has some more armor particularly against bullets and melee
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_MEDIUM,
		laser = ARMOR_LASER_MINOR,
		bomb = ARMOR_BOMB_MINOR
	)

/obj/vehicle/animal/warmount/RunOver(mob/living/carbon/human/H)
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

/obj/vehicle/animal/warmount/collide_act(atom/movable/AM)
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
