//Inhalers
//Just like hypopsray code
/obj/item/reagent_containers/inhaler
	name = "autoinhaler"
	desc = "A rapid and safe way to administer small amounts of drugs into the lungs by untrained or trained personnel."
	icon = 'icons/obj/item/reagent_containers/syringe.dmi'
	contained_sprite = TRUE
	icon_state = "autoinhaler"
	item_state = "autoinhaler"
	center_of_mass = list("x" = 16,"y" = 11)
	unacidable = 1
	amount_per_transfer_from_this = 5
	volume = 5
	w_class = WEIGHT_CLASS_SMALL
	possible_transfer_amounts = null
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	slot_flags = SLOT_BELT
	var/name_label
	var/spent = FALSE
	/// Define to false if overlays aren't wanted, such as if the sprite isn't designed for them.
	var/has_overlays = TRUE
	matter = list(MATERIAL_GLASS = 400, DEFAULT_WALL_MATERIAL = 200)

/obj/item/reagent_containers/inhaler/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	if(LAZYLEN(reagents.reagent_volumes))
		. += SPAN_NOTICE("It is currently loaded.")
	else
		. += SPAN_NOTICE("It is spent.")

/obj/item/reagent_containers/inhaler/Initialize()
	. =..()
	if(name_label)
		name_unlabel = name
		name = "[name] ([name_label])"
		verbs += /atom/proc/remove_label
	if(reagents_to_add)
		atom_flags = 0
		spent = FALSE
	update_icon()

/obj/item/reagent_containers/inhaler/on_reagent_change()
	update_icon()
	return

/obj/item/reagent_containers/inhaler/proc/inject(var/mob/living/carbon/human/H, var/mob/user, var/proximity)
	if (!istype(H) || !proximity)
		return

	if(!reagents.total_volume)
		to_chat(user,SPAN_WARNING("\The [src] is empty."))
		return

	if ( ((user.is_clumsy()) || (user.mutations & DUMB)) && prob(10))
		to_chat(user,SPAN_DANGER("Your hand slips from clumsiness!"))
		if(!H.eyes_protected(src, FALSE))
			eyestab(H,user)
		if(H.reagents)
			var/contained = reagentlist()
			var/trans = reagents.trans_to_mob(H, amount_per_transfer_from_this, CHEM_TOUCH)
			admin_inject_log(user, H, src, contained, reagents.get_temperature(), trans)
			playsound(src.loc, 'sound/items/stimpack.ogg', 50, 1)
			user.visible_message(SPAN_NOTICE("[user] accidentally sticks the [src] in [H]'s eyes!"),
									SPAN_NOTICE("You accidentally stick the [src] in [H]'s eyes!"))

			to_chat(user,SPAN_NOTICE("[trans] units injected. [reagents.total_volume] units remaining in \the [src]."))
			spent = TRUE
			update_icon()
		return

	if (!user.IsAdvancedToolUser())
		to_chat(user,SPAN_WARNING("You don't have the dexterity to do this!"))
		return

	if(user == H)
		if(!H.can_eat(src))
			return
	else
		if(!H.can_force_feed(user, src))
			return

	user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
	user.do_attack_animation(H)

	if(user == H)
		user.visible_message(SPAN_NOTICE("\The [user] injects themselves with \the [src]"),
								SPAN_NOTICE("You stick the \the [src] in your mouth and press the injection button."))

	else
		user.visible_message(SPAN_WARNING("\The [user] attempts to administer \the [src] to \the [H]..."),
								SPAN_NOTICE("You attempt to administer \the [src] to \the [H]..."))

		if (!do_after(user, 1 SECONDS, H))
			to_chat(user,SPAN_NOTICE("You and the target need to be standing still in order to inject \the [src]."))
			return

		user.visible_message(SPAN_NOTICE("\The [user] injects \the [H] with \a [src]."),
								SPAN_NOTICE("You stick \the [src] in \the [H]'s mouth and press the injection button."))

	if(H.reagents)
		var/contained = reagentlist()
		var/temp = reagents.get_temperature()
		var/trans = reagents.trans_to_mob(H, amount_per_transfer_from_this, CHEM_BREATHE, bypass_checks = TRUE)
		admin_inject_log(user, H, src, contained, temp, trans)
		playsound(src.loc, 'sound/items/stimpack.ogg', 50, 1)
		to_chat(user,SPAN_NOTICE("[trans] units injected. [reagents.total_volume] units remaining in \the [src]."))
		spent = TRUE

	update_icon()
	return TRUE

