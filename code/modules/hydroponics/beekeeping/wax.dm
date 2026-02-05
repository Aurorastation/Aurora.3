GLOBAL_LIST_INIT_TYPED(wax_recipes, /datum/stack_recipe, list(
	new /datum/stack_recipe("candle", /obj/item/flame/candle)
))

/obj/item/stack/wax
	name = "wax"
	singular_name = "wax piece"
	desc = "Soft substance produced by botany. Used to make candles."
	icon = 'icons/obj/beekeeping.dmi'
	icon_state = "wax"
	max_amount = 50

/obj/item/stack/wax/New()
	..()
	recipes = GLOB.wax_recipes
