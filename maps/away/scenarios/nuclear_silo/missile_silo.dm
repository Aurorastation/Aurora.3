/obj/structure/missile_silo
	name = "missile silo blast door"
	desc = "An enormous reinforced plasteel silo door. It is mechanically operated and can not be forced non-destructively."
	icon = 'icons/effects/missile_silo.dmi'
	icon_state = "silo"
	density = 1
	anchored = 1

/obj/structure/icbm
	name = "RS-20 nuclear ballistic missile"
	desc = "A Zavodskoi-designed hypersonic missile carrying a nuclear payload. With a maximum speed of over 20% the speed of light in vacuum or Mach 25 in atmosphere, interplanetary travel capability, and an accuracy to the meter, this missile forms a cornerstone of arsenals galaxy-wide, able to function as both an anti-orbital weapon and an intercontinental nuclear bomb, delivered anywhere on a planet or in a solar system. The nuclear warhead on this has enough power to level a city."
	icon = 'icons/effects/icbm.dmi'
	icon_state = "icbm"
	density = 1
	anchored = 1
	layer = ABOVE_HUMAN_LAYER
	pixel_x = 8
	pixel_y = 10

/obj/structure/ship_weapon_dummy/icbm_dummy
	name = "icbm dummy"
	layer = ABOVE_HUMAN_LAYER+0.1
