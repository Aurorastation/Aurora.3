/obj/structure/dueling_table
	name = "dueling table"
	icon = 'icons/obj/battle_monsters/furniture.dmi'
	anchored = 1
	density = 1
	climbable = 1
	throwpass = 1

/obj/structure/dueling_table/no_colide
	density = 0

/obj/structure/dueling_table/no_colide/above_layer
	layer = ABOVE_MOB_LAYER

/obj/effect/decal/battlemonsters_logo
	name = "battlemonsters logo"
	icon = 'icons/obj/battle_monsters/logo.dmi'
	icon_state = "logo"
	anchored = 1
	density = 0
	mouse_opacity = 0

/obj/structure/dueling_table/attackby(obj/item/W as obj, mob/user as mob)
	user.drop_item(src.loc)
	return

/obj/machinery/vending/battlemonsters
	name = "\improper Battlemonsters vendor"
	desc = "A good place to dump all your rent money."
	icon_state = "battlemonsters"
	vend_id = "battlemonsters"
	products = list(
		/obj/item/weapon/book/manual/battlemonsters = 5,
		/obj/item/battle_monsters/wrapped = 20,
		/obj/item/battle_monsters/wrapped/pro = 10,
		/obj/item/battle_monsters/wrapped/rare = 2
	)
	prices = list(
		/obj/item/weapon/book/manual/battlemonsters = 10,
		/obj/item/battle_monsters/wrapped = 150,
		/obj/item/battle_monsters/wrapped/pro = 75,
		/obj/item/battle_monsters/wrapped/rare = 200,
		/obj/item/battle_monsters/wrapped/legendary = 400
	)
	contraband = list(
		/obj/item/battle_monsters/wrapped/legendary = 1
	)
	premium = list(
		/obj/item/weapon/coin/battlemonsters = 10
	)

	restock_items = 0