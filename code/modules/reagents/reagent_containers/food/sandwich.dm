
		S.attackby(W,user)
		qdel(src)
	..()

	name = "sandwich"
	desc = "The best thing since sliced bread."
	icon_state = "breadslice"
	trash = /obj/item/trash/plate
	bitesize = 2

	var/list/ingredients = list()


	var/sandwich_limit = 4
	for(var/obj/item/O in ingredients)
			sandwich_limit += 4

	if(src.contents.len > sandwich_limit)
		user << "<span class='warning'>If you put anything else on \the [src] it's going to collapse.</span>"
		return
		user << "<span class='notice'>You hide [W] in \the [src].</span>"
		user.drop_item()
		W.loc = src
		update()
		return
		user << "<span class='notice'>You layer [W] over \the [src].</span>"
		F.reagents.trans_to_obj(src, F.reagents.total_volume)
		user.drop_item()
		W.loc = src
		ingredients += W
		update()
		return
	..()

	var/fullname = "" //We need to build this from the contents of the var.
	var/i = 0

	cut_overlays()
	var/list/ovr = list()


		i++
		if(i == 1)
			fullname += "[O.name]"
		else if(i == ingredients.len)
			fullname += " and [O.name]"
		else
			fullname += ", [O.name]"

		var/image/I = new(src.icon, "sandwich_filling")
		I.color = O.filling_color
		I.pixel_x = pick(list(-1,0,1))
		I.pixel_y = (i*2)+1
		ovr += I

	var/image/T = new(src.icon, "sandwich_top")
	T.pixel_x = pick(list(-1,0,1))
	T.pixel_y = (ingredients.len * 2)+1
	ovr += T

	add_overlay(ovr)

	name = lowertext("[fullname] sandwich")
	if(length(name) > 80) name = "[pick(list("absurd","colossal","enormous","ridiculous"))] sandwich"
	w_class = n_ceil(Clamp((ingredients.len/2),2,4))

	for(var/obj/item/O in ingredients)
		qdel(O)
	return ..()

	..(user)
	var/obj/item/O = pick(contents)
	user << "<span class='notice'>You think you can see [O.name] in there.</span>"


	var/obj/item/shard
	for(var/obj/item/O in contents)
			shard = O
			break

	var/mob/living/H
	if(istype(M,/mob/living))
		H = M

	if(H && shard && M == user) //This needs a check for feeding the food to other people, but that could be abusable.
		H << "<span class='warning'>You lacerate your mouth on a [shard.name] in the sandwich!</span>"
		H.adjustBruteLoss(5) //TODO: Target head if human.
	..()
