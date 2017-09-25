/datum/event/shipping_error/start()
	var/datum/supply_order/O = new /datum/supply_order()
	O.ordernum = SScargo.ordernum
	O.object = SScargo.supply_packs[pick(SScargo.supply_packs)]
	O.orderedby = random_name(pick(MALE,FEMALE), species = "Human")
	SScargo.shoppinglist += O
