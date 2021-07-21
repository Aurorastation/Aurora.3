/obj/item/material/ashtray
	name = "ashtray"
	icon = 'icons/obj/ashtray.dmi'
	icon_state = "ashtray"
	randpixel = 5
	force_divisor = 0.1
	thrown_force_divisor = 0.1
	var/image/base_image
	var/max_butts = 10
	w_class = ITEMSIZE_TINY

/obj/item/material/ashtray/Initialize(newloc, material_key)
	. = ..()
	if(!material)
		return INITIALIZE_HINT_QDEL
	max_butts = round(material.hardness/10) //This is arbitrary but whatever.
	randpixel_xy()
	update_icon()

/obj/item/material/ashtray/shatter()
	..()
	if(emptyout(get_turf(src)))
		visible_message(SPAN_DANGER("The contents of [src] spill everywhere!"))

/obj/item/material/ashtray/proc/emptyout(atom/dest)
	if(!contents.len)
		return FALSE
	for (var/obj/O in contents)
		O.forceMove(dest)
	update_icon()
	return TRUE

/obj/item/material/ashtray/attack_self(mob/user)
	var/turf/dest = get_turf(src)
	if(emptyout(dest))
		user.visible_message("<b>[user]</b> pours [src] out onto [dest].", SPAN_NOTICE("You pour [src] out onto [dest]."))
		return
	to_chat(user, SPAN_WARNING("[src] is empty, there's nothing to pour out!"))

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
			if (cig.lit == TRUE)
				user.visible_message("<b>[user]</b> crushes [cig] in [src], putting it out.", SPAN_NOTICE("You crush [cig] in [src], putting it out."))
				playsound(src.loc, 'sound/items/cigs_lighters/cig_snuff.ogg', 50, 1)
				STOP_PROCESSING(SSprocessing, cig)
				var/obj/item/butt = new cig.type_butt(src)
				cig.transfer_fingerprints_to(butt)
				qdel(cig)
				W = butt
				//spawn(1)
				//	TemperatureAct(150)
			else if (cig.lit == FALSE)
				user.visible_message(
					"<b>[user]</b> places [cig] in [src] without even smoking it.",
					SPAN_NOTICE("You place [cig] in [src] without even smoking it. Why would you do that?")
				)
		else
			user.visible_message("<b>[user]</b> places [W] in [src].", SPAN_NOTICE("You place [W] in [src]."))

		user.update_inv_l_hand()
		user.update_inv_r_hand()
		add_fingerprint(user)
		update_icon()
	else
		health = max(0,health - W.force)
		user.visible_message(user, SPAN_DANGER("[user] hits [src] with [W]!"), SPAN_DANGER("You hit [src] with [W]."))
		playsound(get_turf(src), material.hitsound, 25)
		if (health < 1)
			shatter()
	return

/obj/item/material/ashtray/throw_impact(atom/hit_atom)
	if (health > 0)
		health = max(0,health - 3)
		if(emptyout(get_turf(src)))
			visible_message(SPAN_DANGER("[src] slams into [hit_atom], spilling its contents everywhere!"))
		if (health < 1)
			shatter()
			return
		update_icon()
	return ..()

/obj/item/material/ashtray/plastic/Initialize(newloc, material_key)
	. = ..(newloc, MATERIAL_PLASTIC)

/obj/item/material/ashtray/bronze/Initialize(newloc, material_key)
	. = ..(newloc, MATERIAL_BRONZE)

/obj/item/material/ashtray/glass/Initialize(newloc, material_key)
	. = ..(newloc, MATERIAL_GLASS)
