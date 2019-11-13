/obj/item/storage/toolbox
	name = "toolbox"
	desc = "Danger. Very robust."
	icon = 'icons/obj/storage.dmi'
	icon_state = "red"
	item_state = "toolbox_red"
	center_of_mass = list("x" = 16,"y" = 11)
	flags = CONDUCT
	force = 5
	throwforce = 10
	throw_speed = 1
	throw_range = 7
	w_class = 4
	max_w_class = 3
	max_storage_space = 14 //enough to hold all starting contents
	origin_tech = list(TECH_COMBAT = 1)
	attack_verb = list("robusted")
	use_sound = 'sound/items/storage/toolbox.ogg'
	var/stunhit = 0
	drop_sound = 'sound/items/drop/metalboots.ogg'

/obj/item/storage/toolbox/Initialize()
	. = ..()
	update_force()

/obj/item/storage/toolbox/emergency
	name = "emergency toolbox"
	icon_state = "red"
	item_state = "toolbox_red"
	starts_with = list(\
		/obj/item/crowbar/red = 1,\
		/obj/item/extinguisher/mini = 1,\
		/obj/item/device/radio = 1\
	)

/obj/item/storage/toolbox/emergency/fill()
	. = ..()
	if(prob(50))
		new /obj/item/device/flashlight(src)
	else
		new /obj/item/device/flashlight/flare(src)

/obj/item/storage/toolbox/mechanical
	name = "mechanical toolbox"
	icon_state = "blue"
	item_state = "toolbox_blue"
	starts_with = list(\
		/obj/item/screwdriver = 1,\
		/obj/item/wrench = 1,\
		/obj/item/weldingtool = 1,
		/obj/item/crowbar = 1,\
		/obj/item/device/analyzer = 1,\
		/obj/item/wirecutters = 1\
	)

/obj/item/storage/toolbox/electrical
	name = "electrical toolbox"
	icon_state = "yellow"
	item_state = "toolbox_yellow"
	starts_with = list(\
		/obj/item/screwdriver = 1,\
		/obj/item/wirecutters = 1,\
		/obj/item/device/t_scanner = 1,\
		/obj/item/crowbar = 1\
	)

/obj/item/storage/toolbox/electrical/fill()
	. = ..()
	var/color = pick("red","yellow","green","blue","pink","orange","cyan","white")
	new /obj/item/stack/cable_coil(src,30,color)
	new /obj/item/stack/cable_coil(src,30,color)
	if(prob(5))
		new /obj/item/clothing/gloves/yellow(src)
	else
		new /obj/item/stack/cable_coil(src,30,color)

/obj/item/storage/toolbox/syndicate
	name = "suspicious looking toolbox"
	icon_state = "syndicate"
	item_state = "toolbox_syndi"
	origin_tech = list(TECH_COMBAT = 1, TECH_ILLEGAL = 1)
	force = 7.0
	starts_with = list(\
		/obj/item/clothing/gloves/yellow = 1,\
		/obj/item/screwdriver = 1,\
		/obj/item/wrench = 1,\
		/obj/item/weldingtool = 1,
		/obj/item/crowbar = 1,\
		/obj/item/wirecutters = 1,\
		/obj/item/device/multitool = 1,\
	)


/obj/item/storage/toolbox/proc/update_force()
	force = initial(force)
	for (var/obj/item/I in contents)
		force += I.w_class*1.5

/obj/item/storage/toolbox/handle_item_insertion(obj/item/W as obj, prevent_warning = 0)
	if (..(W, prevent_warning))
		update_force()


/obj/item/storage/toolbox/attack(mob/living/M as mob, mob/user as mob, var/target_zone)
	update_force()
	if (..())
		if (contents.len)
			spill(3, get_turf(M))
			playsound(M, 'sound/items/trayhit2.ogg', 100, 1)  //sound playin' again
			update_force()
			user.visible_message(span("danger", "[user] smashes the [src] into [M], causing it to break open and strew its contents across the area"))


/obj/item/storage/toolbox/lunchbox
	name = "rainbow lunchbox"
	icon = 'icons/obj/lunchbox.dmi'
	force = 3
	throwforce = 5
	contained_sprite = 1
	icon_state = "lunchbox_rainbow"
	item_state = "lunchbox_rainbow"
	desc = "A little lunchbox. This one is the colors of the rainbow."
	attack_verb = list("lunched")
	w_class = 3
	max_storage_space = 8
	var/filled = FALSE

/obj/item/storage/toolbox/lunchbox/fill()
	..()
	if(filled)
		var/list/lunches = lunchables_lunches()
		var/lunch = lunches[pick(lunches)]
		new lunch(src)

		var/list/snacks = lunchables_snacks()
		var/snack = snacks[pick(snacks)]
		new snack(src)

		var/list/drinks = lunchables_drinks()
		var/drink = drinks[pick(drinks)]
		new drink(src)

/obj/item/storage/toolbox/lunchbox/filled
	filled = TRUE

/obj/item/storage/toolbox/lunchbox/heart
	name = "heart lunchbox"
	icon_state = "lunchbox_hearts"
	item_state = "lunchbox_hearts"
	desc = "A little lunchbox. This one has little hearts on it."

/obj/item/storage/toolbox/lunchbox/heart/filled
	filled = TRUE

/obj/item/storage/toolbox/lunchbox/cat
	name = "cat lunchbox"
	icon_state = "lunchbox_cat"
	item_state = "lunchbox_cat"
	desc = "A little lunchbox. This one has a cat stamp on it."

/obj/item/storage/toolbox/lunchbox/cat/filled
	filled = TRUE

/obj/item/storage/toolbox/lunchbox/nt
	name = "NanoTrasen brand lunchbox"
	icon_state = "lunchbox_nanotrasen"
	item_state = "lunchbox_nanotrasen"
	desc = "A little lunchbox. This one is branded with the NanoTrasen logo."

/obj/item/storage/toolbox/lunchbox/nt/filled
	filled = TRUE

/obj/item/storage/toolbox/lunchbox/nymph
	name = "\improper diona nymph lunchbox"
	icon_state = "lunchbox_dionanymph"
	item_state = "lunchbox_dionanymph"
	desc = "A little lunchbox. This one has a diona nymph on the side."

/obj/item/storage/toolbox/lunchbox/nymph/filled
	filled = TRUE

/obj/item/storage/toolbox/lunchbox/syndicate
	name = "black and red lunchbox"
	icon_state = "lunchbox_syndie"
	item_state = "lunchbox_syndie"
	desc = "A little lunchbox. This one is a sleek black and red."

/obj/item/storage/toolbox/lunchbox/syndicate/filled
	filled = TRUE
