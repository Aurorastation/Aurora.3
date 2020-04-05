/obj/item/teleportation_scroll
	name = "scroll of teleportation"
	desc = "A scroll for moving around."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "scroll"
	item_state = "scroll"
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_books.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_books.dmi'
		)
	var/uses = 4.0
	w_class = 1
	item_state = "paper"
	throw_speed = 4
	throw_range = 20
	origin_tech = list(TECH_BLUESPACE = 4)

/obj/item/teleportation_scroll/attack_self(mob/living/user as mob)
	if(!user.is_wizard())
		if(istype(user, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = user
			var/obj/item/organ/O = H.internal_organs_by_name[pick(BP_EYES,"appendix",BP_KIDNEYS,BP_LIVER, BP_HEART, BP_LUNGS, BP_BRAIN)]
			if(O == null)
				to_chat(user, span("notice", "You can't make any sense of the arcane glyphs. . . maybe you should try again."))
			else
				to_chat(user, span("alert", "As you stumble over the arcane glyphs, you feel a twisting sensation in [O]!"))
				user.visible_message("<span class='danger'>A flash of smoke pours out of [user]'s orifices!</span>")
				playsound(user, 'sound/magic/lightningshock.ogg', 40, 1)
				var/datum/effect/effect/system/smoke_spread/smoke = new /datum/effect/effect/system/smoke_spread()
				smoke.set_up(5, 0, user.loc)
				smoke.attach(user)
				smoke.start()
				user.show_message("<b>[user]</b> screams!",2)
				user.drop_item()
				if(O && istype(O))
					O.removed(user)
			return
	else
		user.set_machine(src)
		var/dat = "<B>Teleportation Scroll:</B><BR>"
		dat += "Number of uses: [src.uses]<BR>"
		dat += "<HR>"
		dat += "<B>Four uses use them wisely:</B><BR>"
		dat += "<A href='byond://?src=\ref[src];spell_teleport=1'>Teleport</A><BR>"
		dat += "Kind regards,<br>Wizards Federation<br><br>P.S. Don't forget to bring your gear, you'll need it to cast most spells.<HR>"
		user << browse(dat, "window=scroll")
		onclose(user, "scroll")
		return

/obj/item/teleportation_scroll/Topic(href, href_list)
	..()
	if (usr.stat || usr.restrained() || src.loc != usr)
		return
	var/mob/living/carbon/human/H = usr
	if (!( istype(H, /mob/living/carbon/human)))
		return 1
	if ((usr == src.loc || (in_range(src, usr) && istype(src.loc, /turf))))
		usr.set_machine(src)
		if (href_list["spell_teleport"])
			if (src.uses >= 1)
				teleportscroll(H)
	attack_self(H)
	return

/obj/item/teleportation_scroll/proc/teleportscroll(var/mob/user)

	var/A

	A = input(user, "Area to jump to", "BOOYEA", A) in teleportlocs
	var/area/thearea = teleportlocs[A]

	if (user.stat || user.restrained())
		return
	if(!((user == loc || (in_range(src, user) && istype(src.loc, /turf)))))
		return

	var/datum/effect/effect/system/smoke_spread/smoke = new /datum/effect/effect/system/smoke_spread()
	smoke.set_up(5, 0, user.loc)
	smoke.attach(user)
	smoke.start()
	var/list/L = list()
	for(var/turf/T in get_area_turfs(thearea))
		if(!T.density && !T.is_hole)
			var/clear = 1
			for(var/obj/O in T)
				if(O.density)
					clear = 0
					break
			if(clear)
				L+=T

	if(!L.len)
		to_chat(user, "The spell matrix was unable to locate a suitable teleport destination for an unknown reason. Sorry.")
		return

	if(user && user.buckled)
		user.buckled.unbuckle_mob()

	var/list/tempL = L
	var/attempt = null
	var/success = 0
	while(tempL.len)
		attempt = pick(tempL)
		success = user.Move(attempt)
		if(!success)
			tempL.Remove(attempt)
		else
			break

	if(!success)
		user.forceMove(pick(L))

	smoke.start()
	src.uses -= 1
