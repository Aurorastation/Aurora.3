////////////////////////////////////////////////////////////////////////////////
/// Syringes.
////////////////////////////////////////////////////////////////////////////////
#define SYRINGE_DRAW 0
#define SYRINGE_INJECT 1
#define SYRINGE_BROKEN 2
#define SYRINGE_CAPPED 3

/obj/item/reagent_containers/syringe
	name = "syringe"
	desc = "A syringe."
	icon = 'icons/obj/syringe.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_medical.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_medical.dmi',
		)
	item_state = "syringe_0"
	icon_state = "0"
	center_of_mass = list("x" = 16,"y" = 14)
	matter = list(MATERIAL_GLASS = 150)
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = null
	volume = 15
	w_class = 1
	slot_flags = SLOT_EARS
	sharp = 1
	noslice = 1
	unacidable = 1 //glass
	var/mode = SYRINGE_CAPPED
	var/used = FALSE
	var/dirtiness = 0
	var/list/targets
	var/list/datum/disease2/disease/viruses
	var/image/filling //holds a reference to the current filling overlay
	var/visible_name = "a syringe"
	var/time = 30
	center_of_mass = null
	drop_sound = 'sound/items/drop/glass.ogg'

/obj/item/reagent_containers/syringe/Initialize()
	. = ..()
	update_icon()

/obj/item/reagent_containers/syringe/Destroy()
	LAZYCLEARLIST(viruses)
	LAZYCLEARLIST(targets)
	return ..()

/obj/item/reagent_containers/syringe/process() // this only happens once it's used
	if(prob(75)) // sorry, had to nerf this.
		return
	dirtiness = min(dirtiness + LAZYLEN(targets), 75)
	if(dirtiness >= 75)
		STOP_PROCESSING(SSprocessing, src)
	return 1

/obj/item/reagent_containers/syringe/proc/infect_limb(var/obj/item/organ/external/eo)
	eo.germ_level += dirtiness // only 75% of the way to an infection at max

/obj/item/reagent_containers/syringe/proc/dirty(var/mob/living/carbon/human/target, var/obj/item/organ/external/eo)
	LAZYINITLIST(targets)

	//Just once!
	targets |= WEAKREF(target)

	//Grab any viruses they have
	var/datum/disease2/disease/virus
	if(LAZYLEN(target.virus2.len))
		LAZYINITLIST(viruses)
		virus = pick(target.virus2.len)
		viruses += virus.getcopy()

	//Dirtiness should be very low if you're the first injectee. If you're spam-injecting 4 people in a row around you though,
	//This gives the last one a 30% chance of infection.
	if(prob(dirtiness+(targets.len-1)*10))
		log_and_message_admins("[loc] infected [target]'s [eo.name] with \the [src].")
		addtimer(CALLBACK(src, .proc/infect_limb), rand(5 MINUTES, 10 MINUTES))

	//75% chance to spread a virus if we have one
	if(LAZYLEN(viruses) && prob(75))
		var/newvir = pick(viruses - virus)
		var/datum/disease2/disease/newvirus = viruses[newvir]
		infect_virus2(target,newvirus.getcopy())

	if(!used)
		START_PROCESSING(SSprocessing, src)
		used = TRUE

/obj/item/reagent_containers/syringe/on_reagent_change()
	update_icon()

/obj/item/reagent_containers/syringe/pickup(mob/user)
	..()
	update_icon()

/obj/item/reagent_containers/syringe/dropped(mob/user)
	..()
	update_icon()

/obj/item/reagent_containers/syringe/attack_self(mob/user as mob)
	switch(mode)
		if(SYRINGE_CAPPED)
			mode = SYRINGE_DRAW
			to_chat(user, span("notice", "You uncap the syringe."))
		if(SYRINGE_DRAW)
			mode = SYRINGE_INJECT
		if(SYRINGE_INJECT)
			mode = SYRINGE_DRAW
		if(SYRINGE_BROKEN)
			return
	update_icon()

/obj/item/reagent_containers/syringe/attack_hand()
	..()
	update_icon()

/obj/item/reagent_containers/syringe/attackby(obj/item/I as obj, mob/user as mob)
	return

