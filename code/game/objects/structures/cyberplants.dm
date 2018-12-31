/obj/structure/cyberplant
	name = "Asters \"FluorescEnt\""
	desc = "One of those famous Aster's holoplants! Add to your Space a bit of the comfort from old Earth, by buying this blue buddy. A nuclear battery and a rugged case guarantee that your flower will survive journey to another galaxy, and variety of plant types won't let you to get bored along the way!"
	icon = 'icons/obj/cyberplants.dmi'
	icon_state = "holopot"
	var/brightness_on = 4
	var/emagged = FALSE
	var/interference = FALSE
	var/icon/plant = null
	var/plant_color
	var/glow_color
	var/hologram_opacity = 0.85
	var/global/list/possible_plants = list(
		"plant-1",
		"plant-10",
		"plant-09",
		"plant-15",
		"plant-13",
		"plant-xmas",
		"plant-03",
		"plant-08",
		"plant-02",
		"plant-04",
		"plant-06",
		"plant-07",
		"plant-14",
		"plant-16",
		"plant-17",
		"plant-21",
		"plant-22",
		"plant-35",
		"plant-36",
	)
	var/global/list/possible_colors = list(
		rgb(60, 148, 197),
		COLOR_NAVY_BLUE,
		COLOR_GREEN,
		COLOR_MAROON,
		COLOR_PURPLE,
		COLOR_VIOLET,
		COLOR_OLIVE,
		COLOR_BROWN_ORANGE,
		COLOR_DARK_ORANGE,
		COLOR_SEDONA,
		COLOR_DARK_BROWN,
		COLOR_BLUE,
		COLOR_DEEP_SKY_BLUE,
		COLOR_LIME,
		COLOR_CYAN,
		COLOR_TEAL,
		COLOR_RED,
		COLOR_PINK,
		COLOR_ORANGE,
		COLOR_YELLOW,
		COLOR_SUN,
		COLOR_BLUE_LIGHT,
		COLOR_RED_LIGHT,
		COLOR_BEIGE,
		COLOR_LUMINOL,
		COLOR_SILVER,
		COLOR_WHITE,
		COLOR_NT_RED,
		COLOR_BOTTLE_GREEN,
		COLOR_CHESTNUT,
		COLOR_BEASTY_BROWN,
		COLOR_WHEAT,
		COLOR_CYAN_BLUE,
		COLOR_LIGHT_CYAN,
		COLOR_PAKISTAN_GREEN,
		COLOR_HULL,
		COLOR_AMBER,
		COLOR_SKY_BLUE,
		COLOR_CIVIE_GREEN,
		COLOR_DARK_GUNMETAL,
	)

/obj/structure/cyberplant/Initialize()
	..()
	change_plant(plant)
	change_color(plant_color)

	update_icon()

	set_light(brightness_on, brightness_on/2)

/obj/structure/cyberplant/update_icon()
	..()
	overlays.Cut()
	if (!plant)
		return

	plant.ChangeOpacity(hologram_opacity)
	overlays += plant

/obj/structure/cyberplant/proc/change_plant(var/state)
	plant = prepare_icon(state)

/obj/structure/cyberplant/proc/change_color(var/color)
	if (!plant)
		return

	if(!color)
		color = pick(possible_colors)

	glow_color = color
	plant_color = color
	plant.ColorTone(color)

	set_light(l_color=color)

/obj/structure/cyberplant/attack_hand(var/mob/user)
	if(!interference)
		if (prob(1))
			change_plant("emagged")
		else
			change_plant()
		update_icon()

/obj/structure/cyberplant/proc/prepare_icon(var/state)
	if(!state)
		state = pick(possible_plants)

	var/plant_icon = icon(icon, state)
	return getHologramIcon(plant_icon, 0, hologram_opacity)

/obj/structure/cyberplant/emag_act()
	if(emagged)
		return

	emagged = TRUE
	plant = change_plant("emagged")

	update_icon()

/obj/structure/cyberplant/proc/doInterference()
	if(!interference)
		interference = TRUE
		spawn(0)
			if (!src || QDELETED(src))
				return

			overlays.Cut()
			set_light(0, 0)
			sleep(3)
			if (!src || QDELETED(src))
				return

			overlays += plant
			set_light(brightness_on, brightness_on/2)
			sleep(3)
			if (!src || QDELETED(src))
				return

			overlays -= plant
			set_light(0, 0)
			sleep(3)
			if (!src || QDELETED(src))
				return

			change_color()
			set_light(brightness_on, brightness_on/2)
			update_icon()

			interference = FALSE

/obj/structure/cyberplant/Crossed(var/mob/living/L)
	if (istype(L))
		doInterference()