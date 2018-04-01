/datum/language/kocasslani
	name = "Neo-Kocasslani"
	desc = "The enigmatic rune-speech of the belligerent Neo-Kocasslani people. A necessity in the warlike death worlds, it becomes a burden to civilized society."
	speech_verb = "screeches"
	ask_verb = "warbles"
	exclaim_verb = "roars"
	colour = "vox"
	key = "m"
	flags = NO_STUTTER
	syllables = list("az","ash","agh","bag","bub","dug","durb","ghash","gimb","glob","gul","hai","ishi","krimp","lug","nazg","og","ol","ronk","skai","shar","sha","sna","ga","thrak","ur","uk")

/datum/language/kocasslani/get_random_name()
	var/new_name = "[pick(list("Az","Ash","Agh","Bag","Bub","Dug","Durb","Ghash","Gimb","Glob","Gul","Hai","Ishi","Krimp","Lug","Nazg","Og","Ol","Ronk","Skai","Shar","Sha","Sna","Ga","Thrak","Ur","Uk"))]"
	var/max = rand(1,3)
	for(var/i=0;i<= max;i++)
		if(i != max && prob(50/max))
			new_name += "[pick(list("-","-","-","'","'","'"))]"
		new_name += "[pick(list("az","ash","agh","bag","bub","dug","durb","ghash","gimb","glob","gul","hai","ishi","krimp","lug","nazg","og","ol","ronk","skai","shar","sha","sna","ga","thrak","ur","uk"))]"
	return new_name