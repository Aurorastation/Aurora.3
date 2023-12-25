/obj/item/reagent_containers/chem_disp_cartridge
	name = "chemical dispenser cartridge"
	desc = "This goes in a chemical dispenser."
	icon = 'icons/obj/item/reagent_containers/cartridge.dmi'
	icon_state = "cartridge"
	contained_sprite = TRUE
	filling_states = "20;40;60;80;100"
	w_class = ITEMSIZE_NORMAL

	volume = CARTRIDGE_VOLUME_LARGE
	amount_per_transfer_from_this = 50
	// Large, but inaccurate. Use a chem dispenser or beaker for accuracy.
	possible_transfer_amounts = list(50, 100)
	unacidable = 1

	var/spawn_reagent = null
	var/label = ""

	var/temperature_override = 0 //A non-zero value with set the temperature of the reagents inside to this value, in kelvin.


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
	cut_overlays()

	if(reagents?.total_volume)
		var/mutable_appearance/filling = mutable_appearance(icon, "[icon_state]-[get_filling_state()]")
		filling.color = reagents.get_color()
		add_overlay(filling)

	if(!is_open_container())
		var/lid_icon = "lid_[icon_state]"
		var/mutable_appearance/lid = mutable_appearance(icon, lid_icon)
		add_overlay(lid)

/obj/item/reagent_containers/chem_disp_cartridge/examine(mob/user)
	. = ..()
	to_chat(user, "It has a capacity of [volume] units.")
	if(reagents.total_volume <= 0)
		to_chat(user, "It is empty.")
	else
		to_chat(user, "It contains [reagents.total_volume] units of liquid.")
	if(!is_open_container())
		to_chat(user, "The cap is sealed.")

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
			to_chat(user, "<span class='notice'>You set the label on \the [src] to '[L]'.</span>")

		label = L
		name = "[initial(name)] - '[L]'"
	else
		if(user)
			to_chat(user, "<span class='notice'>You clear the label on \the [src].</span>")
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

/obj/item/reagent_containers/chem_disp_cartridge/attackby(obj/item/W as obj, mob/user as mob)
	..()
	update_icon()

/obj/item/reagent_containers/chem_disp_cartridge/afterattack(obj/target, mob/user , flag)
	if (!is_open_container() || !flag)
		return

	else if(istype(target, /obj/structure/reagent_dispensers)) //A dispenser. Transfer FROM it TO us.
		target.add_fingerprint(user)

		if(!target.reagents.total_volume && target.reagents)
			to_chat(user, "<span class='warning'>\The [target] is empty.</span>")
			return

		if(reagents.total_volume >= reagents.maximum_volume)
			to_chat(user, "<span class='warning'>\The [src] is full.</span>")
			return

		var/trans = target.reagents.trans_to(src, target:amount_per_transfer_from_this)
		to_chat(user, "<span class='notice'>You fill \the [src] with [trans] units of the contents of \the [target].</span>")

	else if(target.is_open_container() && target.reagents) //Something like a glass. Player probably wants to transfer TO it.

		if(!reagents.total_volume)
			to_chat(user, "<span class='warning'>\The [src] is empty.</span>")
			return

		if(target.reagents.total_volume >= target.reagents.maximum_volume)
			to_chat(user, "<span class='warning'>\The [target] is full.</span>")
			return

		var/trans = src.reagents.trans_to(target, amount_per_transfer_from_this)
		to_chat(user, "<span class='notice'>You transfer [trans] units of the solution to \the [target].</span>")

	else
		return ..()
	update_icon()
