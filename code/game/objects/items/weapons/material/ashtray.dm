/obj/item/material/ashtray
	name = "ashtray"
	icon = 'icons/obj/ashtray.dmi'
	randpixel = 5
	force_divisor = 0.1
	thrown_force_divisor = 0.1
	var/image/base_image
	var/max_butts = 10

/obj/item/material/ashtray/New(var/newloc, var/material_name)
	..(newloc, material_name)
	if(!material)
		qdel(src)
		return
	max_butts = round(material.hardness/10) //This is arbitrary but whatever.
	randpixel_xy()
	update_icon()
	return

/obj/item/material/ashtray/update_icon()
	color = null
	cut_overlays()
	var/list/ashtray_cache = SSicon_cache.ashtray_cache
	var/cache_key = "base-[material.name]"
	if(!ashtray_cache[cache_key])
		var/image/I = image('icons/obj/ashtray.dmi',"ashtray")
		I.color = material.icon_colour
		ashtray_cache[cache_key] = I
	add_overlay(ashtray_cache[cache_key])

	if (contents.len == max_butts)
		add_overlay("ashtray_full")
		desc = "It's stuffed full."
	else if (contents.len > max_butts/2)
		add_overlay("ashtray_half")
		desc = "It's half-filled."
	else
		desc = "An ashtray made of [material.display_name]."

/obj/item/material/ashtray/attackby(obj/item/W as obj, mob/user as mob)
	if (health <= 0)
		return
	if (istype(W,/obj/item/trash/cigbutt) || istype(W,/obj/item/clothing/mask/smokable/cigarette) || istype(W, /obj/item/flame/match))
		if (contents.len >= max_butts)
			to_chat(user, "\The [src] is full.")
			return
		user.remove_from_mob(W)
		W.forceMove(src)

		if (istype(W,/obj/item/clothing/mask/smokable/cigarette))
			var/obj/item/clothing/mask/smokable/cigarette/cig = W
			if (cig.lit == 1)
				src.visible_message("[user] crushes [cig] in \the [src], putting it out.")
				playsound(src.loc, 'sound/items/cigs_lighters/cig_snuff.ogg', 50, 1)
				STOP_PROCESSING(SSprocessing, cig)
				var/obj/item/butt = new cig.type_butt(src)
				cig.transfer_fingerprints_to(butt)
				qdel(cig)
				W = butt
				//spawn(1)
				//	TemperatureAct(150)
			else if (cig.lit == 0)
				to_chat(user, "You place [cig] in [src] without even smoking it. Why would you do that?")

		src.visible_message("[user] places [W] in [src].")
		user.update_inv_l_hand()
		user.update_inv_r_hand()
		add_fingerprint(user)
		update_icon()
	else
		health = max(0,health - W.force)
		to_chat(user, "You hit [src] with [W].")
		if (health < 1)
			shatter()
	return

/obj/item/material/ashtray/throw_impact(atom/hit_atom)
	if (health > 0)
		health = max(0,health - 3)
		if (contents.len)
			src.visible_message("<span class='danger'>\The [src] slams into [hit_atom], spilling its contents!</span>")
		for (var/obj/item/clothing/mask/smokable/cigarette/O in contents)
			O.forceMove(src.loc)
		if (health < 1)
			shatter()
			return
		update_icon()
	return ..()

/obj/item/material/ashtray/plastic/New(var/newloc)
	..(newloc, MATERIAL_PLASTIC)

/obj/item/material/ashtray/bronze/New(var/newloc)
	..(newloc, MATERIAL_BRONZE)

/obj/item/material/ashtray/glass/New(var/newloc)
	..(newloc, MATERIAL_GLASS)
