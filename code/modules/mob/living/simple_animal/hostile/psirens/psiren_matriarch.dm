/mob/living/simple_animal/hostile/psiren/matriarch
	name = "Matriarch"
	icon = 'icons/mob/npc/psiren_matriarch.dmi'
	icon_state = "psiren_matriarch"
	icon_living = "psiren_matriarch"
	icon_dead = "psiren_matriarch_dead"
	health = 9999
	maxhealth = 9999
	// Speaks via Xenoglossia.
	universal_speak = TRUE
	universal_understand = TRUE
	mob_size = MOB_LARGE
	mob_weight = MOB_WEIGHT_SUPERHEAVY
	melee_damage_lower = 35
	melee_damage_upper = 40
	melee_reach = 2
	armor_penetration = 30
	meat_amount = 5
	meat_type = /obj/item/reagent_containers/food/snacks/squidmeat/psiren_tentacle_meat
	butchering_products = list(/obj/item/reagent_containers/food/snacks/squidmeat/psiren_body_meat = 5)

/mob/living/simple_animal/hostile/psiren/matriarch/Initialize()
	. = ..()
	add_spell(new /spell/targeted/eject_ink_cloud, "const_spell_ready")

/spell/targeted/eject_ink_cloud
	name = "Eject Ink Cloud"
	desc = "Eject a cloud of Lemurian fog."
	feedback = "CEIB"
	range = 0
	spell_flags = INCLUDEUSER
	charge_max = 30 SECONDS
	max_targets = 1

	invocation_type = SpI_EMOTE
	invocation = "ejects a cloud of Lemurian fog."

	hud_state = "cloud"

/spell/targeted/eject_ink_cloud/cast(mob/target, mob/living/user as mob)
	..()
	var/datum/effect/effect/system/smoke_spread/psiren/S = new/datum/effect/effect/system/smoke_spread/psiren()
	S.set_up(15, 0, user.loc, null)
	S.start()
	return TRUE
