/datum/technomancer/spell/repel_missiles
	name = "Repel Missiles"
	desc = "Places a repulsion field around you, which attempts to deflect incoming bullets and lasers, making them 45% less likely \
	to hit you.  The field lasts for 10 minutes and can be granted to yourself or an ally."
	cost = 25
	obj_path = /obj/item/spell/modifier/repel_missiles
	ability_icon_state = "tech_repelmissiles"
	category = SUPPORT_SPELLS

/obj/item/spell/modifier/repel_missiles
	name = "repel missiles"
	desc = "Use it before they start shooting at you!"
	icon_state = "generic"
	cast_methods = CAST_RANGED
	aspect = ASPECT_FORCE
	light_color = "#FF5C5C"
	modifier_type = /datum/modifier/technomancer/repel_missiles
	modifier_duration = 10 MINUTES

/datum/modifier/technomancer/repel_missiles
	name = "repel_missiles"
	desc = "A repulsion field can always be useful to have."
	mob_overlay_state = "repel_missiles"

	on_created_text = "<span class='notice'>You have a repulsion field around you, which will attempt to deflect projectiles.</span>"
	on_expired_text = "<span class='warning'>Your repulsion field has expired.</span>"
	evasion = 45
	stacks = MODIFIER_STACK_EXTEND //TODOMATT: Tick this file and figure this out