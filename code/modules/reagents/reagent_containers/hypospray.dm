////////////////////////////////////////////////////////////////////////////////
/// HYPOSPRAY
////////////////////////////////////////////////////////////////////////////////

/obj/item/reagent_containers/hypospray
	name = "hypospray"
	desc = "A sterile, air-needle autoinjector for administration of drugs to patients."
	desc_extended = "The Zeng-Hu Pharmaceuticals' Hypospray - 9 out of 10 doctors recommend it!"
	desc_info = "Unlike a syringe, reagents have to be poured into the hypospray before it can be used."
	icon = 'icons/obj/item/reagent_containers/syringe.dmi'
	contained_sprite = TRUE
	item_state = "hypo"
	icon_state = "hypo"
	amount_per_transfer_from_this = 5
	unacidable = 1
	volume = 15
	possible_transfer_amounts = list(5, 10, 15)
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	slot_flags = SLOT_BELT
	drop_sound = 'sound/items/drop/gun.ogg'
	pickup_sound = 'sound/items/pickup/gun.ogg'
	var/armorcheck = 1
	var/time = 3 SECONDS
	var/image/filling //holds a reference to the current filling overlay
	matter = list(MATERIAL_GLASS = 400, DEFAULT_WALL_MATERIAL = 200)

/obj/item/reagent_containers/hypospray/Initialize()
	. = ..()
	update_icon()

/obj/item/reagent_containers/hypospray/AltClick(var/mob/user)
	set_APTFT()

/obj/item/reagent_containers/hypospray/on_reagent_change()
	update_icon()
	return

/obj/item/reagent_containers/hypospray/cmo
	name = "premium hypospray"
	desc = "A high-end version of the regular hypospray, it allows for a substantially higher rate of drug administration to patients."
	desc_extended = "The Zeng-Hu Pharmaceuticals' Hypospray Mk-II is a cutting-edge version of the regular hypospray, with a much more expensive and streamlined injection process."
	desc_info = "This version of the hypospray has no delay before injecting a patient with reagent."
	icon_state = "cmo_hypo"
	item_state = "cmo_hypo"
	volume = 30
	possible_transfer_amounts = list(5, 10, 15, 30)
	time = 0

/obj/item/reagent_containers/hypospray/attack(var/mob/M, var/mob/user, target_zone)
	. = ..()
	if(isliving(M))
		var/mob/living/L = M
		var/inj_time = time
		var/mod_time = L.can_inject(user, TRUE, target_zone, armorcheck)
		if(!mod_time)
			return
		else if(inj_time <= 0 && mod_time > 1)
			inj_time = (1 SECOND) * mod_time
		else
			inj_time *= mod_time
		user.visible_message(SPAN_WARNING("\The [user] is trying to inject \the [L] with \the [src]!"), SPAN_NOTICE("You are trying to inject \the [L] with \the [src]."))
		if(do_mob(user, L, inj_time))
			inject(M, user, M.Adjacent(user))

/obj/item/reagent_containers/hypospray/update_icon()
	cut_overlays()

	var/rounded_vol = round(reagents.total_volume, round(reagents.maximum_volume / (volume / 5)))
	icon_state = "[initial(icon_state)]_[rounded_vol]"

	if(reagents.total_volume)
		filling = image(icon, src, "[initial(icon_state)][volume]")

		filling.icon_state = "[initial(icon_state)][rounded_vol]"

		filling.color = reagents.get_color()
		add_overlay(filling)

/obj/item/reagent_containers/hypospray/proc/inject(var/mob/M, var/mob/user, proximity)
	if(!proximity || !istype(M))
		return

	if(!reagents.total_volume)
		to_chat(user, SPAN_WARNING("\The [src] is empty."))
		return

	user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
	user.do_attack_animation(M)
	to_chat(user, SPAN_NOTICE("You inject \the [M] with \the [src]."))
	to_chat(M, SPAN_NOTICE("You feel a tiny prick!"))
	playsound(src, 'sound/items/hypospray.ogg',25)

	if(M.reagents)
		var/contained = reagentlist()
		var/temp = reagents.get_temperature()
		var/trans = reagents.trans_to_mob(M, amount_per_transfer_from_this, CHEM_BLOOD)
		admin_inject_log(user, M, src, contained, temp, trans)
		to_chat(user, SPAN_NOTICE("[trans] units injected. [reagents.total_volume] units remaining in \the [src]."))

	update_icon()
	return TRUE

