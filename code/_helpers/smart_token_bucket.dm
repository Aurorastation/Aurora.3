/**
 * # A bucket token, used inside a smart token bucket
 */
/datum/bucket_token
	///The content of the token, can be anything really
	var/content = null

	///The creation time of this token
	var/time = null

	///The time this token will expire, this is always an absolute time, not a delay
	var/expire_time = null

	///The callback to invoke when this token expires
	var/datum/callback/callback = null

/**
 * Creates a new bucket_token
 *
 * * content - The content of the token, can be anything really
 * * expiration - The time at which the token expires, NOT A WAITING, A TIME
 * * callback - The callback to invoke when the token expires
 */
/datum/bucket_token/New(var/content, var/expiration, var/callback)

	if(expiration < STB_REALTIMESOURCE)
		crash_with("The expiration time of the token is in the past, this is not allowed.")

	src.time = STB_REALTIMESOURCE
	src.expire_time = expiration
	src.callback = callback

	src.content = content

/// TRUE if the bucket is operating in fixed TTL mode
#define STB_IS_FIXEDTTL_MODE (HAS_FLAG(src.mode, STB_MODE_FIXEDTTL))
/// TRUE if the bucket is a leaky bucket
#define STB_IS_LEAKYBUCKET (HAS_FLAG(src.flags, STB_FLAG_LEAKYBUCKET))

/**
 * # Smart Token Bucket
 *
 * A smart token bucket, able to work with either a fixed or variable TTL, with the option of being a leaky bucket in doing so
 *
 */
/datum/smart_token_bucket
	///The content inside the bucket, a list of bucket_tokens
	var/list/content = list()
	///The size of the bucket, this is an hard limit, no tokens will be allowed to be inserted above this treshold
	var/bucket_size = null

	///The bucket general operation mode in regards to the timers, see the STB_MODE_* defines
	var/mode = null
	///Flags about the operation of this bucket, see the STB_FLAG_* defines
	var/flags = null

	///How long the tokens last, this is only relevant in fixedTTL mode (mode = STB_MODE_FIXEDTTL)
	var/tokens_lifetime = null

	///Time for the next token that expires, in fixedTTL mode this is the next time the scheduled OnDemand function will run
	var/next_expiration = null
	///The callback identifier for the scheduled OnDemand function, in fixedTTL mode
	var/next_expiration_callback = null

	///The soft overfill limit, the function specified in high_watermark_call will be called for each token inserted above this limit
	var/high_watermark = null
	///The function to call over high_watermark, use CALLBACK(obj, PROC_REF()) or equivalent to reference it at assignment
	var/datum/callback/high_watermark_call = null
	///If the bucket is in high watermark
	var/is_high_watermark = FALSE

	///The soft underfill limit, the function specified in low_watermark_call will be called for each token expired below this limit
	var/low_watermark = null
	///The function to call below low_watermark, use CALLBACK(obj, PROC_REF()) or equivalent to reference it at assignment
	var/datum/callback/low_watermark_call = null
	///If the bucker is in low watermark
	var/is_low_watermark = TRUE

	///If an ondemand run is in progress, internal only
	var/OnDemandInProgress = FALSE

	///A cached list to batch insertions, to avoid continuously resizing the content list
	var/list/insertion_list[1024]
	///An index of the insertion_list, pointing to the last position we've used
	var/insertion_list_index = 0
	///Used during expiration, this indicates how much we have offset already, without the need to keep .Remove()'ing, thus avoiding list resizes
	var/batch_expired_offset = 0



/**
 * Creates a new smart token bucket
 *
 * * mode - The general mode the bucket will be operating at, see STB_MODE_* defines, if not specified it will be STB_MODE_FIXEDTTL
 * * flags - Fine tuning flags for the bucket behaviour, see STB_FLAG_* defines
 * * tokens_lifetime - The lifetime of the tokens, only used if mode = STB_MODE_FIXEDTTL
 */
/datum/smart_token_bucket/New(var/mode = STB_MODE_FIXEDTTL, var/flags, var/tokens_lifetime)

	if(isnull(mode))
		crash_with("You must specify a mode.")
	src.mode = mode
	src.flags = flags

	if(STB_IS_FIXEDTTL_MODE)
		if(!tokens_lifetime)
			crash_with("Trying to initialize a smart token bucket in fixed TTL mode, without specifying the time.")
		else
			src.tokens_lifetime = tokens_lifetime



