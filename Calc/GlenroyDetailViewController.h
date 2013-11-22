//
//  GlenroyDetailViewController.h
//  Calc
//
//  Created by Joel Glovacki on 7/24/12.
//  Copyright (c) 2012 ByteStudios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/CoreAnimation.h>

@interface GlenroyDetailViewController : UIViewController <UISplitViewControllerDelegate, UITextFieldDelegate, UIPopoverControllerDelegate, UIActionSheetDelegate> {
    UIColor *selectedColor;
    UIPopoverController *miniConverter;
    UIPopoverController *settingsPopover;
    UIPopoverController *infoPopover;
    NSMutableArray *storedLookups;
}

@property (weak, nonatomic) UITextField *focusedTextField;
@property (weak, nonatomic) NSString *transPickedCalculation;
@property (weak, nonatomic) NSString *transPickedCalculationUnits;
@property (weak, nonatomic) UITableView *transTableView;
@property (assign) int transTotalVariables;
@property (strong, nonatomic) UIPopoverController *masterPopoverController;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *showInfo;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *showSettings;

@property (weak, nonatomic) IBOutlet UIImageView *interface;
@property (weak, nonatomic) IBOutlet UITextField *userVar1;
@property (weak, nonatomic) IBOutlet UITextField *userVar2;
@property (weak, nonatomic) IBOutlet UITextField *userVar3;
@property (weak, nonatomic) IBOutlet UIButton *returnButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UILabel *finalResult;
@property (weak, nonatomic) IBOutlet UILabel *userLabel1;
@property (weak, nonatomic) IBOutlet UILabel *userLabel2;
@property (weak, nonatomic) IBOutlet UILabel *userLabel3;
@property (weak, nonatomic) IBOutlet UILabel *finalResultUnits;

@property (weak, nonatomic) NSString *transUserLabel1;
@property (weak, nonatomic) NSString *transUserLabel2;
@property (weak, nonatomic) NSString *transUserLabel3;
@property (assign) bool isCurlStarted;

- (void)configureView;

- (void)updateFinalResult;

- (void)resetUI;

- (IBAction)didDeleteCharacter:(UIButton *)sender;

- (IBAction)didEnterVariable:(UIButton *)sender;

- (IBAction)didPressKeypadButton:(UIButton *)sender;

- (IBAction)showInfo:(UIBarButtonItem *)sender;

- (IBAction)showSettings:(UIBarButtonItem *)sender;

- (void)visuallySelectField:(UITextField *) textField;

- (IBAction)tapOptions:(UITapGestureRecognizer *)sender;

@property (weak, nonatomic) IBOutlet UIView *calculator;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *convertNumberButton;

@end
