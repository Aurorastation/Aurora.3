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
	on_created_text = "<span class='warning'>You start to glow very brightly!</span>"
	on_expired_text = "<span class='notice'>Your glow has ended.</span>"
