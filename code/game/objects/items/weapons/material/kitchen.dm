/obj/item/material/kitchen
	icon = 'icons/obj/kitchen.dmi'

/*
 * Utensils
 */
/obj/item/material/kitchen/utensil
	drop_sound = 'sound/items/drop/knife.ogg'
	w_class = 1
	thrown_force_divisor = 1
	origin_tech = list(TECH_MATERIAL = 1)
	attack_verb = list("attacked", "stabbed", "poked")
	sharp = FALSE
	edge = FALSE
	force_divisor = 0.1 // 6 when wielded with hardness 60 (steel)
	thrown_force_divisor = 0.25 // 5 when thrown with weight 20 (steel)
	var/loaded      //Descriptive string for currently loaded food object.
	var/is_liquid = FALSE //whether you've got liquid on your utensil
	var/scoop_food = 1

/obj/item/material/kitchen/utensil/New()
	..()
	if (prob(60))
		src.pixel_y = rand(0, 4)
	create_reagents(5)
	return

/obj/item/material/kitchen/utensil/attack(mob/living/carbon/M, mob/user, var/target_zone)
	if(!istype(M))
		return ..()

	if(user.a_intent != I_HELP)
		if(target_zone == BP_HEAD || target_zone == BP_EYES)
			if((user.is_clumsy()) && prob(50))
				M = user
			return eyestab(M,user)
		else
			return ..()
	var/fullness = M.get_fullness()
	if(reagents.total_volume > 0)
		if(M == user)
			if(!M.can_eat(loaded))
				return
			if (fullness > (550 * (1 + M.overeatduration / 2000)))
				to_chat(M, "You cannot force anymore food down!")
				return
			M.visible_message(span("notice", "\The [user] [is_liquid ? "drinks" : "eats"] some [loaded] from \the [src]."))
		else
			if (fullness > (550 * (1 + M.overeatduration / 2000)))
				to_chat(M, "You cannot force anymore food down their throat!")
				return
			user.visible_message(span("warning", "\The [user] begins to feed \the [M]!"))
			if(!(M.can_force_feed(user, loaded) && do_mob(user, M, 5 SECONDS)))
				return
			M.visible_message(span("notice", "\The [user] feeds some [loaded] to \the [M] with \the [src]."))
		reagents.trans_to_mob(M, reagents.total_volume, CHEM_INGEST)
		if(is_liquid)
			playsound(user.loc, 'sound/items/drink.ogg', rand(10, 50), 1)
			is_liquid = FALSE
		else
			playsound(user.loc, 'sound/items/eatfood.ogg', rand(10, 50), 1)
		cut_overlays()
		return
	else
		to_chat(user, span("warning", "You don't have anything on \the [src].")) 	//if we have help intent and no food scooped up DON'T STAB OURSELVES WITH THE FORK)
		return

/obj/item/material/kitchen/utensil/fork
	name = "fork"
	desc = "It's a fork. Sure is pointy."
	icon_state = "fork"
	sharp = TRUE

/obj/item/material/kitchen/utensil/fork/plastic
	default_material = MATERIAL_PLASTIC

/obj/item/material/kitchen/utensil/spoon
	name = "spoon"
	desc = "It's a spoon. You can see your own upside-down face in it."
	icon_state = "spoon"
	attack_verb = list("attacked", "poked")
	force_divisor = 0.1 //2 when wielded with weight 20 (steel)

/obj/item/material/kitchen/utensil/spoon/plastic
	default_material = MATERIAL_PLASTIC

/*
 * Knives
 */
/obj/item/material/kitchen/utensil/knife
	name = "knife"
	desc = "A knife for eating with. Can cut through any food."
	icon_state = "knife"
	force_divisor = 0.1 // 6 when wielded with hardness 60 (steel)
	scoop_food = FALSE
	sharp = TRUE
	edge = TRUE

// Identical to the tactical knife but nowhere near as stabby.
// Kind of like the toy esword compared to the real thing.
/obj/item/material/kitchen/utensil/knife/boot
	name = "boot knife"
	desc = "A small fixed-blade knife for putting inside a boot."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "tacknife"
	item_state = "knife"
	applies_material_colour = 0
	unbreakable = 1

/obj/item/material/kitchen/utensil/knife/attack(mob/target, mob/living/user, var/target_zone)
	if ((user.is_clumsy()) && prob(50))
		to_chat(user, span("warning", "You accidentally cut yourself with \the [src]."))
		user.take_organ_damage(20)
		return
	return ..()

/obj/item/material/kitchen/utensil/knife/plastic
	default_material = MATERIAL_PLASTIC

/*
 * Rolling Pins
 */

/obj/item/material/kitchen/rollingpin
	name = "rolling pin"
	desc = "Used to knock out the Bartender."
	icon_state = "rolling_pin"
	attack_verb = list("bashed", "battered", "bludgeoned", "thrashed", "whacked")
	default_material = "wood"
	force_divisor = 0.7 // 10 when wielded with weight 15 (wood)
	thrown_force_divisor = 1 // as above
	drop_sound = 'sound/items/drop/wooden.ogg'

/obj/item/material/kitchen/rollingpin/attack(mob/living/M, mob/living/user, var/target_zone)
	if ((user.is_clumsy()) && prob(50))
		to_chat(user, span("warning", "\The [src] slips out of your hand and hits your head."))
		user.drop_from_inventory(src)
		user.take_organ_damage(10)
		user.Paralyse(2)
		return
	return ..()
