//Let's get some REAL contraband stuff in here. Because come on, getting brigged for LIPSTICK is no fun.

//Illicit drugs~
/obj/item/storage/pill_bottle/happy
	name = "bottle of Happy pills"
	desc = "Highly illegal drug. When you want to see the rainbow."
	starts_with = list(/obj/item/reagent_containers/pill/happy = 7)

/obj/item/storage/pill_bottle/zoom
	name = "bottle of Zoom pills"
	desc = "Highly illegal drug. Trade brain for speed."
	starts_with = list(/obj/item/reagent_containers/pill/zoom = 7)

/obj/item/reagent_containers/glass/beaker/vial/random
	flags = 0
	var/list/random_reagent_list = list(list("water" = 15) = 1, list("cleaner" = 15) = 1)

/obj/item/reagent_containers/glass/beaker/vial/random/toxin
	random_reagent_list = list(
		list("mindbreaker" = 10, "space_drugs" = 20)	= 3,
		list("carpotoxin" = 15)							= 2,
		list("impedrezene" = 15)						= 2,
		list("dextrotoxin" = 10)						= 1)

/obj/item/reagent_containers/glass/beaker/vial/random/Initialize()
	. = ..()
	if(is_open_container())
		flags ^= OPENCONTAINER

	var/list/picked_reagents = pickweight(random_reagent_list)
	for(var/reagent in picked_reagents)
		reagents.add_reagent(reagent, picked_reagents[reagent])

	var/list/names = new
	for(var/datum/reagent/R in reagents.reagent_list)
		names += R.name

	desc = "Contains [english_list(names)]."
	update_icon()


/obj/item/reagent_containers/glass/beaker/vial/venenum
	flags = 0

/obj/item/reagent_containers/glass/beaker/vial/venenum/Initialize()
	. = ..()
	if(is_open_container())
		flags ^= OPENCONTAINER
	reagents.add_reagent("venenum",volume)
	desc = "Contains venenum."
	update_icon()

/obj/item/reagent_containers/glass/beaker/vial/hallucinagen
	name = "vial of hallucinagens"
	desc = "A potent cocktail of mindbreaker and space drugs. Guaranteed to unhinge a person from reality."
	
/obj/item/reagent_containers/glass/beaker/vial/hallucinagen/Initialize()
	. = ..()
	reagents.add_reagent("mindbreaker", 10) 
	reagents.add_reagent("space_drugs" = 20)
	update_icon()

/obj/item/reagent_containers/glass/beaker/vial/carpotoxin
	name = "vial of carpotoxin"
	desc = "A vial of concentrated carpotoxin. While deadly on its own, it can also be used in an ingredient for other, more potent mixtures. Completely unathi-safe."
	
/obj/item/reagent_containers/glass/beaker/vial/carpotoxin/Initialize()
	. = ..()
	reagents.add_reagent("carpotoxin", 20)
	update_icon()

/obj/item/reagent_containers/glass/beaker/vial/unathipoison
	name = "vial of unathi poison"
	desc = "A potent mixture of concentrated frost oils and ethenol. Extremely deadly to unathi."
	
/obj/item/reagent_containers/glass/beaker/vial/unathipoison/Initialize()
	. = ..()
	reagents.add_reagent("frosttoxin", 15)
	update_icon()

/obj/item/reagent_containers/glass/beaker/vial/bugpoison
	name = "vial of cardox"
	desc = "A toxic phoron-cleaning chemical agent that is particularly deadly to vaurca."
	
/obj/item/reagent_containers/glass/beaker/vial/bugpoison/Initialize()
	. = ..()
	reagents.add_reagent("cardox", 30)
	update_icon()

/obj/item/reagent_containers/glass/beaker/vial/dragonsand
	name = "vial of dragonsand suspension"
	desc = "A potent substance that superheats the victim's body, causing them to ignite and burn to death painfully."
	
/obj/item/reagent_containers/glass/beaker/vial/tajarapoison/Initialize()
	. = ..()
	reagents.add_reagent("firetoxin", 15)
	update_icon()

/obj/item/reagent_containers/syringe/stealthpen
	name = "pen"
	desc = "An instrument for writing or drawing with ink. This one is in black, in a classic, grey casing. Stylish, classic and professional."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "pen"
	item_state = "pen"
	center_of_mass = list("x" = 16,"y" = 14)
	matter = list(MATERIAL_GLASS = 150)
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = null
	volume = 10
	w_class = 1
	slot_flags = SLOT_EARS
	sharp = 0
	noslice = 1
	unacidable = 0
	mode = SYRINGE_DRAW
	var/list/targets
	var/visible_name = "pen"

/obj/item/reagent_containers/syringe/stealthpen/on_reagent_change()
	return

/obj/item/reagent_containers/syringe/stealthpen/pickup(mob/user)
	return

/obj/item/reagent_containers/syringe/stealthpen/dropped(mob/user)
	return

/obj/item/reagent_containers/syringe/stealthpen/attack_self(mob/user as mob)
	playsound(loc, 'sound/items/penclick.ogg', 50, 1)

/obj/item/reagent_containers/syringe/stealthpen/attack_hand()
	..()
	return

