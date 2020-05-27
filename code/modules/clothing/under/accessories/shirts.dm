/obj/item/clothing/accessory/sweater
	name = "sweater"
	desc = "A warm knit sweater."
	desc_fluff = "Fortunately, it comes with Itch-Proof technology. The only thing they haven't invented is a better fashion sense for you, though."
	icon_state = "sweater"
	item_state = "sweater"

/obj/item/clothing/accessory/sweaterargyle
	name = "argyle sweater"
	desc = "A warm knit sweater with an argyle pattern."
	desc_fluff = "Never go unprepared for the next work-mandated secret santa with this fashion statement! Revel in their awkward thanks as they unbox it! Realize that you've received one too!"
	icon_state = "sweaterargyle"
	item_state = "sweaterargyle"

/obj/item/clothing/accessory/sweatervest
	name = "sweater vest"
	desc = "A warm knit sweater vest."
	desc_fluff = "Unlike a bulletproof vest, the only thing this'll protect you from is the opposite sex."
	icon_state = "sweatervest"
	item_state = "sweatervest"

/obj/item/clothing/accessory/sweatervestargyle
	name = "argyle sweater vest"
	desc = "A warm knit sweater vest with an argyle pattern."
	desc_fluff = "Reminds you of family picture day. Wearing this is entirely your own volition, unfortunately."
	icon_state = "sweaterargylevest"
	item_state = "sweaterargylevest"

/obj/item/clothing/accessory/sweaterturtleneck
	name = "turtleneck sweater"
	desc = "A warm knit turtleneck sweater."
	desc_fluff = "Engineered for the rigors of poetry club finger snapping."
	icon_state = "sweaterturtleneck"
	item_state = "sweaterturtleneck"

/obj/item/clothing/accessory/sweaterargyleturtleneck
	name = "argyle turtleneck sweater"
	desc = "A warm knit argyle turtleneck sweater."
	desc_fluff = "Now your clothing can be as stuffy as your personality."
	icon_state = "sweaterargyleturtleneck"
	item_state = "sweaterargyleturtleneck"

/obj/item/clothing/accessory/sweatertubeneck
	name = "tubeneck sweater"
	desc = "A warm knit tubeneck sweater."
	desc_fluff = "What the hell is cashmere anyway?"
	icon_state = "sweatertubeneck"
	item_state = "sweatertubeneck"

/obj/item/clothing/accessory/sweaterargyletubeneck
	name = "argyle tubeneck sweater"
	desc = "A warm knit argyle tubeneck sweater."
	desc_fluff = "Does not come with accompanying dog-sized version."
	icon_state = "sweaterargyletubeneck"
	item_state = "sweaterargyletubeneck"

/obj/item/clothing/accessory/dressshirt
	name = "dress shirt"
	desc = "A casual dress shirt."
	icon_state = "dressshirt"
	item_state = "dressshirt"

/obj/item/clothing/accessory/dressshirt_r
	name = "dress shirt"
	desc = "A casual dress shirt. This one has its sleeves rolled up."
	icon_state = "dressshirt_r"
	item_state = "dressshirt_r"

//Legacy
/obj/item/clothing/accessory/wcoat
	name = "waistcoat"
	desc = "For some classy, murderous fun."
	icon_state = "wcoat"
	item_state = "wcoat"

//New one that will actually be in the loadout
/obj/item/clothing/accessory/wcoat_rec
	name = "waistcoat"
	desc = "For some classy, murderous fun."
	icon_state = "wcoat_rec"
	item_state = "wcoat_rec"

/obj/item/clothing/accessory/longsleeve
	name = "long-sleeved shirt"
	desc = "A long-sleeved shirt made of light fabric."
	icon_state = "longshirt"
	item_state = "longshirt"

/obj/item/clothing/accessory/longsleeve_s
	name = "long-sleeved shirt"
	desc = "A long-sleeved shirt made of light fabric. This one is striped."
	icon_state = "longshirt_s"
	item_state = "longshirt_s"

/obj/item/clothing/accessory/longsleeve_sb
	name = "long-sleeved shirt"
	desc = "A long-sleeved shirt made of light fabric. This one is striped."
	icon_state = "longshirt_sb"
	item_state = "longshirt_sb"

/obj/item/clothing/accessory/tshirt
	name = "t-shirt"
	desc = "A simple, cheap t-shirt."
	icon_state = "tshirt"
	item_state = "tshirt"

/obj/item/clothing/accessory/silversun
	name = "silversun floral shirt"
	desc = "A stylish Solarian shirt of Silversun design. It bears a floral design. This one is cyan."
	icon = 'icons/clothing/under/shirts/hawaiian.dmi'
	icon_state = "hawaii"
	item_state = "hawaii"
	contained_sprite = TRUE
	var/open = FALSE

/obj/item/clothing/accessory/silversun/verb/unbutton()
	set name = "Unbutton Shirt"
	set category = "Object"
	set src in usr

	if(!istype(usr, /mob/living))
		return
	if(use_check_and_message(usr))
		return

	var/mob/user = usr
	attack_self(user)

/obj/item/clothing/accessory/silversun/attack_self(mob/user)
	open = !open
	icon_state = "[initial(icon_state)][open ? "_open" : ""]"
	item_state = icon_state
	to_chat(user, span("notice", "You [open ? "open" : "close"] \the [src]."))
	// the below forces the shirt to hard reset its image so it resets later its fucking weird ok
	inv_overlay = null
	mob_overlay = null

/obj/item/clothing/accessory/silversun/red
	desc = "A stylish Solarian shirt of Silversun design. It bears a floral design. This one is crimson."
	icon_state = "hawaii_red"
	item_state = "hawaii_red"

/obj/item/clothing/accessory/silversun/random
	name = "silversun floral shirt"

/obj/item/clothing/accessory/silversun/random/Initialize()
	. = ..()
	if(prob(50))
		icon_state = "hawaii_red"
	color = color_rotation(rand(-11,12)*15)
