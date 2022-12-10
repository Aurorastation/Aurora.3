#define ALLOWED_BOARD_TYPES list("c", "c-k", "h-ki", "h-qe", "h-b", "h-k", "h-r", "h-p")
#define ALLOWED_BOARD_FACTIONS list("red", "black")
#define IS_VALID_BOARD_POSITION(p) (p >= 0 && p < 64)

/obj/item/board
	name = "holo board"
	desc = "A standard 16\" holo checkerboard."
	icon = 'icons/obj/pieces.dmi'
	icon_state = "board"

	var/list/pieces = list()
	var/list/lastAction = null

/obj/item/board/attack_hand(mob/living/carbon/human/M as mob)
	if(!isturf(loc)) //so if you want to play the game, you need to put it down somewhere
		..()
	else
		if(ui_interact(M))
			..()
		

/obj/item/board/ui_interact(mob/user, var/datum/topic_state/state = default_state)
	var/datum/vueui/ui = SSvueui.get_open_ui(user, src)
	. = TRUE
	if (!ui)
		ui = new(user, src, "misc-boardgame", 450, 570, "Board", state = state)
		. = FALSE
	ui.open()

/obj/item/board/vueui_data_change(list/data, mob/user, datum/vueui/ui)
	data = data || list()
	. = data
	data["pieces"] = pieces
	data["last"] = lastAction

/obj/item/board/Topic(href, href_list)
	
	if(href_list["add"])
		if(pieces.len > 64)
			return
		if(verifyPiece(href_list["add"]["piece"]))
			pieces[++pieces.len] = href_list["add"]["piece"]

	if(href_list["change"])
		if(verifyPiece(href_list["change"]["piece"]) && isnum(href_list["change"]["index"]))
			lastAction = pieces[href_list["change"]["index"]]
			pieces[href_list["change"]["index"]] = href_list["change"]["piece"]

	
	if(href_list["remove"] && isnum(href_list["remove"]["index"]))
		lastAction = pieces[href_list["remove"]["index"]]
		pieces -= list(pieces[href_list["remove"]["index"]])
	
	SSvueui.check_uis_for_change(src)

/obj/item/board/proc/verifyPiece(var/list/piece)
	if(!(piece["type"] in ALLOWED_BOARD_TYPES))
		return FALSE
	if(!(piece["faction"] in ALLOWED_BOARD_FACTIONS))
		return FALSE
	if(!(IS_VALID_BOARD_POSITION(piece["pos"])))
		return FALSE
	return TRUE
	
#undef ALLOWED_BOARD_TYPES
#undef ALLOWED_BOARD_FACTIONS
#undef IS_VALID_BOARD_POSITION