/obj/item/reagent_containers/inhaler/afterattack(var/mob/living/carbon/human/H, var/mob/user, proximity)
	if (!istype(H))
		return ..()

	if(!proximity)
		return

/obj/item/reagent_containers/inhaler/attack(mob/living/target_mob, mob/living/user, target_zone)
	if(is_open_container())
		to_chat(user,SPAN_NOTICE("You must secure the reagents inside \the [src] before using it!"))
		return FALSE

	else
		inject(target_mob, user, target_mob.Adjacent(user))
	. = ..()

/obj/item/reagent_containers/inhaler/attack_self(mob/user as mob)
	if(is_open_container())
		if(LAZYLEN(reagents.reagent_volumes))
			to_chat(user,SPAN_NOTICE("With a quick twist of \the [src]'s lid, you secure the reagents inside."))
			atom_flags &= ~ATOM_FLAG_OPEN_CONTAINER
			spent = FALSE
			update_icon()
		else
			to_chat(user,SPAN_NOTICE("You can't secure \the [src] without putting reagents in!"))
	else
		to_chat(user,SPAN_NOTICE("The reagents inside \the [src] are already secured."))
	return

/obj/item/reagent_containers/inhaler/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item.isscrewdriver() && !is_open_container())
		to_chat(user,SPAN_NOTICE("Using \the [attacking_item], you unsecure the inhaler's lid.")) // it locks shut after being secured
		atom_flags |= ATOM_FLAG_OPEN_CONTAINER
		update_icon()
		return TRUE
	. = ..()

/obj/item/reagent_containers/inhaler/update_icon()
	icon_state = "[initial(icon_state)][spent]"
	item_state = "[initial(item_state)][spent]"

	if(has_overlays)
		ClearOverlays()
		if(!is_open_container())
			var/mutable_appearance/backing_overlay = mutable_appearance(icon, "autoinhaler_secured")
			AddOverlays(backing_overlay)
		if(reagents.total_volume)
			var/mutable_appearance/reagent_overlay = mutable_appearance(icon, "autoinhaler_reagents")
			reagent_overlay.color = reagents.get_color()
			AddOverlays(reagent_overlay)

	update_held_icon()

/obj/item/reagent_containers/inhaler/dexalin
	name_label = "dexalin"
	desc = "A rapid and safe way to administer small amounts of drugs into the lungs by untrained or trained personnel. This one contains dexalin."
	atom_flags = 0

/obj/item/reagent_containers/inhaler/dexalin/Initialize()
	. =..()
	reagents.add_reagent(/singleton/reagent/dexalin, volume)
	update_icon()
	return

/obj/item/reagent_containers/inhaler/peridaxon
	name_label = "peridaxon"
	desc = "A rapid and safe way to administer small amounts of drugs into the lungs by untrained or trained personnel. This one contains peridaxon."
	atom_flags = 0

/obj/item/reagent_containers/inhaler/peridaxon/Initialize()
	. =..()
	reagents.add_reagent(/singleton/reagent/peridaxon, volume)
	update_icon()
	return

/obj/item/reagent_containers/inhaler/hyperzine
	name_label = "hyperzine"
	desc = "A rapid and safe way to administer small amounts of drugs into the lungs by untrained or trained personnel. This one contains hyperzine."
	atom_flags = 0

/obj/item/reagent_containers/inhaler/hyperzine/Initialize()
	. =..()
	reagents.add_reagent(/singleton/reagent/hyperzine, volume)
	update_icon()
	return

