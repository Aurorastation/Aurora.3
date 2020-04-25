/obj/item/spellbook/student
	spellbook_type = /datum/spellbook/student

/obj/item/spellbook/student/attack_self(mob/living/user as mob)
	if(user.is_wizard(TRUE))
		to_chat(user, "<span class='warning'>This books is written for students, not for a true wizard like yourself!</span>")
		return

	..()

/datum/spellbook/student
	name = "\improper student's spellbook"
	feedback = "ST"
	desc = "This spell book has a sticker on it that says, 'certified for children 5 and older'."
	book_desc = "This spellbook is dedicated to teaching neophytes in the ways of magic."
	title = "Book of Spells and Education"
	title_desc = "Buy spells using your available spell slots. Artefacts may also be bought however their cost is permanent."
	book_flags = 0
	max_uses = 8

	spells = list(/spell/targeted/mend =						1,
				/spell/aoe_turf/knock =							1,
				/spell/targeted/projectile/magic_missile =		1,
				/spell/aoe_turf/conjure/forcewall =				1,
				/spell/shadow_shroud =							1,
				/spell/aoe_turf/disable_tech =					1,
				/spell/targeted/entangle =						1,
				/spell/aoe_turf/knock =							1,
				/obj/structure/closet/wizard/armor =			1,
				/obj/item/gun/energy/staff/focus =				1,
				/obj/item/storage/belt/wands/full =				2,
				/obj/item/monster_manual =						2,
				/obj/item/contract/wizard/xray =				1
					)
