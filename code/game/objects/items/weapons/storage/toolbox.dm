/obj/item/weapon/storage/toolbox
	name = "toolbox"
	desc = "Danger. Very robust."
	icon = 'icons/obj/storage.dmi'
	icon_state = "red"
	item_state = "toolbox_red"
	flags = CONDUCT
	force = 5
	throwforce = 10
	throw_speed = 1
	throw_range = 7
	w_class = 4
	max_w_class = 3
	max_storage_space = 14 //can hold 7 w_class-2 items or up to 3 w_class-3 items (with 1 w_class-2 item as change).
	origin_tech = "combat=1"
	attack_verb = list("robusted")
	var/stunhit = 0

/obj/item/weapon/storage/toolbox/initialize()
	spawn(3)
		update_force()

/obj/item/weapon/storage/toolbox/emergency
	name = "emergency toolbox"
	icon_state = "red"
	item_state = "toolbox_red"

	New()
		..()
		new /obj/item/weapon/crowbar/red(src)
		new /obj/item/weapon/extinguisher/mini(src)
		if(prob(50))
			new /obj/item/device/flashlight(src)
		else
			new /obj/item/device/flashlight/flare(src)
		new /obj/item/device/radio(src)

/obj/item/weapon/storage/toolbox/mechanical
	name = "mechanical toolbox"
	icon_state = "blue"
	item_state = "toolbox_blue"

	New()
		..()
		new /obj/item/weapon/screwdriver(src)
		new /obj/item/weapon/wrench(src)
		new /obj/item/weapon/weldingtool(src)
		new /obj/item/weapon/crowbar(src)
		new /obj/item/device/analyzer(src)
		new /obj/item/weapon/wirecutters(src)

/obj/item/weapon/storage/toolbox/electrical
	name = "electrical toolbox"
	icon_state = "yellow"
	item_state = "toolbox_yellow"

	New()
		..()
		var/color = pick("red","yellow","green","blue","pink","orange","cyan","white")
		new /obj/item/weapon/screwdriver(src)
		new /obj/item/weapon/wirecutters(src)
		new /obj/item/device/t_scanner(src)
		new /obj/item/weapon/crowbar(src)
		new /obj/item/stack/cable_coil(src,30,color)
		new /obj/item/stack/cable_coil(src,30,color)
		if(prob(5))
			new /obj/item/clothing/gloves/yellow(src)
		else
			new /obj/item/stack/cable_coil(src,30,color)

/obj/item/weapon/storage/toolbox/syndicate
	name = "suspicious looking toolbox"
	icon_state = "syndicate"
	item_state = "toolbox_syndi"
	origin_tech = "combat=1;syndicate=1"
	force = 7.0

	New()
		..()
		var/color = pick("red","yellow","green","blue","pink","orange","cyan","white")
		new /obj/item/weapon/screwdriver(src)
		new /obj/item/weapon/wrench(src)
		new /obj/item/weapon/weldingtool(src)
		new /obj/item/weapon/crowbar(src)
		new /obj/item/stack/cable_coil(src,30,color)
		new /obj/item/weapon/wirecutters(src)
		new /obj/item/device/multitool(src)


/obj/item/weapon/storage/toolbox/proc/update_force()
	force = initial(force)
	for (var/obj/item/I in contents)
		force += I.w_class*1.5

/obj/item/weapon/storage/toolbox/handle_item_insertion(obj/item/W as obj, prevent_warning = 0)
	if (..(W, prevent_warning))
		update_force()


/obj/item/weapon/storage/toolbox/attack(mob/living/M as mob, mob/user as mob)
	update_force()
	..(M, user)
	if (contents.len)
		spill(3, get_turf(M))
		playsound(M, 'sound/items/trayhit2.ogg', 100, 1)  //sound playin' again
		update_force()
		user.visible_message(span("danger", "[user] smashes the [src] into [M], causing it to break open and strew its contents across the area"))

