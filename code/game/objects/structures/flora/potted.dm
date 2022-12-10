
/obj/structure/flora/pottedplant
	name = "potted plant"
	icon = 'icons/obj/plants.dmi'
	icon_state = "plant-26"
	var/dead = 0
	var/obj/item/stored_item

/obj/structure/flora/pottedplant/Destroy()
	QDEL_NULL(stored_item)
	return ..()

/obj/structure/flora/pottedplant/proc/death()
	if (!dead)
		icon_state = "plant-dead"
		name = "dead [name]"
		desc = "It looks dead."
		dead = 1
//No complex interactions, just make them fragile
/obj/structure/flora/pottedplant/ex_act(var/severity = 2.0)
	death()
	return ..()

/obj/structure/flora/pottedplant/fire_act()
	death()
	return ..()

/obj/structure/flora/pottedplant/attackby(obj/item/W, mob/user)
	if(!ishuman(user))
		return
	if(istype(W, /obj/item/holder))
		return //no hiding mobs in there
	user.visible_message("[user] begins digging around inside of \the [src].", "You begin digging around in \the [src], trying to hide \the [W].")
	playsound(loc, 'sound/effects/plantshake.ogg', 50, 1)
	if(do_after(user, 20, act_target = src))
		if(!stored_item)
			if(W.w_class <= ITEMSIZE_NORMAL)
				user.drop_from_inventory(W,src)
				stored_item = W
				to_chat(user,"<span class='notice'>You hide \the [W] in [src].</span>")
				return
			else
				to_chat(user,"<span class='notice'>\The [W] can't be hidden in [src], it's too big.</span>")
				return
		else
			to_chat(user,"<span class='notice'>There is something hidden in [src].</span>")
			return
	return ..()

/obj/structure/flora/pottedplant/attack_hand(mob/user)
	user.visible_message("[user] begins digging around inside of \the [src].", "You begin digging around in \the [src], searching it.")
	playsound(loc, 'sound/effects/plantshake.ogg', 50, 1)
	if(do_after(user, 40, act_target = src))
		if(!stored_item)
			to_chat(user,"<span class='notice'>There is nothing hidden in [src].</span>")
		else
			if(istype(stored_item, /obj/item/device/paicard))
				stored_item.forceMove(src.loc)
				to_chat(user,"<span class='notice'>You reveal \the [stored_item] from [src].</span>")
			else
				user.put_in_hands(stored_item)
				to_chat(user,"<span class='notice'>You take \the [stored_item] from [src].</span>")
			stored_item = null

/obj/structure/flora/pottedplant/bullet_act(var/obj/item/projectile/Proj)
	if (prob(Proj.damage*2))
		death()
		return 1
	return ..()

//Added random icon selection for potted plants.
//It was silly they always used the same sprite when we have 26 sprites of them in the icon file
/obj/structure/flora/pottedplant/random/New()
	..()
	var/number = rand(1,36)
	if (number == 36)
		if (prob(90))//Make the weird one rarer
			number = rand(1,35)
		else if(!desc)
			desc = "A half-sentient plant borne from a mishap in a Zeng-Hu genetics lab."

	if(!desc)
		switch(number) //Wezzy's cool new plant description code. Special thanks to Sindorman.
			if(3)
				desc = "A bouquet of Bieselite flora."
			if(4)
				desc = "A bamboo plant. Used widely in Japanese crafts."
			if(5)
				desc = "Some kind of fern."
			if(7)
				desc = "A reedy plant mostly used for decoration in Skrell homes, admired for its luxuriant stalks."
			if(9)
				desc = "A fleshy cave dwelling plant with huge nodules for flowers."
			if(9)
				desc = "A scrubby cactus adapted to the Moghes deserts."
			if(13)
				desc = "A hardy succulent adapted to the Moghes deserts."
			if(14)
				desc = "That's a huge flower. Previously, the petals would be used in dyes for unathi garb. Now it's more of a decorative plant."
			if(15)
				desc = "A pitiful pot of stubby flowers."
			if(18)
				desc = "An orchid plant. As beautiful as it is delicate."
			if(19)
				desc = "A ropey, aquatic plant with crystaline flowers."
			if(20)
				desc = "A bioluminescent half-plant half-fungus hybrid. Said to come from Sedantis I."
			if(22)
				desc = "A cone shrub. Sadly doesn't come from Coney Island."
			if(26)
				desc = "A bulrush. Commonly referred to as cattail."
			if(27)
				desc = "A rose bush. Don't prick yourself."
			if(32)
				desc = "A woody shrub."
			if(33)
				desc = "A woody shrub. Seems to be in need of watering."
			if(34)
				desc = "A woody shrub. This one seems to be in bloom. It's just like one of my japanese animes."
			else
				desc = "Just your common, everyday houseplant."



	if (number < 10)
		number = "0[number]"
	icon_state = "plant-[number]"