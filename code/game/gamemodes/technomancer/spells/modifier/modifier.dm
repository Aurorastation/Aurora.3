/obj/item/spell/modifier
	name = "modifier template"
	desc = "Tell a coder if you can read this in-game."
	icon_state = "purify"
	cast_methods = CAST_MELEE
	var/modifier_type = null
	var/modifier_duration = null // Will last forever by default.  Final duration may differ due to 'spell power'
//	var/spell_color = "#03A728"
	var/spell_light_intensity = 2
	var/spell_light_range = 3

/obj/item/spell/modifier/Initialize()
	. = ..()
	set_light(spell_light_range, spell_light_intensity, l_color = light_color)

/obj/item/spell/modifier/on_melee_cast(atom/hit_atom, mob/user)
	if(isliving(hit_atom))
		return on_add_modifier(hit_atom)
	return FALSE

/obj/item/spell/modifier/on_ranged_cast(atom/hit_atom, mob/user)
	if(isliving(hit_atom))
		return on_add_modifier(hit_atom)
	return FALSE


/obj/item/spell/modifier/proc/on_add_modifier(var/mob/living/L)
	var/duration = modifier_duration
	if(duration)
		duration = round(duration * calculate_spell_power(1.0), 1)
	var/str = calculate_spell_power(1)
	L.add_modifier(modifier_type, 4, owner, 0, str, duration, 4) //the 4s here are MODIFIER_TIMED and MODIFIER_OVERRIDE_STRENGTHEN respectively, but apparently they are "undefined"
	log_and_message_admins("has casted [src] on [L].")
	qdel(src)
	return TRUE

// Technomancer specific subtype which keeps track of spell power and gets targeted specificially by Dispel.
/datum/modifier/technomancer
	var/on_created_text
	var/on_expired_text

/datum/modifier/technomancer/activate()
	..()
	to_chat(target, SPAN_WARNING(on_created_text))

/datum/modifier/technomancer/stop()
	..()
	to_chat(target, SPAN_WARNING(on_expired_text))