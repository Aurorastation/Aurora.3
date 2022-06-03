/obj/item/device/versebook
	name = "\improper versebook"
	desc = "If you see this, someone fucked up. Make a issue request."
	desc_fluff = "No, seriously. Make a issue request"
	contained_sprite = TRUE
	icon = 'icons/obj/human_items.dmi'
	icon_state = "dominiabook"
	item_state = "dominiabook"
	var/reading = FALSE

	drop_sound = 'sound/items/drop/book.ogg'

	pickup_sound = 'sound/items/pickup/book.ogg'

	var/list/randomquip = list()

/obj/item/device/versebook/attack_self(mob/user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)

	if(reading) //So you can't read twice.
		to_chat(usr, SPAN_WARNING("You are already reading this book."))
		return
	reading = TRUE //begin reading

	user.visible_message(SPAN_NOTICE("[user] begins to flip through [src]."))
	playsound(loc, 'sound/bureaucracy/bookopen.ogg', 50, 1)

	var/q // recycled from tip of the day code. it just works!(TM)
	var/quip // in actuality it randomly determines a value, then uses that value to select a particular line from the txt below
	if(quip)
		q = quip
	else
		if(randomquip.len)
			q = pick(randomquip)

	if(do_after(user, 25))
		to_chat(user, "<span class='notice'>You notice a particular verse: [q]</span>")
	reading = FALSE

/obj/item/device/versebook/tribunal
	name = "\improper tribunal codex"
	desc = "A holy text of the Moroz Holy Tribunal, the state religion of the Empire of Dominia."
	desc_fluff = "An almost mandatory possession for any Dominian household, containing a list of edicts, litanies, and rituals."
	icon_state = "dominiabook"
	item_state = "dominiabook"

/obj/item/device/versebook/tribunal/Initialize()
	. = ..()
	randomquip = file2list("ingame_manuals/dominia.txt")  //Needs a .txt file, each line is a 'verse' the book will randomly choose to display to user.

/obj/item/device/versebook/gadpathur
	name = "\improper gadpathurian morale manual"
	desc = "A popular Gadpathurian pocket guide, used to carry a fragment of the Commander's wisdom abroad."
	desc_fluff = "Manufactured using recycled paper and canvas. The wisdom within the text is based on the collected speeches of Commander Patvardhan and her assorted councillors."
	icon_state = "gadpathurbook"
	item_state = "gadpathurbook"

/obj/item/device/versebook/gadpathur/Initialize()
	. = ..()
	randomquip = file2list("ingame_manuals/gadpathur.txt")

/obj/item/device/versebook/biesel
	name = "\improper Constitution of The Federal Republic of Biesel"
	desc = "A common possession by Biesel government officals, the printed text of the constitution for the Federal Republic of Biesel and the Corporate Reconstruction Zone, adopted in 2452."
	desc_fluff = "This book has the Republic of Biesel's iconic symbol etched on the cover, the text within details the structure of the Federal Democracy the Republic is today."
	icon_state = "bieselbook"
	item_state = "bieselbook"

/obj/item/device/versebook/biesel/Initialize()
	. = ..()
	randomquip = file2list("ingame_manuals/biesel.txt")