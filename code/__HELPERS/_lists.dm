/*
 * Holds procs to help with list operations
 * Contains groups:
 * Misc
 * Sorting
 */

/*
 * Misc
 */

// Generic listoflist safe add and removal macros:
///If value is a list, wrap it in a list so it can be used with list add/remove operations
#define LIST_VALUE_WRAP_LISTS(value) (islist(value) ? list(value) : value)
///Add an untyped item to a list, taking care to handle list items by wrapping them in a list to remove the footgun
#define UNTYPED_LIST_ADD(list, item) (list += LIST_VALUE_WRAP_LISTS(item))
///Remove an untyped item to a list, taking care to handle list items by wrapping them in a list to remove the footgun
#define UNTYPED_LIST_REMOVE(list, item) (list -= LIST_VALUE_WRAP_LISTS(item))

/*
 * ## Lazylists
 *
 * * What is a lazylist?
 *
 * True to its name a lazylist is a lazy instantiated list.
 * It is a list that is only created when necessary (when it has elements) and is null when empty.
 *
 * * Why use a lazylist?
 *
 * Lazylists save memory - an empty list that is never used takes up more memory than just `null`.
 *
 * * When to use a lazylist?
 *
 * Lazylists are best used on hot types when making lists that are not always used.
 *
 * For example, if you were adding a list to all atoms that tracks the names of people who touched it,
 * you would want to use a lazylist because most atoms will never be touched by anyone.
 *
 * * How do I use a lazylist?
 *
 * A lazylist is just a list you defined as `null` rather than `list()`.
 * Then, you use the LAZY* macros to interact with it, which are essentially null-safe ways to interact with a list.
 *
 * Note that you probably should not be using these macros if your list is not a lazylist.
 * This will obfuscate the code and make it a bit harder to read and debug.
 *
 * Generally speaking you shouldn't be checking if your lazylist is `null` yourself, the macros will do that for you.
 * Remember that LAZYLEN (and by extension, length) will return 0 if the list is null.
 */

///Initialize the lazylist
#define LAZYINITLIST(L) if (!L) { L = list(); }
///If the provided list is empty, set it to null
#define UNSETEMPTY(L) if (L && !length(L)) L = null
///If the provided key -> list is empty, remove it from the list
#define ASSOC_UNSETEMPTY(L, K) if (!length(L[K])) L -= K;
///Like LAZYCOPY - copies an input list if the list has entries, If it doesn't the assigned list is nulled
#define LAZYLISTDUPLICATE(L) (L ? L.Copy() : null )
///Remove an item from the list, set the list to null if empty
#define LAZYREMOVE(L, I) if(L) { L -= I; if(!length(L)) { L = null; } }
///Add an item to the list, if the list is null it will initialize it
#define LAZYADD(L, I) if(!L) { L = list(); } L += I;
///Add an item to the list if not already present, if the list is null it will initialize it
#define LAZYOR(L, I) if(!L) { L = list(); } L |= I;
///Returns the key of the submitted item in the list
#define LAZYFIND(L, V) (L ? L.Find(V) : 0)
///returns L[I] if L exists and I is a valid index of L, runtimes if L is not a list
#define LAZYACCESS(L, I) (L ? (isnum(I) ? (I > 0 && I <= length(L) ? L[I] : null) : L[I]) : null)
///Sets the item K to the value V, if the list is null it will initialize it
#define LAZYSET(L, K, V) if(!L) { L = list(); } L[K] = V;
///Sets the length of a lazylist
#define LAZYSETLEN(L, V) if (!L) { L = list(); } L.len = V;
///Returns the length of the list
#define LAZYLEN(L) length(L)
///Sets a list to null
#define LAZYNULL(L) L = null
///Adds to the item K the value V, if the list is null it will initialize it
#define LAZYADDASSOC(L, K, V) if(!L) { L = list(); } L[K] += V;
///This is used to add onto lazy assoc list when the value you're adding is a /list/. This one has extra safety over lazyaddassoc because the value could be null (and thus cant be used to += objects)
#define LAZYADDASSOCLIST(L, K, V) if(!L) { L = list(); } L[K] += list(V);
///Removes the value V from the item K, if the item K is empty will remove it from the list, if the list is empty will set the list to null
#define LAZYREMOVEASSOC(L, K, V) if(L) { if(L[K]) { L[K] -= V; if(!length(L[K])) L -= K; } if(!length(L)) L = null; }
///Accesses an associative list, returns null if nothing is found
#define LAZYACCESSASSOC(L, I, K) L ? L[I] ? L[I][K] ? L[I][K] : null : null : null
///Qdel every item in the list before setting the list to null
#define QDEL_LAZYLIST(L) for(var/I in L) qdel(I); L = null;
//These methods don't null the list
///Use LAZYLISTDUPLICATE instead if you want it to null with no entries
#define LAZYCOPY(L) (L ? L.Copy() : list() )
/// Consider LAZYNULL instead
#define LAZYCLEARLIST(L) if(L) L.Cut()
///Returns the list if it's actually a valid list, otherwise will initialize it
#define SANITIZE_LIST(L) ( islist(L) ? L : list() )
/// Performs an insertion on the given lazy list with the given key and value. If the value already exists, a new one will not be made.
#define LAZYORASSOCLIST(lazy_list, key, value) \
	LAZYINITLIST(lazy_list); \
	LAZYINITLIST(lazy_list[key]); \
	lazy_list[key] |= value;

