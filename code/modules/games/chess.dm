#define CHESS_WHITE "w"
#define CHESS_BLACK "b"

GLOBAL_DATUM_INIT(chessboard_state, /datum/ui_state/chessboard_state, new)

/// Keeps remote spectators subscribed forever while only allowing players or adjacent living users to interact.
/datum/ui_state/chessboard_state/can_use_topic(src_object, mob/user)
	if(!user?.client)
		return UI_CLOSE
	var/obj/item/chessboard/chessboard = src_object
	if(!istype(chessboard))
		return UI_CLOSE
	var/user_status = user.shared_ui_interaction(chessboard)
	if(chessboard.is_board_player(user))
		return max(UI_UPDATE, user_status)
	if(isliving(user) && chessboard.Adjacent(user))
		return max(UI_UPDATE, user_status)
	return UI_UPDATE

/// A self-contained chess set. The board is stored here so every open UI shares the same game.
/obj/item/chessboard
	name = "chess set"
	desc = "A simple chess set with magnetic pieces."
	icon = 'icons/obj/pieces.dmi'
	icon_state = "board"
	w_class = WEIGHT_CLASS_NORMAL
	drop_sound = 'sound/items/drop/wood_sheet.ogg'
	pickup_sound = 'sound/items/pickup/wood_sheet.ogg'
	var/list/board
	var/mob/white_player
	var/mob/black_player
	var/computer_color
	var/computer_difficulty = "casual"
	var/turn = CHESS_WHITE
	var/game_status = "waiting"
	var/en_passant_square
	var/white_can_castle_kingside = TRUE
	var/white_can_castle_queenside = TRUE
	var/black_can_castle_kingside = TRUE
	var/black_can_castle_queenside = TRUE
	var/last_from
	var/last_to
	var/list/captured_pieces
	var/position_version = 0

/obj/item/chessboard/Initialize()
	. = ..()
	reset_board()

/obj/item/chessboard/mechanics_hints(mob/user, distance, is_adjacent)
	. = ..()
	. += "You can <b>left-click</b> the board to open it, or <b>Shift-click</b> it to watch from any distance."
	. += "A seated player can <b>click-drag the board onto themselves</b> to pick it up. Its mag-clamps reject non-players."

/obj/item/chessboard/attack_self(mob/user)
	ui_interact(user)

/obj/item/chessboard/attack_hand(mob/user)
	ui_interact(user)

/obj/item/chessboard/attack_ai(mob/user)
	ui_interact(user)

/obj/item/chessboard/attack_ghost(mob/abstract/ghost/user)
	ui_interact(user)

/obj/item/chessboard/ShiftClick(mob/user)
	ui_interact(user)

/obj/item/chessboard/mouse_drop_dragged(atom/over, mob/user, src_location, over_location, params)
	if(over != user || use_check_and_message(user))
		return
	if(!do_additional_pickup_checks(user))
		return
	pickup(user)
	user.put_in_hands(src)

/obj/item/chessboard/do_additional_pickup_checks(mob/user)
	if(game_status == "playing" && !is_board_player(user))
		to_chat(user, SPAN_WARNING("The mag-clamps prevent you, as a non-player, from picking up [src]!"))
		return FALSE
	return ..()

/obj/item/chessboard/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "You can <b>left-click</b> the board to open it, or <b>Shift-click</b> it to watch from any distance."
	. += "A seated player can <b>click-drag the board onto themselves</b> to pick it up. Its mag-clamps reject non-players."

/obj/item/chessboard/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Chess", "Folding Chess Set", 500, 590)
		ui.open()

/obj/item/chessboard/ui_state(mob/user)
	return GLOB.chessboard_state

