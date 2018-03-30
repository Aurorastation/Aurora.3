/obj/item/weapon/chewing_gum
	name = "chewing gum"
	desc = "Chew obnoxiously into other people's ears."
	icon = 'icons/obj/chewing_gum.dmi'
	icon_state = "wrapper"
	var/is_unwrapped = 0
	var/is_chewed = 0
	var/is_chewing = 0
	var/chem_volume = 15
	var/metabolism = 0.1
	var/flavor = "none"
	w_class = ITEMSIZE_TINY

/obj/item/weapon/chewing_gum/Initialize()
	. = ..()
	flags |= NOREACT
	create_reagents(chem_volume)

/obj/item/weapon/chewing_gum/process()
	if(reagents.total_volume <= 0)
		return
	if(reagents && reagents.total_volume)
		var/mob/living/carbon/human/H = loc
		if(istype(H))
			reagents.trans_to_mob(H, metabolism, CHEM_INGEST, 1)
		else
			STOP_PROCESSING(SSprocessing, src)
			user << "<span class='notice'>Your [name] is now devoid of any flavor.</span>"

/obj/item/weapon/chewing_gum/update_icon()
	if(is_chewed)
		icon_state = "gum_chewed"
		desc = "A piece of chewed chewing gum. Gross!"
	else if(is_unwrapped)
		icon_state = "gum"
		desc = "A piece of chewing gum."
	else
		color = reagents.get_color() // ONLY CHANGE ONCE
		icon_state = "wrapper"
		desc = "A piece of chewing gum, wrapped up in paper. This one is [flavor] flavored."

/obj/item/weapon/chewing_gum/proc/unwrap(mob/living/carbon/user as mob)
	if(!is_unwrapped)
		user << "<span class='notice'>You unwrap \the [name].</span>"
		is_unwrapped = 1
		update_icon()

/obj/item/weapon/chewing_gum/proc/eat_gum(mob/living/carbon/user as mob)
	if(!is_unwrapped)
		user << "<span class='notice'>You need to unwrap \the [name] before you eat it!</span>"
		return

	user << "<span class='notice'>You put the [name] in your mouth and start chewing.</span>"

	flags &= ~NOREACT
	reagents.handle_reactions()

	var/foundgum = 0
	for(var/obj/item/weapon/chewing_gum/gum in user.contents)
		if(istype(gum) && gum.is_chewing && gum != src)
			reagents.trans_to_obj(gum,reagents.total_volume)
			foundgum = 1
			START_PROCESSING(SSprocessing, gum)
			qdel(src)
			break

	if(!foundgum)
		user.drop_item()
		src.forceMove(user)
		user.contents += src
		START_PROCESSING(SSprocessing, src)

	is_chewed = 1
	is_chewing = 1
	update_icon()

/obj/item/weapon/chewing_gum/attack_self(mob/living/carbon/user as mob)
	unwrap(user)

/obj/item/weapon/chewing_gum/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(istype(user) && user == M)
		eat_gum(user)
	else
		return

/obj/item/weapon/chewing_gum/banana/Initialize()
	. = ..()
	flavor = "banana"
	reagents.add_reagent("banana",4)
	reagents.add_reagent("sugar",2)
	update_icon()

/obj/item/weapon/chewing_gum/berryjuice/Initialize()
	. = ..()
	flavor = "berry"
	reagents.add_reagent("berryjuice",4)
	reagents.add_reagent("sugar",2)
	update_icon()

/obj/item/weapon/chewing_gum/grapejuice/Initialize()
	. = ..()
	flavor = "grape"
	reagents.add_reagent("grapejuice",4)
	reagents.add_reagent("sugar",2)
	update_icon()

/obj/item/weapon/chewing_gum/lemonjuice/Initialize()
	. = ..()
	flavor = "lemon"
	reagents.add_reagent("lemonjuice",4)
	reagents.add_reagent("sugar",2)
	update_icon()

/obj/item/weapon/chewing_gum/limejuice/Initialize()
	. = ..()
	flavor = "lime"
	reagents.add_reagent("limejuice",4)
	reagents.add_reagent("sugar",2)
	update_icon()

/obj/item/weapon/chewing_gum/orangejuice/Initialize()
	. = ..()
	flavor = "orange"
	reagents.add_reagent("orangejuice",4)
	reagents.add_reagent("sugar",2)
	update_icon()

/obj/item/weapon/chewing_gum/watermelonjuice/Initialize()
	. = ..()
	flavor = "watermelon"
	reagents.add_reagent("watermelonjuice",4)
	reagents.add_reagent("sugar",2)
	update_icon()

/obj/item/weapon/chewing_gum/mint/Initialize()
	. = ..()
	flavor = "mint"
	reagents.add_reagent("mint",4)
	reagents.add_reagent("sugar",2)
	update_icon()

/obj/item/weapon/chewing_gum/bubblegum/Initialize()
	. = ..()
	flavor = "bubblegum"
	reagents.add_reagent("bubblegum",4)
	reagents.add_reagent("sugar",2)
	update_icon()
	color = "#FFC0CB"

/obj/item/weapon/chewing_gum/phoron/Initialize()
	. = ..()
	flavor = "phoron"
	reagents.add_reagent("phoron",5)
	update_icon()

/obj/item/weapon/chewing_gum/tricordrazine/Initialize()
	. = ..()
	flavor = "tricordrazine"
	reagents.add_reagent("tricordrazine",15)
	update_icon()

