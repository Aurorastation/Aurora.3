/obj/item/reagent_containers/dropper
	name = "dropper"
	desc = "A dropper. It has a volume of 5 units."
	desc_info = "Alt Click or Activate this item to change transfer rate."
	icon = 'icons/obj/chemical.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_medical.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_medical.dmi',
		)
	icon_state = "dropper"
	item_state = "dropper"
	filling_states = "10;25;50;75;100"
	build_from_parts = TRUE
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list(1,2,3,4,5)
	w_class = ITEMSIZE_TINY
	slot_flags = SLOT_EARS
	volume = 5
	drop_sound = 'sound/items/drop/glass_small.ogg'
	pickup_sound = 'sound/items/pickup/glass_small.ogg'

/obj/item/reagent_containers/dropper/afterattack(var/obj/target, var/mob/user, var/flag)
	if(!target.reagents || !flag)
		return

	if(reagents.total_volume)
		if(!REAGENTS_FREE_SPACE(target.reagents))
			to_chat(user, SPAN_NOTICE("[target] is full."))
			return

		if(!target.is_open_container() && !ismob(target) && !istype(target, /obj/item/reagent_containers/food) && !istype(target, /obj/item/clothing/mask/smokable/cigarette)) //You can inject humans and food but you cant remove the shit.
			to_chat(user, SPAN_NOTICE("You cannot directly fill this object."))
			return

		var/trans = 0

		if(ismob(target))
			var/time = 20 //2/3rds the time of a syringe
			user.visible_message(SPAN_WARNING("[user] is trying to squirt something into [target]'s eyes!"))

			if(!do_mob(user, target, time))
				return

			if(istype(target, /mob/living/carbon/human))
				var/mob/living/carbon/human/victim = target

				if(victim.isSynthetic())
					return

				var/obj/item/safe_thing = null
				if(victim.wear_mask)
					if (victim.wear_mask.body_parts_covered & EYES)
						safe_thing = victim.wear_mask
				if(victim.head)
					if (victim.head.body_parts_covered & EYES)
						safe_thing = victim.head
				if(victim.glasses)
					if (!safe_thing && (victim.glasses.body_parts_covered & EYES))
						safe_thing = victim.glasses

				if(safe_thing)
					trans = reagents.trans_to_obj(safe_thing, amount_per_transfer_from_this)
					user.visible_message(SPAN_WARNING("[user] tries to squirt something into [target]'s eyes, but fails!"), SPAN_WARNING("You try to squirt something into [target]'s eyes, but fail!"))
					return

			var/mob/living/M = target
			var/contained = reagentlist()
			trans = reagents.trans_to_mob(target, amount_per_transfer_from_this, CHEM_BLOOD)
			admin_inject_log(user, M, src, contained, reagents.get_temperature(), trans)
			user.visible_message(SPAN_WARNING("[user] squirts something into [target]'s eyes!"), SPAN_NOTICE("You transfer [trans] units of the solution. [reagents.total_volume] units remaining in \the [src]."))
			return

		else
			trans = reagents.trans_to(target, amount_per_transfer_from_this) //sprinkling reagents on generic non-mobs
			to_chat(user, SPAN_NOTICE("You transfer [trans] units of the solution."))

	else // Taking from something
		if(!target.is_open_container() && !istype(target,/obj/structure/reagent_dispensers))
			to_chat(user, SPAN_NOTICE("You cannot directly remove reagents from [target]."))
			return

		if(!target.reagents || !target.reagents.total_volume)
			to_chat(user, SPAN_NOTICE("[target] is empty."))
			return

		var/trans = target.reagents.trans_to_obj(src, amount_per_transfer_from_this)
		to_chat(user, SPAN_NOTICE("You fill \the [src] with [trans] units of the solution."))

/obj/item/reagent_containers/dropper/attack_self(mob/user)
	set_APTFT()

/obj/item/reagent_containers/dropper/AltClick(mob/user)
	set_APTFT()

/obj/item/reagent_containers/dropper/on_reagent_change()
	update_icon()

/obj/item/reagent_containers/dropper/update_icon()
	cut_overlays()
	if(reagents.total_volume)
		worn_overlay = "filling"
		add_overlay(overlay_image('icons/obj/reagentfillings.dmi', "[icon_state]-[get_filling_state()]", color = reagents.get_color()))
		worn_overlay_color = reagents.get_color() // handles inhands
		update_held_icon()
	else
		worn_overlay = null
		update_held_icon()

/obj/item/reagent_containers/dropper/examine(mob/user)
	..(user)
	if(LAZYLEN(reagents.reagent_volumes))
		to_chat(user, SPAN_NOTICE("\The [src] is holding [reagents.total_volume] units out of [volume]. Current transfer is [amount_per_transfer_from_this] units."))
	else
		to_chat(user, SPAN_NOTICE("It is empty."))

/obj/item/reagent_containers/dropper/electronic_pipette
	name = "electronic pipette"
	desc = "A laboratory standard electronic pipette, designed for a finer and more precise transfer rate of substances with a volume of 5 units."
	icon = 'icons/obj/chemical.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_medical.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_medical.dmi',
		)
	icon_state = "electronic_pipette"
	item_state = "electronic_pipette"
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list(0.1, 0.2, 0.5, 1, 2, 3, 4, 5)

/obj/item/reagent_containers/dropper/cyborg_pipette
	name = "cyborg pipette"
	desc = "A cyborg pipette which contains a larger internal volume of 10 units, while still capable of having finer transfer rates if required."
	icon_state = "cyborg_pipette"
	item_state = "cyborg_pipette"
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(0.1, 0.2, 0.5, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
	volume = 10

////////////////////////////////////////////////////////////////////////////////
/// Droppers. END
////////////////////////////////////////////////////////////////////////////////
