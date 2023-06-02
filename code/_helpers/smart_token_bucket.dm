#define STB_REALTIMESOURCE world.timeofday //The source of the time to base the tokens calculations off

/datum/bucket_token
	var/content = null //The content of the token, can be anything really
	var/time = null //The creation time of this token
	var/expire_time = null //The time this token will expire
	var/datum/callback/callback = null //The callback to invoke when this token expires

/datum/bucket_token/New(var/content, var/expiration)

	if(expiration < STB_REALTIMESOURCE)
		crash_with("The expiration time of the token is in the past, this is not allowed.")

	src.time = STB_REALTIMESOURCE
	if(!isnull(expiration) && isnum(expiration))
		src.expire_time = expiration

	src.content = content


#define STB_MODE_FIXEDTTL BITFLAG(1) //All tokens have the same lifetime
#define STB_MODE_VARIABLETTL BITFLAG(2) //Each token can specify a different lifetime

#define STB_FLAG_LEAKYBUCKET BITFLAG(1) //Used to indicate that each token must expire on its own, rather than wait for the next operation on the bucket to do something

/datum/smart_token_bucket
	var/list/content = list() //The content inside the bucket

	var/bucket_size = null //The size of the bucket
	var/mode = null //The bucket operation mode
	var/flags = null //Flags about the operation of this bucket
	var/tokens_lifetime = null //How long the tokens last, in fixedTTL mode

	var/next_expiration = null //Time for the next token that expires
	var/next_expiration_callback = null //The callback handler of the timer to expire the next token

	var/high_watermark = null //Soft overfill limit
	var/high_watermark_call = null //What to call in case the high_watermark is reached or surpassed

	var/low_watermark = null //Soft underfill limit
	var/low_watermark_call = null //What to call in case the low_watermark is reached or surpassed




/datum/smart_token_bucket/New(var/mode = STB_MODE_FIXEDTTL, var/flags = null, var/tokens_lifetime)

	if(isnull(mode))
		crash_with("You must specify a mode.")

	if((mode & STB_MODE_FIXEDTTL) && !tokens_lifetime)
		crash_with("Trying to initialize a smart token bucket in fixed TTL mode, without specifying the time.")
	else if((mode & STB_MODE_FIXEDTTL))
		src.tokens_lifetime = tokens_lifetime

	src.mode = mode
	src.flags = flags


#define STB_BTREE_INSERT(TOKEN) BINARY_INSERT(TOKEN, src.content, /datum/bucket_token, TOKEN, expire_time, COMPARE_KEY)
#define STB_EXPIRED_TOKEN_GUARD(TIME) ((TIME <= STB_REALTIMESOURCE) || isnull(TIME)) ? crash_with("You cannot add a token without an expire_time set, or that has already expired!") : null

#define STB_IS_FIXEDTTL_MODE (src.mode & STB_MODE_FIXEDTTL)
#define STB_IS_LEAKYBUCKET (src.flags & STB_FLAG_LEAKYBUCKET)

#define STB_REGISTER_EXPIRATION_TIMER_FIXEDTTL(TOKEN) (src.next_expiration_callback = addtimer(CALLBACK(src, PROC_REF(Expire), TOKEN), tokens_lifetime, TIMER_UNIQUE|TIMER_STOPPABLE))
#define STB_PURGE_EXPIRATION_TIMER (src.next_expiration_callback) ? deltimer(src.next_expiration_callback) : null
#define STB_RUN_ONDEMAND_PROCESS (STB_IS_LEAKYBUCKET ? null : OnDemandProcess())
/**
 * Inserts an object or prebaked token into the bucket, if it's not a prebaked token one will be created
 *
 * token_expire_time is relevant and only used in variableTTL mode
 *
 * Returns FALSE in case it's full above the size
 */
