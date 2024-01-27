
////////////////////////////////////////////////////////////////////////////////
/// (Mixing)Glass.
////////////////////////////////////////////////////////////////////////////////
/obj/item/reagent_containers/glass
	name = " "
	desc = " "
	icon = 'icons/obj/item/reagent_containers/glass.dmi'
	icon_state = null
	item_state = null
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,25,30,60)
	volume = 60
	accuracy = 0.1
	w_class = ITEMSIZE_SMALL
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	fragile = 2
	unacidable = 1 //glass doesn't dissolve in acid
	drop_sound = 'sound/items/drop/bottle.ogg'
	pickup_sound = 'sound/items/pickup/bottle.ogg'
	var/label_text = ""

/obj/item/reagent_containers/glass/Initialize()
	. = ..()
	AddComponent(/datum/component/base_name, name)

/obj/item/reagent_containers/glass/examine(mob/user, distance, is_adjacent)
	. = ..()
	if(distance > 2)
		return
	if(LAZYLEN(reagents.reagent_volumes))
		to_chat(user, SPAN_NOTICE("It contains [round(reagents.total_volume, accuracy)] units of a reagent."))
		for(var/_T in reagents.reagent_volumes)
			var/singleton/reagent/T = GET_SINGLETON(_T)
			if(T.reagent_state == LIQUID)
				to_chat(user, SPAN_NOTICE("You see something liquid in the beaker."))
				break // to stop multiple messages of this
			if(T.reagent_state == GAS)
				to_chat(user, SPAN_NOTICE("You see something gaseous in the beaker."))
				break
			if(T.reagent_state == SOLID)
				to_chat(user, SPAN_NOTICE("You see something solid in the beaker."))
				break
	else
		to_chat(user, SPAN_NOTICE("It is empty."))
	if(!is_open_container())
		to_chat(user, SPAN_NOTICE("An airtight lid seals it completely."))

/obj/item/reagent_containers/glass/get_additional_forensics_swab_info()
	var/list/additional_evidence = ..()
	var/list/Bdata = REAGENT_DATA(reagents, /singleton/reagent/blood/)
	var/list/blood_Data = list(
		Bdata["blood_DNA"] = Bdata["blood_type"]
	)
	if(Bdata)
		additional_evidence["type"] = EVIDENCE_TYPE_BLOOD
		additional_evidence["sample_type"] = "blood"
		additional_evidence["dna"] += blood_Data
		additional_evidence["sample_message"] = "You dip the swab inside [src] to sample its contents."

	return additional_evidence

/obj/item/reagent_containers/glass/attack_self(mob/user)
	..()
	if(is_open_container())
		to_chat(user, "<span class = 'notice'>You put the lid on \the [src].</span>")
		atom_flags ^= ATOM_FLAG_OPEN_CONTAINER
	else
		to_chat(user, "<span class = 'notice'>You take the lid off \the [src].</span>")
		atom_flags |= ATOM_FLAG_OPEN_CONTAINER
	update_icon()

/obj/item/reagent_containers/glass/AltClick(var/mob/user)
	set_APTFT()

/obj/item/reagent_containers/glass/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/storage/part_replacer))
		if(!reagents || !reagents.total_volume)
			return ..()
	if(W.ispen() || istype(W, /obj/item/device/flashlight/pen))
		var/tmp_label = sanitizeSafe(input(user, "Enter a label for [name]", "Label", label_text), MAX_NAME_LEN)
		if(length(tmp_label) > 15)
			to_chat(user, "<span class='notice'>The label can be at most 15 characters long.</span>")
		else
			to_chat(user, "<span class='notice'>You set the label to \"[tmp_label]\".</span>")
			label_text = tmp_label
			update_name_label()
			update_icon()
		return
	. = ..() // in the case of nitroglycerin, explode BEFORE it shatters

