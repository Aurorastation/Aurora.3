/*
 * Holds procs to help with list operations
 * Contains groups:
 *			Misc
 *			Sorting
 */

/*
 * Misc
 */

//Returns a list in plain english as a string
/proc/english_list(var/list/input, nothing_text = "nothing", and_text = " and ", comma_text = ", ", final_comma_text = "" )
	var/total = input.len
	if (!total)
		return "[nothing_text]"
	else if (total == 1)
		return "[input[1]]"
	else if (total == 2)
		return "[input[1]][and_text][input[2]]"
	else
		var/output = ""
		var/index = 1
		while (index < total)
			if (index == total - 1)
				comma_text = final_comma_text

			output += "[input[index]][comma_text]"
			index++

		return "[output][and_text][input[index]]"


/proc/ConvertReqString2List(var/list/source_list)
	var/list/temp_list = params2list(source_list)
	for(var/O in temp_list)
		temp_list[O] = text2num(temp_list[O])
	return temp_list

//Checks for specific types in a list
/proc/is_type_in_list(var/atom/A, var/list/L)
	for(var/type in L)
		if(istype(A, type))
			return 1
	return 0

/proc/instances_of_type_in_list(atom/A, list/L, strict = FALSE)
	. = 0
	if (strict)
		for (var/type in L)
			if (type == A.type)
				.++
	else
		for(var/type in L)
			if(istype(A, type))
				.++

//Removes any null entries from the list
//Returns TRUE if the list had nulls, FALSE otherwise
/proc/listclearnulls(list/L)
	var/start_len = L.len
	var/list/N = new(start_len)
	L -= N
	return L.len < start_len

/*
 * Returns list containing all the entries from first list that are not present in second.
 * If skiprep = 1, repeated elements are treated as one.
 * If either of arguments is not a list, returns null
 */
/proc/difflist(var/list/first, var/list/second, var/skiprep=0)
	if(!islist(first) || !islist(second))
		return
	var/list/result = new
	if(skiprep)
		for(var/e in first)
			if(!(e in result) && !(e in second))
				result += e
	else
		result = first - second
	return result

/*
 * Returns list containing entries that are in either list but not both.
 * If skipref = 1, repeated elements are treated as one.
 * If either of arguments is not a list, returns null
 */
/proc/uniquemergelist(var/list/first, var/list/second, var/skiprep=0)
	if(!islist(first) || !islist(second))
		return
	var/list/result = new
	if(skiprep)
		result = difflist(first, second, skiprep)+difflist(second, first, skiprep)
	else
		result = first ^ second
	return result


//Picks a random element by weight from a list. The list must be correctly constructed in this format:
//mylist[myelement1] = myweight1
//mylist[myelement2] = myweight2
//The proc will return the element index, and not the weight.
/proc/pickweight(list/L)
	var/total = 0
	var/item
	for (item in L)
		if (isnull(L[item]))
		//Change by nanako, a default weight will no longer overwrite an explicitly set weight of 0
		//It will only use a default if no weight is defined
			L[item] = 1
		total += L[item]
	total = rand() * total//Fix by nanako, allows it to handle noninteger weights
	for (item in L)
		total -= L[item]
		if (total <= 0)
			return item

	return null


//Pick a random element from the list and remove it from the list.
/proc/pick_n_take(list/listfrom)
	if (listfrom.len > 0)
		var/picked = pick(listfrom)
		listfrom -= picked
		return picked
	return null

//Returns the top(last) element from the list and removes it from the list (typical stack function)
/proc/pop(list/listfrom)
	if (listfrom.len > 0)
		var/picked = listfrom[listfrom.len]
		listfrom.len--
		return picked
	return null

//Returns the next element in parameter list after first appearance of parameter element. If it is the last element of the list or not present in list, returns first element.
/proc/next_in_list(element, list/L)
	for(var/i=1, i<L.len, i++)
		if(L[i] == element)
			return L[i+1]
	return L[1]