/obj/item/reagent_containers/syringe/afterattack(obj/target, mob/user, proximity)
	if(!proximity || !target.reagents)
		return

	if(mode == SYRINGE_CAPPED)
		to_chat(user, span("notice", "This syringe is capped!"))
		return
	if(mode == SYRINGE_BROKEN)
		to_chat(user, span("warning", "This syringe is broken!"))
		return

	if(user.a_intent == I_GRAB && ishuman(user) && ishuman(target)) // we could add other things here eventually. trepanation maybe
		var/mob/living/carbon/human/H = target
		if (check_zone(user.zone_sel.selecting) == BP_CHEST) // impromptu needle thoracostomy, re-inflate a collapsed lung
			var/P = (user == target) ? "their" : (target.name + "\'s")
			var/SM = (user == target) ? "your" : (target.name + "\'s")
			user.visible_message(span("danger", "[user] aims \the [src] between [P] ribs!"), span("danger", "You aim \the [src] between [SM] ribs!"))
			if(!do_mob(user, target, 1.5 SECONDS))
				return
			user.visible_message(span("warning", "[user] jabs \the [src] between [P] ribs with \the [src]!"), span("warning", "You jab \the [src] between [SM] ribs!"))
			if(H.is_lung_ruptured())
				var/obj/item/organ/internal/lungs/L = H.internal_organs_by_name[BP_LUNGS]
				if(!L.rescued)
					L.rescued = TRUE
				else
					L.rescued = FALSE
					L.take_damage(3)
			return

	if(user.a_intent == I_HURT && ishuman(user))
		if((user.is_clumsy()) && prob(50))
			target = user
		syringestab(target, user)
		return


	switch(mode)
		if(SYRINGE_DRAW)

			if(!reagents.get_free_space())
				to_chat(user, span("warning", "The syringe is full."))
				mode = SYRINGE_INJECT
				return

			if(ismob(target))//Blood!
				if(reagents.has_reagent("blood"))
					to_chat(user, span("notice", "There is already a blood sample in this syringe."))
					return
				if(istype(target, /mob/living/carbon))
					if(istype(target, /mob/living/carbon/slime))
						to_chat(user, span("warning", "You are unable to locate any blood."))
						return
					var/amount = reagents.get_free_space()
					var/mob/living/carbon/T = target
					if(!T.dna)
						to_chat(user, span("warning", "You are unable to locate any blood. (To be specific, your target seems to be missing their DNA datum)."))
						return
					if(NOCLONE in T.mutations) //target done been et, no more blood in him
						to_chat(user, span("warning", "You are unable to locate any blood."))
						return

					var/datum/reagent/B
					if(istype(T, /mob/living/carbon/human))
						var/mob/living/carbon/human/H = T
						if(H.species && H.species.flags & NO_BLOOD)
							H.reagents.trans_to_obj(src, amount)
						else
							B = T.take_blood(src, amount)
					else
						B = T.take_blood(src,amount)

					if (B)
						reagents.reagent_list += B
						reagents.update_total()
						on_reagent_change()
						reagents.handle_reactions()
					to_chat(user, span("notice", "You take a blood sample from [target]."))
					for(var/mob/O in viewers(4, user))
						O.show_message(span("notice", "[user] takes a blood sample from [target]."), 1)

			else //if not mob
				if(!target.reagents.total_volume)
					to_chat(user, span("notice", "[target] is empty."))
					return

				if(!target.is_open_container() && !istype(target, /obj/structure/reagent_dispensers) && !istype(target, /obj/item/slime_extract))
					to_chat(user, span("notice", "You cannot directly remove reagents from this object."))
					return

				var/trans = target.reagents.trans_to_obj(src, amount_per_transfer_from_this)
				to_chat(user, span("notice", "You fill the syringe with [trans] units of the solution."))
				update_icon()

			if(!reagents.get_free_space())
				mode = SYRINGE_INJECT
				update_icon()

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

				var/injtime = time //Injecting through a voidsuit takes longer due to needing to find a port.

				if(istype(H))
					if(H.wear_suit)
						if(istype(H.wear_suit, /obj/item/clothing/suit/space))
							injtime = injtime * 2
						else if(!H.can_inject(user, 1))
							return
					if(isvaurca(H))
						injtime = injtime * 2

				else if(isliving(target))

					var/mob/living/M = target
					if(!M.can_inject(user, 1))
						return

				if(injtime == time)
					user.visible_message(span("warning", "[user] is trying to inject [target] with [visible_name]!"))
				else
					if(isvaurca(H))
						user.visible_message(span("warning", "[user] begins hunting for an injection port on [target]'s carapace!"))
					else
						user.visible_message(span("warning", "[user] begins hunting for an injection port on [target]'s suit!"))

				user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
				user.do_attack_animation(target)

				if(!do_mob(user, target, injtime))
					return

				user.visible_message(span("warning", "[user] injects [target] with the syringe!"))

			var/trans
			if(ismob(target))
				var/contained = reagentlist()
				trans = reagents.trans_to_mob(target, amount_per_transfer_from_this, CHEM_BLOOD)
				dirty(target, affected)
				admin_inject_log(user, target, src, contained, reagents.get_temperature(), trans)
			else
				trans = reagents.trans_to(target, amount_per_transfer_from_this)
			to_chat(user, span("notice", "You inject [trans] units of the solution. The syringe now contains [src.reagents.total_volume] units."))
			if (reagents.total_volume <= 0 && mode == SYRINGE_INJECT)
				mode = SYRINGE_DRAW
				update_icon()

	return

