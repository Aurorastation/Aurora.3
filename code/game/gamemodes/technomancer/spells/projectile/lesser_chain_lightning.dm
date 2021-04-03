/datum/technomancer/spell/lesser_chain_lightning
	name = "Lesser Chain Lightning"
	desc = "This is very similar to the function Chain Lightning, however it is considerably less powerful.  As a result, it's a lot \
	more economical in terms of energy cost, as well as instability generation.  Lightning functions cannot miss due to distance."
	cost = 100
	obj_path = /obj/item/spell/projectile/chain_lightning/lesser
	ability_icon_state = "tech_chain_lightning"
	category = OFFENSIVE_SPELLS

/obj/item/spell/projectile/chain_lightning/lesser
	name = "lesser chain lightning"
	icon_state = "chain_lightning"
	desc = "Now you can throw around lightning like it's nobody's business."
	cast_methods = CAST_RANGED
	aspect = ASPECT_SHOCK
	spell_projectile = /obj/item/projectile/beam/chain_lightning
	energy_cost_per_shot = 1000
	instability_per_shot = 5
	cooldown = 10

/obj/item/projectile/beam/chain_lightning/lesser
	bounces = 2
	power = 20