/*
 * Sorting
 */

//Reverses the order of items in the list
/proc/reverselist(list/L)
	var/list/output = list()
	if(L)
		for(var/i = L.len; i >= 1; i--)
			output += L[i]
	return output

//Randomize: Return the list in a random order
/proc/shuffle(var/list/L)
	if(!L)
		return

	L = L.Copy()

	for(var/i=1; i<L.len; i++)
		L.Swap(i, rand(i,L.len))
	return L

//Return a list with no duplicate entries
/proc/uniquelist(var/list/L)
	. = list()
	for(var/i in L)
		. |= i

//Mergesort: divides up the list into halves to begin the sort
/proc/sortKey(var/list/client/L, var/order = 1)
	if (!L)
		return
	var/list/target = L.Copy()
	return sortTim(target, order ? /proc/cmp_ckey_asc : /proc/cmp_ckey_dsc, FALSE)

//Mergesort: divides up the list into halves to begin the sort
/proc/sortAtom(var/list/atom/L, var/order = 1)
	if (!L)
		return
	var/list/target = L.Copy()
	return sortTim(target, order ? /proc/cmp_name_asc : /proc/cmp_name_dsc, FALSE)

//Mergesort: Specifically for record datums in a list.
/proc/sortRecord(var/list/datum/record/L, var/order = 1)
	if (!L)
		return
	var/list/target = L.Copy()
	sortTim(target, order ? /proc/cmp_records_asc : /proc/cmp_records_dsc, FALSE)
	return target

//Mergesort: any value in a list
/proc/sortList(var/list/L)
	if (!L)
		return
	var/list/target = L.Copy()
	return sortTim(target, /proc/cmp_text_asc)

//Mergsorge: uses sortList() but uses the var's name specifically. This should probably be using mergeAtom() instead
/proc/sortNames(var/list/L)
	if (!L)
		return
	var/list/target = L.Copy()
	return sortTim(target, /proc/cmp_name_asc, FALSE)

// List of lists, sorts by element[key] - for things like crew monitoring computer sorting records by name.
/proc/sortByKey(var/list/L, var/key)
	if(L.len < 2)
		return L
	var/middle = L.len / 2 + 1
	return mergeKeyedLists(sortByKey(L.Copy(0, middle), key), sortByKey(L.Copy(middle), key), key)

/proc/mergeKeyedLists(var/list/L, var/list/R, var/key)
	var/Li=1
	var/Ri=1
	var/list/result = new()
	while(Li <= L.len && Ri <= R.len)
		if(sorttext(L[Li][key], R[Ri][key]) < 1)
			// Works around list += list2 merging lists; it's not pretty but it works
			result += "temp item"
			result[result.len] = R[Ri++]
		else
			result += "temp item"
			result[result.len] = L[Li++]

	if(Li <= L.len)
		return (result + L.Copy(Li, 0))
	return (result + R.Copy(Ri, 0))


//Mergesort: any value in a list, preserves key=value structure
/proc/sortAssoc(var/list/L)
	var/list/ret = L.Copy()
	sortTim(ret, /proc/cmp_text_asc, FALSE)
	return ret

// Macros to test for bits in a bitfield. Note, that this is for use with indexes, not bit-masks!
#define BITTEST(bitfield,index)  ((bitfield)  &   (1 << (index)))
#define BITSET(bitfield,index)   (bitfield)  |=  (1 << (index))
#define BITRESET(bitfield,index) (bitfield)  &= ~(1 << (index))
#define BITFLIP(bitfield,index)  (bitfield)  ^=  (1 << (index))