/obj/item/weapon/chewing_gum/nicotine/Initialize()
	. = ..()
	flavor = "nicotine"
	reagents.add_reagent("nicotine",4)
	reagents.add_reagent("mint",3)
	reagents.add_reagent("sugar",2)
	update_icon()
	color = "#99FF99"

/obj/item/weapon/chewing_gum/death/Initialize()
	. = ..()
	flavor = "licorice"
	reagents.add_reagent("zombiepowder",6)
	reagents.add_reagent("tricordrazine",6)
	color = "#FF7F50"

//-----------------------------------------
//------------------Boxes------------------
//-----------------------------------------

/obj/item/weapon/storage/gum_box
	name = "gum box"
	desc = "Contains gum."
	icon = 'icons/obj/chewing_gum.dmi'
	icon_state = "package"
	can_hold = list(
		/obj/item/weapon/chewing_gum/
	)
	storage_slots = ITEMSIZE_TINY * 6
	max_w_class = ITEMSIZE_TINY
	max_storage_space = ITEMSIZE_TINY * 6
	w_class = ITEMSIZE_SMALL

/obj/item/weapon/storage/gum_box/mint
	name = "package of mint gum"
	desc = "Contains six pieces of mint flavored gum."

/obj/item/weapon/storage/gum_box/mint/fill()
	new /obj/item/weapon/chewing_gum/mint(src)
	new /obj/item/weapon/chewing_gum/mint(src)
	new /obj/item/weapon/chewing_gum/mint(src)
	new /obj/item/weapon/chewing_gum/mint(src)
	new /obj/item/weapon/chewing_gum/mint(src)
	new /obj/item/weapon/chewing_gum/mint(src)
	color = "#FFFFFF"

/obj/item/weapon/storage/gum_box/tropical
	name = "package of tropical gum"
	desc = "Contains six pieces of tropical flavored gum."

/obj/item/weapon/storage/gum_box/tropical/fill()
	new /obj/item/weapon/chewing_gum/banana(src)
	new /obj/item/weapon/chewing_gum/berryjuice(src)
	new /obj/item/weapon/chewing_gum/watermelonjuice(src)
	new /obj/item/weapon/chewing_gum/lemonjuice(src)
	new /obj/item/weapon/chewing_gum/limejuice(src)
	new /obj/item/weapon/chewing_gum/orangejuice(src)
	color = "#FFFF88"

/obj/item/weapon/storage/gum_box/bubblegum
	name = "package of bubblegum"
	desc = "Contains six pieces of bubblegum."

/obj/item/weapon/storage/gum_box/bubblegum/fill()
	new /obj/item/weapon/chewing_gum/bubblegum(src)
	new /obj/item/weapon/chewing_gum/bubblegum(src)
	new /obj/item/weapon/chewing_gum/bubblegum(src)
	new /obj/item/weapon/chewing_gum/bubblegum(src)
	new /obj/item/weapon/chewing_gum/bubblegum(src)
	new /obj/item/weapon/chewing_gum/bubblegum(src)
	color = "#FFC1CC"

/obj/item/weapon/storage/gum_box/phoron
	name = "package of phoron gum"
	desc = "Contains six pieces of phoron gum."

/obj/item/weapon/storage/gum_box/phoron/fill()
	new /obj/item/weapon/chewing_gum/phoron(src)
	new /obj/item/weapon/chewing_gum/phoron(src)
	new /obj/item/weapon/chewing_gum/phoron(src)
	new /obj/item/weapon/chewing_gum/phoron(src)
	new /obj/item/weapon/chewing_gum/phoron(src)
	new /obj/item/weapon/chewing_gum/phoron(src)
	color = "#A275FF"

/obj/item/weapon/storage/gum_box/tricordrazine
	name = "package of tricordrazine gum"
	desc = "Contains six pieces of tricordrazine gum."

/obj/item/weapon/storage/gum_box/tricordrazine/fill()
	new /obj/item/weapon/chewing_gum/tricordrazine(src)
	new /obj/item/weapon/chewing_gum/tricordrazine(src)
	new /obj/item/weapon/chewing_gum/tricordrazine(src)
	new /obj/item/weapon/chewing_gum/tricordrazine(src)
	new /obj/item/weapon/chewing_gum/tricordrazine(src)
	new /obj/item/weapon/chewing_gum/tricordrazine(src)
	color = "#AA5555"

/obj/item/weapon/storage/gum_box/nicotine
	name = "package of nicotine gum"
	desc = "Contains six pieces of nicotine gum."

/obj/item/weapon/storage/gum_box/nicotine/fill()
	new /obj/item/weapon/chewing_gum/nicotine(src)
	new /obj/item/weapon/chewing_gum/nicotine(src)
	new /obj/item/weapon/chewing_gum/nicotine(src)
	new /obj/item/weapon/chewing_gum/nicotine(src)
	new /obj/item/weapon/chewing_gum/nicotine(src)
	new /obj/item/weapon/chewing_gum/nicotine(src)
	color = "#99FF99"

/obj/item/weapon/storage/gum_box/death
	name = "package of licorice gum"
	desc = "Contains six pieces of licorice gum. It has some fine print under the bottom of the box, but it's too small to see."

/obj/item/weapon/storage/gum_box/death/fill()
	new /obj/item/weapon/chewing_gum/death(src)
	new /obj/item/weapon/chewing_gum/death(src)
	new /obj/item/weapon/chewing_gum/death(src)
	new /obj/item/weapon/chewing_gum/death(src)
	new /obj/item/weapon/chewing_gum/death(src)
	new /obj/item/weapon/chewing_gum/death(src)
	color = "#222222"