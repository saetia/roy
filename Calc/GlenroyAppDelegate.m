//
//  GlenroyAppDelegate.m
//  Calc
//
//  Created by Joel Glovacki on 7/24/12.
//  Copyright (c) 2012 ByteStudios. All rights reserved.
//

#import "GlenroyAppDelegate.h"
#import "GANTracker.h"

static const NSInteger kGANDispatchPeriodSec = 10;

@implementation GlenroyAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];

    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0.090196f green:0.207843f blue:0.443137f alpha:1.0f]];
    
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
      
        
        UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
        UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
        splitViewController.delegate = (id)navigationController.topViewController;
        
        
        
    } else {
        
        
        
        CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
        
        if (iOSDeviceScreenSize.height == 480)
        {
            // Instantiate a new storyboard object using the storyboard file named Storyboard_iPhone35
            UIStoryboard *iPhone35Storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
            
            // Instantiate the initial view controller object from the storyboard
            UIViewController *initialViewController = [iPhone35Storyboard instantiateInitialViewController];
            
            // Instantiate a UIWindow object and initialize it with the screen size of the iOS device
            self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            
            // Set the initial view controller to be the root view controller of the window object
            self.window.rootViewController  = initialViewController;
            
            // Set the window object to be the key window and show it
            [self.window makeKeyAndVisible];
        }
        
        if (iOSDeviceScreenSize.height == 568)
        {   // iPhone 5 and iPod Touch 5th generation: 4 inch screen
            // Instantiate a new storyboard object using the storyboard file named Storyboard_iPhone4
            UIStoryboard *iPhone4Storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone5" bundle:nil];
            
            UIViewController *initialViewController = [iPhone4Storyboard instantiateInitialViewController];
            self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            self.window.rootViewController  = initialViewController;
            [self.window makeKeyAndVisible];
        }

        
        
        
    }

    
    [self initDefaults];
    [self googleTracking];


    
    
    
    

    
    

    
    return YES;
    
}
	

- (void)googleTracking {

    
    [[GANTracker sharedTracker] startTrackerWithAccountID:@"UA-33990026-1"
                                           dispatchPeriod:kGANDispatchPeriodSec
                                                 delegate:nil];

    NSError *error;
    
//    if (![[GANTracker sharedTracker] setCustomVariableAtIndex:1
//                                                         name:@"iPhone1"
//                                                        value:@"iv1"
//                                                    withError:&error]) {
//        // Handle error here
//    }
    
//
//    if (![[GANTracker sharedTracker] trackEvent:@"my_category"
//                                         action:@"my_action"
//                                          label:@"my_label"
//                                          value:-1
//                                      withError:&error]) {
//        // Handle error here
//    }
    if (![[GANTracker sharedTracker] trackPageview:@"/app_launch"
                                         withError:&error]) {
        // Handle error here
    }
    

}


- (void)initDefaults {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults objectForKey:@"rememberOldEntries"] == nil) {
        [defaults setBool:YES forKey:@"rememberOldEntries"];
        [defaults synchronize];
    }


}

- (void)applicationWillResignActive:(UIApplication *)application{

}

- (void)applicationDidEnterBackground:(UIApplication *)application{

}

- (void)applicationWillEnterForeground:(UIApplication *)application{

}

- (void)applicationDidBecomeActive:(UIApplication *)application{

}

- (void)applicationWillTerminate:(UIApplication *)application{
 
}

@end
