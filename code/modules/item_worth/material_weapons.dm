/obj/item/material
	var/worth_multiplier = 1

//Rule of thumb is: worth more than the parts put in
//Finished good is worth more than its individual parts
//todo, refactor this to be something like /obj/item/material_weapon/blah

/obj/item/material/kitchen
	worth_multiplier = 1.1

/obj/item/material/butterfly
	worth_multiplier = 8

/obj/item/material/harpoon
	worth_multiplier = 15

/obj/item/material/hatchet
	worth_multiplier = 6

/obj/item/material/minihoe
	worth_multiplier = 6

/obj/item/material/scythe
	worth_multiplier = 20

/obj/item/material/sword
	worth_multiplier = 30

/obj/item/material/twohanded/fireaxe
	worth_multiplier = 31

/obj/item/material/twohanded/spear
	worth_multiplier = 7 //blade + stuff

/obj/item/material/star
	worth_multiplier = 25