** Build and run **
1. Set the target's Bundle Identifier.
2. Set the apiKey variable in AppDelegate.swift.
3. Run the app. Enable push notifications when prompted. The push token will be logged to the console when it is received.
4. Send test push messages to the token from the Flurry/Marketing/Campaigns web page.
5. Observe logged messages.

** CoreLocation implementation fails to respond within 15 seconds and the app is killed **
1. Monitor app messages from the Console app.
2. Force close the Flurry Push app.
3. Send a test notification.
4. Dismiss the notification banner, if any.
5. Launch the app from the iOS Notification Center by tapping on the notification item.
6. The console will show the app starting. Sometimes notification-related messages are logged. The app hangs for 15 seconds before this is logged: "Location callback block not executed in a timely manner!" iOS then kills the app.

** CoreLocation unexpectedly active **
1. Watching the app console during startup, Flurry appears to use CoreLocation. This is unexpected and unwanted. How do I prevent Flurry from retrieving location?

** Extra completion notifications
1. Launch the app.
2. Send a test notification.
3. Tap the notification's banner.
4. This calls userNotificationCenter(_:didReceive:withCompletionHandler:)
5. I delegate this call to FlurryMessaging.receivedNotificationResponse(_:withCompletionHandler:)
6. The Flurry completion handler is unexpectedly called twice. Here are logged events:
`
default	14:14:31.999680 -0500	Flurry Push	Calling FlurryMessaging.receivedNotificationResponse...
default	14:14:31.002411 -0500	Flurry Push	FlurryMessaging.receivedNotificationResponse complete.
default	14:14:31.006691 -0500	Flurry Push	FlurryMessaging.receivedNotificationResponse complete.
`