/datum/smart_token_bucket/proc/Insert(var/datum/bucket_token/token_content, var/token_expire_time)

	/**
	 * Guards
	 */
	if(!src.mode)
		crash_with("The smart token bucket is not initialized, initialize the bucket before trying to insert.")
	if((!isnull(src.bucket_size)) && (src.content.len >= src.bucket_size))
		return FALSE

	/**
	 * Insertion (and eventual creation) of the token in the bucket
	 */

	// In fixedTTL mode
	if(STB_IS_FIXEDTTL_MODE)

		//If not a token already, make a new token with the param as content
		if(!istype(token_content, /datum/bucket_token))
			var/datum/bucket_token/newtoken = new(content = token_content, expiration = (STB_REALTIMESOURCE + tokens_lifetime))
			token_content = newtoken

	//In variableTTL mode
	else
		//If not a token already, make a new token with the param as content
		if(!istype(token_content, /datum/bucket_token))
			STB_EXPIRED_TOKEN_GUARD(token_expire_time)

			var/datum/bucket_token/newtoken = new(content = token_content, expiration = token_expire_time)
			token_content = newtoken
		else
			STB_EXPIRED_TOKEN_GUARD(token_content.expire_time)


	//if an high watermark is specified, call the registered proc if it's triggered
	if((src.content.len >= high_watermark))
		if(high_watermark_call)
			call(high_watermark_call)()

	/**
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
			OnDemandProcess()

			if(token_content.expire_time >= src.next_expiration)

				src.next_expiration = token_content.expire_time

				STB_PURGE_EXPIRATION_TIMER

				STB_REGISTER_EXPIRATION_TIMER_FIXEDTTL(token_content)


	//We are operating in variableTTL mode
	else

		if(STB_IS_LEAKYBUCKET)
			if(token_content.expire_time <= src.next_expiration)
				src.next_expiration = token_content.expire_time
			addtimer(CALLBACK(src, PROC_REF(Expire), token_content), token_content.expire_time)

		//Not leaky bucket
		else
			OnDemandProcess()

			if(token_content.expire_time >= src.next_expiration)

				src.next_expiration = token_content.expire_time

				STB_PURGE_EXPIRATION_TIMER

				STB_REGISTER_EXPIRATION_TIMER_FIXEDTTL(token_content)



	STB_BTREE_INSERT(token_content)



/**
 * Called by a callback to expire a token
 */
/datum/smart_token_bucket/proc/Expire(var/datum/bucket_token/expiring_token, var/skip_on_demand_process = FALSE)

	//This token does not exist, aka probably already popped, just return
	if(!(expiring_token in src.content))
		(skip_on_demand_process) ? null : STB_RUN_ONDEMAND_PROCESS
		return

	//Invoke the token callback, if registered
	if(expiring_token.callback && istype(expiring_token.callback, /datum/callback/))
		expiring_token.callback.Invoke(expiring_token.content)

	if(!isnull(low_watermark) && (src.low_watermark <= src.content.len))
		if(low_watermark_call)
			call(low_watermark_call)()

	src.content.Remove(expiring_token)

	if(!skip_on_demand_process)
		STB_RUN_ONDEMAND_PROCESS



/**
 * The maintenance function, called at operations on the bucket when the bucket is not operating in leaky bucket mode
 */
/datum/smart_token_bucket/proc/OnDemandProcess()
	var/token = PeekExpired()

	while(token)
		Expire(expiring_token = token, skip_on_demand_process = TRUE)
		token = PeekExpired()


/**
 * Returns the FIRST token in the list that has expired, DOES NOT REMOVE IT, just peek
 *
 * Works only in NON-LEAKY-BUCKET mode
 */
/datum/smart_token_bucket/proc/PeekExpired()

	if(STB_IS_LEAKYBUCKET)
		crash_with("The bucket is working as leaky bucket, looking for expired tokens when they get popped as soon as they expire makes no sense.")

	for(var/datum/bucket_token/token as anything in src.content)

		//If we have reached the area where expire_time is greater than our current time, no point in searching anymore
		if(token.expire_time >= STB_REALTIMESOURCE)
			return FALSE

		//If the expire time is lower than our current time, the token has expired, return it
		if(token.expire_time <= STB_REALTIMESOURCE)
			return token

/**
 * Returns the first valid token in the bucket, or null if theres nothing.
 *
 * Does not remove the element.
 */
/datum/smart_token_bucket/proc/Peek()
	OnDemandProcess() //Let's get rid of the expired ones first
	return src.content?[1]

/**
 * Pops one (non expired) token from the bucket and returns it, removing it from the bucket, does not expire it
 */
/datum/smart_token_bucket/proc/Pop()
	var/popped = Peek()
	src.content.Remove(popped)
	return popped

	if(STB_IS_FIXEDTTL_MODE)
		if(!src.content.len)
			STB_PURGE_EXPIRATION_TIMER





/obj/teardropbucket
	name = "The bucket of the teardrops I will have"
	var/datum/smart_token_bucket/stb

/obj/teardropbucket/New(loc, ...)
	. = ..()
	stb = new(mode = STB_MODE_FIXEDTTL, flags = STB_FLAG_LEAKYBUCKET, tokens_lifetime = 1 MINUTE)
	stb.low_watermark = 2
	stb.low_watermark_call = PROC_REF(LowWatermark)
	stb.high_watermark = 4
	stb.high_watermark_call = PROC_REF(HighWatermark)

/obj/teardropbucket/verb/AddTear()
	name = "Add a tear"

	var/tear = input("Tear content")

	stb.Insert(tear)


/obj/teardropbucket/verb/PopTear()
	to_chat(usr, "[stb.Pop()]")

/obj/teardropbucket/verb/PeekTear()
	to_chat(usr, "[stb.Peek()?.content]")

/obj/teardropbucket/verb/PeekExpiredTear()
	to_chat(usr, "[stb.PeekExpired()?.content]")

/obj/teardropbucket/proc/LowWatermark()
	to_world("Low watermark triggered")

/obj/teardropbucket/proc/HighWatermark()
	to_world("High watermark triggered")