/*
	Aurora Snowflake
*/
#define LAZYPICK(L,DEFAULT) (LAZYLEN(L) ? pick(L) : DEFAULT)
#define LAZYISIN(L, I) (L ? (I in L) : FALSE)
#define LAZYDISTINCTADD(L, I) if(!L) { L = list(); } L |= I;
#define LAZYREPLACEKEY(L, K, NK) if(L) { if(L[K]) { L[NK] = L[K] } else {L += NK} L -= K; }

// Shims for some list procs in lists.dm.
#define isemptylist(L) (!LAZYLEN(L))

/**
 * Removes any null entries from the list
 * Returns TRUE if the list had nulls, FALSE otherwise
**/
/proc/list_clear_nulls(list/list_to_clear)
	return (list_to_clear.RemoveAll(null) > 0)

#define reverseList(L) reverse_range(L.Copy())

/// Passed into BINARY_INSERT to compare keys
#define COMPARE_KEY __BIN_LIST[__BIN_MID]
/// Passed into BINARY_INSERT to compare values
#define COMPARE_VALUE __BIN_LIST[__BIN_LIST[__BIN_MID]]

/****
	* Binary search sorted insert
	* INPUT: Object to be inserted
	* LIST: List to insert object into
	* TYPECONT: The typepath of the contents of the list
	* COMPARE: The object to compare against, usualy the same as INPUT
	* COMPARISON: The variable on the objects to compare
	* COMPTYPE: How should the values be compared? Either COMPARE_KEY or COMPARE_VALUE.
	*/
#define BINARY_INSERT(INPUT, LIST, TYPECONT, COMPARE, COMPARISON, COMPTYPE) \
	do {\
		var/list/__BIN_LIST = LIST;\
		var/__BIN_CTTL = length(__BIN_LIST);\
		if(!__BIN_CTTL) {\
			__BIN_LIST += INPUT;\
		} else {\
			var/__BIN_LEFT = 1;\
			var/__BIN_RIGHT = __BIN_CTTL;\
			var/__BIN_MID = (__BIN_LEFT + __BIN_RIGHT) >> 1;\
			var ##TYPECONT/__BIN_ITEM;\
			while(__BIN_LEFT < __BIN_RIGHT) {\
				__BIN_ITEM = COMPTYPE;\
				if(__BIN_ITEM.##COMPARISON <= COMPARE.##COMPARISON) {\
					__BIN_LEFT = __BIN_MID + 1;\
				} else {\
					__BIN_RIGHT = __BIN_MID;\
				};\
				__BIN_MID = (__BIN_LEFT + __BIN_RIGHT) >> 1;\
			};\
			__BIN_ITEM = COMPTYPE;\
			__BIN_MID = __BIN_ITEM.##COMPARISON > COMPARE.##COMPARISON ? __BIN_MID : __BIN_MID + 1;\
			__BIN_LIST.Insert(__BIN_MID, INPUT);\
		};\
	} while(FALSE)

/**
 * Custom binary search sorted insert utilising comparison procs instead of vars.
 * INPUT: Object to be inserted
 * LIST: List to insert object into
 * TYPECONT: The typepath of the contents of the list
 * COMPARE: The object to compare against, usualy the same as INPUT
 * COMPARISON: The plaintext name of a proc on INPUT that takes a single argument to accept a single element from LIST and returns a positive, negative or zero number to perform a comparison.
 * COMPTYPE: How should the values be compared? Either COMPARE_KEY or COMPARE_VALUE.
 */
#define BINARY_INSERT_PROC_COMPARE(INPUT, LIST, TYPECONT, COMPARE, COMPARISON, COMPTYPE) \
	do {\
		var/list/__BIN_LIST = LIST;\
		var/__BIN_CTTL = length(__BIN_LIST);\
		if(!__BIN_CTTL) {\
			__BIN_LIST += INPUT;\
		} else {\
			var/__BIN_LEFT = 1;\
			var/__BIN_RIGHT = __BIN_CTTL;\
			var/__BIN_MID = (__BIN_LEFT + __BIN_RIGHT) >> 1;\
			var ##TYPECONT/__BIN_ITEM;\
			while(__BIN_LEFT < __BIN_RIGHT) {\
				__BIN_ITEM = COMPTYPE;\
				if(__BIN_ITEM.##COMPARISON(COMPARE) <= 0) {\
					__BIN_LEFT = __BIN_MID + 1;\
				} else {\
					__BIN_RIGHT = __BIN_MID;\
				};\
				__BIN_MID = (__BIN_LEFT + __BIN_RIGHT) >> 1;\
			};\
			__BIN_ITEM = COMPTYPE;\
			__BIN_MID = __BIN_ITEM.##COMPARISON(COMPARE) > 0 ? __BIN_MID : __BIN_MID + 1;\
			__BIN_LIST.Insert(__BIN_MID, INPUT);\
		};\
	} while(FALSE)

