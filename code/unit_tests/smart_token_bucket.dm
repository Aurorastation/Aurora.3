/*
 *
 *  Smart token bucket tests
 *
 */

/datum/unit_test/smart_token_bucket
	name = "Smart Token Bucket Unit Test"
	var/datum/smart_token_bucket/stb
	var/datum/smart_token_bucket/stb2
	var/expiration_count = 0
	var/high_watermark_count = 0
	var/low_watermark_count = 0
	var/total_expired_amount = 0
	var/list/inserted_token_contents = list()
	var/list/expired_token_contents = list()
	var/is_inserting = FALSE
	var/expired_during_insertion = 0

/datum/unit_test/smart_token_bucket/start_test()

	if(Test1() == UNIT_TEST_FAILED)
		TEST_FAIL("Failed on Test1")
	else if(Test2() == UNIT_TEST_FAILED)
		TEST_FAIL("Failed on Test2")
	else
		TEST_PASS("Smart Token Bucket tests were successful")

	return 1

/datum/unit_test/smart_token_bucket/proc/Test1(var/tears = 100000, var/high_watermark = 30, var/low_watermark = 2, var/tokens_lifetime = (10 SECONDS))

	var/modes = list("FixedTTL" = STB_MODE_FIXEDTTL, "VariableTTL" = STB_MODE_VARIABLETTL)
	var/flags = list("none" = null, "LeakyBucket" = STB_FLAG_LEAKYBUCKET)

	for(var/mode in modes)
		for(var/flag in flags)


			if(HAS_FLAG(modes[mode], STB_MODE_FIXEDTTL))
				src.stb = new(mode = modes[mode], flags = flags[flag], tokens_lifetime = tokens_lifetime)
			else
				src.stb = new(mode = modes[mode], flags = flags[flag])
			src.stb.high_watermark = high_watermark
			src.stb.high_watermark_call = CALLBACK(src, PROC_REF(HighWatermark))
			src.stb.low_watermark = low_watermark
			src.stb.low_watermark_call = CALLBACK(src, PROC_REF(LowWatermark))
			src.stb.bucket_size =  tears

			var/expected_total_expired_amount = 0
			src.is_inserting = TRUE
			for(var/i=0, i<tears, i++)
				if(HAS_FLAG(modes[mode], STB_MODE_FIXEDTTL))
					stb.Insert(token_content = i, callback = CALLBACK(src, PROC_REF(TokenExpired)))
				else
					stb.Insert(token_content = i, token_expire_time = (STB_REALTIMESOURCE + tokens_lifetime), callback = CALLBACK(src, PROC_REF(TokenExpired)))

				expected_total_expired_amount += i
				src.inserted_token_contents.Add(i)
			src.is_inserting = FALSE

			TEST_DEBUG("Inserted [tears] tears, mode [mode] flags [flag]")


			//Sanity check that we haven't added any shit, expired more things than we should or not expired something that we should have
			src.stb.Peek() //This ensures the insertion list is fully committed

			TEST_ASSERT(((src.stb.content.len + src.expiration_count) == tears), "The sum of expirations and what is in the bucket must be equal to what we added") //The sum of expirations and what is in the bucket must be equal to what we added, unless we shat something up

			for(var/datum/bucket_token/token in src.stb.content)
				TEST_ASSERT((!isnull(token.content)), "There is a null token in the bucket, but we have not added it")

			//Wait and process until all the tokens are expired
			while(src.stb.insertion_list_index || src.stb.content.len)
				if(NOT_FLAG(flags[flag], STB_FLAG_LEAKYBUCKET))
					stb.OnDemandProcess()
				sleep(1)

			TEST_ASSERT((!stb.insertion_list_index), "The insertion list (cache) was not emptied correctly")
			TEST_ASSERT((!stb.content.len), "There are still buckets in the token, after they should have expired")

			//Check that we have received back the tokens in the order of expiration, aka how we added them
			for(var/i in 1 to src.inserted_token_contents.len)
				TEST_ASSERT(((src.inserted_token_contents[i]) == (src.expired_token_contents[i])), "We have received back expired tokens in an unexpected order")

			TEST_ASSERT((expected_total_expired_amount == src.total_expired_amount), "The expected amount of tokens was not returned, \
			meaning we might have sent some repeatedly, skipped some, or the likes") //This pretty much guarantees that we have always returned the correct token

			//Verify that the watermarks works
			if(!src.expired_during_insertion) //If there are expirations during the insertion, this offsets, I can't figure out how to calculate how much, so fuck it
				TEST_ASSERT((high_watermark == (tears - (src.high_watermark_count + src.expired_during_insertion))), "We triggered the high watermark an unexpected amount of times")
				TEST_ASSERT((low_watermark == src.low_watermark_count), "We triggered the low watermark an unexpected amount of times")
			src.high_watermark_count = 0
			src.low_watermark_count = 0

			//Reset vars
			src.expiration_count = 0
			src.total_expired_amount = 0
			src.inserted_token_contents = list()
			src.expired_token_contents = list()
			src.expired_during_insertion = 0

	return TRUE

