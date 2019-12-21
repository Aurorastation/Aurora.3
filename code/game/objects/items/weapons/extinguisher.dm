/obj/item/reagent_containers/extinguisher_refill
	name = "extinguisher refiller"
	desc = "A one time use extinguisher refiller that allows fire extinguishers to be refilled with an aerosol mix. Just pour in the reagents and twist."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "metal_canister"
	item_state = "metal_canister"
	hitsound = 'sound/weapons/smash.ogg'
	flags = CONDUCT | OPENCONTAINER
	throwforce = 8
	w_class = 4.0 // Don't want to give people free bluespace beakers.
	throw_speed = 2
	throw_range = 10
	force = 8
	matter = list(DEFAULT_WALL_MATERIAL = 90)
	attack_verb = list("slammed", "whacked", "bashed", "thunked", "battered", "bludgeoned", "thrashed")
	amount_per_transfer_from_this = 300
	possible_transfer_amounts = null
	volume = 300
	drop_sound = 'sound/items/drop/gascan.ogg'

/obj/item/reagent_containers/extinguisher_refill/attackby(var/obj/O as obj, var/mob/user as mob)

	if(istype(O,/obj/item/extinguisher))
		var/obj/item/extinguisher/E = O
		if(src.is_open_container())
			to_chat(user,"<span class='notice'>\The [src] needs to be secured first!</span>")
		else if(src.reagents.total_volume <= 0)
			to_chat(user,"<span class='notice'>\The [src] is empty!</span>")
		else if(E.reagents.total_volume < E.reagents.maximum_volume)
			src.reagents.trans_to(E, src.reagents.total_volume)
			user.visible_message("<span class='notice'>[user] fills \the [E] with the [src].</span>", "<span class='notice'>You fill \the [E] with the [src].</span>")
			playsound(E.loc, 'sound/items/stimpack.ogg', 50, 1)
		else
			to_chat(user,"<span class='notice'>\The [E] is full!</span>")
		return

	. = ..()

/obj/item/reagent_containers/extinguisher_refill/attack_self(mob/user as mob) //Copied from inhalers.
	if(is_open_container())
		if(reagents && reagents.reagent_list.len)
			to_chat(user,"<span class='notice'>With a quick twist of the cartridge's lid, you secure the reagents inside \the [src].</span>")
			flags &= ~OPENCONTAINER
		else
			to_chat(user,"<span class='notice'>You can't secure the cartridge without putting reagents in!</span>")
	else
		to_chat(user,"<span class='notice'>\The reagents inside [src] are already secured!</span>")
	return

/obj/item/reagent_containers/extinguisher_refill/attackby(obj/item/W, mob/user)
	if(W.isscrewdriver() && !is_open_container())
		to_chat(user,"<span class='notice'>Using \the [W], you unsecure the extinguisher refill cartridge's lid.</span>") // it locks shut after being secured
		flags |= OPENCONTAINER
		return
	. = ..()

/obj/item/reagent_containers/extinguisher_refill/examine(var/mob/user) //Copied from inhalers.
	if(!..(user, 2))
		return

	if(is_open_container())
		if(reagents && reagents.reagent_list.len)
			to_chat(user,"<span class='notice'>It contains [round(reagents.total_volume, accuracy)] units of non-aerosol mix.</span>")
		else
			to_chat(user,"<span class='notice'>It is empty.</span>")
	else
		if(reagents && reagents.reagent_list.len)
			to_chat(user,"<span class='notice'>The reagents are secured in the aerosol mix.</span>")
		else
			to_chat(user,"<span class='notice'>The cartridge seems spent.</span>")

/obj/item/reagent_containers/extinguisher_refill/filled
	name = "extinguisher refiller (monoammonium phosphate)"
	desc = "A one time use extinguisher refiller that allows fire extinguishers to be refilled with an aerosol mix. This one contains monoammonium phosphate."

/obj/item/reagent_containers/extinguisher_refill/filled/Initialize()
		. =..()
		reagents.add_reagent("monoammoniumphosphate", volume)
		flags &= ~OPENCONTAINER
		return

/obj/item/extinguisher
	name = "fire extinguisher"
	desc = "A traditional red fire extinguisher."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "fire_extinguisher0"
	item_state = "fire_extinguisher"
	hitsound = 'sound/weapons/smash.ogg'
	flags = CONDUCT
	throwforce = 10
	w_class = 3.0
	throw_speed = 2
	throw_range = 10
	force = 10.0
	matter = list(DEFAULT_WALL_MATERIAL = 90)
	attack_verb = list("slammed", "whacked", "bashed", "thunked", "battered", "bludgeoned", "thrashed")
	drop_sound = 'sound/items/drop/gascan.ogg'

	var/spray_particles = 3
	var/spray_amount = 10	//units of liquid per particle
	var/spray_distance = 3
	var/max_water = 300
	var/last_use = 1.0
	var/safety = 1
	var/sprite_name = "fire_extinguisher"