/// Inserts TOKEN into the binary tree of the bucket
#define STB_BTREE_INSERT(TOKEN) BINARY_INSERT(TOKEN, src.content, /datum/bucket_token, ##TOKEN, expire_time, COMPARE_KEY)

/// Register a callback timer for the expiration of tokens, ONLY in non-leakybucket operation
#define STB_REGISTER_EXPIRATION_TIMER(TOKEN, WAITTIME)\
	src.next_expiration = ##TOKEN:expire_time;\
	src.next_expiration_callback = addtimer(CALLBACK(src, PROC_REF(ExpireCallbackTimer), ##TOKEN), max(##WAITTIME, 0), TIMER_UNIQUE|TIMER_STOPPABLE)

/**
 * Checks if the low watermark function needs to be called, and if so calls it with CONTENT as a parameter
 *
 * * CONTENT - The content to send to the callback function
 */
#define STB_CALL_LOWWATERMARK(CONTENT)\
	if(!isnull(src.low_watermark) && ((src.content.len + src.insertion_list_index + src.batch_expired_offset) <= src.low_watermark)){\
		src.is_low_watermark = TRUE;\
		if(src.low_watermark_call){\
			src.low_watermark_call.Invoke(##CONTENT);\
		}\
	}\
	else{\
		src.is_low_watermark = FALSE;\
	}

/// Removes the timer for the expiration of a token and nulls the bucket's next_expiration, in non-leakybucket mode
#define STB_PURGE_EXPIRATION_TIMER\
	if(src.next_expiration_callback){\
		deltimer(src.next_expiration_callback);\
		src.next_expiration = null;\
		src.next_expiration_callback = null;\
	};

/// In non-leakybucket operations, rearm the callback timer
#define STB_REARMCALLBACK\
	if((!STB_IS_LEAKYBUCKET)){\
		if(src.content.len){\
			STB_REGISTER_EXPIRATION_TIMER((src.content[src.content.len]), (src.content[(src.content.len)]:expire_time - STB_REALTIMESOURCE));\
		}\
		else{\
			STB_PURGE_EXPIRATION_TIMER;\
		}\
	}

/// Commits the insertion list to the actual content
#define STB_COMMIT_INSERTIONLIST\
	if((STB_IS_FIXEDTTL_MODE) && src.insertion_list_index){\
		src.content.Add(src.insertion_list.Copy(1,(src.insertion_list_index+1)));\
		src.insertion_list_index = 0;\
		src.batch_expired_offset = 0;\
	}


/**
 * Expires a token
 *
 * * expiring_token - The token to expire
 * * SKIP_REMOVE - If to skip the removal from the bucket content, to batch the removal in a single .Cut(), which is more efficient
 * * SKIP_CHECK - Skips the check to confirm that the token is in the list
 */
#define STB_EXPIRE(expiring_token, SKIP_REMOVE, SKIP_CHECK)\
	if(SKIP_CHECK || (##expiring_token in src.content)){\
		if(!isnull(src.high_watermark) && ((src.content.len + src.insertion_list_index + src.batch_expired_offset) < src.high_watermark)){\
			src.is_high_watermark = FALSE;\
		}\
		\
		STB_CALL_LOWWATERMARK(##expiring_token);\
		if(UNLINT(!##SKIP_REMOVE)){\
			src.content.Remove(##expiring_token);\
		}\
		\
		if(##expiring_token:callback){\
			##expiring_token:callback:Invoke(##expiring_token);\
		}\
	}

/**
 * On Demand Processing
 *
 * Used to seek and purge already expired tokens in the list, in non-leakybucket operations
 *
 * * LIST - The list to run the processing on
 */
#define STB_ONDEMANDPROCESS(LIST)\
	do {\
		if(!src.OnDemandInProgress){\
			src.OnDemandInProgress = TRUE;\
			if(src.next_expiration <= STB_REALTIMESOURCE){\
				STB_COMMIT_INSERTIONLIST;\
			}\
			src.batch_expired_offset = 0;\
			var/counter = 0;\
			for(var/_i in 1 to LIST.len){\
				if(src.content[_i]:expire_time <= STB_REALTIMESOURCE){\
					STB_EXPIRE(src.content[_i], TRUE, TRUE);\
					counter += 1;\
					src.batch_expired_offset -= 1;\
				}\
				else{\
					break;\
				}\
			}\
			if(counter){\
				##LIST.Cut(1,(counter+1));\
			}\
			src.batch_expired_offset = 0;\
			if(!STB_IS_LEAKYBUCKET){\
				if(##LIST.len && !src.next_expiration){\
					src.next_expiration = ##LIST[##LIST.len]:expire_time;\
				}\
			}\
			src.OnDemandInProgress = FALSE;\
		}\
	} while(FALSE)

/// Runs the ondemand processing to find and expire the tokens in fixed TTL mode
#define STB_RUN_ONDEMAND_PROCESS\
	if(!STB_IS_LEAKYBUCKET){\
		STB_ONDEMANDPROCESS(src.content);\
	};


/**
 * Inserts an object or prebaked token into the bucket, if it's not a prebaked token one will be created
 *
 * * token_content - The content that you want to put in the token, or a token
 * * token_expire_time - The expire time of a token, only valid in Variable TTL mode AND if token_content is not a token itself
 * * callback - The callback to call when the token expired
 *
 * Returns TRUE if the token was added, FALSE in case it's full at or above bucket_size
 */
/datum/smart_token_bucket/proc/Insert(var/datum/bucket_token/token_content, var/token_expire_time = null, var/datum/callback/callback)

	//Guards//
	if(!src.mode)
		crash_with("The smart token bucket is not initialized, initialize the bucket before trying to insert.")

	//Prevent insertion of tokens if the hard limit (bucket size) is reached
	if((!isnull(src.bucket_size)) && ((src.content.len + insertion_list_index) >= src.bucket_size))
		return FALSE

	//Prevent insertion of expired tokens
	if((istype(token_content, /datum/bucket_token) && token_content.expire_time < STB_REALTIMESOURCE) || (!isnull(token_expire_time) && (token_expire_time < STB_REALTIMESOURCE)))
		crash_with("You cannot insert a token that has already expired in the bucket.")

	// Preparation of the token//

	//If it's not already a token, make a new token with the content
	if(!istype(token_content, /datum/bucket_token))
		if(STB_IS_FIXEDTTL_MODE)
			token_content = new(content = token_content, expiration = (STB_REALTIMESOURCE + tokens_lifetime), callback = callback)
		else
			token_content = new(content = token_content, expiration = token_expire_time, callback = callback)


	//if an high watermark is specified, call the registered proc if it's triggered
	if(((src.content.len + src.insertion_list_index) >= src.high_watermark))
		src.is_high_watermark = TRUE
		if(src.high_watermark_call)
			src.high_watermark_call.Invoke(token_content)
	else
		src.is_high_watermark = FALSE

	if(((src.content.len + src.insertion_list_index) <= src.low_watermark))
		src.is_low_watermark = TRUE
	else
		src.is_low_watermark = FALSE


	//Registration and handling of expiration callback(s)//

	if(STB_IS_LEAKYBUCKET)
		//Refresh the next expiration of the bucket, if the new token expires sooner than what we already have in the bucket
		if(token_content.expire_time <= src.next_expiration)
			src.next_expiration = token_content.expire_time

		addtimer(CALLBACK(src, PROC_REF(Expire), token_content), ((STB_IS_FIXEDTTL_MODE) ? tokens_lifetime : (token_content.expire_time - STB_REALTIMESOURCE)))

	else
		STB_ONDEMANDPROCESS(src.content)

		if(!src.next_expiration)

			STB_PURGE_EXPIRATION_TIMER

			STB_REGISTER_EXPIRATION_TIMER(token_content, ((STB_IS_FIXEDTTL_MODE) ? tokens_lifetime : (token_content.expire_time - STB_REALTIMESOURCE)))


	// INSERTION OF THE TOKENS //

	//If we are in fixedTTL, it is guaranteed that every new token will expire after the ones already present, so we can skip the btree search and just append it
	//otherwise, we have to use the btree search to insert it at the correct position of the tree
	if(!(STB_IS_FIXEDTTL_MODE))
		STB_BTREE_INSERT(token_content)
	else
		//The insertion list is full, have to commit it
		if(src.insertion_list_index == src.insertion_list.len)
			STB_COMMIT_INSERTIONLIST

		src.insertion_list_index += 1
		src.insertion_list[src.insertion_list_index] = token_content


/**
 * Called by a callback timer, not supposed to be called directly
 *
 * * expiring_token - The token that set the callback and is expiring
 */
/datum/smart_token_bucket/proc/ExpireCallbackTimer(var/datum/bucket_token/expiring_token)
	STB_COMMIT_INSERTIONLIST
	STB_RUN_ONDEMAND_PROCESS
	STB_EXPIRE(expiring_token, FALSE, FALSE)
	STB_REARMCALLBACK

/**
 * Expires a token
 *
 * * expiring_token - The token to expire
 * * skip_on_demand_process - Skips the call to OnDemandProcess()
 */
/datum/smart_token_bucket/proc/Expire(var/datum/bucket_token/expiring_token, var/skip_on_demand_process = FALSE)
	STB_COMMIT_INSERTIONLIST
	if(!skip_on_demand_process)
		STB_ONDEMANDPROCESS(src.content)
	STB_EXPIRE(expiring_token, FALSE, FALSE)


/**
 * Returns the FIRST token in the list that has expired, DOES NOT REMOVE IT, just peek
 *
 * Works only in NON-LEAKY-BUCKET mode, as tokens that expire are immediately removed otherwise
 */
/datum/smart_token_bucket/proc/PeekExpired()

	if(STB_IS_LEAKYBUCKET)
		crash_with("The bucket is working as leaky bucket, looking for expired tokens when they get popped as soon as they expire makes no sense.")

	STB_COMMIT_INSERTIONLIST

	for(var/datum/bucket_token/token as anything in src.content)

		//If we have reached the area where expire_time is greater than our current time, no point in searching anymore
		if(token.expire_time > STB_REALTIMESOURCE)
			return FALSE

		//If the expire time is lower than our current time, the token has expired, return it
		else
			return token


/**
 * Returns the valid token in the bucket at the index, or null if theres nothing at said index.
 *
 * Does not remove the element.
 *
 * * index - The position in the bucket to peek at
 */
/datum/smart_token_bucket/proc/PeekAt(var/index)
	STB_COMMIT_INSERTIONLIST

	if(index <= src.content.len)
		if(!(STB_IS_LEAKYBUCKET))
			STB_RUN_ONDEMAND_PROCESS

		return src.content[index]

	else
		return null

/**
 * Returns the first valid token in the bucket, or null if theres nothing.
 *
 * Does not remove the element.
 */
/datum/smart_token_bucket/proc/Peek()
	return PeekAt(1)


/**
 * Pops the (non expired) token from the bucket at index and returns it, removing it from the bucket
 *
 * Does not trigger the token's expiration callback, as it's not expired.
 *
 * * index - The position in the bucket to pop a token from
 */
/datum/smart_token_bucket/proc/PopAt(var/index)
	STB_COMMIT_INSERTIONLIST

	//Process ondemand in non-leakybucket mode
	if(!STB_IS_LEAKYBUCKET)
		STB_ONDEMANDPROCESS(src.content)

	if(index <= src.content.len)
		if(index == src.content.len)
			if(!STB_IS_LEAKYBUCKET)
				STB_PURGE_EXPIRATION_TIMER
				if((src.content.len)-1)
					STB_REGISTER_EXPIRATION_TIMER(src.content[(src.content.len-1)], (src.content[(src.content.len-1)]:expire_time - STB_REALTIMESOURCE))

		var/popped = src.content[index]
		src.content.Remove(popped)

		STB_CALL_LOWWATERMARK(popped)
		return popped

	else
		return null

/**
 * Pops the oldest (non expired) token from the bucket and returns it, removing it from the bucket
 */
/datum/smart_token_bucket/proc/Pop()
	return PopAt(1)


/**
 * The maintenance function, called at operations on the bucket when the bucket is not operating in leaky bucket mode
 */
/datum/smart_token_bucket/proc/OnDemandProcess()
	STB_ONDEMANDPROCESS(src.content)



#undef STB_IS_FIXEDTTL_MODE
#undef STB_BTREE_INSERT
#undef STB_IS_LEAKYBUCKET
#undef STB_REGISTER_EXPIRATION_TIMER
#undef STB_CALL_LOWWATERMARK
#undef STB_EXPIRE
#undef STB_PURGE_EXPIRATION_TIMER
#undef STB_REARMCALLBACK
#undef STB_ONDEMANDPROCESS
#undef STB_RUN_ONDEMAND_PROCESS
#undef STB_COMMIT_INSERTIONLIST
