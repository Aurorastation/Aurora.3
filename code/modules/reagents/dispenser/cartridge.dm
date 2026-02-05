/obj/item/reagent_containers/chem_disp_cartridge
	name = "chemical dispenser cartridge"
	desc = "This goes in a chemical dispenser."
	icon = 'icons/obj/item/reagent_containers/cartridge.dmi'
	icon_state = "cartridge"
	contained_sprite = TRUE
	filling_states = "20;40;60;80;100"
	w_class = WEIGHT_CLASS_NORMAL

	volume = CARTRIDGE_VOLUME_LARGE
	amount_per_transfer_from_this = 50
	// Large, but inaccurate. Use a chem dispenser or beaker for accuracy.
	possible_transfer_amounts = list(50, 100)
	unacidable = 1

	var/spawn_reagent = null
	var/label = ""

	var/temperature_override = 0 //A non-zero value with set the temperature of the reagents inside to this value, in kelvin.

/obj/item/reagent_containers/chem_disp_cartridge/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "It has a capacity of [volume] units."
	if(reagents.total_volume <= 0)
		. += "It is empty."
	else
		. += "It contains [reagents.total_volume] units of liquid."
	if(!is_open_container())
		. += "The cap is sealed."

/obj/item/reagent_containers/chem_disp_cartridge/Initialize(mapload,temperature_override)
	. = ..()
	if(temperature_override)
		src.temperature_override = temperature_override
	if(spawn_reagent)
		reagents.add_reagent(spawn_reagent, volume, temperature = src.temperature_override)
		var/singleton/reagent/R = GET_SINGLETON(spawn_reagent)
		if(label)
			setLabel(label)
		else
			setLabel(R.name)

/obj/item/reagent_containers/chem_disp_cartridge/update_icon()
	ClearOverlays()

	if(reagents?.total_volume)
		var/mutable_appearance/filling = mutable_appearance(icon, "[icon_state]-[get_filling_state()]")
		filling.color = reagents.get_color()
		AddOverlays(filling)

	if(!is_open_container())
		var/lid_icon = "lid_[icon_state]"
		var/mutable_appearance/lid = mutable_appearance(icon, lid_icon)
		AddOverlays(lid)

/obj/item/reagent_containers/chem_disp_cartridge/verb/verb_set_label(L as text)
	set name = "Set Cartridge Label"
	set category = "Object"
	set src in view(usr, 1)

	if (!ishuman(usr))
		return

	if (usr.stat)
		to_chat(usr, "You cannot do that in your current state.")
		return

	setLabel(L, usr)

/obj/item/reagent_containers/chem_disp_cartridge/proc/setLabel(L, mob/user = null)
	if(L)
		if(user)
			to_chat(user, SPAN_NOTICE("You set the label on \the [src] to '[L]'."))

		label = L
		name = "[initial(name)] - '[L]'"
	else
		if(user)
			to_chat(user, SPAN_NOTICE("You clear the label on \the [src]."))
		label = ""
		name = initial(name)
	update_icon()

/obj/item/reagent_containers/chem_disp_cartridge/attack_self()
	..()
	if (is_open_container())
		to_chat(usr, "<span class = 'notice'>You put the cap on \the [src].</span>")
		atom_flags ^= ATOM_FLAG_OPEN_CONTAINER
	else
		to_chat(usr, "<span class = 'notice'>You take the cap off \the [src].</span>")
		atom_flags |= ATOM_FLAG_OPEN_CONTAINER
	update_icon()

/obj/item/reagent_containers/chem_disp_cartridge/attackby(obj/item/attacking_item, mob/user)
	..()
	update_icon()

/obj/item/reagent_containers/chem_disp_cartridge/afterattack(obj/target, mob/user , flag)
	if (!is_open_container() || !flag)
		return

	else if(istype(target, /obj/structure/reagent_dispensers)) //A dispenser. Transfer FROM it TO us.
		var/obj/structure/reagent_dispensers/reagent_dispensers = target
		reagent_dispensers.add_fingerprint(user)

		if(!reagent_dispensers.reagents.total_volume && reagent_dispensers.reagents)
			to_chat(user, SPAN_WARNING("\The [target] is empty."))
			return

		if(reagents.total_volume >= reagents.maximum_volume)
			to_chat(user, SPAN_WARNING("\The [src] is full."))
			return

		var/trans = reagent_dispensers.reagents.trans_to(src, reagent_dispensers.amount_per_transfer_from_this)
		to_chat(user, SPAN_NOTICE("You fill \the [src] with [trans] units of the contents of \the [target]."))

	else if(target.is_open_container() && target.reagents) //Something like a glass. Player probably wants to transfer TO it.

		if(!reagents.total_volume)
			to_chat(user, SPAN_WARNING("\The [src] is empty."))
			return

		if(target.reagents.total_volume >= target.reagents.maximum_volume)
			to_chat(user, SPAN_WARNING("\The [target] is full."))
			return

		var/trans = src.reagents.trans_to(target, amount_per_transfer_from_this)
		to_chat(user, SPAN_NOTICE("You transfer [trans] units of the solution to \the [target]."))

	else
		return ..()
	update_icon()
