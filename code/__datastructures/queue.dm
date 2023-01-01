// FIFO Queue datastructure
// Not currently known to be used anywhere, but was present in data_structures.dm so kept it

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