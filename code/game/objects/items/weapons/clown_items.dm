/* Clown Items
 * Contains:
 * 		Banana Peels
 *		Soap
 *		Bike Horns
 */

/*
 * Banana Peals
 */
/obj/item/weapon/bananapeel/Crossed(AM as mob|obj)
	if (istype(AM, /mob/living))
		var/mob/living/M = AM
		M.slip("the [src.name]",4)
/*
 * Soap
 */
/obj/item/weapon/soap/New()
	..()
	create_reagents(10)
	wet()

/obj/item/weapon/soap/proc/wet()
	playsound(loc, 'sound/effects/slosh.ogg', 25, 1)
	reagents.add_reagent("cleaner", 10)

/obj/item/weapon/soap/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/weapon/key))
		if(!key_data)
			to_chat(user, "<span class='notice'>You imprint \the [I] into \the [src].</span>")
			var/obj/item/weapon/key/K = I
			key_data = K.key_data
			update_icon()
		return
	..()

/obj/item/weapon/soap/update_icon()
	overlays.Cut()
	if(key_data)
		overlays += image('icons/obj/items.dmi', icon_state = "soap_key_overlay")

/obj/item/weapon/soap/Crossed(AM as mob|obj)
	if (istype(AM, /mob/living))
		var/mob/living/M =	AM
		M.slip("the [src.name]",3)

/obj/item/weapon/soap/afterattack(atom/target, mob/user as mob, proximity)
	if(!proximity) return
	//I couldn't feasibly  fix the overlay bugs caused by cleaning items we are wearing.
	//So this is a workaround. This also makes more sense from an IC standpoint. ~Carn
	if(user.client && (target in user.client.screen))
		to_chat(user, "<span class='notice'>You need to take that [target.name] off before cleaning it.</span>")
	else if(istype(target,/obj/effect/decal/cleanable))
		to_chat(user, "<span class='notice'>You scrub \the [target.name] out.</span>")
		qdel(target)
	else if(istype(target,/turf))
		to_chat(user, "You start scrubbing the [target.name]")
		if (do_after(user, 30, needhand = 0))
			to_chat(user, "<span class='notice'>You scrub \the [target.name] clean.</span>")
			var/turf/T = target
			T.clean(src, user)
	else if(istype(target,/obj/structure/sink) || istype(target,/obj/structure/sink))
		to_chat(user, "<span class='notice'>You wet \the [src] in the sink.</span>")
		wet()
	else if (istype(target, /obj/structure/mopbucket) || istype(target, /obj/item/weapon/reagent_containers/glass) || istype(target, /obj/structure/reagent_dispensers/watertank))
		if (target.reagents && target.reagents.total_volume)
			to_chat(user, "<span class='notice'>You wet \the [src] in the [target].</span>")
			wet()
		else
			to_chat(user, "\The [target] is empty!")
	else
		to_chat(user, "<span class='notice'>You clean \the [target.name].</span>")
		target.clean_blood()
	return

//attack_as_weapon
/obj/item/weapon/soap/attack(mob/living/target, mob/living/user, var/target_zone)
	if(target && user && ishuman(target) && ishuman(user) && !target.stat && !user.stat && user.zone_sel &&user.zone_sel.selecting == "mouth" )
		user.visible_message("<span class='danger'>\The [user] washes \the [target]'s mouth out with soap!</span>")
		user.setClickCooldown(DEFAULT_QUICK_COOLDOWN) //prevent spam
		return
	..()

/*
 * Bike Horns
 */
/obj/item/weapon/bikehorn/attack_self(mob/user as mob)
	if (spam_flag == 0)
		spam_flag = 1
		playsound(src.loc, 'sound/items/bikehorn.ogg', 50, 1)
		src.add_fingerprint(user)
		spawn(20)
			spam_flag = 0
	return
