/obj/item/implanter
	name = "implanter"
	icon = 'icons/obj/items.dmi'
	icon_state = "implanter0"
	item_state = "syringe_0"
	throw_speed = 1
	throw_range = 5
	w_class = 2.0
	matter = list(DEFAULT_WALL_MATERIAL = 320, "glass" = 800)
	var/obj/item/implant/imp = null

/obj/item/implanter/attack_self(var/mob/user)
	if(!imp)
		return ..()
	imp.forceMove(get_turf(src))
	user.put_in_hands(imp)
	to_chat(user, "<span class='notice'>You remove \the [imp] from \the [src].</span>")
	name = "implanter"
	imp = null
	update()
	return

/obj/item/implanter/proc/update()
	if (src.imp)
		src.icon_state = "implanter1"
	else
		src.icon_state = "implanter0"
	return

/obj/item/implanter/attack(mob/M as mob, mob/user as mob, var/target_zone)
	if (!istype(M, /mob/living/carbon))
		return
	if (user && src.imp)
		M.visible_message("<span class='warning'>[user] is attemping to implant [M].</span>")

		user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
		user.do_attack_animation(M)

		var/turf/T1 = get_turf(M)
		if (T1 && ((M == user) || do_after(user, 50)))
			if(user && M && (get_turf(M) == T1) && src && src.imp)
				M.visible_message("<span class='warning'>[M] has been implanted by [user].</span>")

				admin_attack_log(user, M, "Implanted using \the [src.name] ([src.imp.name])", "Implanted with \the [src.name] ([src.imp.name])", "used an implanter, [src.name] ([src.imp.name]), on")

				if(src.imp.implanted(M))
					src.imp.forceMove(M)
					src.imp.imp_in = M
					src.imp.implanted = 1
					if (ishuman(M))
						var/mob/living/carbon/human/H = M
						var/obj/item/organ/external/affected = H.get_organ(target_zone)
						affected.implants += src.imp
						imp.part = affected

						BITSET(H.hud_updateflag, IMPLOYAL_HUD)
					if(istype(src.imp, /obj/item/implanter/loyalty))
						to_chat(M, "<span class ='notice'You feel a sudden surge of loyalty to [current_map.company_name]!</span>")

				src.imp = null
				update()

	return

/obj/item/implanter/loyalty
	name = "implanter-loyalty"

/obj/item/implanter/loyalty/New()
	src.imp = new /obj/item/implant/loyalty( src )
	..()
	update()
	return

/obj/item/implanter/explosive
	name = "implanter (E)"

/obj/item/implanter/explosive/New()
	src.imp = new /obj/item/implant/explosive( src )
	..()
	update()
	return

/obj/item/implanter/adrenalin
	name = "implanter-adrenalin"

/obj/item/implanter/adrenalin/New()
	src.imp = new /obj/item/implant/adrenalin(src)
	..()
	update()
	return

/obj/item/implanter/compressed
	name = "implanter (C)"
	icon_state = "cimplanter1"

/obj/item/implanter/compressed/New()
	imp = new /obj/item/implant/compressed( src )
	..()
	update()
	return

/obj/item/implanter/compressed/update()
	if (imp)
		var/obj/item/implant/compressed/c = imp
		if(!c.scanned)
			icon_state = "cimplanter1"
		else
			icon_state = "cimplanter2"
	else
		icon_state = "cimplanter0"
	return

/obj/item/implanter/compressed/attack(mob/M as mob, mob/user as mob)
	var/obj/item/implant/compressed/c = imp
	if (!c)	return
	if (c.scanned == null)
		to_chat(user, "Please scan an object with the implanter first.")
		return
	..()

/obj/item/implanter/compressed/afterattack(atom/A, mob/user as mob, proximity)
	if(!proximity)
		return
	if(istype(A,/obj/item) && imp)
		var/obj/item/implant/compressed/c = imp
		if (c.scanned)
			to_chat(user, "<span class='warning'>Something is already scanned inside the implant!</span>")
			return
		c.scanned = A
		if(istype(A.loc,/mob/living/carbon/human))
			var/mob/living/carbon/human/H = A.loc
			H.remove_from_mob(A)
		else if(istype(A.loc,/obj/item/storage))
			var/obj/item/storage/S = A.loc
			S.remove_from_storage(A)
		A.loc.contents.Remove(A)
		update()

/obj/item/implanter/freedom/Initialize()
	imp = new /obj/item/implant/freedom( src )
	..()
	update()

/obj/item/implanter/uplink
	name = "implanter (U)"

/obj/item/implanter/uplink/Initialize()
	imp = new /obj/item/implant/uplink( src )
	..()
	update()

/obj/item/implanter/ipc_tag
	name = "IPC/Shell tag implanter"
	desc = "A special implanter used for implanting synthetics with a special tag."
	var/obj/item/organ/ipc_tag/ipc_tag = null

/obj/item/implanter/ipc_tag/New()
	ipc_tag = new(src)
	..()
	update()

/obj/item/implanter/ipc_tag/update()
	if (ipc_tag)
		icon_state = "cimplanter1"
	else
		icon_state = "cimplanter0"
	return

/obj/item/implanter/ipc_tag/attack(mob/M as mob, mob/user as mob)
	if (!ishuman(M))
		return

	if (!ipc_tag)
		to_chat(user, "<span class ='warning'>[src] is empty!</span>")
		return

	var/mob/living/carbon/human/H = M
	if (!H.species || !isipc(H) || !H.organs_by_name["head"])
		to_chat(user, "<span class = 'warning'>You cannot use this on a non-synthetic organism!</span>")
		return

	if (H.internal_organs_by_name["ipc tag"])
		to_chat(user, "<span class = 'warning'>[H] is already tagged!</span>")
		return

	for (var/mob/O in viewers(M, null))
		O.show_message("<span class = 'warning'>[M] has been implanted by [user].</span>", 1)

	M.attack_log += text("\[[time_stamp()]\] <font color='orange'> Implanted with [src.name] ([src.ipc_tag.name])  by [user.name] ([user.ckey])</font>")
	user.attack_log += text("\[[time_stamp()]\] <font color='red'>Used the [src.name] ([src.ipc_tag.name]) to implant [M.name] ([M.ckey])</font>")
	msg_admin_attack("[key_name_admin(user)] implanted [key_name_admin(M)] with [src.name] (INTENT: [uppertext(user.a_intent)]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)",ckey=key_name(user),ckey_target=key_name(M))

	user.show_message("<span class = 'warning'>You implanted the implant into [M].</span>")

	ipc_tag.replaced(H, H.organs_by_name["head"])

	ipc_tag = null

	update()

	var/datum/species/machine/machine = H.species
	machine.update_tag(H, H.client)

/obj/item/implanter/ipc_tag/attackby(var/obj/item/organ/ipc_tag/new_tag, mob/user as mob)
	..()

	if (!istype(new_tag))
		return

	if (ipc_tag)
		return

	ipc_tag = new_tag
	user.drop_from_inventory(new_tag,src)
	update()
