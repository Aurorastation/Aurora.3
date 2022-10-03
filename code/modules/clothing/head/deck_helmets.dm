/obj/item/clothing/head/deckhelmet
	name = "deck helmet"
	icon = 'icons/clothing/head/deckhelmet.dmi'
	desc = "A plastic helmet with a visor, used in hangars on many ships."
	icon_state = "deckcrew"
	item_state = "deckcrew"
	flags_inv = BLOCKHEADHAIR
	contained_sprite = TRUE
	armor = list(
		melee = ARMOR_MELEE_SMALL //they're just plastic helmets, protect you a bit from hitting your head while working in the hanger but not much more
	)

/obj/item/clothing/head/deckhelmet/green
	name = "green deck helmet"
	desc = "A plastic helmet with a visor, used by support staff in hangars on many ships."
	icon_state = "deckcrew_g"
	item_state = "deckcrew_g"

/obj/item/clothing/head/deckhelmet/blue
	name = "blue deck helmet"
	desc = "A plastic helmet with a visor, used by tug operators in hangars on many ships."
	icon_state = "deckcrew_b"
	item_state = "deckcrew_b"

/obj/item/clothing/head/deckhelmet/yellow
	name = "yellow deck helmet"
	desc = "A plastic helmet with a visor, used by traffic control in hangars on many ships."
	icon_state = "deckcrew_y"
	item_state = "deckcrew_y"

/obj/item/clothing/head/deckhelmet/purple
	name = "purple deck helmet"
	desc = "A plastic helmet with a visor, used by fueling personnel in hangars on many ships."
	icon_state = "deckcrew_p"
	item_state = "deckcrew_p"

 //uncomment when we get shipguns
/*/obj/item/clothing/head/deckhelmet/red
	name = "red deck helmet"
	desc = "A plastic helmet with a visor, used by munitions handlers in hangars on many ships."
	icon_state = "deckcrew_r"
	item_state = "deckcrew_r"
*/