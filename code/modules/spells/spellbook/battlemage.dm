/obj/item/spellbook/battlemage
	spellbook_type = /datum/spellbook/battlemage


/datum/spellbook/battlemage
	name = "\improper battlemage's bible"
	feedback = "BM"
	desc = "A treatise on the use of magic in combat situation."
	book_desc = "Mix physical with the mystical in head to head combat."
	title = "The Art of Magical Combat"
	title_desc = "Buy spells using your available spell slots. Artefacts may also be bought however their cost is permanent."
	book_flags = CAN_MAKE_CONTRACTS
	max_uses = 12

	spells = list(/spell/targeted/equip_item/shield =				1,
				/spell/targeted/projectile/dumbfire/fireball =		1,
				/spell/targeted/projectile/magic_missile =			1,
				/spell/targeted/torment =							1,
				/spell/targeted/heal_target =						2,
				/spell/targeted/genetic/mutate =					1,
				/spell/targeted/projectile/dumbfire/stuncuff =		2,
				/spell/aoe_turf/conjure/mirage =					1,
				/spell/targeted/shapeshift/corrupt_form =			1,
				/spell/targeted/flesh_to_stone =					1,
				/spell/noclothes =									1,
				/obj/structure/closet/wizard/armor =				1,
				/obj/item/gun/energy/staff/focus =					1,
				/obj/item/gun/energy/staff/chaos =					1,
				/obj/item/storage/belt/wands/full =					2,
				/obj/item/melee/energy/wizard =						2,
				/obj/item/monster_manual =							2,
				/obj/item/contract/apprentice =						1
				)