/obj/item/chessboard/ui_data(mob/user)
	clear_disconnected_players()
	var/list/data = list()
	data["board"] = board
	data["white_player"] = white_player ? white_player.name : (computer_color == CHESS_WHITE ? "Chess computer" : null)
	data["black_player"] = black_player ? black_player.name : (computer_color == CHESS_BLACK ? "Chess computer" : null)
	data["user_color"] = user == white_player ? CHESS_WHITE : (user == black_player ? CHESS_BLACK : null)
	data["computer_color"] = computer_color
	data["computer_difficulty"] = computer_difficulty
	data["orientation"] = user == black_player ? CHESS_BLACK : CHESS_WHITE
	data["turn"] = turn
	data["status"] = game_status
	data["en_passant"] = isnull(en_passant_square) ? -1 : en_passant_square
	data["white_castle_kingside"] = white_can_castle_kingside
	data["white_castle_queenside"] = white_can_castle_queenside
	data["black_castle_kingside"] = black_can_castle_kingside
	data["black_castle_queenside"] = black_can_castle_queenside
	data["last_from"] = last_from
	data["last_to"] = last_to
	data["captured"] = captured_pieces
	data["position_version"] = position_version
	return data

/obj/item/chessboard/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return TRUE

	var/mob/user = ui.user
	clear_disconnected_players()
	add_fingerprint(user)
	switch(action)
		if("join")
			if(!isliving(user) || !Adjacent(user))
				return TRUE
			var/chosen_color = params["color"]
			if(user == white_player || user == black_player || computer_color)
				return TRUE
			if(chosen_color == CHESS_WHITE && !white_player)
				white_player = user
			else if(chosen_color == CHESS_BLACK && !black_player)
				black_player = user
			else
				return TRUE
			if(both_sides_seated() && game_status == "waiting")
				game_status = "playing"
			visible_message(SPAN_NOTICE("[user] takes the [chosen_color == CHESS_WHITE ? "white" : "black"] side at [src]."))

		if("start_solo")
			if(!isliving(user) || !Adjacent(user))
				return TRUE
			if(white_player || black_player || computer_color)
				return TRUE
			var/human_color = params["color"]
			var/difficulty = params["difficulty"]
			if(!(human_color in list(CHESS_WHITE, CHESS_BLACK)) || !(difficulty in list("novice", "casual", "club", "expert")))
				return TRUE
			reset_board()
			computer_color = human_color == CHESS_WHITE ? CHESS_BLACK : CHESS_WHITE
			computer_difficulty = difficulty
			if(human_color == CHESS_WHITE)
				white_player = user
			else
				black_player = user
			game_status = "playing"
			visible_message(SPAN_NOTICE("[user] starts a solo game at [src]."))

		if("leave")
			if(user == white_player)
				white_player = null
			else if(user == black_player)
				black_player = null
			else
				return TRUE
			if(computer_color)
				computer_color = null
			if(game_status == "playing")
				game_status = "waiting"

		if("move", "computer_move")
			if(game_status != "playing")
				return TRUE
			var/user_color = user == white_player ? CHESS_WHITE : (user == black_player ? CHESS_BLACK : null)
			if(!user_color)
				return TRUE
			if(action == "move" && user_color != turn)
				return TRUE
			if(action == "computer_move" && (computer_color != turn || user_color == turn))
				return TRUE
			var/from = text2num(params["from"])
			var/destination = text2num(params["to"])
			if(!isnum(from) || !isnum(destination) || from < 0 || from > 63 || destination < 0 || destination > 63)
				return TRUE
			if(text2num(params["position_version"]) != position_version)
				balloon_alert(user, "board changed")
				return TRUE
			if(copytext(board[from + 1], 1, 2) != turn)
				return TRUE
			var/list/proposed_board = params["board"]
			if(!valid_board_state(proposed_board) || proposed_board[from + 1] != "")
				return TRUE
			apply_client_move(proposed_board, from, destination, params)

		if("resign")
			if(game_status != "playing")
				return TRUE
			if(user == white_player)
				game_status = "black_wins"
			else if(user == black_player)
				game_status = "white_wins"
			else
				return TRUE
			visible_message(SPAN_NOTICE("[user] resigns their game at [src]."))

		if("reset")
			if(user != white_player && user != black_player)
				return TRUE
			if(game_status == "playing")
				balloon_alert(user, "finish this game first")
				return TRUE
			reset_board()
			if(both_sides_seated())
				game_status = "playing"

		else
			return FALSE

	return TRUE

