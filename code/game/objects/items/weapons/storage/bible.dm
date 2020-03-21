/obj/item/storage/bible
	name = "bible"
	desc = "A holy item, containing the written words of a religion."
	icon_state = "bible"
	item_state = "bible"
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_books.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_books.dmi'
		)
	icon = 'icons/obj/library.dmi'
	throw_speed = 1
	throw_range = 5
	w_class = ITEMSIZE_SMALL // POKKET - geeves
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
		if(A.reagents && A.reagents.has_reagent("water")) //blesses all the water in the holder
			if(A.reagents.get_reagent_amount("water") > 60)
				to_chat(user, span("notice", "There's too much water for you to bless at once!"))
			else
				to_chat(user, span("notice", "You bless the water in [A], turning it into holy water."))
				var/water2holy = A.reagents.get_reagent_amount("water")
				A.reagents.del_reagent("water")
				A.reagents.add_reagent("holywater", water2holy)

/obj/item/storage/bible/attackby(obj/item/W as obj, mob/user as mob)
	if(src.use_sound)
		playsound(src.loc, src.use_sound, 50, 1, -5)
	..()

/obj/item/storage/bible/proc/Set_Religion(mob/user)
	if(use_check(user))
		return
	if(!ishuman(user))
		return

	var/religion_name = "Christianity"
	var/new_religion = sanitize(input(user, "You are the crew services officer. Would you like to change your religion? Default is Christianity, in SPACE.", "Name change", religion_name), MAX_NAME_LEN)

	if(!new_religion)
		new_religion = religion_name

	var/book_name = sanitize(input(user, "Would you like the change your bible name? Default is holy bible.", "Book name change", name), MAX_NAME_LEN)

	if(book_name)
		name = book_name
		SSticker.Bible_name = book_name

	var/new_book_style = input(user,"Which bible style would you like?") in list("Generic", "Bible", "White Bible", "Melted Bible", "Quran", "Torah", "Holy Light", "Tome", "Scroll", "The King in Yellow", "Ithaqua", "Trinary", "Stars", "Scrapbook", "Atheist", "Necronomicon")
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
		if("The King in Yellow")
			icon_state = "kingyellow"
			item_state = "kingyellow"
		if("Ithaqua")
			icon_state = "ithaqua"
			item_state = "ithaqua"
		if("Trinary")
			icon_state = "trinary"
			item_state = "trinary"
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
		else
			var/randbook = "book" + pick("1", "2", "3", "4", "5", "6" , "7")
			icon_state = randbook
			item_state = randbook

	SSticker.Bible_icon_state = icon_state
	SSticker.Bible_item_state = item_state

	verbs -= /obj/item/storage/bible/proc/Set_Religion
