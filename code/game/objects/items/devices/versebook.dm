/obj/item/device/versebook
	name = "\improper versebook"
	desc = "If you see this, someone fucked up. Make a issue request."
	desc_extended = "No, seriously. Make a issue request"
	icon = 'icons/obj/library.dmi'
	icon_state = "dominiabook"
	item_state = "dominia"
	w_class = WEIGHT_CLASS_SMALL
	/// Boolean that prevents reading multiple times
	var/reading = FALSE

	drop_sound = 'sound/items/drop/book.ogg'

	pickup_sound = 'sound/items/pickup/book.ogg'

	/// takes `file2list(FILE.txt)`. Each line in the .txt file is a verse that is randomly selected
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
		to_chat(user, SPAN_NOTICE("You notice a particular verse: [q]"))
	reading = FALSE

/obj/item/device/versebook/tribunal
	name = "\improper tribunal codex"
	desc = "A holy text of the Moroz Holy Tribunal, the state religion of the Empire of Dominia."
	desc_extended = "An almost mandatory possession for any Dominian household, containing a list of edicts, litanies, and rituals."
	icon_state = "dominiabook"
	item_state = "dominia"

/obj/item/device/versebook/tribunal/Initialize()
	. = ..()
	randomquip = file2list('texts/ingame_manuals/dominia.txt')  //Needs a .txt file, each line is a 'verse' the book will randomly choose to display to user.

/obj/item/device/versebook/gadpathur
	name = "\improper gadpathurian morale manual"
	desc = "A popular Gadpathurian pocket guide, used to carry a fragment of the Commander's wisdom abroad."
	desc_extended = "Manufactured using recycled paper and canvas. The wisdom within the text is based on the collected speeches of Commander Patvardhan and her assorted councillors."
	icon_state = "gadpathurbook"
	item_state = "gadpathur"

/obj/item/device/versebook/gadpathur/Initialize()
	. = ..()
	randomquip = file2list('texts/ingame_manuals/gadpathur.txt')

/obj/item/device/versebook/biesel
	name = "\improper Constitution of The Federal Republic of Biesel"
	desc = "A common possession by Biesel government officals, the printed text of the constitution for the Federal Republic of Biesel and the Corporate Reconstruction Zone, adopted in 2452."
	desc_extended = "This book has the Republic of Biesel's iconic symbol etched on the cover, the text within details the structure of the Federal Democracy the Republic is today."
	icon_state = "bieselbook"
	item_state = "biesel"

/obj/item/device/versebook/biesel/Initialize()
	. = ..()
	randomquip = file2list('texts/ingame_manuals/biesel.txt')

/obj/item/device/versebook/trinary
	name = "\improper The Order (abdridged version)"
	desc = "The holy text of the Trinary Perfection, who believe in synthetic perfection and eventual salvation."
	desc_extended = "This book contains some verses of the core beliefs of the Trinary Perfection, including some of the original works by the Corkfells, some additions by the prophet-like figure Flock, and a few recent additions by Ecclesiarch ARM-1DRIL. This is the abridged version, with only the core beliefs present."
	icon_state = "trinarybook"
	item_state = "trinary"

/obj/item/device/versebook/trinary/Initialize()
	. = ..()
	randomquip = file2list('texts/ingame_manuals/trinary.txt')

/obj/item/device/versebook/templeist
	name = "\improper The Voice of Temple (abdridged version)"
	desc = "The holy text of the Lodge of Temple Architect, an order within the Trinary Perfection that seeks to attain its goals via technological advancement and scientific discovery."
	desc_extended = "This book contains some of the words of Temple, a sacred AI within the Trinary Perfection and namesake of the Lodge of the Temple Architect. It also includes some teachings by leading members within the sect. Due to its recent establishment, this book is frequently changed and amended \
	as new insights into their faith are realized."
	icon_state = "templeistbook"
	item_state = "templeist"

