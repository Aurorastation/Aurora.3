// This file contains data structures such as Stack and Queue

///////////
///Stack///
///////////

/Stack
	var/list/contents
	var/next

/Stack/New()
	contents = list()
	next = null

/Stack/proc/push(var/element)
	next = element
	contents += element

/Stack/proc/pop()
	. = next
	if(contents.len > 0)
		contents.len --
		if(contents.len == 0)
			next = null
		else
			next = contents[contents.len]

/Stack/proc/size()
	return contents.len

/Stack/proc/as_list()
	return contents



///////////
///Queue///
///////////

/Queue
	var/list/contents
	var/next

/Queue/New()
	contents = list()
	next = null

/Queue/proc/enqueue(var/element)
	if(!next)
		next = element
	contents += element

/Queue/proc/dequeue()
	. = next
	if(contents.len > 0)
		contents.Cut(1,2)
		if(contents.len == 0)
			next = null
		else
			next = contents[1]

/Queue/proc/size()
	return contents.len

/Queue/proc/as_list()
	return contents