/obj/item/reagent_containers/hypospray/afterattack(atom/target, mob/user, proximity)
	if (!proximity)
		return

	if (!isliving(target))
		return ..()

/obj/item/reagent_containers/hypospray/autoinjector
	name = "autoinjector"
	desc = "A rapid and safe way to administer small amounts of drugs by untrained or trained personnel."
	desc_extended = "Funded by the Stellar Corporate Conglomerate, produced by Zeng-Hu Pharmaceuticals, this autoinjector system was rebuilt from the ground up from the old variant to provide maximum user feedback."
	desc_info = "Autoinjectors are spent after using them. To re-use, use a screwdriver to open the back panel, then simply pour any desired reagent inside. Alt-click while it's on your person to prepare it for reuse."
	icon_state = "autoinjector"
	item_state = "autoinjector"
	slot_flags = SLOT_EARS
	var/name_label
	var/spent = TRUE
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = null
	volume = 5
	time = 0

/obj/item/reagent_containers/hypospray/autoinjector/Initialize()
	. = ..()
	if(name_label)
		name_unlabel = name
		name = "[name] ([name_label])"
		verbs += /atom/proc/remove_label
	if(reagents_to_add)
		atom_flags = 0
		spent = FALSE
	update_icon()

/obj/item/reagent_containers/hypospray/autoinjector/attack(var/mob/M, var/mob/user, target_zone)
	if(is_open_container())
		to_chat(user, SPAN_NOTICE("You must secure the reagents inside \the [src] before using it!"))
		return FALSE
	. = ..()

/obj/item/reagent_containers/hypospray/autoinjector/inject(mob/M, mob/user, proximity)
	. = ..()
	if(.)
		spent = TRUE
		update_icon()

/obj/item/reagent_containers/hypospray/autoinjector/attack_self(mob/user as mob)
	if(is_open_container())
		to_chat(user, SPAN_WARNING("\The [src] hasn't been secured yet!"))
		return
	if(do_after(user, 1 SECOND))
		inject(user, user, TRUE)

/obj/item/reagent_containers/hypospray/autoinjector/AltClick(mob/user)
	if(is_open_container() && user == loc)
		if(LAZYLEN(reagents.reagent_volumes))
			to_chat(user, SPAN_NOTICE("With a quick twist of \the [src]'s lid, you secure the reagents inside."))
			spent = FALSE
			atom_flags &= ~ATOM_FLAG_OPEN_CONTAINER
			update_icon()
		else
			to_chat(user, SPAN_NOTICE("You can't secure \the [src] without putting reagents in!"))
		return
	return ..()

/obj/item/reagent_containers/hypospray/autoinjector/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item.isscrewdriver() && !is_open_container())
		to_chat(user, SPAN_NOTICE("Using \the [attacking_item], you unsecure the autoinjector's lid.")) // it locks shut after being secured
		atom_flags |= ATOM_FLAG_OPEN_CONTAINER
		update_icon()
		return TRUE
	. = ..()

/obj/item/reagent_containers/hypospray/autoinjector/update_icon()
	cut_overlays()
	if(!is_open_container())
		var/mutable_appearance/backing_overlay = mutable_appearance(icon, "autoinjector_secured")
		add_overlay(backing_overlay)

	icon_state = "[initial(icon_state)][spent]"
	item_state = "[initial(item_state)][spent]"

	if(reagents.total_volume)
		var/mutable_appearance/reagent_overlay = mutable_appearance(icon, "autoinjector_reagents")
		reagent_overlay.color = reagents.get_color()
		add_overlay(reagent_overlay)
	update_held_icon()

/obj/item/reagent_containers/hypospray/autoinjector/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if(LAZYLEN(reagents.reagent_volumes))
		. += SPAN_NOTICE("It is currently loaded.")
	else
		. += SPAN_NOTICE("It is empty.")


/obj/item/reagent_containers/hypospray/autoinjector/inaprovaline
	name_label = "inaprovaline"
	reagents_to_add = list(/singleton/reagent/inaprovaline = 5)

