///replaces reverseList ~Carnie
/proc/reverse_range(list/inserted_list, start = 1, end = 0)
	if(inserted_list.len)
		start = start % inserted_list.len
		end = end % (inserted_list.len + 1)
		if(start <= 0)
			start += inserted_list.len
		if(end <= 0)
			end += inserted_list.len + 1

		--end
		while(start < end)
			inserted_list.Swap(start++, end--)

	return inserted_list
