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

/Queue/New()
	contents = list()

/Queue/proc/enqueue(var/element)
	contents += element

/Queue/proc/dequeue()
	if(!contents.len)
		return null
	var/item = contents[1]
	contents.Cut(1, 2)
	return item

/Queue/proc/size()
	return contents.len

/Queue/proc/as_list()
	return contents