/obj/item/reagent_containers/hypospray/autoinjector/dylovene
	name_label = "dylovene"
	reagents_to_add = list(/singleton/reagent/dylovene = 5)

/obj/item/reagent_containers/hypospray/autoinjector/emergency
	name_label = "emergency"
	reagents_to_add = list(/singleton/reagent/inaprovaline = 2.5, /singleton/reagent/dexalin = 2.5)

/obj/item/reagent_containers/hypospray/autoinjector/emergency/Initialize()
	. = ..()
	desc += " This auto-injector is to be used in emergencies. It contains a small amount of inaprovaline and dexalin."

/obj/item/reagent_containers/hypospray/autoinjector/coagzolug
	name_label = "coagzolug"
	desc = "A rapid and safe way to administer small amounts of drugs by untrained or trained personnel. This one contains coagzolug, a quick-acting blood coagulant that will slow bleeding for as long as it's within the bloodstream."
	volume = 5
	atom_flags = 0
	reagents_to_add = list(/singleton/reagent/coagzolug = 5)

/obj/item/reagent_containers/hypospray/autoinjector/hyronalin
	name_label = "hyronalin"
	atom_flags = 0
	reagents_to_add = list(/singleton/reagent/hyronalin = 5)

/obj/item/reagent_containers/hypospray/autoinjector/sideeffectbgone
	name_label = "sideeffects-be-gone!"
	desc = "A special cocktail designed to counter the side-effects of various drugs. Has 2 uses."
	volume = 30
	amount_per_transfer_from_this = 15

	reagents_to_add = list(/singleton/reagent/synaptizine = 5, /singleton/reagent/cetahydramine = 10, /singleton/reagent/oculine = 5, /singleton/reagent/ethylredoxrazine = 10)

/obj/item/reagent_containers/hypospray/autoinjector/stimpack
	name = "stimpack"
	desc = "A simple chemical cocktail of hyperzine and mortaphenyl designed to boost efficiency by 6,000% (estimated). Hoo-rah!"
	volume = 20
	amount_per_transfer_from_this = 20

	reagents_to_add = list(/singleton/reagent/hyperzine = 12, /singleton/reagent/mortaphenyl = 6, /singleton/reagent/synaptizine = 2)

/obj/item/reagent_containers/hypospray/autoinjector/survival
	name = "survival autoinjector"
	desc = "A special cocktail designed to keep you alive in the field should disaster seek to prevail."
	volume = 35
	amount_per_transfer_from_this = 35

	reagents_to_add = list(/singleton/reagent/tricordrazine = 15, /singleton/reagent/inaprovaline = 5, /singleton/reagent/dexalin/plus = 5, /singleton/reagent/oxycomorphine = 3, /singleton/reagent/synaptizine = 2, /singleton/reagent/mental/corophenidate = 5)

/obj/item/reagent_containers/hypospray/autoinjector/berserk
	name_label = "berserk injector"
	desc = "An injector containing Red Nightshade. Used before fights to induce a berserk state."
	volume = 5
	amount_per_transfer_from_this = 5

	reagents_to_add = list(/singleton/reagent/toxin/berserk = 5)

/obj/item/reagent_containers/hypospray/autoinjector/trauma
	name = "trauma hypo-injector"
	desc = "A special hypospray made to combat most forms of physical trauma."
	volume = 15
	amount_per_transfer_from_this = 15

	reagents_to_add = list(/singleton/reagent/butazoline = 15)

/obj/item/reagent_containers/hypospray/autoinjector/burn
	name = "burn hypo-injector"
	desc = "A special hypospray made to combat most types of superficial burns."
	volume = 15
	amount_per_transfer_from_this = 15

	reagents_to_add = list(/singleton/reagent/dermaline = 15)

/obj/item/reagent_containers/hypospray/autoinjector/oxygen
	name = "oxygenation hypo-injector"
	desc = "A special hypospray made to combat oxygen deprivation."
	volume = 15
	amount_per_transfer_from_this = 15

	reagents_to_add = list(/singleton/reagent/dexalin/plus = 15)

