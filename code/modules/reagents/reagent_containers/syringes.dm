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
	desc_info = "This tool can be used to reinflate a collapsed lung. To do this, activate grab intent, select the patient's chest, then click on them. It will hurt a lot, but it will buy time until surgery can be performed."
	icon = 'icons/obj/syringe.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_medical.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_medical.dmi',
		)
	icon_state = "0"
	item_state = "syringe"
	build_from_parts = TRUE
	matter = list(MATERIAL_GLASS = 150)
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list(1, 2, 5, 10, 15)
	volume = 15
	w_class = ITEMSIZE_TINY
	slot_flags = SLOT_EARS
	sharp = 1
	noslice = 1
	unacidable = 1 //glass
	var/mode = SYRINGE_CAPPED
	var/image/filling //holds a reference to the current filling overlay (used for syringe guns)
	var/used = FALSE
	var/dirtiness = 0
	var/list/targets
	var/list/datum/disease2/disease/viruses
	var/time = 30


	var/last_jab = 0 //Spam prevention
	center_of_mass = null

	drop_sound = 'sound/items/drop/glass_small.ogg'
	pickup_sound = 'sound/items/pickup/glass_small.ogg'

/obj/item/reagent_containers/syringe/Initialize()
	. = ..()
	update_icon()

/obj/item/reagent_containers/syringe/Destroy()
	LAZYCLEARLIST(targets)
	return ..()

/obj/item/reagent_containers/syringe/process() // this only happens once it's used
	if(prob(75)) // sorry, had to nerf this.
		return
	dirtiness = min(dirtiness + LAZYLEN(targets), 75)
	if(dirtiness >= 75)
		STOP_PROCESSING(SSprocessing, src)
	return 1

/obj/item/reagent_containers/syringe/AltClick(var/mob/user)
	set_APTFT()

/obj/item/reagent_containers/syringe/proc/infect_limb(var/obj/item/organ/external/eo)
	eo.germ_level += dirtiness // only 75% of the way to an infection at max

