/datum/technomancer/spell/corona
	name = "Corona"
	desc = "Causes the victim to glow very brightly, which while harmless in itself, makes it easier for them to be hit.  The \
	bright glow also makes it very difficult to be stealthy.  The effect lasts for one minute."
	cost = 50
	obj_path = /obj/item/spell/modifier/corona
	ability_icon_state = "tech_corona"
	category = SUPPORT_SPELLS

/obj/item/spell/modifier/corona
	name = "corona"
	desc = "How brilliant!"
	icon_state = "radiance"
	cast_methods = CAST_RANGED
	aspect = ASPECT_LIGHT
	light_color = "#D9D900"
	spell_light_intensity = 5
	spell_light_range = 3
	modifier_type = /datum/modifier/technomancer/corona
	modifier_duration = 1 MINUTE

/datum/modifier/technomancer/corona
	on_created_text = SPAN_WARNING("You start to glow very brightly!")
	on_expired_text = SPAN_NOTICE("Your glow has ended.")
	miss_chance_modifier = -25
	var/obj/effect/technomancer_corona/corona_light

/datum/modifier/technomancer/corona/activate()
	. = ..()
	if(!.)
		return
	corona_light = new(target)
	RegisterSignal(target, COMSIG_UNARMED_HARM_DEFENDER, PROC_REF(handle_harm_defend), override = TRUE)

/datum/modifier/technomancer/corona/deactivate()
	QDEL_NULL(corona_light)
	if(target)
		UnregisterSignal(target, COMSIG_UNARMED_HARM_DEFENDER)
	return ..()

/datum/modifier/technomancer/corona/proc/handle_harm_defend(mob/defender, mob/attacker, defender_skill_level, miss_chance, rand_damage, block_chance)
	SIGNAL_HANDLER
	*miss_chance = max(*miss_chance - 10, 0)

/obj/effect/technomancer_corona
	name = "corona"
	invisibility = INVISIBILITY_ABSTRACT
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	light_system = MOVABLE_LIGHT

/obj/effect/technomancer_corona/Initialize()
	. = ..()
	set_light_range_power_color(6, 4, "#D9D900")
	set_light_on(TRUE)
