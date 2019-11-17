/obj/item/storage/bible
	name = "bible"
	desc = "Apply to head repeatedly."
	icon_state ="bible"
	icon = 'icons/obj/library.dmi'
	throw_speed = 1
	throw_range = 5
	w_class = 3.0
	var/mob/affecting = null
	use_sound = 'sound/bureaucracy/bookopen.ogg'
	drop_sound = 'sound/bureaucracy/bookclose.ogg'

/obj/item/storage/bible/booze
	name = "bible"
	desc = "To be applied to the head repeatedly."
	icon_state = "bible"
	starts_with = list(
		/obj/item/reagent_containers/food/drinks/bottle/small/beer = 2,
		/obj/item/spacecash = 3
	)

/obj/item/storage/bible/afterattack(atom/A, mob/user as mob, proximity)
	if(!proximity) return
	if(user.mind && (user.mind.assigned_role == "Chaplain"))
		if(A.reagents && A.reagents.has_reagent("water")) //blesses all the water in the holder
			to_chat(user, "<span class='notice'>You bless [A].</span>")
			var/water2holy = A.reagents.get_reagent_amount("water")
			A.reagents.del_reagent("water")
			A.reagents.add_reagent("holywater",water2holy)

/obj/item/storage/bible/attackby(obj/item/W as obj, mob/user as mob)
	if (src.use_sound)
		playsound(src.loc, src.use_sound, 50, 1, -5)
	..()

/obj/item/storage/bible/proc/Set_Religion(mob/user)
	if(use_check(user))
		return

	if(!ishuman(user))
		return

	var/religion_name = "Christianity"
	var/new_religion = sanitize(input(user, "You are the crew services officer. Would you like to change your religion? Default is Christianity, in SPACE.", "Name change", religion_name), MAX_NAME_LEN)

	if (!new_religion)
		new_religion = religion_name

	var/book_name = sanitize(input(user, "Would you like the change your bible name? Default is holy bible.", "Book name change", name), MAX_NAME_LEN)

	if (book_name)
		name = book_name
		SSticker.Bible_name = book_name

	var/new_book_style = input(user,"Which bible style would you like?") in list("Bible", "Quran", "Scrapbook", "Creeper", "White Bible", "Holy Light", "Atheist", "Tome", "The King in Yellow", "Ithaqua", "Scientology", "the bible melts", "Necronomicon")
	switch(new_book_style)
		if("Quran")
			icon_state = "quran"
			item_state = "quran"
		if("Scrapbook")
			icon_state = "scrapbook"
			item_state = "scrapbook"
		if("Creeper")
			icon_state = "creeper"
			item_state = "creeper"
		if("White Bible")
			icon_state = "white"
			item_state = "white"
		if("Holy Light")
			icon_state = "holylight"
			item_state = "holylight"
		if("Atheist")
			icon_state = "atheist"
			item_state = "atheist"
		if("Tome")
			icon_state = "tome"
			item_state = "tome"
		if("The King in Yellow")
			icon_state = "kingyellow"
			item_state = "kingyellow"
		if("Ithaqua")
			icon_state = "ithaqua"
			item_state = "ithaqua"
		if("Scientology")
			icon_state = "scientology"
			item_state = "scientology"
		if("the bible melts")
			icon_state = "melted"
			item_state = "melted"
		if("Necronomicon")
			icon_state = "necronomicon"
			item_state = "necronomicon"
		else
			icon_state = "bible"
			item_state = "bible"

	SSticker.Bible_icon_state = icon_state
	SSticker.Bible_item_state = item_state

	verbs -= /obj/item/storage/bible/proc/Set_Religion