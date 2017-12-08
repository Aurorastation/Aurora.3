//////////////////////////////Construct Spells/////////////////////////

proc/findNullRod(var/atom/target)
		return 1
	else if(target.contents)
		for(var/atom/A in target.contents)
			if(findNullRod(A))
				return 1
	return 0