/obj/item/reagent_containers/hypospray/autoinjector/purity
	name = "purity hypo-injector"
	desc = "A special hypospray made to combat most forms of impurities such as genetic damage and infections."
	volume = 15
	amount_per_transfer_from_this = 15

	reagents_to_add = list(/singleton/reagent/thetamycin = 10, /singleton/reagent/ryetalyn = 5)

/obj/item/reagent_containers/hypospray/autoinjector/organ
	name = "organ hypo-injector"
	desc = "A special hypospray made to combat internal damage."
	volume = 15
	amount_per_transfer_from_this = 15

	reagents_to_add = list(/singleton/reagent/peridaxon = 10, /singleton/reagent/oculine = 5)

/obj/item/reagent_containers/hypospray/autoinjector/pain
	name = "numbing hypo-injector"
	desc = "A special hypospray made to combat pain. This one only injects <b>5 units</b> at a time."
	volume = 15
	amount_per_transfer_from_this = 5

	reagents_to_add = list(/singleton/reagent/oxycomorphine = 15)

/obj/item/reagent_containers/hypospray/combat
	name = "combat hypospray"
	desc = "A hypospray loaded with combat stimulants. Its needle has the ability to bypass armor."
	item_state = "combat_hypo"
	icon_state = "combat_hypo"
	volume = 20
	armorcheck = FALSE
	time = 0

	reagents_to_add = list(/singleton/reagent/kilosemine = 10)

/obj/item/reagent_containers/hypospray/combat/empty
	name = "combat hypospray"
	desc = "A sleek black hypospray. Its needle has the ability to bypass armor."
	reagents_to_add = FALSE

/obj/item/reagent_containers/hypospray/autoinjector/sanasomnum
	name = "sanasomnum autoinjector"
	desc = "A special autoinjector loaded with outlawed biomechanical stem cells, inducing a regenerative coma so intense it can heal almost any injury - even broken bones, organ and brain damage, severed tendons, and arterial damage. Upon use one will fall immediately into a state of unconsciousness lasting roughly three to five minutes, arising completely healed. The only thing it cannot fix are organs that have been destroyed outright, or so much cumulative damage that death is all but certain. The only downside is that Sanasomnum use guarantees extreme cancerous growth months or years down the line, which is invariably fatal in the long-term. However, in the short-term, it will save your life."
	volume = 20
	amount_per_transfer_from_this = 20

	reagents_to_add = list(/singleton/reagent/sanasomnum = 20)

/obj/item/reagent_containers/hypospray/autoinjector/bicaridine
	name = "bicaridine autoinjector"
	desc = "An autoinjector loaded with bicaridine, a chemical used to treat physical trauma."
	volume = 15
	amount_per_transfer_from_this = 15
	reagents_to_add = list(/singleton/reagent/bicaridine = 15)

/obj/item/reagent_containers/hypospray/autoinjector/kelotane
	name = "kelotane autoinjector"
	desc = "An autoinjector loaded with kelotane, a chemical used to treat burnt tissue."
	volume = 15
	amount_per_transfer_from_this = 15
	reagents_to_add = list(/singleton/reagent/kelotane = 15)

/obj/item/reagent_containers/hypospray/autoinjector/peridaxon
	name = "peridaxon autoinjector"
	desc = "An autoinjector loaded with peridaxon, a chemical used to treat minor organ damage."
	volume = 10
	amount_per_transfer_from_this = 10
	reagents_to_add = list(/singleton/reagent/peridaxon = 10)

/obj/item/reagent_containers/hypospray/autoinjector/impedrezene
	name = "impedrezene autoinjector"
	desc = "An autoinjector loaded with impedrezene, a narcotic that impairs one's ability to think by impeding the function of brain cells in the cerebral cortex."
	volume = 5
	amount_per_transfer_from_this = 5
	reagents_to_add = list(/singleton/reagent/drugs/impedrezene)

/obj/item/reagent_containers/hypospray/autoinjector/night_juice
	name = "night life autoinjector"
	desc = "An auto injector loaded with night life, a liquid narcotic commonly used by the more wealthy drug-abusing citizens of the Eridani Federation."
	volume = 10
	amount_per_transfer_from_this = 10
	reagents_to_add = list(/singleton/reagent/drugs/night_juice)
