/obj/item/spellbook/spatial
	spellbook_type = /datum/spellbook/spatial

/datum/spellbook/spatial
	name = "\improper spatial manual"
	feedback = "SP"
	desc = "You feel like this might disappear from out of under you."
	book_desc = "Movement and teleportation. Run from your problems!"
	title = "Manual of Spatial Transportation"
	title_desc = "Buy spells using your available spell slots. Artefacts may also be bought however their cost is permanent."
	book_flags = CAN_MAKE_CONTRACTS
	max_uses = 10

	spells = list(/spell/targeted/ethereal_jaunt = 					1,
				/spell/aoe_turf/blink = 				1,
				/spell/area_teleport = 					1,
				/spell/targeted/projectile/dumbfire/passage = 		1,
				/spell/mark_recall = 					1,
				/spell/targeted/swap = 					1,
				/spell/targeted/projectile/magic_missile = 		2,
				/spell/aoe_turf/conjure/forcewall = 			1,
				/spell/targeted/subjugation = 					1,
				/spell/aoe_turf/smoke = 				1,
				/spell/aoe_turf/conjure/summon/bats = 			3,
				/obj/item/contract/wizard/tk = 			5,
				/obj/structure/closet/wizard/scrying = 			2,
				/obj/item/storage/belt/wands/full = 		4,
				/obj/item/teleportation_scroll = 		1,
				/obj/item/contract/apprentice = 			1
				)
