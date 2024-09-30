/singleton/cargo_item
	var/name = "generic cargo item"
	var/supplier = "generic supplier"
	var/description = "A basic cargo item."
	var/price = 1
	var/list/items = list()
	var/access = 0 //req_access level required to order/open the crate
	var/container_type = "crate" //what container it spawns in
	var/groupable = 1 //whether or not this can be combined with other items in a crate
	var/item_mul = 1

/singleton/cargo_item/security

/singleton/cargo_item/security/machinepistol
	name = ".45 machine pistol"
	supplier = "Zavodskoi Interstellar"
	description = "A lightweight, fast-firing gun."
	price = 1150
	items = list(
		/obj/item/gun/projectile/automatic/mini_uzi
	)
	access = 0
	container_type = "crate"
	groupable = 1
	item_mul = 1


/*
".45 machine pistol": {
				"name": ".45 machine pistol",
				"supplier": "zsc",
				"description": "A lightweight, fast firing gun.",
				"categories": [
					"security"
				],
				"price": 1150,
				"items": {
					"mini uzi": {
						"path": "/obj/item/gun/projectile/automatic/mini_uzi",
						"vars": []
					}
				},
				"access": 0,
				"container_type": "crate",
				"groupable": 1,
				"item_mul": 1
			},
*/
/singleton/cargo_item
	name = "Gold"
	description = "Gold is a dense, soft, shiny metal and the most malleable and ductile metal known."
	reagent_state = SOLID
	color = "#F7C430"
	taste_description = "expensive metal"
	fallback_specific_heat = 2.511
	value = 7
