/obj/item/spellbook/cleric
	spellbook_type = /datum/spellbook/cleric

/datum/spellbook/cleric
	name = "\improper cleric's tome"
	feedback = "CR"
	desc = "For those who do not harm, or at least feel sorry about it."
	book_desc = "All about healing and control. Mobility and offense comes at a higher price but not impossible."
	title = "Cleric's Tome of Healing"
	title_desc = "Buy spells using your available spell slots. Artefacts may also be bought however their cost is permanent."
	book_flags = CAN_MAKE_CONTRACTS
	max_uses = 12

	spells = list(/spell/targeted/heal_target =						1,
				/spell/targeted/heal_target/major =					1,
				/spell/targeted/heal_target/area =					1,
				/spell/targeted/heal_target/sacrifice =				1,
				/spell/targeted/resurrection =						2,
				/spell/targeted/mend =								1,
				/spell/targeted/genetic/blind =						1,
				/spell/targeted/shapeshift/baleful_polymorph =		1,
				/spell/targeted/flesh_to_stone =					1,
				/spell/targeted/projectile/dumbfire/stuncuff =		1,
				/spell/aoe_turf/knock =								1,
				/spell/targeted/equip_item/holy_relic =				1,
				/spell/aoe_turf/conjure/grove/sanctuary = 			1,
				/spell/targeted/projectile/dumbfire/fireball =		2,
				/spell/aoe_turf/conjure/forcewall =					1,
				/spell/targeted/subjugation =						1,
				/spell/targeted/mindcontrol =						2,
				/obj/item/gun/energy/staff/focus =					2,
				/obj/item/storage/belt/wands/full =					2,
				/obj/item/poppet =									1,
				/obj/item/contract/apprentice =						1
				)
