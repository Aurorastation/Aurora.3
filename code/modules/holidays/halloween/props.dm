// Halloween Candle Pile
/obj/item/flame/candle/waxcandles
	name = "candle pile"
	desc = "A pile of half molten white wax candles, that seem to burn on forever."
	icon = 'icons/holidays/halloween/props.dmi'
	icon_state = "candles"
	item_state = "candles"
	light_color = "#E09D37"
	wax = 40000

/obj/item/flame/candle/waxcandles/Initialize()
	. = ..()
	light()

// Halloween Banner
/obj/structure/sign/flag/halloween
	name = "large halloween flag"
	desc = "A bright, purple flag with an orange rim, spelling out \"HAPPY HALLOWEEN\"."
	icon = 'icons/holidays/halloween/props.dmi'
	icon_state = "halloween"

/obj/item/flag/halloween/l
	name = "large halloween flag"
	flag_size = 1

/obj/structure/sign/flag/halloween/left
	icon_state = "halloween_l"

/obj/structure/sign/flag/halloween/right
	icon_state = "halloween_r"