//
//  GlenroyMasterViewController.h
//  Calc
//
//  Created by Joel Glovacki on 7/24/12.
//  Copyright (c) 2012 ByteStudios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/CoreAnimation.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

#define ClearValues 1
#define ShareItems 2







@class GlenroyDetailViewController;

@interface GlenroyMasterViewController : UITableViewController <UIActionSheetDelegate, MFMailComposeViewControllerDelegate> {
    NSArray *calculations;
    NSMutableDictionary *calculation_categories;
    UIActionSheet *shareSheet;
    bool presetTableCell;
    
    NSIndexPath *lastSelection;
    
    
}


@property (strong, nonatomic) GlenroyDetailViewController *detailViewController;
@property (strong, nonatomic) NSArray *calculations;
@property (strong, nonatomic) NSMutableDictionary *calculation_categories;


@property (assign) int var2o;
@property (assign) int var3o;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *clearTableValues;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *shareSelectedTableItems;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *shareButton;

- (IBAction)clearTableValues:(UIBarButtonItem *)sender;
- (IBAction)shareSelectedTableItems:(UIBarButtonItem *)sender;
- (IBAction)shareTableItems:(UIBarButtonItem *)sender;

@end