/obj/item/reagent_containers/syringe/afterattack(obj/target, mob/user, proximity)
	if(!proximity || !target.reagents)
		return

	if(mode == SYRINGE_BROKEN)
		to_chat(user, span("warning", "This pen's tip is broken!"))
		return

	switch(mode)
		if(SYRINGE_DRAW)

			if(!reagents.get_free_space())
				to_chat(user, span("warning", "The syringe is full."))
				mode = SYRINGE_INJECT
				return

			if(ismob(target))
				user.visible_message("\The [user] jabs [target] with a pen!", "You jab [target] with your pen, doing no serious damage to them.", "You hear a firey whoosh.")
				to_chat(user, span("notice", "The pen is too blunt to penetrate flesh and is unsuitable for drawing blood."))
			else
				if(!target.reagents.total_volume)
					to_chat(user, span("notice", "[target] is empty."))
					return

				if(!target.is_open_container() && !istype(target, /obj/structure/reagent_dispensers) && !istype(target, /obj/item/slime_extract))
					to_chat(user, span("notice", "You cannot directly remove reagents from this object."))
					return

				var/trans = target.reagents.trans_to_obj(src, amount_per_transfer_from_this)
				to_chat(user, span("notice", "You fill the syringe with [trans] units of the solution."))

			if(!reagents.get_free_space())
				mode = SYRINGE_INJECT

		if(SYRINGE_INJECT)
			if(!reagents.total_volume)
				to_chat(user, span("notice", "The syringe is empty."))
				mode = SYRINGE_DRAW
				return
			if(istype(target, /obj/item/implantcase/chem))
				return

			if(!target.is_open_container() && !ismob(target) && !istype(target, /obj/item/reagent_containers/food) && !istype(target, /obj/item/slime_extract) && !istype(target, /obj/item/clothing/mask/smokable/cigarette) && !istype(target, /obj/item/storage/fancy/cigarettes))
				to_chat(user, span("notice", "You cannot directly fill this object."))
				return
			if(!target.reagents.get_free_space())
				to_chat(user, span("notice", "[target] is full."))
				return

			var/mob/living/carbon/human/H = target
			var/obj/item/organ/external/affected
			if(istype(H))
				affected = H.get_organ(user.zone_sel.selecting)
				if(!affected)
					to_chat(user, span("danger", "\The [H] is missing that limb!"))
					return
				else if(affected.status & ORGAN_ROBOT)
					to_chat(user, span("danger", "You cannot inject a robotic limb."))
					return

			if(ismob(target) && target != user)

				if(istype(H))
					if(H.wear_suit)
						to_chat(user, span("notice", "Your pen cannot penetrate a suit or armor."))
						return
				else if(isliving(target))

					var/mob/living/M = target
					if(!M.can_inject(user, 1))
						return

				if(user.a_intent != I_HARM)
					user.visible_message("\The [user] jabs [target] with a pen!", "You jab [target] with your pen, doing no serious damage to them.", "You hear a firey whoosh.")
					to_chat(user, span("notice", "The pen is too blunt to penetrate flesh without significant force and hostile intent."))
				else
					
					user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
					user.do_attack_animation(target)
					user.visible_message(span("danger", "[user] stabs [target] with the pen!"))

			var/trans
			if(ismob(target))
				syringestab
			else
				trans = reagents.trans_to(target, amount_per_transfer_from_this)
			to_chat(user, span("notice", "You inject the contents of the pen into the [target]. The pen is now empty."))
			if (reagents.total_volume <= 0 && mode == SYRINGE_INJECT)
				mode = SYRINGE_DRAW
	return

/obj/item/reagent_containers/syringe/stealthpen/proc/syringestab(mob/living/carbon/target as mob, mob/living/carbon/user as mob)
	if(istype(target, /mob/living/carbon/human))

		var/mob/living/carbon/human/H = target

		var/target_zone = ran_zone(check_zone(user.zone_sel.selecting), 70)
		var/obj/item/organ/external/affecting = H.get_organ(target_zone)

		if (!affecting || affecting.is_stump())
			to_chat(user, span("danger", "They are missing that limb!"))
			return

		var/hit_area = affecting.name

		if((user != target) && H.check_shields(7, src, user, "\the [src]"))
			return

		if (target != user && H.getarmor(target_zone, "melee") > 5 && prob(50))
			for(var/mob/O in viewers(world.view, user))
				O.show_message(text(span("danger", "[user] tries to stab [target] in \the [hit_area] with [src.name], but the attack is deflected by armor!")), 1)
			user.remove_from_mob(src)
			qdel(src)

			user.attack_log += "\[[time_stamp()]\]<font color='red'> Attacked [target.name] ([target.ckey]) with \the [src] (INTENT: HARM).</font>"
			target.attack_log += "\[[time_stamp()]\]<font color='orange'> Attacked by [user.name] ([user.ckey]) with [src.name] (INTENT: HARM).</font>"
			msg_admin_attack("[key_name_admin(user)] attacked [key_name_admin(target)] with [src.name] (INTENT: HARM) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)",ckey=key_name(user),ckey_target=key_name(src))

			return

		user.visible_message(span("danger", "[user] stabs [target] in \the [hit_area] with [src.name]!"))

		if(affecting.take_damage(3))
			H.UpdateDamageIcon()

	else
		user.visible_message(span("danger", "[user] stabs [target] with [src.name]!"))
		target.take_organ_damage(3)// 7 is the same as crowbar punch

	var/syringestab_amount_transferred = rand(0, (reagents.total_volume - 5)) //nerfed by popular demand
	var/contained_reagents = reagents.get_reagents()
	var/trans = reagents.trans_to_mob(target, syringestab_amount_transferred, CHEM_BLOOD)
	if(isnull(trans)) trans = 0
	admin_inject_log(user, target, src, contained_reagents, reagents.get_temperature(), trans, violent=1)
	break_syringe(target, user)

/obj/item/reagent_containers/syringe/proc/break_syringe(mob/living/carbon/target, mob/living/carbon/user)
	desc += " The tip is broken off."
	mode = SYRINGE_BROKEN
	icon_state = "pen"
	if(target)
		add_blood(target)
	if(user)
		add_fingerprint(user)
	update_icon()