/obj/item/device/versebook/templeist/Initialize()
	. = ..()
	randomquip = file2list('texts/ingame_manuals/templeist.txt')

/obj/item/device/versebook/siakh
	name = "\improper Writings of Judizah Si'akh"
	desc = "A collection of musings, commands and theological discussions, copied many times over from the alleged words of the controversial prophet Judizah Si'akh himself."
	desc_extended = "As close to a 'holy text' as the Si'akh faith has, this book can be found across Moghes and rarely beyond, despite efforts of the nobility to stamp out the firebrand religion. It lays down the \
	commandments and philosophies that a follower of Si'akh must live by, in the hope of redeeming themselves and their world from damnation."
	icon_state = "holybook"
	item_state = "book1"

/obj/item/device/versebook/siakh/Initialize()
	. = ..()
	randomquip = file2list('texts/ingame_manuals/siakh.txt')

/obj/item/device/versebook/autakh
	name = "\improper Reflections upon the Aut'akh Faith"
	desc = "An illegal tome in the Izweski Hegemony, Reflections is a short book penned by the Unathi known as Emzal Paossini, known by Aut'akh as 'Creator of Paradigms', infamous for their role in the creation of the Aut'akh faith."
	desc_extended = "The Aut'akh faith is highly decentralised and does not have holy texts per se. This book is simply a collection of personal musings from one of the Aut'akh's most influential figures.\
	While many of the core ideas of the faith can be traced back to Paossini's words, they are explicit in their desire that it not be venerated or treated as some divine mandate."
	icon_state = "book10"
	item_state = "book10"

/obj/item/device/versebook/autakh/Initialize()
	. = ..()
	randomquip = file2list('texts/ingame_manuals/autakh.txt')

/obj/item/device/versebook/skakh
	name = "\improper Sk'akh Legends"
	desc = "This is a collection of legends, commandments and doctrines of the Sk'akh faith, published by the Church."
	desc_extended = "Variations of this tome have been published for centuries, in one form or another, often changing to deal with recent developments for the Unathi people. This variation looks to have been published \
	fairly recently, and examining it shows several verses speaking on matters such as the new rise of the Aut'akh and Si'akh faiths."
	icon_state = "book3"
	item_state = "book3"

/obj/item/device/versebook/skakh/Initialize()
	. = ..()
	randomquip = file2list('texts/ingame_manuals/skakh.txt')

/obj/item/device/versebook/thakh
	name = "\improper collected Th'akh fables"
	desc = "Th'akh is a decentralised religion, with thousands of variants across Moghes and beyond. This book is a collection of common ancient tales and fables, translated from an archaic form of Sinta'Azaziba into Basic."
	desc_extended = "The tales of various Th'akh sects are numbered beyond count. This particular copy seems to be written by a shaman of the Court of Stars, and the names of their spirit-gods often crop up throughout the text."
	icon_state = "holybook"
	item_state = "book1"

/obj/item/device/versebook/thakh/Initialize()
	. = ..()
	randomquip = file2list('texts/ingame_manuals/thakh.txt')

/obj/item/device/versebook/assunzione
	name = "\improper Luceian Book of Scripture"
	desc = "A collection of historically-backed texts mixed with fables and stories detailing the reasonings, history, and beliefs of the Luceism religion of Assunzione. Translated into Basic by the Luceian Monastery on Biesel."
	desc_extended = "Luceism's founding was unusually well-documented for a religion, and as a result this book features several photographs of cataclysmic events that happened during Assunzione's crisis \
	that birthed this religion, as well as pictures of the religion's first ministers and the cataclysm that founded the religion to begin with."
	icon_state = "luce"
	item_state = "luce"

/obj/item/device/versebook/assunzione/Initialize()
	. = ..()
	randomquip = file2list('texts/ingame_manuals/assunzione.txt')

