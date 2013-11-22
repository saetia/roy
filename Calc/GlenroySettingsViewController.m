//
//  GlenroySettingsViewController.m
//  Calc
//
//  Created by Joel Glovacki on 7/31/12.
//  Copyright (c) 2012 ByteStudios. All rights reserved.
//

#import "GlenroySettingsViewController.h"
#import "GANTracker.h"




@implementation GlenroySettingsViewController
@synthesize useMetricSystemSwitch;
@synthesize rememberOldEntriesSwitch;
@synthesize resetAllPreviouslyEnteredDataButton;
@synthesize aboutUs;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}









- (void)viewDidAppear:(BOOL)animated {

    NSError *error;
    
    if (![[GANTracker sharedTracker] trackPageview:@"/settings_about/"
                                         withError:&error]) {
        
    }

}


- (void)viewDidLoad {
    [super viewDidLoad];

	NSString *path = [[NSBundle mainBundle] pathForResource:@"about" ofType:@"html"];
    NSString *html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];

    aboutUs.delegate = self;
    [aboutUs loadHTMLString:html baseURL:nil];
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];


    //NSLog(@"%@ %@", [self class], [defaults persistentDomainForName:[[NSBundle mainBundle] bundleIdentifier]]);
    
    bool useMetricSystemSetting = [defaults boolForKey:@"useMetricSystem"];
    bool rememberOldEntriesSetting = [defaults boolForKey:@"rememberOldEntries"];
    
    //if (useMetricSystemSetting) NSLog(@"useMetricSystemSetting IS TRUE");
    //if (rememberOldEntriesSetting) NSLog(@"rememberOldEntriesSetting IS TRUE");

    
    if ([defaults objectForKey:@"useMetricSystem"] == nil) useMetricSystemSetting = NO;
    
    if ([defaults objectForKey:@"rememberOldEntries"] == nil) rememberOldEntriesSetting = YES;

    [useMetricSystemSwitch setOn:useMetricSystemSetting animated:NO];
    [rememberOldEntriesSwitch setOn:rememberOldEntriesSetting animated:NO];
    
}

- (void)viewDidUnload {
    [self setUseMetricSystemSwitch:nil];
    [self setRememberOldEntriesSwitch:nil];
    [self setResetAllPreviouslyEnteredDataButton:nil];
    [self setAboutUs:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



- (IBAction)useMetricSystem:(id)sender {
    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *useMetricSystem = [defaults objectForKey:@"useMetricSystem"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:useMetricSystemSwitch.isOn forKey:@"useMetricSystem"];
    [defaults synchronize];

    
    NSNotification *notif = [NSNotification notificationWithName:@"reload" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:notif];

    
    
}

- (IBAction)rememberOldEntries:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:rememberOldEntriesSwitch.isOn forKey:@"rememberOldEntries"];
    [defaults synchronize];
}

- (IBAction)resetAllPreviouslyEnteredData:(id)sender {

    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"Reset All Previously Entered Data?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Reset Data" otherButtonTitles: nil];
	popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    
    
    if (self.tabBarController)
        [popupQuery showInView:self.tabBarController.view]; 
    else 
        [popupQuery showInView:self.view];
    

}



- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0:{
            
            //NSLog(@"Deleting all prefs");
            
            NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
            [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
 
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            if (useMetricSystemSwitch.isOn)
                [defaults setBool:YES forKey:@"useMetricSystem"];
            else
                [defaults setBool:NO forKey:@"useMetricSystem"];

            
            if (rememberOldEntriesSwitch.isOn)
                [defaults setBool:YES forKey:@"rememberOldEntries"];
            else
                [defaults setBool:NO forKey:@"rememberOldEntries"];
            
            //[defaults setBool:rememberOldEntries.isOn forKey:@"rememberOldEntries"];
            
            
            [defaults synchronize];
            
            NSNotification *notif = [NSNotification notificationWithName:@"clearCurrentValues" object:self];
            [[NSNotificationCenter defaultCenter] postNotification:notif];
            
            
            
        }
        break;
        case 1:{
        
            //NSLog(@"Cancel");
        }
        break;
        
    }

            
}


-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    if ( inType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[inRequest URL]];
        return NO;
    }
    
    return YES;
}

@end