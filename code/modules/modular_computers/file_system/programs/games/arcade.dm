/datum/computer_file/program/game/arcade
	filename = "arcadec"					// File name, as shown in the file browser program.
	filedesc = "Unknown Game"				// User-Friendly name. In this case, we will generate a random name in constructor.
	program_icon_state = "game"				// Icon state of this program's screen.
	program_key_icon_state = "black_key"
	extended_desc = "Fun for the whole family! Probably not an AAA title, but at least you can download it on the corporate network.."		// A nice description.
	size = 2								// Size in GQ. Integers only. Smaller sizes should be used for utility/low use programs (like this one), while large sizes are for important programs.
	requires_ntnet = FALSE					// This particular program does not require NTNet network conectivity...
	available_on_ntnet = TRUE				// ... but we want it to be available for download.
	color = LIGHT_COLOR_BLUE
	usage_flags = PROGRAM_ALL_REGULAR
	tgui_id = "NTOSArcade"
	var/player_mana
	var/player_health
	var/enemy_mana
	var/enemy_health
	var/enemy_name = "Greytide Horde"
	var/gameover
	var/information

// Blatantly stolen and shortened version from arcade machines. Generates a random enemy name
/datum/computer_file/program/game/arcade/proc/random_enemy_name()
	var/name_part1 = pick("The Automatic", "Farmer", "Lord", "Professor", "The Cuban", "The Evil", "The Dread King", "The Space", "Lord", "The Great", "Duke", "General", "The Vibrating Bluespace", "Scalie")
	var/name_part2 = pick("Melonoid", "Murdertron", "Sorcerer", "Ruin", "Jeff", "Geoff", "Ectoplasm", "Crushulon", "Uhangoid", "Vhakoid", "Peteoid", "Slime", "Lizard Man", "Unicorn", "Squirrel")
	return "[name_part1] [name_part2]"

// When the program is first created, we generate a new enemy name and name ourselves accordingly.
/datum/computer_file/program/game/arcade/New()
	..()
	enemy_name = random_enemy_name()
	filedesc = "[pick("Defeat", "Destroy", "Decimate", "Decapitate")] [enemy_name]"
	new_game()

// Important in order to ensure that copied versions will have the same enemy name.
/datum/computer_file/program/game/arcade/clone()
	var/datum/computer_file/program/game/arcade/G = ..()
	G.enemy_name = enemy_name
	return G

/datum/computer_file/program/game/arcade/ui_data(mob/user)
	var/list/data = initial_data()

	data["player_health"] = player_health
	data["player_mana"] = player_mana
	data["enemy_health"] = enemy_health
	data["enemy_mana"] = enemy_mana
	data["enemy_name"] = enemy_name
	data["gameover"] = gameover
	data["information"] = information

	return data

/datum/computer_file/program/game/arcade/proc/enemy_play()
	if((enemy_mana < 5) && prob(60))
		var/steal = rand(2, 3)
		player_mana -= steal
		enemy_mana += steal
		information += " [enemy_name] steals [steal] of your power!"
	else if((enemy_health < 15) && (enemy_mana > 3) && prob(80))
		var/healamt = min(rand(3, 5), enemy_mana)
		enemy_mana -= healamt
		enemy_health += healamt
		information += " [enemy_name] heals for [healamt] health!"
	else
		var/dam = rand(3, 6)
		player_health -= dam
		information += " [enemy_name] attacks for [dam] damage!"

/datum/computer_file/program/game/arcade/proc/check_gameover()
	if((player_health <= 0) || player_mana <= 0)
		if(enemy_health <= 0)
			information += "You have defeated [enemy_name], but you have died in the fight!"
		else
			information += "You have been defeated by [enemy_name]!"
		gameover = TRUE
		return TRUE
	else if(enemy_health <= 0)
		gameover = TRUE
		information += "Congratulations! You have defeated [enemy_name]!"
		return TRUE
	return FALSE

/datum/computer_file/program/game/arcade/proc/new_game()
	player_mana = 10
	player_health = 30
	enemy_mana = 20
	enemy_health = 45
	gameover = FALSE
	information = "A new game has started!"

/datum/computer_file/program/game/arcade/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return
	if(action == "new_game")
		new_game()
		return
	if(gameover)
		return
	switch(action)
		if("attack")
			var/damage = rand(2, 6)
			information = "You attack for [damage] damage."
			enemy_health -= damage
			enemy_play()
			check_gameover()
			return TRUE
		if("heal")
			var/healfor = rand(6, 8)
			var/cost = rand(1, 3)
			information = "You heal yourself for [healfor] damage, using [cost] energy in the process."
			player_health += healfor
			player_mana -= cost
			enemy_play()
			check_gameover()
			return TRUE
		if("regain_mana")
			var/regen = rand(4, 7)
			information = "You rest for a while, regaining [regen] energy."
			player_mana += regen
			enemy_play()
			check_gameover()
			return TRUE