/obj/item/reagent_containers/syringe/proc/dirty(var/mob/living/carbon/human/target, var/obj/item/organ/external/eo)
	LAZYINITLIST(targets)

	//Just once!
	targets |= WEAKREF(target)

	//Dirtiness should be very low if you're the first injectee. If you're spam-injecting 4 people in a row around you though,
	//This gives the last one a 30% chance of infection.
	if(prob(dirtiness+(targets.len-1)*10))
		log_and_message_admins("[loc] infected [target]'s [eo.name] with \the [src].")
		addtimer(CALLBACK(src, PROC_REF(infect_limb), eo), rand(5 MINUTES, 10 MINUTES))

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
			to_chat(user, SPAN_NOTICE("You uncap the syringe."))
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
	if(last_jab + time > world.time)
		to_chat(usr, SPAN_WARNING("You're already using \the [src]!"))
		return

	if(!proximity || !target.reagents)
		return

	if(mode == SYRINGE_CAPPED)
		to_chat(user, SPAN_NOTICE("This syringe is capped!"))
		return
	if(mode == SYRINGE_BROKEN)
		to_chat(user, SPAN_WARNING("This syringe is broken!"))
		return

	if(user.a_intent == I_GRAB && ishuman(user) && ishuman(target)) // we could add other things here eventually. trepanation maybe
		var/mob/living/carbon/human/H = target
		if (check_zone(user.zone_sel.selecting) == BP_CHEST) // impromptu needle thoracostomy, re-inflate a collapsed lung
			var/obj/item/organ/internal/lungs/L = H.internal_organs_by_name[BP_LUNGS]
			var/P = (user == target) ? "their" : (target.name + "\'s")
			var/SM = (user == target) ? "your" : (target.name + "\'s")
			if(!L)
				return
			if(isvaurca(target))
				to_chat(usr, SPAN_WARNING("\The [src] won't pierce through [P] carapace!"))
				return
			if(L.rescued == TRUE)
				to_chat(usr, SPAN_NOTICE("[H]'s ribs are already punctured!"))
				return
			last_jab = world.time
			user.visible_message("<b>[user]</b> aims \the [src] between [P] ribs!", SPAN_NOTICE("You aim \the [src] between [SM] ribs!"))
			if(!do_mob(user, target, 1.5 SECONDS))
				last_jab = 0 //Resets to try again immediately
				user.visible_message("<b>[user]</b> fumbles with \the [src]!", SPAN_NOTICE("You fumble with \the [src]!"))
				return
			var/blocked = H.get_blocked_ratio(BP_CHEST, DAMAGE_BRUTE, DAMAGE_FLAG_SHARP, damage = 5)
			if(blocked > 20)
				user.visible_message("<b>[user]</b> jabs \the [src] into [H], but their armor blocks it!", SPAN_WARNING("You jab \the [src] into [H], but their armor blocks it!"))
				return
			user.visible_message("<b>[user]</b> jabs \the [src] between [P] ribs!", SPAN_NOTICE("You jab \the [src] between [SM] ribs!"))
			H.apply_damage(3, DAMAGE_BRUTE, BP_CHEST)
			H.custom_pain("The pain in your chest is living hell!", 50, affecting = H.organs_by_name[BP_CHEST])
			L.oxygen_deprivation = 0
			L.rescued = TRUE
			return

	if(user.a_intent == I_HURT && ishuman(user))
		if((user.is_clumsy()) && prob(50))
			target = user
		syringestab(target, user)
		return


	switch(mode)
		if(SYRINGE_DRAW)

			if(!REAGENTS_FREE_SPACE(reagents))
				to_chat(user, SPAN_WARNING("The syringe is full."))
				mode = SYRINGE_INJECT
				return

			if(ismob(target))//Blood!
				if(reagents.has_reagent(/singleton/reagent/blood))
					to_chat(user, SPAN_NOTICE("There is already a blood sample in this syringe."))
					return
				if(istype(target, /mob/living/carbon))
					if(istype(target, /mob/living/carbon/slime))
						to_chat(user, SPAN_WARNING("You are unable to locate any blood."))
						return
					var/amount = REAGENTS_FREE_SPACE(reagents)
					var/mob/living/carbon/T = target
					if(!T.dna)
						to_chat(user, SPAN_WARNING("You are unable to locate any blood. (To be specific, your target seems to be missing their DNA datum)."))
						return
					if(HAS_FLAG(T.mutations, NOCLONE)) //target done been et, no more blood in him
						to_chat(user, SPAN_WARNING("You are unable to locate any blood."))
						return

					T.take_blood(src,amount)

					to_chat(user, SPAN_NOTICE("You take a blood sample from [target]."))
					for(var/mob/O in viewers(4, user))
						O.show_message(SPAN_NOTICE("[user] takes a blood sample from [target]."), 1)

			else //if not mob
				if(!target.reagents.total_volume)
					to_chat(user, SPAN_NOTICE("[target] is empty."))
					return

				if(!target.is_open_container() && !istype(target, /obj/structure/reagent_dispensers) && !istype(target, /obj/item/slime_extract))
					to_chat(user, SPAN_NOTICE("You cannot directly remove reagents from this object."))
					return

				var/trans = target.reagents.trans_to_obj(src, amount_per_transfer_from_this)
				to_chat(user, SPAN_NOTICE("You fill the syringe with [trans] units of the solution."))
				update_icon()

			if(!REAGENTS_FREE_SPACE(reagents))
				mode = SYRINGE_INJECT
				update_icon()

		if(SYRINGE_INJECT)
			if(!reagents.total_volume)
				to_chat(user, SPAN_NOTICE("The syringe is empty."))
				mode = SYRINGE_DRAW
				return
			if(istype(target, /obj/item/implantcase/chem))
				return

			if(!target.is_open_container() && !ismob(target) && !istype(target, /obj/item/reagent_containers/food) && !istype(target, /obj/item/slime_extract) && !istype(target, /obj/item/clothing/mask/smokable/cigarette) && !istype(target, /obj/item/storage/box/fancy/cigarettes))
				to_chat(user, SPAN_NOTICE("You cannot directly fill this object."))
				return
			if(!REAGENTS_FREE_SPACE(target.reagents))
				to_chat(user, SPAN_NOTICE("[target] is full."))
				return

			var/mob/living/carbon/human/H = target
			var/obj/item/organ/external/affected
			if(istype(H))
				affected = H.get_organ(user.zone_sel.selecting)
				if(!affected)
					to_chat(user, SPAN_DANGER("\The [H] is missing that limb!"))
					return
				else if(affected.status & ORGAN_ROBOT)
					to_chat(user, SPAN_DANGER("You cannot inject a robotic limb."))
					return

			if(ismob(target) && target != user)
				var/inject_time = time
				if(isliving(target))
					last_jab = world.time
					var/mob/living/L = target
					var/inject_mod = L.can_inject(user, TRUE, user.zone_sel.selecting)
					if(!inject_mod)
						return
					inject_time *= inject_mod

				user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
				user.do_attack_animation(target)

				if(!do_mob(user, target, inject_time))
					last_jab = 0
					user.visible_message("<b>[user]</b> fumbles with \the [src]!", SPAN_NOTICE("You fumble with \the [src]!"))
					return
				user.visible_message(SPAN_WARNING("[user] injects [target] with \the [src]!"))
			var/trans
			if(ismob(target))
				var/contained = reagentlist()
				trans = reagents.trans_to_mob(target, amount_per_transfer_from_this, CHEM_BLOOD)
				dirty(target, affected)
				admin_inject_log(user, target, src, contained, reagents.get_temperature(), trans)
			else
				trans = reagents.trans_to(target, amount_per_transfer_from_this)
			user.visible_message(SPAN_WARNING("[user] injects [target] with \the [src]!"),SPAN_NOTICE("You inject [trans] units of the solution. \The [src] now contains [src.reagents.total_volume] units."),2)
			if (reagents.total_volume <= 0 && mode == SYRINGE_INJECT)
				mode = SYRINGE_DRAW
				update_icon()

	return