/obj/item/reagent_containers/glass/proc/update_name_label(var/base_name = initial(name))
	SEND_SIGNAL(src, COMSIG_BASENAME_SETNAME, args)
	if(label_text == "")
		name = base_name
	else
		name = "[base_name] ([label_text])"

/obj/item/reagent_containers/glass/beaker
	name = "beaker"
	desc = "A beaker."
	contained_sprite = TRUE
	icon_state = "beaker"
	item_state = "beaker"
	filling_states = "20;40;60;80;100"
	center_of_mass = list("x" = 16,"y" = 13)
	matter = list(MATERIAL_GLASS = 500)
	drop_sound = 'sound/items/drop/drinkglass.ogg'
	pickup_sound = 'sound/items/pickup/drinkglass.ogg'
	fragile = 1

/obj/item/reagent_containers/glass/beaker/Initialize()
	. = ..()
	desc += " Can hold up to [volume] units."

/obj/item/reagent_containers/glass/beaker/self_feed_message(var/mob/user)
	to_chat(user, SPAN_NOTICE("You drink from \the [src]."))

/obj/item/reagent_containers/glass/beaker/on_reagent_change()
	update_icon()

/obj/item/reagent_containers/glass/beaker/pickup(mob/user)
	..()
	update_icon()

/obj/item/reagent_containers/glass/beaker/dropped(mob/user)
	..()
	update_icon()

/obj/item/reagent_containers/glass/beaker/attack_hand()
	..()
	update_icon()

/obj/item/reagent_containers/glass/beaker/update_icon()
	cut_overlays()

	if(reagents?.total_volume)
		var/mutable_appearance/filling = mutable_appearance(icon, "[icon_state]-[get_filling_state()]")
		filling.color = reagents.get_color()
		add_overlay(filling)

	if(!is_open_container())
		var/lid_icon = "lid_[icon_state]"
		var/mutable_appearance/lid = mutable_appearance(icon, lid_icon)
		add_overlay(lid)

	if(label_text)
		var/label_icon = "label_[icon_state]"
		var/mutable_appearance/label = mutable_appearance(icon, label_icon)
		add_overlay(label)

/obj/item/reagent_containers/glass/beaker/large
	name = "large beaker"
	desc = "A large beaker."
	icon_state = "beakerlarge"
	center_of_mass = list("x" = 17,"y" = 14)
	matter = list(MATERIAL_GLASS = 5000)
	volume = 120
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,25,30,60,120)
	fragile = 6 // a bit sturdier

/obj/item/reagent_containers/glass/beaker/noreact
	name = "cryostasis beaker"
	desc = "A cryostasis beaker that allows for chemical storage without reactions."
	icon_state = "beakernoreact"
	center_of_mass = list("x" = 16,"y" = 13)
	matter = list(MATERIAL_GLASS = 500)
	volume = 60
	amount_per_transfer_from_this = 10
	atom_flags = ATOM_FLAG_OPEN_CONTAINER | ATOM_FLAG_NO_REACT
	fragile = 0

/obj/item/reagent_containers/glass/beaker/bluespace
	name = "bluespace beaker"
	desc = "A bluespace beaker, powered by experimental bluespace technology."
	icon_state = "beakerbluespace"
	center_of_mass = list("x" = 16,"y" = 15)
	matter = list(MATERIAL_PHORON = 1000, MATERIAL_DIAMOND = 100)
	volume = 300
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,25,30,60,120,300)
	fragile = 0

/obj/item/reagent_containers/glass/beaker/vial
	name = "vial"
	desc = "A small glass vial."
	icon_state = "vial"
	item_state = "dropper"
	center_of_mass = list("x" = 16,"y" = 16)
	matter = list(MATERIAL_GLASS = 250)
	volume = 30
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,25)
	fragile = 1 // very fragile

/obj/item/reagent_containers/glass/beaker/medcup
	name = "medicine cup"
	desc = "A glass medicine cup. Like a shot glass for medicine."
	icon_state = "medcup"
	filling_states = "25;50;75;100"
	center_of_mass = list("x" = 16,"y" = 13)
	matter = list(MATERIAL_GLASS = 250)
	volume = 15
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = null
	fragile = 1

