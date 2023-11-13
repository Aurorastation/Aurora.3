/obj/item/device/versebook
	name = "\improper versebook"
	desc = "If you see this, someone fucked up. Make a issue request."
	desc_extended = "No, seriously. Make a issue request"
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_books.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_books.dmi',
		)
	icon = 'icons/obj/library.dmi'
	icon_state = "dominiabook"
	item_state = "dominia"
	w_class = ITEMSIZE_SMALL
	var/reading = FALSE

	drop_sound = 'sound/items/drop/book.ogg'

	pickup_sound = 'sound/items/pickup/book.ogg'

	var/list/randomquip = list()

/obj/item/device/versebook/attack_self(mob/user)
	if(!length(randomquip))
		return
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)

	if(reading) //So you can't read twice.
		to_chat(user, SPAN_WARNING("You are already reading this book."))
		return
	reading = TRUE //begin reading

	user.visible_message(SPAN_NOTICE("[user] begins to flip through [src]."))
	playsound(loc, 'sound/bureaucracy/bookopen.ogg', 50, 1)

	var/q // recycled from tip of the day code. it just works!(TM)
	q = pick(randomquip)

	if(do_after(user, 2.5 SECONDS))
		to_chat(user, "<span class='notice'>You notice a particular verse: [q]</span>")
	reading = FALSE

/obj/item/device/versebook/tribunal
	name = "\improper tribunal codex"
	desc = "A holy text of the Moroz Holy Tribunal, the state religion of the Empire of Dominia."
	desc_extended = "An almost mandatory possession for any Dominian household, containing a list of edicts, litanies, and rituals."
	icon_state = "dominiabook"
	item_state = "dominia"

/obj/item/device/versebook/tribunal/Initialize()
	. = ..()
	randomquip = file2list("ingame_manuals/dominia.txt")  //Needs a .txt file, each line is a 'verse' the book will randomly choose to display to user.

/obj/item/device/versebook/gadpathur
	name = "\improper gadpathurian morale manual"
	desc = "A popular Gadpathurian pocket guide, used to carry a fragment of the Commander's wisdom abroad."
	desc_extended = "Manufactured using recycled paper and canvas. The wisdom within the text is based on the collected speeches of Commander Patvardhan and her assorted councillors."
	icon_state = "gadpathurbook"
	item_state = "gadpathur"

/obj/item/device/versebook/gadpathur/Initialize()
	. = ..()
	randomquip = file2list("ingame_manuals/gadpathur.txt")

/obj/item/device/versebook/biesel
	name = "\improper Constitution of The Federal Republic of Biesel"
	desc = "A common possession by Biesel government officals, the printed text of the constitution for the Federal Republic of Biesel and the Corporate Reconstruction Zone, adopted in 2452."
	desc_extended = "This book has the Republic of Biesel's iconic symbol etched on the cover, the text within details the structure of the Federal Democracy the Republic is today."
	icon_state = "bieselbook"
	item_state = "biesel"

/obj/item/device/versebook/biesel/Initialize()
	. = ..()
	randomquip = file2list("ingame_manuals/biesel.txt")

/obj/item/device/versebook/trinary
	name = "\improper The Order (abdridged version)"
	desc = "The holy text of the Trinary Perfection, who believe in synthetic perfection and eventual salvation."
	desc_extended = "This book contains some verses of the core beliefs of the Trinary Perfection, including some of the original works by the Corkfells, some additions by the prophet-like figure Flock, and a few recent additions by Ecclesiarch ARM-1DRIL. This is the abridged version, with only the core beliefs present."
	icon_state = "trinarybook"
	item_state = "trinary"

/obj/item/device/versebook/trinary/Initialize()
	. = ..()
	randomquip = file2list("ingame_manuals/trinary.txt")

/obj/item/device/versebook/templeist
	name = "\improper The Voice of Temple (abdridged version)"
	desc = "The holy text of the Lodge of Temple Architect, an order within the Trinary Perfection that seeks to attain its goals via technological advancement and scientific discovery."
	desc_extended = "This book contains some of the words of Temple, a sacred AI within the Trinary Perfection and namesake of the Lodge of the Temple Architect. It also includes some teachings by leading members within the sect. Due to its recent establishment, this book is frequently changed and amended \
	as new insights into their faith are realized."
	icon_state = "templeistbook"
	item_state = "trinary"

/obj/item/device/versebook/templeist/Initialize()
	. = ..()
	randomquip = file2list("ingame_manuals/templeist.txt")

/obj/item/device/versebook/siakh
	name = "\improper Writings of Judizah Si'akh"
	desc = "A collection of musings, commands and theological discussions, copied many times over from the alleged words of the controversial prophet Judizah Si'akh himself."
	desc_extended = "As close to a 'holy text' as the Si'akh faith has, this book can be found across Moghes and rarely beyond, despite efforts of the nobility to stamp out the firebrand religion. It lays down the \
	commandments and philosophies that a follower of Si'akh must live by, in the hope of redeeming themselves and their world from damnation."
	icon_state = "holybook"
	item_state = "book1"

/obj/item/device/versebook/siakh/Initialize()
	. = ..()
	randomquip = file2list("ingame_manuals/siakh.txt")

/obj/item/device/versebook/autakh
	name = "\improper Reflections upon the Aut'akh Faith"
	desc = "An illegal tome in the Izweski Hegemony, Reflections is a short book penned by the Unathi known as Emzal Paossini, known by Aut'akh as 'Creator of Paradigms', infamous for their role in the creation of the Aut'akh faith."
	desc_extended = "The Aut'akh faith is highly decentralised and does not have holy texts per se. This book is simply a collection of personal musings from one of the Aut'akh's most influential figures.\
	While many of the core ideas of the faith can be traced back to Paossini's words, they are explicit in their desire that it not be venerated or treated as some divine mandate."
	icon_state = "book10"
	item_state = "book10"

/obj/item/device/versebook/autakh/Initialize()
	. = ..()
	randomquip = file2list("ingame_manuals/autakh.txt")

/obj/item/device/versebook/skakh
	name = "\improper Sk'akh Legends"
	desc = "This is a collection of legends, commandments and doctrines of the Sk'akh faith, published by the Church."
	desc_extended = "Variations of this tome have been published for centuries, in one form or another, often changing to deal with recent developments for the Unathi people. This variation looks to have been published \
	fairly recently, and examining it shows several verses speaking on matters such as the new rise of the Aut'akh and Si'akh faiths."
	icon_state = "book3"
	item_state = "book3"

/obj/item/device/versebook/skakh/Initialize()
	. = ..()
	randomquip = file2list("ingame_manuals/skakh.txt")

/obj/item/device/versebook/thakh
	name = "\improper collected Th'akh fables"
	desc = "Th'akh is a decentralised religion, with thousands of variants across Moghes and beyond. This book is a collection of common ancient tales and fables, translated from an archaic form of Sinta'Azaziba into Basic."
	desc_extended = "The tales of various Th'akh sects are numbered beyond count. This particular copy seems to be written by a shaman of the Court of Stars, and the names of their spirit-gods often crop up throughout the text."
	icon_state = "holybook"
	item_state = "book1"

/obj/item/device/versebook/thakh/Initialize()
	. = ..()
	randomquip = file2list("ingame_manuals/thakh.txt")