/obj/item/reagent_containers/syringe/update_icon()
	cut_overlays()

	var/iconstring = initial(item_state)
	if(mode == SYRINGE_BROKEN)
		icon_state = "broken"
		worn_overlay = null
		return

	if(mode == SYRINGE_CAPPED)
		add_overlay("capped")

	if(reagents && reagents.total_volume)
		worn_overlay = Clamp(round((reagents.total_volume / volume * 15),5), 1, 15) //rounded_vol
		add_overlay(overlay_image('icons/obj/reagentfillings.dmi', "[iconstring][worn_overlay]", color = reagents.get_color()))
		worn_overlay_color = reagents.get_color() // handles inhands
		update_held_icon()
	else
		worn_overlay = 0
	icon_state = "[worn_overlay]"
	if(ismob(loc))
		var/injoverlay
		switch(mode)
			if (SYRINGE_DRAW)
				injoverlay = "draw"
			if (SYRINGE_INJECT)
				injoverlay = "inject"
		add_overlay(injoverlay)

/obj/item/reagent_containers/syringe/proc/syringestab(mob/living/carbon/target as mob, mob/living/carbon/user as mob)
	if(mode == SYRINGE_CAPPED)
		to_chat(user, SPAN_DANGER("You can't stab someone with a capped syringe!"))

	if(istype(target, /mob/living/carbon/human))

		var/mob/living/carbon/human/H = target

		var/target_zone = ran_zone(check_zone(user.zone_sel.selecting), 70)
		var/obj/item/organ/external/affecting = H.get_organ(target_zone)

		if (!affecting || affecting.is_stump())
			to_chat(user, SPAN_DANGER("They are missing that limb!"))
			return

		var/hit_area = affecting.name

		if((user != target) && H.check_shields(7, src, user, "\the [src]"))
			return

		var/armor = H.get_blocked_ratio(target_zone, DAMAGE_BRUTE, damage_flags = DAMAGE_FLAG_SHARP, damage = 5)*100
		if (target != user && armor > 50)
			user.visible_message(SPAN_DANGER("[user] tries to stab \the [target] in the [hit_area] with \the [src], but the attack is deflected by [target.get_pronoun("his")] armor!"), SPAN_WARNING("You try to stab \the [target] in the [hit_area] with \the [src], but the attack is deflected by [target.get_pronoun("his")] armor!"))
			user.remove_from_mob(src)
			qdel(src)

			user.attack_log += "\[[time_stamp()]\]<span class='warning'> Attacked [target.name] ([target.ckey]) with \the [src] (INTENT: HARM).</span>"
			target.attack_log += "\[[time_stamp()]\]<font color='orange'> Attacked by [user.name] ([user.ckey]) with [src.name] (INTENT: HARM).</font>"
			msg_admin_attack("[key_name_admin(user)] attacked [key_name_admin(target)] with [src.name] (INTENT: HARM) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)",ckey=key_name(user),ckey_target=key_name(src))

			return

		user.visible_message(SPAN_DANGER("[user] stabs [target] in \the [hit_area] with [src.name]!"))

		if(affecting.take_damage(3))
			H.UpdateDamageIcon()

	else
		user.visible_message(SPAN_DANGER("[user] stabs [target] with [src.name]!"))
		target.take_organ_damage(3)// 7 is the same as crowbar punch

	var/syringestab_amount_transferred = rand(0, (reagents.total_volume / 2)) //nerfed by popular demand
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
/obj/item/reagent_containers/syringe/large
	name = "large syringe"
	desc = "A large syringe - for those patients who need a little more."
	icon = 'icons/obj/large_syringe.dmi'
	icon_state = "0"
	possible_transfer_amounts = list(5, 15, 30)
	volume = 30

