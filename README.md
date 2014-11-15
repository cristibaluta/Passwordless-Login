RCPasswordlessLogin
===================

Painless login system without password for mobile. It works by registering each device uuid on the server without asking the user.
Once you've done that, you can add new info to that user as it gets collected, for example after you login with facebook you'll associate the facebook id and email to your original user.
Now you have multiple users with the facebook id or email that keeps them associated, and you can sync all of them.


Advantages
==========
Why not using just facebook? Few reasons:
- This system registers your users without asking. Me as a user i totaly hate to login before seeing what can the app do. Later if i decided that i like the app i can login with facebook in order to have synchronization or just take advantage of it's features
- You could login to webpages by entering your email only, you'll just have to confirm it. No need to remind one more password


Usage
=====

If your serverside app can handle more options you can pass an extra dictionary, like the locationDictionary in this example.

	#import "RCPasswordlessLogin.h"
	
	NSDictionary *locationDictionary = @{
		@"loc_latitude":[NSNumber numberWithDouble:45.5],
		@"loc_longitude":[NSNumber numberWithDouble:26.4],
	};
			
	RCPasswordlessLogin *login = [RCPasswordlessLogin initWithServiceURL:[NSURL URLWithString:REGISTER_USER_URL]];
	[login loginWithEmail:@"email" facebookID:@1232314324 extraInfo:locationDictionary completion:^(BOOL success) {
					
	}];
