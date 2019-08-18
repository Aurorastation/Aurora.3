/client/verb/rolldice()
	set name = "Roll the Dice!"
	set desc = "Rolls the Dice of your choice!"
	set category = "OOC"

	var/list/choice = list(4, 6, 8, 10, 12, 20, 50, 100)
	var/input = input("Select the Dice you want!", "Dice", null, null) in choice

	var/conclusion = "[usr] rolls [rand(1,input)] out of [input]!"

	for(var/mob/O in viewers(src))
		to_chat(O, "<span class='notice'>[conclusion]</span>")