/obj/item/reagent_containers/syringe/large/ld50_syringe
	name = "Lethal Injection Syringe"
	desc = "A syringe used for lethal injections."
	amount_per_transfer_from_this = 60
	volume = 60
	time = 300

/obj/item/reagent_containers/syringe/large/ld50_syringe/afterattack(obj/target, mob/user, flag)
	if(mode == SYRINGE_DRAW && ismob(target)) // No drawing 50 units of blood at once
		to_chat(user, SPAN_NOTICE("This needle isn't designed for drawing blood."))
		return
	if(user.a_intent == "hurt" && ismob(target)) // No instant injecting
		to_chat(user, SPAN_NOTICE("This syringe is too big to stab someone with it."))
	..()


////////////////////////////////////////////////////////////////////////////////
/// Syringes. END
////////////////////////////////////////////////////////////////////////////////

/obj/item/reagent_containers/syringe/inaprovaline
	name = "Syringe (inaprovaline)"
	desc = "Contains inaprovaline - used to stabilize patients."
	reagents_to_add = list(/singleton/reagent/inaprovaline = 15)

/obj/item/reagent_containers/syringe/inaprovaline/Initialize()
	. = ..()
	mode = SYRINGE_INJECT
	update_icon()

/obj/item/reagent_containers/syringe/dylovene
	name = "Syringe (dylovene)"
	desc = "Contains anti-toxins."
	reagents_to_add = list(/singleton/reagent/dylovene = 15)

/obj/item/reagent_containers/syringe/dylovene/Initialize()
	. = ..()
	mode = SYRINGE_INJECT
	update_icon()

/obj/item/reagent_containers/syringe/antibiotic
	name = "Syringe (thetamycin)"
	desc = "Contains antibiotics."
	reagents_to_add = list(/singleton/reagent/thetamycin = 15)

/obj/item/reagent_containers/syringe/antibiotic/Initialize()
	. = ..()
	mode = SYRINGE_INJECT
	update_icon()

/obj/item/reagent_containers/syringe/drugs
	name = "Syringe (drugs)"
	desc = "Contains aggressive drugs meant for torture."
	reagents_to_add = list(/singleton/reagent/toxin/panotoxin = 5, /singleton/reagent/mindbreaker = 10)

/obj/item/reagent_containers/syringe/drugs/Initialize()
	. = ..()
	mode = SYRINGE_INJECT
	update_icon()

/obj/item/reagent_containers/syringe/fluvectionem
	name = "Syringe (fluvectionem)"
	desc = "Contains purging medicine."
	reagents_to_add = list(/singleton/reagent/fluvectionem = 15)

/obj/item/reagent_containers/syringe/fluvectionem/Initialize()
	. = ..()
	mode = SYRINGE_INJECT
	update_icon()

/obj/item/reagent_containers/syringe/large/ld50_syringe/chloral
	reagents_to_add = list(/singleton/reagent/polysomnine = 60)

/obj/item/reagent_containers/syringe/large/ld50_syringe/chloral/Initialize()
	. = ..()
	mode = SYRINGE_INJECT
	update_icon()

/obj/item/reagent_containers/syringe/antiparasitic
	name = "Syringe (helmizole)"
	desc = "Contains an antiparasitic medication."
	reagents_to_add = list(/singleton/reagent/antiparasitic = 10)

/obj/item/reagent_containers/syringe/antiparasitic/Initialize()
	. = ..()
	mode = SYRINGE_INJECT
	update_icon()
