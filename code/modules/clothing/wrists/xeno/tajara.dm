/obj/item/clothing/wrists/watch/tajara
	name = "adhomian watch"
	desc = "An adhomian wrist watch made for male Tajara. Due to its use in the past wars, wrist watches are becoming more popular in Adhomai."
	icon = 'icons/obj/tajara_items.dmi'
	icon_state = "watch_taj-male"
	item_state = "watch_taj-male"
	contained_sprite = TRUE

/obj/item/clothing/wrists/watch/tajara/checktime(mob/user)
	set category = "Object.Equipped"
	set name = "Check Time"
	set src in usr

	to_chat(usr, "You check your [name], glancing over at the watch face, reading the time to be '[tajaran_time()]'. Today's date is the '[tajaran_date()]th day of [tajaran_month()], [tajaran_year()]'.")

/obj/item/clothing/wrists/watch/tajara/female
	name = "adhomian watch"
	desc = "An adhomian wrist watch made for female Tajara. Due to its use in the past wars, wrist watches are becoming more popular in Adhomai."
	icon_state = "watch_taj-female"
	item_state = "watch_taj-female"
