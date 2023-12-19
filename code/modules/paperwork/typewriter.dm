 /obj/item/pen/typewriter
	name = "National Typist 'Adhomai Electric' experimental integrated typewriter pen"
	desc = "A mechanical pen that writes on paper inside a typewriter. How did you even get this?"

/obj/item/portable_typewriter
	name = "portable typewriter"
	desc = "A reasonably lightweight typewriter designed to be moved around."
	desc_info = "You can alt-click this to eject the paper. Click and drag onto yourself while adjacent to type on the typewriter."
	desc_extended = "The National Typist Company in the People's Republic of Adhomai was once the largest producer of \
	typewriters on the planet. With the introduction of human technology, however, these items - \
	which were once staples of Tajaran offices - have slowly become more uncommon. That \
	said, rural areas and less urban parts of the planet still rely heavily on these machines."
	icon_state = "typewriter"
	icon = 'icons/obj/device.dmi'
	force = 20
	throwforce = 5
	w_class = ITEMSIZE_NORMAL
	drop_sound = 'sound/items/drop/metalweapon.ogg'
	pickup_sound = 'sound/items/pickup/metalweapon.ogg'

	var/obj/item/paper/stored_paper = null
	var/obj/item/pen/pen

/obj/item/portable_typewriter/New()
	..()
	if(isnull(src.pen))
		src.pen = new /obj/item/pen/typewriter(src)

/obj/item/portable_typewriter/attack_self(mob/user)
	if(isnull(stored_paper))
		to_chat(usr, "<span class='alert'>\The [src] has no paper fed for typing!</span>")
	else
		src.stored_paper.attackby(src.pen, user)
	. = ..()

/obj/item/portable_typewriter/AltClick(mob/user)
	if(!Adjacent(user))
		return

	else if(src.stored_paper)
		var/obj/item/paper/paper = src.stored_paper
		if(src.eject_paper(user.loc))
			user.put_in_hands(paper)
	else
		. = ..()

/obj/item/portable_typewriter/MouseDrop(mob/user as mob)
	if((user == usr && (!( usr.restrained() ) && (!( usr.stat ) && (usr.contents.Find(src) || in_range(src, usr))))))
		if(isnull(stored_paper))
			to_chat(usr, "<span class='alert'>\The [src] has no paper fed for typing!</span>")
		else
			src.stored_paper.attackby(src.pen, user)
	return

/obj/item/portable_typewriter/update_icon()
	if(src.stored_paper)
		src.icon_state = "typewriter_[stored_paper.icon_state]"
	else
		src.icon_state = "typewriter"

/obj/item/portable_typewriter/proc/eject_paper(atom/target, mob/user)
	if(isnull(src.stored_paper))
		return FALSE
	to_chat(usr, "<span class='notice'>\The [src] ejects \the [src.stored_paper].</span>")
	playsound(src.loc, 'sound/bureaucracy/paperfold.ogg', 60, 0)
	src.stored_paper.forceMove(target)
	src.stored_paper = null
	src.update_icon()
	return TRUE

/obj/item/portable_typewriter/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/paper))
		if(isnull(stored_paper))
			if(W.icon_state == "scrap")
				to_chat(usr, "<span class='alert'>\The [W] is too crumpled to feed correctly!</span>")
				return
			else
				user.drop_item(W)
				user.unEquip(W)
				W.forceMove(src)
				src.stored_paper = W
				user.visible_message("<span class='notice'>[user] sucks up \the [W] into \the [src].</span>", "<span class='notice'>You suck up \the [W] into \the [src].</span>")
				src.update_icon()
		else
			to_chat(usr, "<span class='alert'>\The [src] already has a paper in it.</span>")
		. = ..()

/obj/item/portable_typewriter/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	..()
	user.visible_message("<span class='danger'>\The [src] shatters into metal pieces!</span>")
	M.Weaken(2)
	playsound(loc, 'sound/effects/metalhit.ogg', 50, 1)
	playsound(loc, 'sound/weapons/ring.ogg', 50, 1)
	new /obj/item/material/shard/shrapnel(get_turf(user))
	qdel(src)

/obj/item/typewriter_case
	name = "typewriter case"
	desc = "A large briefcase-esque place to store one's typewriter."
	desc_info = "You can alt-click on this case to open and close it. A typewriter can only be removed or added when it is open!"
	desc_extended = "The National Typist Company in the People's Republic of Adhomai was once the largest producer of \
	typewriters on the planet. With the introduction of human technology, however, these items - \
	which were once staples of Tajaran offices - have slowly become more uncommon. That \
	said, rural areas and less urban parts of the planet still rely heavily on these machines."
	icon = 'icons/obj/storage/briefcase.dmi'
	icon_state = "typewriter_case_closed"
	item_state = "briefcase_black"
	contained_sprite = TRUE
	force = 10
	throwforce = 5
	throw_speed = 1
	throw_range = 4
	w_class = ITEMSIZE_LARGE
	drop_sound = 'sound/items/drop/backpack.ogg'
	pickup_sound = 'sound/items/pickup/backpack.ogg'

	var/obj/item/portable_typewriter/machine
	var/opened = 0

/obj/item/typewriter_case/New()
	..()
	if(isnull(src.machine))
		src.machine = new /obj/item/portable_typewriter(src)

/obj/item/typewriter_case/AltClick(mob/user)
	if(!Adjacent(user))
		return

	playsound(src.loc, 'sound/items/storage/briefcase.ogg', 50, 0, -5)

	if(src.opened == 0)
		src.opened = 1
		src.update_icon()
	else if(src.opened == 1)
		src.opened = 0
		src.update_icon()

/obj/item/typewriter_case/update_icon()
	if(src.opened == 1 && src.machine != null)
		src.icon_state = "typewriter_case_open"
	else if (src.opened == 1 && src.machine == null)
		src.icon_state = "typewriter_case_open_e"
	else if (src.opened == 0)
		src.icon_state = "typewriter_case_closed"

/obj/item/typewriter_case/MouseDrop(mob/user as mob)
	if((user == usr && (!( usr.restrained() ) && (!( usr.stat ) && (usr.contents.Find(src) || in_range(src, usr))))))
		if(src.opened == 1)
			if(isnull(machine))
				to_chat(usr, "<span class='alert'>\The [src] is currently empty!</span>")
			else
				user.put_in_hands(src.machine)
				src.machine = null
				src.update_icon()
		else if (src.opened == 0)
			to_chat(usr, "<span class='alert'>\The [src] is currently closed!</span>")
	return

/obj/item/typewriter_case/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/portable_typewriter))
		if(isnull(machine))
			user.drop_item(W)
			user.unEquip(W)
			W.forceMove(src)
			src.machine = W
			user.visible_message("<span class='notice'>[user] places \the [W] into \the [src].</span>", "<span class='notice'>You store \the [W] in \the [src].</span>")
			src.update_icon()
		else
			to_chat(usr, "<span class='alert'>\The [src] already has a typewriter in it!</span>")
		. = ..()