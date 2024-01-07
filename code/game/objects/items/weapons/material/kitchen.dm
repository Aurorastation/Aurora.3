/obj/item/material/kitchen
	icon = 'icons/obj/kitchen.dmi'
	contained_sprite = TRUE

/*
 * Utensils
 */
/obj/item/material/kitchen/utensil
	drop_sound = 'sound/items/drop/knife.ogg'
	pickup_sound = 'sound/items/pickup/knife.ogg'
	hitsound = 'sound/weapons/bladeslice.ogg'
	w_class = ITEMSIZE_TINY
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
	var/transfer_amt = 1
	var/list/bite_sizes = list(1,2,3,4,5)
	use_material_name = FALSE
	applies_material_colour = FALSE

/obj/item/material/kitchen/utensil/Initialize(newloc, material_key)
	. = ..()
	if (prob(60))
		src.pixel_y = rand(0, 4)
	create_reagents(5)

/obj/item/material/kitchen/utensil/attack(mob/living/carbon/M, mob/user, var/target_zone)
	if(!istype(M))
		return ..()

	if(user.a_intent != I_HELP)
		if((target_zone == BP_HEAD || target_zone == BP_EYES) && !M.eyes_protected(src, FALSE))
			if((user.is_clumsy()) && prob(50))
				M = user
			return eyestab(M,user)
		else
			return ..()
	if(reagents.total_volume > 0)
		if(M == user)
			if(!M.can_eat(loaded))
				return
			to_chat(M, SPAN_NOTICE("You [is_liquid ? "drink" : "eat"] some [loaded] from \the [src]."))
		else
			user.visible_message(SPAN_WARNING("\The [user] begins to feed \the [M]!"), SPAN_WARNING("You begin to feed \the [M]!"))
			if(!(M.can_force_feed(user, loaded) && do_mob(user, M, 5 SECONDS)))
				return
			M.visible_message(SPAN_NOTICE("\The [user] feeds some [loaded] to \the [M] with \the [src]."), SPAN_NOTICE("You feed some [loaded] to \the [M] with \the [src]."))
		reagents.trans_to_mob(M, reagents.total_volume, CHEM_INGEST)
		if(is_liquid)
			playsound(user.loc, 'sound/items/drink.ogg', rand(10, 50), 1)
			is_liquid = FALSE
		else
			playsound(user.loc, 'sound/items/eatfood.ogg', rand(10, 50), 1)
		cut_overlays()
		return
	else
		to_chat(user, SPAN_WARNING("You don't have anything on \the [src].")) 	//if we have help intent and no food scooped up DON'T STAB OURSELVES WITH THE FORK)
		return

/obj/item/material/kitchen/utensil/on_rag_wipe()
	. = ..()
	if(reagents.total_volume > 0)
		reagents.clear_reagents()
		is_liquid = FALSE
		loaded = null
		cut_overlays()
	return

/obj/item/material/kitchen/utensil/verb/bite_size()
	set name = "Change bite size"
	set category = "Object"
	set src in usr

	var/nsize = tgui_input_list(usr, "Select the amount of reagents to pick up.", "Bite Size", bite_sizes, transfer_amt)
	if(nsize)
		transfer_amt = nsize
		to_chat(usr, SPAN_NOTICE("\The [src] will now scoop up [transfer_amt] reagents."))

/obj/item/material/kitchen/utensil/fork
	name = "fork"
	desc = "It's a fork. Sure is pointy."
	icon_state = "fork"
	sharp = TRUE
	surgerysound = 'sound/items/surgery/hemostat.ogg'

/obj/item/material/kitchen/utensil/fork/plastic
	icon_state = "plastic_fork"
	default_material = MATERIAL_PLASTIC
	use_material_name = TRUE
	applies_material_colour = TRUE

/obj/item/material/kitchen/utensil/spork
	name = "spork"
	desc = "It's a spork. It's much like a fork, but much blunter."
	icon_state = "spork"

/obj/item/material/kitchen/utensil/spork/plastic
	icon_state = "plastic_spork"
	default_material = MATERIAL_PLASTIC
	use_material_name = TRUE
	applies_material_colour = TRUE

/obj/item/material/kitchen/utensil/fork/chopsticks
	name = "chopsticks"
	desc = "A pair of chopsticks. An extension of one's fingers, one might say."
	icon_state = "chopsticks"

/obj/item/material/kitchen/utensil/fork/chopsticks/bamboo
	icon_state = "plastic_chopsticks"
	default_material = MATERIAL_BAMBOO
	use_material_name = TRUE
	applies_material_colour = TRUE

/obj/item/material/kitchen/utensil/spoon
	name = "spoon"
	desc = "It's a spoon. You can see your own upside-down face in it."
	icon_state = "spoon"
	attack_verb = list("attacked", "poked")
	force_divisor = 0.1 //2 when wielded with weight 20 (steel)

/obj/item/material/kitchen/utensil/spoon/plastic
	icon_state = "plastic_spoon"
	default_material = MATERIAL_PLASTIC
	use_material_name = TRUE
	applies_material_colour = TRUE

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
		to_chat(user, SPAN_WARNING("You accidentally cut yourself with \the [src]."))
		user.take_organ_damage(20)
		return
	return ..()

/obj/item/material/kitchen/utensil/knife/plastic
	icon_state = "plastic_knife"
	default_material = MATERIAL_PLASTIC
	use_material_name = TRUE
	applies_material_colour = TRUE

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
	use_material_name = TRUE
	applies_material_colour = TRUE

/obj/item/material/kitchen/rollingpin/attack(mob/living/M, mob/living/user, var/target_zone)
	if ((user.is_clumsy()) && prob(50))
		to_chat(user, SPAN_WARNING("\The [src] slips out of your hand and hits your head."))
		user.drop_from_inventory(src)
		user.take_organ_damage(10)
		user.Paralyse(2)
		return
	return ..()