/obj/item/reagent_containers/inhaler/xuxigas
	name_label = "xu'xi gas"
	desc = "A rapid and safe way to administer small amounts of drugs into the lungs by untrained or trained personnel. This one contains xu'xi gas."
	atom_flags = 0

/obj/item/reagent_containers/inhaler/xuxigas/Initialize()
	. =..()
	reagents.add_reagent(/singleton/reagent/drugs/xuxigas, volume)
	update_icon()
	return

/obj/item/reagent_containers/inhaler/phoron
	name_label = "phoron"
	desc = "A rapid and safe way to administer small amounts of drugs into the lungs by untrained or trained personnel. This one contains phoron."
	atom_flags = 0

/obj/item/reagent_containers/inhaler/phoron/Initialize()
	. =..()
	reagents.add_reagent(/singleton/reagent/toxin/phoron, volume)
	update_icon()
	return

/obj/item/reagent_containers/inhaler/phoron_special
	name = "vaurca autoinhaler (phoron)"
	desc = "A strange device that contains some sort of heavy-duty bag and mouthpiece combo."
	icon_state = "anthaler"
	atom_flags = 0
	volume = 10
	has_overlays = FALSE

/obj/item/reagent_containers/inhaler/phoron_special/Initialize()
	. =..()
	reagents.add_reagent(/singleton/reagent/toxin/phoron, volume)
	update_icon()
	return

/obj/item/reagent_containers/inhaler/soporific
	name_label = "soporific"
	desc = "A rapid and safe way to administer small amounts of drugs into the lungs by untrained or trained personnel. This one contains soporific."
	volume = 10
	atom_flags = 0

/obj/item/reagent_containers/inhaler/soporific/Initialize()
	. =..()
	reagents.add_reagent(/singleton/reagent/soporific, volume)
	update_icon()
	return

/obj/item/reagent_containers/inhaler/space_drugs
	name_label = "space drugs"
	desc = "A rapid and safe way to administer small amounts of drugs into the lungs by untrained or trained personnel. This one contains space drugs."
	atom_flags = 0

/obj/item/reagent_containers/inhaler/space_drugs/Initialize()
	. =..()
	reagents.add_reagent(/singleton/reagent/drugs/mms, volume)
	update_icon()
	return

/obj/item/reagent_containers/inhaler/ammonia
	name_label = "ammonia"
	desc = "A rapid and safe way to administer small amounts of drugs into the lungs by untrained or trained personnel. This one contains ammonia."
	atom_flags = 0

/obj/item/reagent_containers/inhaler/ammonia/Initialize()
	. =..()
	reagents.add_reagent(/singleton/reagent/ammonia, volume)
	update_icon()
	return

/obj/item/reagent_containers/inhaler/pulmodeiectionem
	name_label = "pulmodeiectionem"
	desc = "A rapid and safe way to administer small amounts of drugs into the lungs by untrained or trained personnel. This one contains pulmodeiectionem."
	atom_flags = 0

/obj/item/reagent_containers/inhaler/pulmodeiectionem/Initialize()
	. =..()
	reagents.add_reagent(/singleton/reagent/pulmodeiectionem, volume)
	update_icon()
	return

/obj/item/reagent_containers/inhaler/pneumalin
	name_label = "pneumalin"
	desc = "A rapid and safe way to administer small amounts of drugs into the lungs by untrained or trained personnel. This one contains pneumalin."
	volume = 10
	atom_flags = 0

/obj/item/reagent_containers/inhaler/pneumalin/Initialize()
	. =..()
	reagents.add_reagent(/singleton/reagent/pneumalin, volume)
	update_icon()
	return

/obj/item/reagent_containers/inhaler/raskara_dust
	name_label = "unmarked autoinhaler"
	desc = "A rapid and safe way to administer small amounts of drugs into the lungs by untrained or trained personnel. This one is unmarked."
	atom_flags = 0

/obj/item/reagent_containers/inhaler/raskara_dust/Initialize()
	. =..()
	reagents.add_reagent(/singleton/reagent/drugs/raskara_dust, volume)
	update_icon()
	return