/obj/item/chessboard/proc/clear_disconnected_players()
	var/seat_cleared = FALSE
	if(white_player && !white_player.client)
		white_player = null
		seat_cleared = TRUE
	if(black_player && !black_player.client)
		black_player = null
		seat_cleared = TRUE
	if(seat_cleared && game_status == "playing")
		game_status = "waiting"
	if(seat_cleared && computer_color)
		computer_color = null

/obj/item/chessboard/proc/is_board_player(mob/user)
	return user && (user == white_player || user == black_player)

/obj/item/chessboard/proc/both_sides_seated()
	var/white_seated = white_player || computer_color == CHESS_WHITE
	var/black_seated = black_player || computer_color == CHESS_BLACK
	return white_seated && black_seated

/obj/item/chessboard/proc/reset_board()
	board = list()
	board.len = 64
	for(var/index = 1 to 64)
		board[index] = ""
	var/list/back_rank = list("r", "n", "b", "q", "k", "b", "n", "r")
	for(var/file = 0 to 7)
		board[file + 1] = "[CHESS_BLACK][back_rank[file + 1]]"
		board[8 + file + 1] = "[CHESS_BLACK]p"
		board[48 + file + 1] = "[CHESS_WHITE]p"
		board[56 + file + 1] = "[CHESS_WHITE][back_rank[file + 1]]"
	turn = CHESS_WHITE
	game_status = "waiting"
	en_passant_square = null
	white_can_castle_kingside = TRUE
	white_can_castle_queenside = TRUE
	black_can_castle_kingside = TRUE
	black_can_castle_queenside = TRUE
	last_from = null
	last_to = null
	captured_pieces = list()
	position_version++

/// Schema validation only; chess rules are intentionally evaluated by TGUI.
/obj/item/chessboard/proc/valid_board_state(list/proposed_board)
	if(!islist(proposed_board) || length(proposed_board) != 64)
		return FALSE
	var/white_kings = 0
	var/black_kings = 0
	var/list/valid_pieces = list("", "wp", "wn", "wb", "wr", "wq", "wk", "bp", "bn", "bb", "br", "bq", "bk")
	for(var/piece in proposed_board)
		if(!(piece in valid_pieces))
			return FALSE
		if(piece == "wk")
			white_kings++
		else if(piece == "bk")
			black_kings++
	return white_kings == 1 && black_kings == 1

/// Commits the position already evaluated by the moving player's browser.
/obj/item/chessboard/proc/apply_client_move(list/proposed_board, from, destination, list/params)
	var/next_status = params["status"]
	if(!(next_status in list("playing", "white_wins", "black_wins", "draw")))
		next_status = "playing"
	var/client_en_passant = text2num(params["en_passant"])
	if(!isnum(client_en_passant) || client_en_passant < 0 || client_en_passant > 63)
		client_en_passant = null
	var/captured_piece = params["captured"]
	if(captured_piece in list("wp", "wn", "wb", "wr", "wq", "bp", "bn", "bb", "br", "bq"))
		captured_pieces += captured_piece

	board = proposed_board.Copy()
	white_can_castle_kingside = !!text2num(params["white_castle_kingside"])
	white_can_castle_queenside = !!text2num(params["white_castle_queenside"])
	black_can_castle_kingside = !!text2num(params["black_castle_kingside"])
	black_can_castle_queenside = !!text2num(params["black_castle_queenside"])
	en_passant_square = client_en_passant
	last_from = from
	last_to = destination
	turn = turn == CHESS_WHITE ? CHESS_BLACK : CHESS_WHITE
	game_status = next_status
	position_version++

#undef CHESS_WHITE
#undef CHESS_BLACK
