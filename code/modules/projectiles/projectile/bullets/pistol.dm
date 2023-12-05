//Base values
/obj/item/projectile/bullet/pistol
	damage = 30
	armor_penetration = 0

//10mm. No changes for now, reference values from base values
/obj/item/projectile/bullet/pistol/civilian/coc
//	damage = 30
//	armor_penetration = 0

/obj/item/projectile/bullet/pistol/civilian/coc/rubber
	damage = 5
	check_armor = "melee"
	agony = 30
	embed = FALSE

//9mm
/obj/item/projectile/bullet/pistol/civilian/sol
	damage = 30
	armor_penetration = 5

/obj/item/projectile/bullet/pistol/civilian/sol/rubber
	damage = 5
	check_armor = "melee"
	agony = 30
	embed = FALSE

//4.6mm caseless
/obj/item/projectile/bullet/pistol/military/coc
	damage = 25
	armor_penetration = 15

/obj/item/projectile/bullet/pistol/military/coc/rubber
	damage = 5
	armor_penetration = 5
	check_armor = "melee"
	agony = 35
	embed = FALSE

//5.7mm
/obj/item/projectile/bullet/pistol/military/sol
	damage = 30
	armor_penetration = 10

/obj/item/projectile/bullet/pistol/military/sol/rubber
	damage = 5
	armor_penetration = 5
	check_armor = "melee"
	agony = 35
	embed = FALSE

//12mm
/obj/item/projectile/bullet/pistol/heavy
	damage = 45
	armor_penetration = 20

//.357 magnum
/obj/item/projectile/bullet/pistol/revolver
	damage = 40
	armor_penetration = 15

//.38 special
/obj/item/projectile/bullet/pistol/revolver/pocket
	armor_penetration = 10
