#define STB_REALTIMESOURCE world.timeofday //The source of the time to base the tokens calculations off

/datum/bucket_token
	///The content of the token, can be anything really
	var/content = null

	///The creation time of this token
	var/time = null

	///The time this token will expire, this is always an absolute time, not a delay
	var/expire_time = null

	///The callback to invoke when this token expires
	var/datum/callback/callback = null

/datum/bucket_token/New(var/content, var/expiration)

	if(expiration < STB_REALTIMESOURCE)
		crash_with("The expiration time of the token is in the past, this is not allowed.")

	src.time = STB_REALTIMESOURCE
	if(!isnull(expiration) && isnum(expiration))
		src.expire_time = expiration

	src.content = content


///All tokens have the same lifetime, set on the bucket
#define STB_MODE_FIXEDTTL BITFLAG(1)
///Each token can specify a different lifetime
#define STB_MODE_VARIABLETTL BITFLAG(2)
///Used to indicate that each token must expire on its own timer, rather than wait for the next operation on the bucket or the last token to expire to do something
#define STB_FLAG_LEAKYBUCKET BITFLAG(1)

/// TRUE if the bucket is operating in fixed TTL mode
#define STB_IS_FIXEDTTL_MODE (HAS_FLAG(src.mode, STB_MODE_FIXEDTTL))
/// TRUE if the bucket is a leaky bucket
#define STB_IS_LEAKYBUCKET (HAS_FLAG(src.flags, STB_FLAG_LEAKYBUCKET))

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
	///The function to call over high_watermark, use PROC_REF() or equivalent to reference it at assignment
	var/high_watermark_call = null

	///The soft underfill limit, the function specified in low_watermark_call will be called for each token expired below this limit
	var/low_watermark = null
	///The function to call below low_watermark, use PROC_REF() or equivalent to reference it at assignment
	var/low_watermark_call = null



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
#define STB_BTREE_INSERT(TOKEN) BINARY_INSERT(TOKEN, src.content, /datum/bucket_token, TOKEN, expire_time, COMPARE_KEY)

/// Register a callback timer for the expiration of tokens, in non-leakybucket operation
#define STB_REGISTER_EXPIRATION_TIMER(TOKEN, WAITTIME) (src.next_expiration_callback = addtimer(CALLBACK(src, PROC_REF(Expire), TOKEN), WAITTIME, TIMER_UNIQUE|TIMER_STOPPABLE))