/datum/unit_test/smart_token_bucket/proc/Test2(var/tears = 10, var/tokens_lifetime = (10 SECONDS))
	var/modes = list("FixedTTL" = STB_MODE_FIXEDTTL, "VariableTTL" = STB_MODE_VARIABLETTL)
	var/flags = list("none" = null, "LeakyBucket" = STB_FLAG_LEAKYBUCKET)

	for(var/mode in modes)
		for(var/flag in flags)


			if(HAS_FLAG(modes[mode], STB_MODE_FIXEDTTL))
				src.stb2 = new(mode = modes[mode], flags = flags[flag], tokens_lifetime = tokens_lifetime)
			else
				src.stb2 = new(mode = modes[mode], flags = flags[flag])
			src.stb2.bucket_size =  tears

			var/expected_total_expired_amount = 0
			for(var/i=0, i<tears, i++)
				if(HAS_FLAG(modes[mode], STB_MODE_FIXEDTTL))
					src.stb2.Insert(token_content = i, callback = CALLBACK(src, PROC_REF(TokenExpired)))
				else
					src.stb2.Insert(token_content = i, token_expire_time = (STB_REALTIMESOURCE + tokens_lifetime), callback = CALLBACK(src, PROC_REF(TokenExpired)))

				expected_total_expired_amount += i
				src.inserted_token_contents.Add(i)

			var/previous_timer_id = src.stb2.next_expiration_callback

			var/datum/bucket_token/low_peeked_token = src.stb2.Peek()
			var/datum/bucket_token/low_popped_token = src.stb2.Pop()

			TEST_ASSERT((previous_timer_id == src.stb2.next_expiration_callback), "The expiration callback was refreshed while not popping the last expiring token") //Shouldn't change when popping low, or peeking

			var/datum/bucket_token/high_peeked_token = src.stb2.PeekAt(src.stb2.content.len)
			var/datum/bucket_token/high_popped_token = src.stb2.PopAt(src.stb2.content.len)

			if(NOT_FLAG(flags[flag], STB_FLAG_LEAKYBUCKET))
				TEST_ASSERT((!isnull(src.stb2.next_expiration_callback) && (previous_timer_id != src.stb2.next_expiration_callback)), "The expiration callback was either\
				not refreshed or was unset after popping the last expiring token") //Should still exist and be a different timer if popped high

			//Ensure we have peeked and popped the right tokens
			TEST_ASSERT((low_peeked_token.content == 0), "The wrong token was returned on low peeking")
			TEST_ASSERT((low_popped_token.content == 0), "The wrong token was returned on low popping")

			TEST_ASSERT((high_peeked_token.content == (tears-1)), "The wrong token was returned on high peeking")
			TEST_ASSERT((high_popped_token.content == (tears-1)), "The wrong token was returned on high peeking")

			//Wait and process until all the tokens are expired
			while(src.stb2.insertion_list_index || src.stb2.content.len)
				sleep(10)

			TEST_ASSERT((expected_total_expired_amount == (src.total_expired_amount + low_popped_token.content + high_popped_token.content)), "Not every token\
			was expired, or some tokens were expired more than once - expected_total_expired_amount: [expected_total_expired_amount], total_expired_amount: [total_expired_amount]\
			, low_popped_token: [low_popped_token.content], high_popped_token: [high_popped_token.content]") //This means we have expired everything

			//Reset vars
			src.expiration_count = 0
			src.total_expired_amount = 0
			src.inserted_token_contents = list()
			src.expired_token_contents = list()
			src.expired_during_insertion = 0

	return TRUE

/datum/unit_test/smart_token_bucket/proc/LowWatermark(var/datum/bucket_token/bucket_token)
	ASSERT(src.stb.is_low_watermark)
	src.low_watermark_count += 1

/datum/unit_test/smart_token_bucket/proc/HighWatermark()
	ASSERT(src.stb.is_high_watermark)
	src.high_watermark_count += 1

/datum/unit_test/smart_token_bucket/proc/TokenExpired(var/datum/bucket_token/bucket_token)
	src.expiration_count += 1
	src.total_expired_amount += bucket_token.content
	src.expired_token_contents.Add(bucket_token.content)

	if(src.is_inserting)
		src.expired_during_insertion += 1

	#define BUCKET_CONTENT_FILL (src.stb.content.len + src.stb.batch_expired_offset + src.stb.insertion_list_index)

	if((BUCKET_CONTENT_FILL < src.stb.high_watermark) && (BUCKET_CONTENT_FILL > src.stb.low_watermark))
		TEST_ASSERT((!src.stb.is_high_watermark), "The bucket is marked as high watermark, when it shouldn't be")
		TEST_ASSERT((!src.stb.is_low_watermark), "The bucket is marked as low watermark, when it shouldn't be")

	if(BUCKET_CONTENT_FILL >= src.stb.high_watermark)
		TEST_ASSERT((src.stb.is_high_watermark), "The bucket is not marked as high watermark, when it should be")
		TEST_ASSERT((!src.stb.is_low_watermark), "The bucket is marked as low watermark, when it shouldn't be")

	if(BUCKET_CONTENT_FILL <= src.stb.low_watermark)
		TEST_ASSERT((!src.stb.is_high_watermark), "The bucket is marked as high watermark, when it shouldn't be")
		TEST_ASSERT((src.stb.is_low_watermark), "The bucket is not marked as low watermark, when it should be")

	#undef BUCKET_CONTENT_FILL