//Converts a bitfield to a list of numbers (or words if a wordlist is provided)
/proc/bitfield2list(bitfield = 0, list/wordlist)
	var/list/r = list()
	if(istype(wordlist,/list))
		var/max = min(wordlist.len,16)
		var/bit = 1
		for(var/i=1, i<=max, i++)
			if(bitfield & bit)
				r += wordlist[i]
			bit = bit << 1
	else
		for(var/bit=1, bit<=65535, bit = bit << 1)
			if(bitfield & bit)
				r += bit

	return r

// Returns the key based on the index
/proc/get_key_by_index(var/list/L, var/index)
	var/i = 1
	for(var/key in L)
		if(index == i)
			return key
		i++
	return null

// Returns the key based on the index
/proc/get_key_by_value(var/list/L, var/value)
	for(var/key in L)
		if(L[key] == value)
			return key

/proc/count_by_type(var/list/L, type)
	var/i = 0
	for(var/T in L)
		if(istype(T, type))
			i++
	return i

/proc/subtypesof(prototype)
	return (typesof(prototype) - prototype)

//creates every subtype of prototype (excluding prototype) and adds it to list L.
//if no list/L is provided, one is created.
/proc/init_subtypes(prototype, list/L)
	if(!istype(L))	L = list()
	for(var/path in subtypesof(prototype))
		L += new path()
	return L

//returns a new list with only atoms that are in typecache L
/proc/typecache_filter_list(list/atoms, list/typecache)
	. = list()
	for(var/thing in atoms)
		var/atom/A = thing
		if (typecache[A.type])
			. += A

/proc/typecache_filter_list_reverse(list/atoms, list/typecache)
	. = list()
	for(var/thing in atoms)
		var/atom/A = thing
		if(!typecache[A.type])
			. += A

/proc/typecache_filter_multi_list_exclusion(list/atoms, list/typecache_include, list/typecache_exclude)
	. = list()
	for(var/thing in atoms)
		var/atom/A = thing
		if(typecache_include[A.type] && !typecache_exclude[A.type])
			. += A

/proc/range_in_typecache(dist, center, list/typecache)
	for (var/thing in range(dist, center))
		var/atom/A = thing
		if (typecache[A.type])
			return TRUE

/proc/typecache_first_match(list/target, list/typecache)
	for (var/thing in target)
		var/datum/D = thing
		if (typecache[D.type])
			return D

//Like typesof() or subtypesof(), but returns a typecache instead of a list
/proc/typecacheof(path, ignore_root_path, only_root_path = FALSE)
	if(ispath(path))
		var/list/types = list()
		if(only_root_path)
			types = list(path)
		else
			types = ignore_root_path ? subtypesof(path) : typesof(path)
		var/list/L = list()
		for(var/T in types)
			L[T] = TRUE
		return L
	else if(islist(path))
		var/list/pathlist = path
		var/list/L = list()
		if(ignore_root_path)
			for(var/P in pathlist)
				for(var/T in subtypesof(P))
					L[T] = TRUE
		else
			for(var/P in pathlist)
				if(only_root_path)
					L[P] = TRUE
				else
					for(var/T in typesof(P))
						L[T] = TRUE
		return L

//Checks for specific types in specifically structured (Assoc "type" = TRUE) lists ('typecaches')
/proc/is_type_in_typecache(atom/A, list/L)
	if(!L || !L.len || !A)

		return 0
	return L[A.type]

#define listequal(A, B) (A.len == B.len && !length(A^B))

/proc/Sum(var/list/input)
	var/total = 0
	for (var/i=1,i<=input.len,i++)
		total += input[i]

	return total


//Move a single element from position fromIndex within a list, to position toIndex
//All elements in the range [1,toIndex) before the move will be before the pivot afterwards
//All elements in the range [toIndex, L.len+1) before the move will be after the pivot afterwards
//In other words, it's as if the range [fromIndex,toIndex) have been rotated using a <<< operation common to other languages.
//fromIndex and toIndex must be in the range [1,L.len+1]
//This will preserve associations ~Carnie
/proc/moveElement(list/L, fromIndex, toIndex)
	if(fromIndex == toIndex || fromIndex+1 == toIndex)	//no need to move
		return
	if(fromIndex > toIndex)
		++fromIndex	//since a null will be inserted before fromIndex, the index needs to be nudged right by one

	L.Insert(toIndex, null)
	L.Swap(fromIndex, toIndex)
	L.Cut(fromIndex, fromIndex+1)


