/obj/item/spellbook/druid
	spellbook_type = /datum/spellbook/druid

/datum/spellbook/druid
	name = "\improper druid's leaflet"
	feedback = "DL"
	desc = "It smells like an air freshener."
	book_desc = "Summons, nature, and a bit o' healin."
	title = "Druidic Guide on how to be smug about nature"
	title_desc = "Buy spells using your available spell slots. Artefacts may also be bought however their cost is permanent."
	book_flags = CAN_MAKE_CONTRACTS
	max_uses = 12

	spells = list(/spell/targeted/heal_target =						1,
				/spell/targeted/heal_target/sacrifice =				1,
				/spell/aoe_turf/conjure/mirage =					1,
				/spell/aoe_turf/conjure/summon/bats =				1,
				/spell/aoe_turf/conjure/summon/bear =				1,
				/spell/targeted/mend =								1,
				/spell/targeted/equip_item/party_hardy =			1,
				/spell/targeted/equip_item/seed =					1,
				/spell/aoe_turf/disable_tech =						1,
				/spell/targeted/entangle =							1,
				/spell/targeted/flesh_to_stone =					1,
				/spell/aoe_turf/conjure/grove/sanctuary =			1,
				/spell/aoe_turf/knock =								1,
				/spell/targeted/shapeshift/baleful_polymorph =		1,
				/spell/targeted/flesh_to_stone =					1,
				/spell/aoe_turf/conjure/golem =						1,
				/obj/structure/closet/wizard/souls =				1,
				/obj/item/monster_manual =							1,
				/obj/item/poppet =									1,
				/obj/item/contract/apprentice =						1
				)
