#define CHASSIS_SMALL 1
#define CHASSIS_MEDIUM 2
#define CHASSIS_LARGE 4
#define CHASSIS_GATLING 8

#define TYPE_PISTOL 1
#define TYPE_CARBINE 2
#define TYPE_RIFLE 3
#define TYPE_GATLING 4

#define MOD_SILENCE 1
#define MOD_NUCLEAR_CHARGE 2

/obj/item/laser_components
	var/reliability = 100
	var/damage = 10
	armor_penetration = 0
	var/fire_delay = 0

/obj/item/laser_components/modifier
	name = "modifier"
	desc = "A basic laser weapon modifier."
	icon_state = "laser" // sprite
	item_state = "laser" // sprite
	var/mod_type

/obj/item/laser_components/capacitor
	name = "capacitor"
	desc = "A basic laser weapon capacitor."
	icon_state = "laser" // sprite
	item_state = "laser" // sprite
	var/shots = 5

/obj/item/laser_components/focusing_lens
	name = "focusing lens"
	desc = "A basic laser weapon focusing lens."
	icon_state = "laser" // sprite
	item_state = "laser" // sprite
	var/dispersion = 1