//Move elements [fromIndex,fromIndex+len) to [toIndex-len, toIndex)
//Same as moveElement but for ranges of elements
//This will preserve associations ~Carnie
/proc/moveRange(list/L, fromIndex, toIndex, len=1)
	var/distance = abs(toIndex - fromIndex)
	if(len >= distance)	//there are more elements to be moved than the distance to be moved. Therefore the same result can be achieved (with fewer operations) by moving elements between where we are and where we are going. The result being, our range we are moving is shifted left or right by dist elements
		if(fromIndex <= toIndex)
			return	//no need to move
		fromIndex += len	//we want to shift left instead of right

		for(var/i=0, i<distance, ++i)
			L.Insert(fromIndex, null)
			L.Swap(fromIndex, toIndex)
			L.Cut(toIndex, toIndex+1)
	else
		if(fromIndex > toIndex)
			fromIndex += len

		for(var/i=0, i<len, ++i)
			L.Insert(toIndex, null)
			L.Swap(fromIndex, toIndex)
			L.Cut(fromIndex, fromIndex+1)

//replaces reverseList ~Carnie
/proc/reverseRange(list/L, start=1, end=0)
	if(L.len)
		start = start % L.len
		end = end % (L.len+1)
		if(start <= 0)
			start += L.len
		if(end <= 0)
			end += L.len + 1

		--end
		while(start < end)
			L.Swap(start++,end--)

	return L

//Copies a list, and all lists inside it recusively
//Does not copy any other reference type
/proc/deepCopyList(list/l)
	if(!islist(l))
		return l
	. = l.Copy()
	for(var/i = 1 to l.len)
		if(islist(.[i]))
			.[i] = .(.[i])

//Sets object value at specified path
/proc/obj_query_set(query, subject, value, delimiter = "/", list/keys)
	. = FALSE
	if(!keys)
		keys = splittext(query, delimiter)
	var/datum/subject_d
	var/list/subject_l
	for (var/i = 1; i < keys.len; i++)
		var/key = keys[i]
		if (isdatum(subject))
			subject_d = subject
			if (!subject_d.vars[key])
				return

			subject = subject_d.vars[key]
		else if (islist(subject))
			subject_l = subject
			if (!subject_l[key])
				return

			subject = subject_l[key]
		else
			return

	if (!subject)
		return
		
	var/final = keys[keys.len]
	if (isdatum(subject))
		subject_d = subject
		if (!subject_d.vars[final])
			return

		subject_d.vars[final] = value
	else if (islist(subject))
		subject_l = subject
		if (!subject_l[final])
			return

		subject_l[final] = value
	else
		return

	return TRUE

//Gets object value at specified path
/proc/obj_query_get(query, subject, delimiter = "/", list/keys)
	. = null
	if(!keys)
		keys = splittext(query, delimiter)
	var/datum/subject_d
	var/list/subject_l
	for (var/i = 1; i < keys.len; i++)
		var/key = keys[i]
		if (isdatum(subject))
			subject_d = subject
			if (!subject_d.vars[key])
				return

			subject = subject_d.vars[key]
		else if (islist(subject))
			subject_l = subject
			if (!subject_l[key])
				return

			subject = subject_l[key]
		else
			return

	if (!subject)
		return
		
	var/final = keys[keys.len]
	if (isdatum(subject))
		subject_d = subject
		if (subject_d.vars[final])
			return subject_d.vars[final]
	else if (islist(subject))
		subject_l = subject
		if (subject_l[final])
			return subject_l[final]