/obj/item/extinguisher/mini
	name = "fire extinguisher"
	desc = "A light and compact fibreglass-framed model fire extinguisher."
	icon_state = "miniFE0"
	item_state = "miniFE"
	hitsound = null	//it is much lighter, after all.
	flags = OPENCONTAINER
	throwforce = 2
	w_class = 2.0
	force = 2.0
	max_water = 60
	spray_amount = 10
	spray_particles = 1
	spray_distance = 1
	sprite_name = "miniFE"

/obj/item/extinguisher/New()
	create_reagents(max_water)
	reagents.add_reagent("monoammoniumphosphate", max_water)
	..()

/obj/item/extinguisher/examine(mob/user)
	if(..(user, 0))
		to_chat(user,"\The [src] contains [src.reagents.total_volume] units of reagents.")
		to_chat(user,"The safety is [safety ? "on" : "off"].")
	return

/obj/item/extinguisher/attack_self(mob/user as mob)
	safety = !safety
	src.icon_state = "[sprite_name][!safety]"
	src.desc = "The safety is [safety ? "on" : "off"]."
	to_chat(user, "The safety is [safety ? "on" : "off"].")
	return

/obj/item/extinguisher/attackby(var/obj/O as obj, var/mob/user as mob)

	if(istype(O,/obj/item/reagent_containers/extinguisher_refill))
		var/obj/item/reagent_containers/extinguisher_refill/ER = O
		if(ER.is_open_container())
			to_chat(user,"<span class='notice'>\The [ER] needs to be secured first!</span>")
		else if(ER.reagents.total_volume <= 0)
			to_chat(user,"<span class='notice'>\The [ER] is empty!</span>")
		else if (src.reagents.total_volume < src.reagents.maximum_volume)
			ER.reagents.trans_to(src, ER.reagents.total_volume)
			user.visible_message("<span class='notice'>[user] fills \the [src] with the [ER].</span>", "<span class='notice'>You fill \the [src] with the [ER].</span>")
			playsound(ER.loc, 'sound/items/stimpack.ogg', 50, 1)
		else
			to_chat(user,"<span class='notice'>\The [src] is full!</span>")
		return

	. = ..()

/obj/item/extinguisher/proc/propel_object(var/obj/O, mob/user, movementdirection)
	if(O.anchored) return

	var/obj/structure/bed/chair/C
	if(istype(O, /obj/structure/bed/chair))
		C = O

	var/list/move_speed = list(1, 1, 1, 2, 2, 3)
	for(var/i in 1 to 6)
		if(C) C.propelled = (6-i)
		O.Move(get_step(user,movementdirection), movementdirection)
		sleep(move_speed[i])

	//additional movement
	for(var/i in 1 to 3)
		O.Move(get_step(user,movementdirection), movementdirection)
		sleep(3)

/obj/item/extinguisher/afterattack(var/atom/target, var/mob/user, var/flag)

	if (!safety)
		if (src.reagents.total_volume < 1)
			to_chat(usr, "<span class='notice'>\The [src] is empty.</span>")
			return

		if (world.time < src.last_use + 20)
			return

		src.last_use = world.time

		playsound(src.loc, 'sound/effects/extinguish.ogg', 75, 1, -3)

		var/direction = get_dir(src,target)

		if(user.buckled && isobj(user.buckled))
			spawn(0)
				propel_object(user.buckled, user, turn(direction,180))

		var/turf/T = get_turf(target)
		var/turf/T1 = get_step(T,turn(direction, 90))
		var/turf/T2 = get_step(T,turn(direction, -90))

		var/list/the_targets = list(T,T1,T2)

		for(var/a = 1 to spray_particles)
			spawn(0)
				if(!src || !reagents.total_volume) return

				var/obj/effect/effect/water/W = new(get_turf(src))
				var/turf/my_target
				if(a <= the_targets.len)
					my_target = the_targets[a]
				else
					my_target = pick(the_targets)
				W.create_reagents(spray_amount)
				reagents.trans_to_obj(W, spray_amount)
				W.set_color()
				W.set_up(my_target,spray_distance,3)

		if((istype(usr.loc, /turf/space)) || (usr.lastarea.has_gravity() == 0))
			user.inertia_dir = get_dir(target, user)
			step(user, user.inertia_dir)
	else
		return ..()
	return
