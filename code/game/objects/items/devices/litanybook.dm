/obj/item/device/litanybook

	name = "\improper tribunal codex"
	desc = "A holy text of the Moroz Holy Tribunal, the state religion of the Empire of Dominia."
	desc_fluff = "An almost mandatory possession for any Dominian household, containing a list of Edicts, litanies, and rituals."
	contained_sprite = TRUE
	icon = 'icons/obj/human_items.dmi'
	icon_state = "dominiabook"
	item_state = "dominiabook"

	drop_sound = 'sound/items/drop/cloth.ogg'

	pickup_sound = 'sound/items/pickup/cloth.ogg'

/obj/item/device/litanybook/attack_self(mob/user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.visible_message(SPAN_NOTICE("You flip through [src]."))

	var/q // recycled from tip of the day code. it just works!(TM)
	var/quip // in actuality it randomly determines a value, then uses that value to select a particular line from the txt below
	if(quip)
		q = quip
	else
		var/list/randomquip = file2list("ingame_manuals/dominia.txt")
		if(randomquip.len)
			q = pick(randomquip)

	if(do_after(user, 25))
		to_chat(user, "<span class='notice'>You notice a particular verse: [q]</span>")

/obj/item/device/litanybook/gadpathur

	name = "\improper gadpathurian morale manual"
	desc = "A popular Gadpathurian pocket guide, used to carry a fragment of the Commander's wisdom abroad."
	desc_fluff = "Manufactured using recycled paper and canvas. The wisdom within the text is based on the collected speeches of Commander Patvardhan and her assorted councillors."
	icon_state = "gadpathurbook"
	item_state = "gadpathurbook"

/obj/item/device/litanybook/gadpathur/attack_self(mob/user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.visible_message(SPAN_NOTICE("You flip through [src]."))

	var/q
	var/quip
	if(quip)
		q = quip
	else
		var/list/randomquip = file2list("ingame_manuals/gadpathur.txt") // had to copy-paste this code or there'll be dominia shit in here
		if(randomquip.len)
			q = pick(randomquip)

	if(do_after(user, 25))
		to_chat(user, "<span class='notice'>You recall the words of the Commander: [q]</span>")
