	name = "implanter"
	icon = 'icons/obj/items.dmi'
	icon_state = "implanter0"
	item_state = "syringe_0"
	throw_speed = 1
	throw_range = 5
	w_class = 2.0

	if(!imp)
		return ..()
	imp.loc = get_turf(src)
	user.put_in_hands(imp)
	user << "<span class='notice'>You remove \the [imp] from \the [src].</span>"
	name = "implanter"
	imp = null
	update()
	return

	if (src.imp)
		src.icon_state = "implanter1"
	else
		src.icon_state = "implanter0"
	return

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
					src.imp.loc = M
					src.imp.imp_in = M
					src.imp.implanted = 1
					if (ishuman(M))
						var/mob/living/carbon/human/H = M
						var/obj/item/organ/external/affected = H.get_organ(target_zone)
						affected.implants += src.imp
						imp.part = affected

						BITSET(H.hud_updateflag, IMPLOYAL_HUD)
						M << "<span class ='notice'You feel a sudden surge of loyalty to [current_map.company_name]!</span>"

				src.imp = null
				update()

	return

	name = "implanter-loyalty"

	..()
	update()
	return

	name = "implanter (E)"

	..()
	update()
	return

	name = "implanter-adrenalin"

	..()
	update()
	return

	name = "implanter (C)"
	icon_state = "cimplanter1"

	..()
	update()
	return

	if (imp)
		if(!c.scanned)
			icon_state = "cimplanter1"
		else
			icon_state = "cimplanter2"
	else
		icon_state = "cimplanter0"
	return

	if (!c)	return
	if (c.scanned == null)
		user << "Please scan an object with the implanter first."
		return
	..()

	if(!proximity)
		return
	if(istype(A,/obj/item) && imp)
		if (c.scanned)
			user << "<span class='warning'>Something is already scanned inside the implant!</span>"
			return
		c.scanned = A
		if(istype(A.loc,/mob/living/carbon/human))
			var/mob/living/carbon/human/H = A.loc
			H.remove_from_mob(A)
			S.remove_from_storage(A)
		A.loc.contents.Remove(A)
		update()

	name = "IPC/Shell tag implanter"
	desc = "A special implanter used for implanting synthetics with a special tag."
	var/obj/item/organ/ipc_tag/ipc_tag = null

	ipc_tag = new(src)
	..()
	update()

	if (ipc_tag)
		icon_state = "cimplanter1"
	else
		icon_state = "cimplanter0"
	return

	if (!ishuman(M))
		return

	if (!ipc_tag)
		user << "<span class ='warning'>[src] is empty!</span>"
		return

	var/mob/living/carbon/human/H = M
	if (!H.species || !isipc(H) || !H.organs_by_name["groin"])
		user << "<span class = 'warning'>You cannot use this on a non-synthetic organism!</span>"
		return

	if (H.internal_organs_by_name["ipc tag"])
		user << "<span class = 'warning'>[H] is already tagged!</span>"
		return

	for (var/mob/O in viewers(M, null))
		O.show_message("<span class = 'warning'>[M] has been implanted by [user].</span>", 1)

	M.attack_log += text("\[[time_stamp()]\] <font color='orange'> Implanted with [src.name] ([src.ipc_tag.name])  by [user.name] ([user.ckey])</font>")
	user.attack_log += text("\[[time_stamp()]\] <font color='red'>Used the [src.name] ([src.ipc_tag.name]) to implant [M.name] ([M.ckey])</font>")
	msg_admin_attack("[key_name_admin(user)] implanted [key_name_admin(M)] with [src.name] (INTENT: [uppertext(user.a_intent)]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)",ckey=key_name(user),ckey_target=key_name(M))

	user.show_message("<span class = 'warning'>You implanted the implant into [M].</span>")

	ipc_tag.replaced(H, H.organs_by_name["groin"])

	qdel(ipc_tag)

	update()

	var/datum/species/machine/machine = H.species
	machine.update_tag(H, H.client)

	..()

	if (!istype(new_tag))
		return

	if (ipc_tag)
		return

	ipc_tag = new_tag
	user.drop_item()
	new_tag.loc = src
	update()