/obj/item/reagent_containers/syringe/update_icon()
	cut_overlays()

	var/matrix/tf = matrix()
	if(istype(loc, /obj/item/storage))
		tf.Turn(-90) //Vertical for storing compactly
		tf.Translate(-3,0) //Could do this with pixel_x but let's just update the appearance once.
	transform = tf

	if(mode == SYRINGE_BROKEN)
		icon_state = "broken"
		return

	if(mode == SYRINGE_CAPPED)
		icon_state = "capped"
		return

	var/rounded_vol = round(reagents.total_volume, round(reagents.maximum_volume / 3))
	if(ismob(loc))
		var/injoverlay
		switch(mode)
			if (SYRINGE_DRAW)
				injoverlay = "draw"
			if (SYRINGE_INJECT)
				injoverlay = "inject"
		add_overlay(injoverlay)
	icon_state = "[rounded_vol]"
	item_state = "syringe_[rounded_vol]"

	if(reagents.total_volume)
		filling = image('icons/obj/syringe.dmi', src, "syringe10")

		filling.icon_state = "syringe[rounded_vol]"

		filling.color = reagents.get_color()
		add_overlay(filling)

/obj/item/reagent_containers/syringe/proc/syringestab(mob/living/carbon/target as mob, mob/living/carbon/user as mob)
	if(mode == SYRINGE_CAPPED)
		to_chat(user, span("danger", "You can't stab someone with a capped syringe!"))

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
	desc += " It is broken."
	mode = SYRINGE_BROKEN
	if(target)
		add_blood(target)
	if(user)
		add_fingerprint(user)
	update_icon()

/obj/item/reagent_containers/syringe/ld50_syringe
	name = "Lethal Injection Syringe"
	desc = "A syringe used for lethal injections."
	amount_per_transfer_from_this = 60
	volume = 60
	visible_name = "a giant syringe"
	time = 300

/obj/item/reagent_containers/syringe/ld50_syringe/afterattack(obj/target, mob/user, flag)
	if(mode == SYRINGE_DRAW && ismob(target)) // No drawing 50 units of blood at once
		to_chat(user, span("notice", "This needle isn't designed for drawing blood."))
		return
	if(user.a_intent == "hurt" && ismob(target)) // No instant injecting
		to_chat(user, span("notice", "This syringe is too big to stab someone with it."))
	..()

////////////////////////////////////////////////////////////////////////////////
/// Syringes. END
////////////////////////////////////////////////////////////////////////////////

/obj/item/reagent_containers/syringe/norepinephrine
	name = "Syringe (norepinephrine)"
	desc = "Contains norepinephrine - used to stabilize patients."
	
/obj/item/reagent_containers/syringe/norepinephrine/Initialize()
	. = ..()
	reagents.add_reagent("norepinephrine", 15)
	mode = SYRINGE_INJECT
	update_icon()

/obj/item/reagent_containers/syringe/dylovene
	name = "Syringe (dylovene)"
	desc = "Contains anti-toxins."
	
/obj/item/reagent_containers/syringe/dylovene/Initialize()
	. = ..()
	reagents.add_reagent("dylovene", 15)
	mode = SYRINGE_INJECT
	update_icon()

/obj/item/reagent_containers/syringe/antiviral
	name = "Syringe (deltamivir)"
	desc = "Contains antiviral agents."

/obj/item/reagent_containers/syringe/antiviral/Initialize()
	. = ..()
	reagents.add_reagent("deltamivir", 15)
	mode = SYRINGE_INJECT
	update_icon()

/obj/item/reagent_containers/syringe/antibiotic
	name = "Syringe (thetamycin)"
	desc = "Contains antibiotics."

/obj/item/reagent_containers/syringe/antibiotic/Initialize()
	. = ..()
	reagents.add_reagent("thetamycin", 15)
	mode = SYRINGE_INJECT
	update_icon()

/obj/item/reagent_containers/syringe/drugs
	name = "Syringe (drugs)"
	desc = "Contains aggressive drugs meant for torture."

/obj/item/reagent_containers/syringe/drugs/Initialize()
	. = ..()
	reagents.add_reagent("panotoxin",  5)
	reagents.add_reagent("mindbreaker",  10)
	mode = SYRINGE_INJECT
	update_icon()

/obj/item/reagent_containers/syringe/calomel
	name = "Syringe (calomel)"
	desc = "Contains purging medicine."

/obj/item/reagent_containers/syringe/calomel/Initialize()
	. = ..()
	reagents.add_reagent("calomel",  15)
	mode = SYRINGE_INJECT
	update_icon()


/obj/item/reagent_containers/syringe/ld50_syringe/chloral/Initialize()
	. = ..()
	reagents.add_reagent("chloralhydrate", 60)
	mode = SYRINGE_INJECT
	update_icon()
