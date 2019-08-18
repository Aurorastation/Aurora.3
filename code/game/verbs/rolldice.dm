/client/verb/rolldice()
	set name = "Roll the Dice!"
	set desc = "Rolls the Dice of your choice!"
	set category = "OOC"

	var/list/choice = list(2, 4, 6, 8, 10, 12, 20, 50, 100)
	var/input = input("Select the Dice you want!", "Dice", null, null) in choice

	to_chat(usr, "<span class='notice'>You roll [rand(1,input)] out of [input]!</span>")