/obj/item/device/versebook/assunzione/pocket
	name = "pocket Luceian Book of Scripture"
	desc = "A miniaturized edition of the Luceian Book of Scripture, a collection of historically-backed texts mixed with fables and stories detailing the reasonings, history, and \
	beliefs of the Luceism religion of Assunzione. Translated into Basic by the Luceian Monastery on Biesel. This one fits nicely in a pocket or in a bag."
	icon_state = "luce_pocket"
	w_class = WEIGHT_CLASS_TINY

/// Tajaran Political Books

/obj/item/device/versebook/pra
	name = "\improper Hadiist Manifesto"
	desc = "A compact red book that outlines the principles of Hadiism, required reading for PRA citizens."
	desc_extended = "A political document supposedly written by Al’mari Hadii after the First Revolution. It is regarded as the foundation of the Hadiist Ideology. \
	It presents an analysis of the Tajaran situation post-conflict and how they could secure their future in the galaxy. \
	Its reading is mandatory in all Republican schools and copies can be found in most homes and public buildings."
	icon_state = "prabook"
	item_state = "pra"

/obj/item/device/versebook/pra/Initialize()
	. = ..()
	randomquip = file2list("texts/ingame_manuals/hadiism.txt")

/obj/item/device/versebook/dpra
	name = "\improper In Defense of Al'mari's Legacy"
	desc = "The manifesto of the Democratic People’s Republic of Adhomai’s founder, Supreme Commander Nated."
	desc_extended = "the political manifesto that laid the foundations of the Al’mariist ideology, written by Supreme Commander Nated briefly after the coup attempt. \
	The book denounces the rise of President Hadii as a betrayal of Al’mari’s vision for Adhomai. \
	The text is infamous for its xenophobia; alien influence is blamed as the main source of the Tajara’s problems."
	icon_state = "dprabook"
	item_state = "dpra"

/obj/item/device/versebook/dpra/Initialize()
	. = ..()
	randomquip = file2list("texts/ingame_manuals/almariism.txt")

/obj/item/device/versebook/nka
	name = "\improper The New Kingdom"
	desc = "This is a political text written by the New Kingdom of Adhomai’s first King Vahzirthaamro Azunja."
	desc_extended = "a political text written by King Vahzirthaamro Azunja during his time in hiding. \
	The book calls for the toppling of the Hadiist regime and the restoration of a constitutional monarchy. \
	The New Kingdom proposes the creation of a new political system to preserve the traditional Tajaran society while avoiding the pitfalls of the previous regime. \
	Copies were illegally published and smuggled all across Northern Harr'masir before the uprising."
	icon_state = "nkabook"
	item_state = "nka"

/obj/item/device/versebook/nka/Initialize()
	. = ..()
	randomquip = file2list("texts/ingame_manuals/royalism.txt")

/// Tajaran Religious Texts

/obj/item/device/versebook/twinsuns
	name = "\improper Holy Scrolls"
	desc = "An abridged collection of teachings for those worshipers of S’rendarr and Messa."
	desc_extended = "Books and teachings of the S’randmarr worship have seen numerous variations over the storied existence of the faith. \
	In recent times, many priests have taken to compiling their own copies of scripture and teachings for their local faithful \
	until the great Horde of Scrolls has been conquered."
	icon_state = "twinsunsbook"
	item_state = "twinsuns"

/obj/item/device/versebook/twinsuns/Initialize()
	. = ..()
	randomquip = file2list("texts/ingame_manuals/twinsuns.txt")

/obj/item/device/versebook/matake
	name = "\improper Ma'ta'ke legends"
	desc = "An abridged collection of stories and teachings from the Ma’ta’ke gods."
	desc_extended = "The Ma’ta’ke Gods and their worship has never been organized, \
	however the Kraszarrumalkarii, the priesthood of Kraszar, in achieving their priestly duties, \
	organize numerous volumes of stories and myths regarding the pantheon."
	icon_state = "matakebook"
	item_state = "matake"

/obj/item/device/versebook/matake/Initialize()
	. = ..()
	randomquip = file2list("texts/ingame_manuals/matake.txt")