/obj/item/reagent_containers/glass/beaker/medcup/attack_self() // No lid for the medcup
	return

/obj/item/reagent_containers/glass/beaker/cryoxadone/reagents_to_add = list(/singleton/reagent/cryoxadone = 30)

/obj/item/reagent_containers/glass/beaker/sulphuric/reagents_to_add = list(/singleton/reagent/acid = 60)

/obj/item/reagent_containers/glass/beaker/pitcher
	name = "pitcher"
	desc = "Everyone's best friend in the morning."
	icon_state = "coffeepot"
	unacidable = TRUE
	amount_per_transfer_from_this = 10
	volume = 120
	possible_transfer_amounts = list(5,10,15,30,60,120)

// buckets

/obj/item/reagent_containers/glass/bucket
	desc = "A blue plastic bucket."
	name = "bucket"
	icon = 'icons/obj/janitor.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_janitor.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_janitor.dmi',
		)
	icon_state = "bucket"
	item_state = "bucket"
	center_of_mass = list("x" = 16,"y" = 10)
	accuracy = 1
	matter = list(DEFAULT_WALL_MATERIAL = 200)
	w_class = ITEMSIZE_NORMAL
	amount_per_transfer_from_this = 120
	possible_transfer_amounts = list(5,10,15,25,30,50,60,100,120,250,300)
	volume = 300
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	unacidable = 0
	drop_sound = 'sound/items/drop/helm.ogg'
	pickup_sound = 'sound/items/pickup/helm.ogg'
	var/helmet_type = /obj/item/clothing/head/helmet/bucket
	fragile = 0

/obj/item/reagent_containers/glass/bucket/attackby(var/obj/D, mob/user as mob)
	if(isprox(D))
		to_chat(user, "You add [D] to [src].")
		qdel(D)
		user.put_in_hands(new /obj/item/bucket_sensor)
		qdel(src)
		return
	else if(D.iswirecutter())
		to_chat(user, "<span class='notice'>You cut a big hole in \the [src] with \the [D].</span>")
		user.put_in_hands(new helmet_type)
		qdel(src)
		return
	else if(istype(D, /obj/item/mop))
		if(reagents.total_volume < 1)
			to_chat(user, "<span class='warning'>\The [src] is empty!</span>")
		else
			reagents.trans_to_obj(D, 5)
			to_chat(user, "<span class='notice'>You wet \the [D] in \the [src].</span>")
			playsound(loc, 'sound/effects/slosh.ogg', 25, 1)
		return
	else
		return ..()

/obj/item/reagent_containers/glass/bucket/update_icon()
	cut_overlays()
	if(reagents.total_volume > 0)
		add_overlay("water_[initial(icon_state)]")
	if(!is_open_container())
		add_overlay("lid_[initial(icon_state)]")

/obj/item/reagent_containers/glass/bucket/on_reagent_change()
	update_icon()

/obj/item/reagent_containers/glass/bucket/self_feed_message(var/mob/user)
	to_chat(user, "<span class='notice'>You drink heavily from \the [src].</span>")

/obj/item/reagent_containers/glass/bucket/wood
	name = "wooden bucket"
	desc = "An old wooden bucket."
	icon = 'icons/obj/janitor.dmi'
	icon_state = "woodbucket"
	item_state = "woodbucket"
	center_of_mass = list("x" = 16,"y" = 8)
	matter = list("wood" = 50)
	drop_sound = 'sound/items/drop/wooden.ogg'
	pickup_sound = 'sound/items/pickup/wooden.ogg'
	helmet_type = /obj/item/clothing/head/helmet/bucket/wood

/obj/item/reagent_containers/glass/bucket/wood/attackby(var/obj/D, mob/user as mob)
	if(isprox(D))
		to_chat(user, "This wooden bucket doesn't play well with electronics.")
		return
	..()
