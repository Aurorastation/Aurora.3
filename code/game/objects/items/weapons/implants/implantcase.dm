//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/obj/item/implantcase
	name = "glass case"
	desc = "A case containing an implant."
	icon = 'icons/obj/items.dmi'
	icon_state = "implantcase-0"
	item_state = "implantcase"
	throw_speed = 1
	throw_range = 5
	w_class = 1.0
	var/obj/item/implant/imp = null

/obj/item/implantcase/proc/update()
	if (src.imp)
		src.icon_state = text("implantcase-[]", src.imp.implant_color)
	else
		src.icon_state = "implantcase-0"
	return

/obj/item/implantcase/attackby(obj/item/I as obj, mob/user as mob)
	..()
	if (I.ispen())
		var/t = input(user, "What would you like the label to be?", text("[]", src.name), null)  as text
		if (user.get_active_hand() != I)
			return
		if((!in_range(src, usr) && src.loc != user))
			return
		t = sanitizeSafe(t, MAX_NAME_LEN)
		if(t)
			src.name = text("Glass Case - '[]'", t)
		else
			src.name = "Glass Case"
	else if(istype(I, /obj/item/reagent_containers/syringe))
		if(!src.imp)	return
		if(!src.imp.allow_reagents)	return
		if(src.imp.reagents.total_volume >= src.imp.reagents.maximum_volume)
			to_chat(user, "<span class='warning'>\The [src] is full.</span>")
		else
			var/trans = I.reagents.trans_to_obj(src.imp, 5)
			if (trans > 0)
				to_chat(user, "<span class='notice'>You inject [trans] units of the solution. The syringe now contains [I.reagents.total_volume] units.</span>")
	else if (istype(I, /obj/item/implanter))
		var/obj/item/implanter/M = I
		if (M.imp)
			if ((src.imp || M.imp.implanted))
				return
			M.imp.forceMove(src)
			src.imp = M.imp
			M.imp = null
			src.update()
			M.update()
		else
			if (src.imp)
				if (M.imp)
					return
				src.imp.forceMove(M)
				M.imp = src.imp
				src.imp = null
				update()
			M.update()
	return


/obj/item/implantcase/tracking
	name = "glass case - 'tracking'"
	desc = "A case containing a tracking implant."
	icon_state = "implantcase-b"

/obj/item/implantcase/tracking/New()
	src.imp = new /obj/item/implant/tracking( src )
	..()
	return


/obj/item/implantcase/explosive
	name = "glass case - 'explosive'"
	desc = "A case containing an explosive implant."
	icon_state = "implantcase-r"

/obj/item/implantcase/explosive/New()
	src.imp = new /obj/item/implant/explosive( src )
	..()
	return


/obj/item/implantcase/chem
	name = "glass case - 'chem'"
	desc = "A case containing a chemical implant."
	icon_state = "implantcase-b"

/obj/item/implantcase/chem/New()
	src.imp = new /obj/item/implant/chem( src )
	..()
	return


/obj/item/implantcase/loyalty
	name = "glass case - 'mind shield'"
	desc = "A case containing a mind shield implant."
	icon_state = "implantcase-r"

/obj/item/implantcase/loyalty/New()
	src.imp = new /obj/item/implant/mindshield( src )
	..()
	return


/obj/item/implantcase/death_alarm
	name = "glass case - 'death alarm'"
	desc = "A case containing a death alarm implant."
	icon_state = "implantcase-b"

/obj/item/implantcase/death_alarm/New()
	src.imp = new /obj/item/implant/death_alarm( src )
	..()
	return


/obj/item/implantcase/freedom
	name = "glass case - 'freedom'"
	desc = "A case containing a freedom implant."
	icon_state = "implantcase-r"

/obj/item/implantcase/freedom/New()
	src.imp = new /obj/item/implant/freedom( src )
	..()
	return


/obj/item/implantcase/adrenalin
	name = "glass case - 'adrenalin'"
	desc = "A case containing an adrenalin implant."
	icon_state = "implantcase-b"

/obj/item/implantcase/adrenalin/New()
	src.imp = new /obj/item/implant/adrenalin( src )
	..()
	return


/obj/item/implantcase/dexplosive
	name = "glass case - 'explosive'"
	desc = "A case containing an explosive."
	icon_state = "implantcase-r"

/obj/item/implantcase/dexplosive/New()
	src.imp = new /obj/item/implant/dexplosive( src )
	..()
	return


/obj/item/implantcase/health
	name = "glass case - 'health'"
	desc = "A case containing a health tracking implant."
	icon_state = "implantcase-b"

/obj/item/implantcase/health/New()
	src.imp = new /obj/item/implant/health( src )
	..()
	return


/obj/item/implantcase/aggression
	name = "glass case - 'aggression'"
	desc = "A case containing an aggression inducing implant."
	icon_state = "implantcase-b"

/obj/item/implantcase/aggression/New()
	src.imp = new /obj/item/implant/aggression(src)
	..()
	return