#define SORT_FIRST_INDEX(list) (list[1])
#define SORT_COMPARE_DIRECTLY(thing) (thing)
#define SORT_VAR_NO_TYPE(varname) var/varname
/****
	* Even more custom binary search sorted insert, using defines instead of vars
	* INPUT: Item to be inserted
	* LIST: List to insert INPUT into
	* TYPECONT: A define setting the var to the typepath of the contents of the list
	* COMPARE: The item to compare against, usualy the same as INPUT
	* COMPARISON: A define that takes an item to compare as input, and returns their comparable value
	* COMPTYPE: How should the list be compared? Either COMPARE_KEY or COMPARE_VALUE.
	*/
#define BINARY_INSERT_DEFINE(INPUT, LIST, TYPECONT, COMPARE, COMPARISON, COMPTYPE) \
	do {\
		var/list/__BIN_LIST = LIST;\
		var/__BIN_CTTL = length(__BIN_LIST);\
		if(!__BIN_CTTL) {\
			__BIN_LIST += INPUT;\
		} else {\
			var/__BIN_LEFT = 1;\
			var/__BIN_RIGHT = __BIN_CTTL;\
			var/__BIN_MID = (__BIN_LEFT + __BIN_RIGHT) >> 1;\
			##TYPECONT(__BIN_ITEM);\
			while(__BIN_LEFT < __BIN_RIGHT) {\
				__BIN_ITEM = COMPTYPE;\
				if(##COMPARISON(__BIN_ITEM) <= ##COMPARISON(COMPARE)) {\
					__BIN_LEFT = __BIN_MID + 1;\
				} else {\
					__BIN_RIGHT = __BIN_MID;\
				};\
				__BIN_MID = (__BIN_LEFT + __BIN_RIGHT) >> 1;\
			};\
			__BIN_ITEM = COMPTYPE;\
			__BIN_MID = ##COMPARISON(__BIN_ITEM) > ##COMPARISON(COMPARE) ? __BIN_MID : __BIN_MID + 1;\
			__BIN_LIST.Insert(__BIN_MID, INPUT);\
		};\
	} while(FALSE)

/**
 * Picks a random element from a list based on a weighting system.
 * For example, given the following list:
 * A = 6, B = 3, C = 1, D = 0
 * A would have a 60% chance of being picked,
 * B would have a 30% chance of being picked,
 * C would have a 10% chance of being picked,
 * and D would have a 0% chance of being picked.
 * You should only pass integers in.
 */
/proc/pick_weight(list/list_to_pick)
	var/total = 0
	var/item
	for(item in list_to_pick)
		if(!list_to_pick[item])
			list_to_pick[item] = 0
		total += list_to_pick[item]

	total = rand(1, total)
	for(item in list_to_pick)
		total -= list_to_pick[item]
		if(total <= 0 && list_to_pick[item])
			return item

	return null

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

///Converts a bitfield to a list of numbers (or words if a wordlist is provided)
/proc/bitfield_to_list(bitfield = 0, list/wordlist)
	var/list/return_list = list()
	if(islist(wordlist))
		var/max = min(wordlist.len, 24)
		var/bit = 1
		for(var/i in 1 to max)
			if(bitfield & bit)
				return_list += wordlist[i]
			bit = bit << 1
	else
		for(var/bit_number = 0 to 23)
			var/bit = 1 << bit_number
			if(bitfield & bit)
				return_list += bit

	return return_list

///Copies a list, and all lists inside it recusively
///Does not copy any other reference type
/proc/deep_copy_list(list/inserted_list)
	if(!islist(inserted_list))
		return inserted_list
	. = inserted_list.Copy()
	for(var/i in 1 to inserted_list.len)
		var/key = .[i]
		if(isnum(key))
			// numbers cannot ever be associative keys
			continue
		var/value = .[key]
		if(islist(value))
			value = deep_copy_list(value)
			.[key] = value
		if(islist(key))
			key = deep_copy_list(key)
			.[i] = key
			.[key] = value

/// Turns an associative list into a flat list of keys
/proc/assoc_to_keys(list/input)
	var/list/keys = list()
	for(var/key in input)
		UNTYPED_LIST_ADD(keys, key)
	return keys
