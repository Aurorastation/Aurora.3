/obj/item/reagent_containers/dropper
	name = "dropper"
	desc = "A dropper. Transfers 5 units."
	icon = 'icons/obj/chemical.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_medical.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_medical.dmi',
		)
	icon_state = "dropper"
	item_state = "dropper"
	worn_overlay = "filling"
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
			to_chat(user, "<span class='notice'>[target] is full.</span>")
			return

		if(!target.is_open_container() && !ismob(target) && !istype(target, /obj/item/reagent_containers/food) && !istype(target, /obj/item/clothing/mask/smokable/cigarette)) //You can inject humans and food but you cant remove the shit.
			to_chat(user, "<span class='notice'>You cannot directly fill this object.</span>")
			return

		var/trans = 0

		if(ismob(target))
			var/time = 20 //2/3rds the time of a syringe
			user.visible_message("<span class='warning'>[user] is trying to squirt something into [target]'s eyes!</span>")

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
					user.visible_message("<span class='warning'>[user] tries to squirt something into [target]'s eyes, but fails!</span>", "<span class='warning'>You try to squirt something into [target]'s eyes, but fail!</span>")
					return

			trans = reagents.trans_to_mob(target, reagents.total_volume, CHEM_BLOOD)
			user.visible_message("<span class='warning'>[user] squirts something into [target]'s eyes!</span>", "<span class='notice'>You transfer [trans] units of the solution.</span>")

			var/mob/living/M = target
			var/contained = reagentlist()
			M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been squirted with [name] by [user.name] ([user.ckey]). Reagents: [contained]</font>")
			user.attack_log += text("\[[time_stamp()]\] <span class='warning'>Used the [name] to squirt [M.name] ([M.key]). Reagents: [contained]</span>")
			msg_admin_attack("[key_name_admin(user)] squirted [key_name_admin(M)] with [name]. Reagents: [contained] (INTENT: [uppertext(user.a_intent)]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)",ckey=key_name(user),ckey_target=key_name(M))
			return

		else
			trans = reagents.trans_to(target, amount_per_transfer_from_this) //sprinkling reagents on generic non-mobs
			to_chat(user, "<span class='notice'>You transfer [trans] units of the solution.</span>")

	else // Taking from something

		if(!target.is_open_container() && !istype(target,/obj/structure/reagent_dispensers))
			to_chat(user, "<span class='notice'>You cannot directly remove reagents from [target].</span>")
			return

		if(!target.reagents || !target.reagents.total_volume)
			to_chat(user, "<span class='notice'>[target] is empty.</span>")
			return

		var/trans = target.reagents.trans_to_obj(src, amount_per_transfer_from_this)
		to_chat(user, "<span class='notice'>You fill the dropper with [trans] units of the solution.</span>")

/obj/item/reagent_containers/dropper/on_reagent_change()
	update_icon()

/obj/item/reagent_containers/dropper/update_icon()
	cut_overlays()
	if(reagents)
		add_overlay(overlay_image('icons/obj/reagentfillings.dmi', "[icon_state]", color = reagents.get_color()))
		worn_overlay_color = reagents.get_color() // handles inhands
		update_held_icon()

/obj/item/reagent_containers/dropper/AltClick(mob/user)
	var/N = input("Amount per transfer from this:", "[src]") as null|anything in possible_transfer_amounts
	if(N)
		amount_per_transfer_from_this = N

/obj/item/reagent_containers/dropper/industrial
	name = "industrial dropper"
	desc = "A larger dropper. Transfers 10 units."
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(1,2,3,4,5,6,7,8,9,10)
	volume = 10

////////////////////////////////////////////////////////////////////////////////
/// Droppers. END
////////////////////////////////////////////////////////////////////////////////
