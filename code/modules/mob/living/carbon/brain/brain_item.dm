/obj/item/organ/pariah_brain
	name = "brain remnants"
	desc = "Did someone tread on this? It looks useless for cloning or cyborgification."
	organ_tag = "brain"
	parent_organ = BP_HEAD
	icon = 'icons/mob/npc/alien.dmi'
	icon_state = "chitin"
	vital = 1

/obj/item/organ/internal/brain/xeno
	name = "thinkpan"
	desc = "It looks kind of like an enormous wad of purple bubblegum."
	icon = 'icons/mob/npc/alien.dmi'
	icon_state = "chitin"

/obj/item/organ/internal/brain/xeno/gain_trauma()
	return

/obj/item/organ/internal/brain/slime
	name = "slime core"
	desc = "A complex, organic knot of jelly and crystalline particles."
	robotic = 2
	icon = 'icons/mob/npc/slimes.dmi'
	icon_state = "green slime extract"
	can_lobotomize = 0

/obj/item/organ/internal/brain/golem
	name = "chelm"
	desc = "A tightly furled roll of paper, covered with indecipherable runes."
	robotic = 2
	icon = 'icons/obj/library.dmi'
	icon_state = "scroll"
	item_state = "scroll"
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_books.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_books.dmi'
		)
	can_lobotomize = 0
