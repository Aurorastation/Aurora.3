/obj/item/spellbook/necromancer
	spellbook_type = /datum/spellbook/necromancer


/datum/spellbook/necromancer
	name = "\improper necromancer's grimoire"
	feedback = "NG"
	desc = "A grimoire full of spells dealing with the death and the afterlife."
	book_desc = "A spellbook full of dark magic dealing mostly with the afterlife."
	title = "The Art of Necromancy"
	title_desc = "Buy spells using your available spell slots. Artefacts may also be bought however their cost is permanent."
	book_flags = CAN_MAKE_CONTRACTS
	max_uses = 8

	spells = list(/spell/targeted/projectile/dumbfire/fireball =	1,
				/spell/targeted/torment =							1,
				/spell/targeted/subjugation =						1,
				/spell/targeted/lichdom =							2,
				/spell/aoe_turf/conjure/mirage =					1,
				/spell/aoe_turf/conjure/summon/bats =				1,
				/spell/targeted/shapeshift/corrupt_form =			1,
				/spell/targeted/life_steal =						1,
				/spell/targeted/raise_dead =						2,
				/spell/shadow_shroud =								1,
				/spell/noclothes =									1,
				/obj/structure/closet/wizard/armor =				1,
				/obj/structure/closet/wizard/scrying =				2,
				/obj/structure/closet/wizard/souls =				1,
				/obj/item/contract/apprentice =						1
				)
