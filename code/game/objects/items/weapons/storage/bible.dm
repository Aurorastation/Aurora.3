/obj/item/storage/bible
	name = "bible"
	desc = "A holy item, containing the written words of a religion."
	icon_state = "bible"
	item_state = "bible"
	icon = 'icons/obj/library.dmi'
	throw_speed = 1
	throw_range = 5
	w_class = WEIGHT_CLASS_SMALL // POKKET - geeves
	var/mob/affecting = null
	use_sound = 'sound/bureaucracy/bookopen.ogg'
	drop_sound = 'sound/bureaucracy/bookclose.ogg'

/obj/item/storage/bible/booze
	name = "bible"
	desc = "A holy item, containing the written words of a religion."
	icon_state = "bible"
	starts_with = list(
		/obj/item/reagent_containers/food/drinks/bottle/small/beer = 2,
		/obj/item/spacecash = 3
	)

/obj/item/storage/bible/afterattack(atom/A, mob/user as mob, proximity)
	if(!proximity)
		return
	if(user.mind && (user.mind.assigned_role == "Chaplain"))
		if(A.reagents && A.reagents.has_reagent(/singleton/reagent/water)) //blesses all the water in the holder
			if(REAGENT_VOLUME(A.reagents, /singleton/reagent/water) > 60)
				to_chat(user, SPAN_NOTICE("There's too much water for you to bless at once!"))
			else
				to_chat(user, SPAN_NOTICE("You bless the water in [A], turning it into holy water."))
				var/water2holy = REAGENT_VOLUME(A.reagents, /singleton/reagent/water)
				A.reagents.del_reagent(/singleton/reagent/water)
				A.reagents.add_reagent(/singleton/reagent/water/holywater, water2holy)

/obj/item/storage/bible/attackby(obj/item/attacking_item, mob/user)
	if(src.use_sound)
		playsound(src.loc, src.use_sound, 50, 1, -5)
	return ..()

/obj/item/storage/bible/verb/Set_Religion(mob/user)
	set name = "Set Religion"
	set desc = "Set your own religion."
	set src in usr

	if(use_check(user))
		return
	if(!ishuman(user))
		return

	var/religion_name = "Christianity"
	var/new_religion = sanitize(input(user, "Would you like to change your religion? Default is Christianity.", "Name change", religion_name), MAX_NAME_LEN)

	if(!new_religion)
		new_religion = religion_name

	var/book_name = sanitize(input(user, "Would you like the change your bible name? Default is holy bible.", "Book name change", name), MAX_NAME_LEN)

	if(book_name)
		name = book_name
	if(user.mind && (user.mind.assigned_role == "Chaplain"))
		SSticker.Bible_name = book_name

	var/new_book_style = tgui_input_list(user, "Which holy book style would you like?", "Holy Book", list("Generic", "Bible", "White Bible", "Melted Bible", "Quran", "Torah", "Holy Light", "Tome", "Scroll", "Guru", "The King in Yellow", "Ithaqua", "Trinary", "Stars", "Scrapbook", "Atheist", "Necronomicon"))
	switch(new_book_style)
		if("Bible")
			icon_state = "bible"
			item_state = "bible"
		if("White Bible")
			icon_state = "white"
			item_state = "white"
		if("Melted Bible")
			icon_state = "melted"
			item_state = "melted"
		if("Quran")
			icon_state = "quran"
			item_state = "quran"
		if("Torah")
			icon_state = "torah"
			item_state = "torah"
		if("Kojiki")
			icon_state = "kojiki"
			item_state = "kojiki"
		if("Holy Light")
			icon_state = "holylight"
			item_state = "holylight"
		if("Tome")
			icon_state = "tome"
			item_state = "tome"
		if("Scroll")
			icon_state = "scroll"
			item_state = "scroll"
		if("Ithaqua")
			icon_state = "ithaqua"
			item_state = "ithaqua"
		if("Trinary")
			icon_state = "trinary"
			item_state = "trinary"
		if("Guru")
			icon_state = "guru"
			item_state = "book"
		if("Stars")
			icon_state = "skrellbible"
			item_state = "skrellbible"
		if("Scrapbook")
			icon_state = "scrapbook"
			item_state = "scrapbook"
		if("Atheist")
			icon_state = "atheist"
			item_state = "atheist"
		if("Necronomicon")
			icon_state = "necronomicon"
			item_state = "necronomicon"
		if("Skrell")
			icon_state = "skrellbible"
			item_state = "skrellbible"
		if("Diona Eternal")
			icon_state = "eternal"
			item_state = "eternal"
		else
			var/randbook = "book" + pick("1", "2", "3", "4", "5", "6" , "7", "8", "9", "10", "11", "12", "13" , "14", "15" , "16")
			icon_state = randbook
			item_state = randbook

	if(user.mind && (user.mind.assigned_role == "Chaplain"))
		SSticker.Bible_icon_state = icon_state
		SSticker.Bible_item_state = item_state

	verbs -= /obj/item/storage/bible/verb/Set_Religion
