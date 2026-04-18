/datum/technomancer/spell/instability_tap
	name = "Instability Tap"
	desc = "Creates a large sum of energy (5,000 at normal spell power), at the cost of a very large amount of instability afflicting you."
	enhancement_desc = "50% more energy gained, 20% less instability gained."
	spell_power_desc = "Amount of energy gained scaled with spell power."
	cost = 100
	obj_path = /obj/item/spell/instability_tap
	ability_icon_state = "tech_instabilitytap"
	category = UTILITY_SPELLS

/obj/item/spell/instability_tap
	name = "instability tap"
	desc = "Short term gain for long term consequences never end bad, right?"
	cast_methods = CAST_USE
	aspect = ASPECT_UNSTABLE

/obj/item/spell/instability_tap/New()
	..()
	set_light_range_power_color(3, 2, "#FA58F4")
	set_light_on(TRUE)

/obj/item/spell/instability_tap/on_use_cast(mob/user)
	. = ..()
	var/amount = calculate_spell_power(5000)
	if(check_for_scepter())
		core.give_energy(amount * 1.5)
		adjust_instability(40)
	else
		core.give_energy(amount)
		adjust_instability(50)
	playsound(src, 'sound/effects/supermatter.ogg', 75, 1)
	qdel(src)