/// Checks if the low watermark function needs to be called, and if so calls it with CONTENT as a parameter
#define STB_CALL_LOWWATERMARK(CONTENT)\
	if(!isnull(low_watermark) && (src.content.len <= src.low_watermark)){\
		if(low_watermark_call){\
			call(low_watermark_call)(##CONTENT);\
		}\
	}


#define STB_EXPIRE(expiring_token)\
	if((expiring_token in src.content)){\
		if(expiring_token.callback && istype(expiring_token.callback, /datum/callback/)){\
			expiring_token.callback.Invoke(expiring_token.content);\
		}\
		\
		STB_CALL_LOWWATERMARK(expiring_token);\
		src.content.Remove(expiring_token);\
		if((!STB_IS_LEAKYBUCKET) && !src.next_expiration_callback){\
			STB_REGISTER_EXPIRATION_TIMER((src.content[src.content.len]), (src.content[(src.content.len)].expire_time - STB_REALTIMESOURCE));\
		}\
	}\


/// Removes the timer for the expiration of a token and nulls the bucket's next_expiration, in non-leakybucket mode
#define STB_PURGE_EXPIRATION_TIMER\
	if(src.next_expiration_callback){\
		deltimer(src.next_expiration_callback);\
		src.next_expiration = null;\
		src.next_expiration_callback = null;\
	};


// /datum/smart_token_bucket/proc/PeekExpired()

// 	if(STB_IS_LEAKYBUCKET)
// 		crash_with("The bucket is working as leaky bucket, looking for expired tokens when they get popped as soon as they expire makes no sense.")

// 	for(var/datum/bucket_token/token as anything in src.content)

// 		//If we have reached the area where expire_time is greater than our current time, no point in searching anymore
// 		if(token.expire_time > STB_REALTIMESOURCE)
// 			return FALSE

// 		//If the expire time is lower than our current time, the token has expired, return it
// 		if(token.expire_time <= STB_REALTIMESOURCE)
// 			return token

#define STB_PEEKEXPIRED(RET)\
	##RET = null;\
	for(var/datum/bucket_token/expiredtoken as anything in src.content){\
		if(expiredtoken.expire_time > STB_REALTIMESOURCE){\
			##RET = FALSE;\
			break;\
		}\
		else{\
			##RET = expiredtoken;\
			break;\
		}\
	}\


#define STB_ONDEMANDPROCESS\
	do {\
		var/datum/bucket_token/token; \
		STB_PEEKEXPIRED(token);\
		while(token && (token.expire_time <= STB_REALTIMESOURCE)){\
			STB_EXPIRE(token);\
			STB_PEEKEXPIRED(token);\
		}\
		if(!STB_IS_LEAKYBUCKET){\
			if(src.content.len && !src.next_expiration){\
				src.next_expiration = src.content[src.content.len].expire_time;\
			}\
		}\
	} while(FALSE)

/// Runs the ondemand processing to find and expire the tokens in fixed TTL mode
#define STB_RUN_ONDEMAND_PROCESS\
	if(!STB_IS_LEAKYBUCKET){\
		STB_ONDEMANDPROCESS;\
	};


#define STB_PEEKAT(INDEX)\
	if(!(STB_IS_LEAKYBUCKET)){\
		STB_RUN_ONDEMAND_PROCESS;\
	}\
	return src.content?[INDEX]


#define STB_POPAT(INDEX)\
	do {\
		if(!STB_IS_LEAKYBUCKET){\
			STB_ONDEMANDPROCESS;\
			if(INDEX == src.content.len){\
				STB_PURGE_EXPIRATION_TIMER;\
				if((src.content.len)-1){\
					src.next_expiration = src.content[src.content.len-1].expire_time;\
					STB_REGISTER_EXPIRATION_TIMER(src.content[(src.content.len-1)], (src.content[(src.content.len-1)].expire_time - STB_REALTIMESOURCE));\
				}\
			}\
		}\
		var/popped = src.content?[INDEX];\
		if(!popped){\
			return FALSE;\
		}\
		src.content.Remove(popped);\
		if(STB_IS_FIXEDTTL_MODE){\
			if(!src.content.len){\
				STB_PURGE_EXPIRATION_TIMER;\
			}\
		}\
		STB_CALL_LOWWATERMARK(popped);\
		return popped;\
	} while (FALSE)


/**
 * Inserts an object or prebaked token into the bucket, if it's not a prebaked token one will be created
 *
 * * token_content - The content that you want to put in the token, or a token
 * * token_expire_time - The expire time of a token, only valid in Variable TTL mode AND if token_content is not a token itself
 *
 * Returns TRUE if the token was added, FALSE in case it's full at or above bucket_size
 */
/datum/smart_token_bucket/proc/Insert(var/datum/bucket_token/token_content, var/token_expire_time = null)

	/*
	 * Guards
	 */
	if(!src.mode)
		crash_with("The smart token bucket is not initialized, initialize the bucket before trying to insert.")

	//Prevent insertion of tokens if the hard limit (bucket size) is reached
	if((!isnull(src.bucket_size)) && (src.content.len >= src.bucket_size))
		return FALSE

	//Prevent insertion of expired tokens
	if((istype(token_content, /datum/bucket_token) && token_content.expire_time < STB_REALTIMESOURCE) || (!isnull(token_expire_time) && (token_expire_time < STB_REALTIMESOURCE)))
		crash_with("You cannot insert a token that has already expired in the bucket.")

	/*
	 * Preparation of the token
	 */

	if(!istype(token_content, /datum/bucket_token))
		var/datum/bucket_token/newtoken
		if(STB_IS_FIXEDTTL_MODE)
			newtoken = new(content = token_content, expiration = (STB_REALTIMESOURCE + tokens_lifetime))
		else
			newtoken = new(content = token_content, expiration = token_expire_time)
		token_content = newtoken


	//if an high watermark is specified, call the registered proc if it's triggered
	if((src.content.len >= high_watermark))
		if(high_watermark_call)
			call(high_watermark_call)(token_content)

	/*
	 * Registration and handling of expiration callback(s)
	 */

	//We are operating in fixed TTL mode
	if(STB_IS_FIXEDTTL_MODE)

		//We are going for a leaky bucket, register an Expire() timer for each token
		if(STB_IS_LEAKYBUCKET)

			if(token_content.expire_time <= src.next_expiration)
				src.next_expiration = token_content.expire_time

			addtimer(CALLBACK(src, PROC_REF(Expire), token_content), tokens_lifetime)

		//Not a leaky bucket, we only care to process when something is added, removed, or the longest timer expires
		else
			STB_ONDEMANDPROCESS

			if(token_content.expire_time >= src.next_expiration)

				STB_PURGE_EXPIRATION_TIMER

				src.next_expiration = token_content.expire_time

				STB_REGISTER_EXPIRATION_TIMER(token_content, tokens_lifetime)


	//We are operating in variableTTL mode
	else

		//In variableTTL leaky bucket scenario, just register a callback timer for every token according to the diff between the expire time and the current time,
		//thus giving us the wait time for the token to expire
		if(STB_IS_LEAKYBUCKET)
			if(token_content.expire_time <= src.next_expiration)
				src.next_expiration = token_content.expire_time
			addtimer(CALLBACK(src, PROC_REF(Expire), token_content), (token_content.expire_time - STB_REALTIMESOURCE))

		//Not leaky bucket, this is where we cry
		else
			STB_ONDEMANDPROCESS

			if(!src.next_expiration)
				STB_PURGE_EXPIRATION_TIMER

				src.next_expiration = token_content.expire_time

				STB_REGISTER_EXPIRATION_TIMER(token_content, (token_content.expire_time - STB_REALTIMESOURCE))


	//If we are in fixedTTL, it is guaranteed that every new token will expire after the ones already present, so we can skip the btree search and just append it
	//otherwise, we have to use the btree search to insert it at the correct position of the tree
	if(!(STB_IS_FIXEDTTL_MODE))
		STB_BTREE_INSERT(token_content)
	else
		src.content += token_content

	return TRUE


/**
 * Called by a callback to expire a token, generally not supposed to be called directly
 *
 * * expiring_token - The token to expire
 * * skip_on_demand_process - Skips the call to OnDemandProcess()
 */
/datum/smart_token_bucket/proc/Expire(var/datum/bucket_token/expiring_token, var/skip_on_demand_process = FALSE)
	STB_EXPIRE(expiring_token)
	if(!skip_on_demand_process)
		STB_RUN_ONDEMAND_PROCESS


/**
 * Returns the FIRST token in the list that has expired, DOES NOT REMOVE IT, just peek
 *
 * Works only in NON-LEAKY-BUCKET mode, as tokens that expire are immediately removed otherwise
 */
/datum/smart_token_bucket/proc/PeekExpired()

	if(STB_IS_LEAKYBUCKET)
		crash_with("The bucket is working as leaky bucket, looking for expired tokens when they get popped as soon as they expire makes no sense.")

	for(var/datum/bucket_token/token as anything in src.content)

		//If we have reached the area where expire_time is greater than our current time, no point in searching anymore
		if(token.expire_time > STB_REALTIMESOURCE)
			return FALSE

		//If the expire time is lower than our current time, the token has expired, return it
		if(token.expire_time <= STB_REALTIMESOURCE)
			return token


/**
 * Returns the valid token in the bucket at the index, or null if theres nothing at said index.
 *
 * Does not remove the element.
 *
 * * index - The position in the bucket to peek at
 */
/datum/smart_token_bucket/proc/PeekAt(var/index)
	STB_PEEKAT(index)

/**
 * Returns the first valid token in the bucket, or null if theres nothing.
 *
 * Does not remove the element.
 */
/datum/smart_token_bucket/proc/Peek()
	STB_PEEKAT(1)


/**
 * Pops the (non expired) token from the bucket at index and returns it, removing it from the bucket
 *
 * Does not trigger the token's expiration callback, as it's not expired.
 *
 * * index - The position in the bucket to pop a token from
 */
/datum/smart_token_bucket/proc/PopAt(var/index)
	STB_POPAT(index)

/**
 * Pops the oldest (non expired) token from the bucket and returns it, removing it from the bucket
 */
/datum/smart_token_bucket/proc/Pop()
	STB_POPAT(1)


/**
 * The maintenance function, called at operations on the bucket when the bucket is not operating in leaky bucket mode
 */
/datum/smart_token_bucket/proc/OnDemandProcess()
	STB_ONDEMANDPROCESS



//#undef STB_REALTIMESOURCE
#undef STB_BTREE_INSERT
#undef STB_IS_LEAKYBUCKET
#undef STB_REGISTER_EXPIRATION_TIMER
#undef STB_CALL_LOWWATERMARK
#undef STB_EXPIRE
#undef STB_PURGE_EXPIRATION_TIMER
#undef STB_ONDEMANDPROCESS
#undef STB_RUN_ONDEMAND_PROCESS
#undef STB_PEEKAT
#undef STB_POPAT


/obj/teardropbucket
	name = "The bucket of the teardrops I will have"
	var/datum/smart_token_bucket/stb

/obj/teardropbucket/New(loc, ...)
	. = ..()
	stb = new(mode = STB_MODE_FIXEDTTL, flags = null, tokens_lifetime = (60 SECONDS))
	stb.tokens_lifetime = 60 SECONDS
	stb.low_watermark = 2
	stb.low_watermark_call = PROC_REF(LowWatermark)
	stb.high_watermark = 4
	stb.high_watermark_call = PROC_REF(HighWatermark)

/obj/teardropbucket/verb/AddTear()
	name = "Add a tear"

	var/tear = input("Tear content")
	//var/ttl = text2num(input("TTL"))

	//stb.Insert(tear, (STB_REALTIMESOURCE + (ttl SECONDS)))
	stb.Insert(tear)

/obj/teardropbucket/proc/Benchmark(var/tears = 1000)

	var/modes = list("FixedTTL" = STB_MODE_FIXEDTTL, "VariableTTL" = STB_MODE_VARIABLETTL)
	var/flags = list("none" = null, "LeakyBucket" = STB_FLAG_LEAKYBUCKET)

	for(var/mode in modes)
		for(var/flag in flags)


			if(HAS_FLAG(modes[mode], STB_MODE_FIXEDTTL))
				stb = new(mode = modes[mode], flags = flags[flag], tokens_lifetime = (1 SECONDS))
			else
				stb = new(mode = modes[mode], flags = flags[flag])

			rustg_time_reset("fff")
			rustg_time_milliseconds("fff")

			for(var/i=0, i<tears, i++)
				if(HAS_FLAG(modes[mode], STB_MODE_FIXEDTTL))
					stb.Insert(i)
				else
					stb.Insert(i, (STB_REALTIMESOURCE + 1 SECONDS))

			to_world("Inserting [tears] tears took [rustg_time_milliseconds("fff")] ms, mode [mode] flags [flag]")

			rustg_time_reset("expiration")
			rustg_time_milliseconds("expiration")


			var/sleeptime = 0
			var/OnDemandProcessingTime = 0
			while(stb.content.len)
				if(NOT_FLAG(flags[flag], STB_FLAG_LEAKYBUCKET))
					rustg_time_reset("OnDemandProcessingTime")
					rustg_time_milliseconds("OnDemandProcessingTime")
					stb.OnDemandProcess()
					OnDemandProcessingTime += rustg_time_milliseconds("OnDemandProcessingTime")

				rustg_time_reset("waiting")
				rustg_time_milliseconds("waiting")
				sleep(1)
				sleeptime += rustg_time_milliseconds("waiting")

			var/expirationTime = NOT_FLAG(flags[flag], STB_FLAG_LEAKYBUCKET) ? OnDemandProcessingTime : (rustg_time_milliseconds("fff")) - sleeptime

			to_world("The expiration of [tears] tears took [expirationTime] ms, mode [mode] flags [flag]")
			rustg_time_reset("expiration")

			ASSERT(!stb.content.len)

/obj/teardropbucket/verb/PopTear()
	to_chat(usr, "[stb.Pop()?.content]")

/obj/teardropbucket/proc/PopTearAt(var/index = 1)
	to_chat(usr, "[stb.PopAt(index)?.content]")

/obj/teardropbucket/verb/PeekTear()
	to_chat(usr, "[stb.Peek()?.content]")

/obj/teardropbucket/proc/PeekTearAt(var/index = 1)
	to_chat(usr, "[stb.PeekAt(index)?.content]")

/obj/teardropbucket/verb/PeekExpiredTear()
	to_chat(usr, "[stb.PeekExpired()?.content]")

/obj/teardropbucket/proc/LowWatermark()
	return FALSE
	//to_world("Low watermark triggered")

/obj/teardropbucket/proc/HighWatermark()
	return FALSE
	//to_world("High watermark triggered")
