//
//  GlenroySettingsViewController.h
//  Calc
//
//  Created by Joel Glovacki on 7/31/12.
//  Copyright (c) 2012 ByteStudios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GlenroySettingsViewController : UIViewController <UIActionSheetDelegate, UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UISwitch *useMetricSystemSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *rememberOldEntriesSwitch;
@property (weak, nonatomic) IBOutlet UIButton *resetAllPreviouslyEnteredDataButton;

@property (weak, nonatomic) IBOutlet UIWebView *aboutUs;

- (IBAction)useMetricSystem:(id)sender;
- (IBAction)rememberOldEntries:(id)sender;
- (IBAction)resetAllPreviouslyEnteredData:(id)sender;

@end
