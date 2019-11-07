//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

proc/Intoxicated(phrase)
	phrase = html_decode(phrase)
	var/leng=lentext(phrase)
	var/counter=lentext(phrase)
	var/newphrase=""
	var/newletter=""
	while(counter>=1)
		newletter=copytext(phrase,(leng-counter)+1,(leng-counter)+2)
		if(rand(1,3)==3)
			if(lowertext(newletter)=="o")	newletter="u"
			if(lowertext(newletter)=="s")	newletter="ch"
			if(lowertext(newletter)=="a")	newletter="ah"
			if(lowertext(newletter)=="c")	newletter="k"
		switch(rand(1,7))
			if(1,3,5,8)	newletter="[lowertext(newletter)]"
			if(2,4,6,15)	newletter="[uppertext(newletter)]"
			if(7)	newletter+="'"
			//if(9,10)	newletter="<b>[newletter]</b>"
			//if(11,12)	newletter="<big>[newletter]</big>"
			//if(13)	newletter="<small>[newletter]</small>"
		newphrase+="[newletter]";counter-=1
	return newphrase

proc/NewStutter(phrase, str = 1)
	if(str < 1)
		return phrase
	else
		str = Ceiling(str/5)

	var/list/split_phrase = text2list(phrase," ") //Split it up into words.
	var/list/unstuttered_words = split_phrase.Copy()

	var/max_stutter = str <= split_phrase.len ? str : split_phrase.len
	var/stutters = rand(1, max_stutter)

	for(var/i = 0, i < stutters, i++)
		if (!unstuttered_words.len)
			break

		var/word = pick(unstuttered_words)
		unstuttered_words -= word //Remove from unstuttered words so we don't stutter it again.
		var/index = split_phrase.Find(word) //Find the word in the split phrase so we can replace it.
		var/regex/R = regex("^(\\W*)((?:\[Tt\]|\[Cc\]|\[Ss\])\[Hh\]|\\w)(\\w*)(\\W*)$")

		if(!R.Find(word))
			continue

		if (lentext(word) > 1)
			if(prob(25) && str > 1) // stutter word instead
				word = R.Replace(word, "$1$2$3-\\L$2$3")
			else if(prob(50) && str > 1) // prolong word
				var/prolonged = ""
				for(var/j = 0, j < str, j++)
					prolonged += R.group[2]
				var/regex/upper = regex("\[A-Z\]")
				if(!upper.Find(R.group[3]))
					prolonged = lowertext(prolonged)
				word = R.Replace(word, "$1$2[prolonged]$3$4")
			else
				if(prob(10 * str)) // harder stutter if stronger
					word = R.Replace(word, "$1$2-$2-$2$3$4")
				else // normal stutter
					word = R.Replace(word, "$1$2-$2$3$4")

		if(prob(3 * str)) // stammer / pause
			word = R.Replace(word, "$0 ... ")

		split_phrase[index] = word

	return jointext(split_phrase," ")

proc/Stagger(mob/M,d) //Technically not a filter, but it relates to drunkenness.
	step(M, pick(d,turn(d,90),turn(d,-90)))

proc/Ellipsis(original_msg, chance = 50)
	if(chance <= 0) return "..."
	if(chance >= 100) return original_msg

	var/list
		words = text2list(original_msg," ")
		new_words = list()

	var/new_msg = ""

	for(var/w in words)
		if(prob(chance))
			new_words += "..."
		else
			new_words += w

	new_msg = jointext(new_words," ")

	return new_msg
