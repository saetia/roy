//
//  GlenroyDetailViewController.m
//  Calc
//
//  Created by Joel Glovacki on 7/24/12.
//  Copyright (c) 2012 ByteStudios. All rights reserved.
//

#import "GlenroyDetailViewController.h"
#import "GANTracker.h"

@implementation GlenroyDetailViewController

#pragma mark - Managing the detail item

@synthesize calculator = _calculator;
@synthesize convertNumberButton = _convertNumberButton;


@synthesize showInfo = _showInfo;
@synthesize showSettings = _showSettings;
@synthesize interface = _interface;

@synthesize userVar1 = _userVar1;
@synthesize userVar2 = _userVar2;
@synthesize userVar3 = _userVar3;

@synthesize returnButton = _returnButton;
@synthesize deleteButton = _deleteButton;
@synthesize finalResult = _finalResult;

@synthesize userLabel1 = _userLabel1;
@synthesize userLabel2 = _userLabel2;
@synthesize userLabel3 = _userLabel3;
@synthesize finalResultUnits = _finalResultUnits;


@synthesize transUserLabel1;
@synthesize transUserLabel2;
@synthesize transUserLabel3;
@synthesize transTotalVariables;
@synthesize transPickedCalculation;
@synthesize transPickedCalculationUnits;








- (void)configureView {
    // Update the user interface for the detail item.
    
    if (self.transPickedCalculation){
        
        self.title = self.transPickedCalculation;
        
    } else {
        
        //on boot
        self.title = @"Basis Weight → Yield";
        self.finalResultUnits.text = @"Pounds / Ream";
        _userLabel1.text = @"Unit Weight – lb/ream";
        _userLabel1.alpha = 1;
        _userLabel2.alpha = 0;
        _userLabel3.alpha = 0;
        _userVar1.alpha = 1;
        _userVar2.alpha = 0;
        _userVar3.alpha = 0;
        
    }
    
    if (self.transUserLabel1) _userLabel1.text = self.transUserLabel1;
    if (self.transUserLabel2) _userLabel2.text = self.transUserLabel2;
    if (self.transUserLabel3) _userLabel3.text = self.transUserLabel3;
    
    
    if (self.transPickedCalculationUnits) _finalResultUnits.text = self.transPickedCalculationUnits;
    
    
    if (self.transTotalVariables){

        _userLabel1.alpha = 0;
        _userLabel2.alpha = 0;
        _userLabel3.alpha = 0;
        _userVar2.alpha = 0;
        _userVar2.alpha = 0;
        _userVar3.alpha = 0;
        
        //NSLog(@"%d",self.transTotalVariables);
        
        switch (self.transTotalVariables){
            case 3:
                _userLabel3.alpha = 1;
                _userVar3.alpha = 1;
            case 2:
                _userLabel2.alpha = 1;
                _userVar2.alpha = 1;
            case 1:
                _userLabel1.alpha = 1;
                _userVar1.alpha = 1;
        }
        
        
        
    }
    

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        
        //NSLog(@"Setting initial location");
        
        _userLabel1.frame = CGRectMake(310, 241, 310, 31);
        _userVar1.frame = CGRectMake(81, 241, 221, 31);

        _userLabel2.frame = CGRectMake(310, 241 + 49, 310, 31);
        _userVar2.frame = CGRectMake(81, 241 + 49, 221, 31);

        _userLabel3.frame = CGRectMake(310, 241 + 98, 310, 31);
        _userVar3.frame = CGRectMake(81, 241 + 98, 221, 31);
        
    }

    
    [self restoreFromDefaults];
    [self updateFinalResult];

    NSString *pageUrl = [NSString stringWithFormat:@"/calculation/%@",self.title];
    
    NSError *error;
    
    if (![[GANTracker sharedTracker] trackPageview:pageUrl
                                         withError:&error]) {
       
    }
    
    
    
}


- (void)clearCurrentValues {
    
    _userVar1.text = @"";
    _userVar2.text = @"";
    _userVar3.text = @"";

    if (settingsPopover){
        [settingsPopover dismissPopoverAnimated:YES];
        settingsPopover = nil;
        _showSettings.tintColor = nil;
    }
    
    [self updateFinalResult];
    
}




- (void)restoreFromDefaults {
    
    // Load from defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSArray *currentCalculation = [defaults objectForKey:self.title];
    
    //NSLog(@"Reading from %@", self.title);
    
    if ([currentCalculation count] && [defaults boolForKey:@"rememberOldEntries"]){
        _userVar1.text = [currentCalculation objectAtIndex:0];
        _userVar2.text = [currentCalculation objectAtIndex:1];
        _userVar3.text = [currentCalculation objectAtIndex:2];
    } else {
        _userVar1.text = @"";
        _userVar2.text = @"";
        _userVar3.text = @"";
    }
    
    //[self updateFinalResult];
    
}


- (void)textFieldDidChange:(NSString *)myText {
    //NSLog(@"FIELD CHANGED - %@",_finalResult.text);
    [self updateFinalResult];
}








- (void)storeValues {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    //NSLog(@"Storing %@, %@, %@ in %@", _userVar1.text, _userVar2.text, _userVar3.text, self.title);
    
    NSMutableArray *array = [[defaults objectForKey:self.title] mutableCopy];
    
    if (!array) array = [[NSMutableArray alloc] init];
    
    if (_userVar1.text) [array insertObject:_userVar1.text atIndex:0];
    if (_userVar2.text) [array insertObject:_userVar2.text atIndex:1];
    if (_userVar3.text) [array insertObject:_userVar3.text atIndex:2];
    
    if ([array count]) [defaults setObject:array forKey:self.title];
    
    [defaults synchronize];
    
}










- (NSString *)calculateTotalWithFirst:(float)first second:(float)second third:(float)third {
    
    float total = 0;
    
    if ([self.title isEqualToString:@"MSI → Linear Feet"] || [self.title isEqualToString:@"MSI → Linear Meters"]){
        total = ((first / second) * 1000/12);
    }
    if ([self.title isEqualToString:@"Basis Weight → Yield"]) {
        total = (432000 / first);
    }
    if ([self.title isEqualToString:@"Yield → Basis Weight"]) {
        total = (432000 / first);
    }
    if ([self.title isEqualToString:@"MI → Linear Feet"] || [self.title isEqualToString:@"MI → Linear Meters"]) {
        float si = (first*second*1000);
        float li = si/third;
        float lf = li/12;
        total = lf;
        //total = (((first/second)*1000/third)/12);
    }
    if ([self.title isEqualToString:@"MI → MSI"] || [self.title isEqualToString:@"MI → m²"]) {
        total = first * second;
    }
    if ([self.title isEqualToString:@"MSI Price → MI Price"]) {
        total = (first * second);
    }
    if ([self.title isEqualToString:@"Linear Feet → MI"] || [self.title isEqualToString:@"Linear Meters → MI"]) {
        total = ((first * 12)/second) * third/1000;
    }
    if ([self.title isEqualToString:@"Roll Length"]) {
        float one = M_PI * (first/2)*(first/2);
        float two = M_PI * (second/2)*(second/2);
        float three = third/1000;
        float four = (one - two) / three;
        total = four / 12;
    }
    if ([self.title isEqualToString:@"Roll Outside Diameter"]) {
        float one = first * 12;
        float two = M_PI * (second/2)*(second/2);
        float three = third/1000;
        total = (sqrt(((one*three)+two)/M_PI))*2;
    }
    
    if ([self.title isEqualToString:@"Weight | Yield → Linear Ft"] || [self.title isEqualToString:@"Weight | Yield → Linear Meters"]) {
        total = (36000*second)/(third*(432000/first));
    }
    if ([self.title isEqualToString:@"Weight | BW → Linear Ft"] || [self.title isEqualToString:@"Weight | Basis Weight → Linear Meters"]) {
        total = (36000*second)/(third*first);
        //total = (36000*first)/(third*second);
    }
    if ([self.title isEqualToString:@"Length | Yield → Weight"]) {
        //total = (first*third*(432000/second)/36000);
        total = (second*third*(432000/first)/36000);
    }
    if ([self.title isEqualToString:@"Length | BW → Weight"]) {
        total = (second*third*first)/36000;
    }
    

    //NSString *enteredTotal = [NSString stringWithFormat:@"%@%@", focusedTextField.text, pressedButton];
    
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    //NSLog(@"preformat %f",total);
    
    NSString* totalWithFormatting = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:total]];
    
    
    [self storeTotal:totalWithFormatting];
    
    return totalWithFormatting;
    
}



- (void)storeTotal:(NSString *)total {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //NSLog(@"Storing %@ for %@", total, self.title);
    
    NSMutableArray *array = [[defaults objectForKey:self.title] mutableCopy];
    
    if (!array) array = [[NSMutableArray alloc] init];

    [array insertObject:total atIndex:3];
    
    [defaults setObject:array forKey:self.title];
    
    //NSLog(@"ARRAY!%@",array);
    
    [defaults synchronize];
    
}




- (void)updateFinalResult {
    
    float first = _userVar1.text.floatValue;
    float second = _userVar2.text.floatValue;
    float third = _userVar3.text.floatValue;
    
    [self storeValues];
    
    if (!first || (_userVar2.alpha && !second) || (_userVar3.alpha && !third)){
       
        //NSLog(@"I am about to fail");
        
        _finalResult.text = @"0.00";
        _finalResult.alpha = 0;
        _finalResultUnits.alpha = 0;
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDuration:0.4];
            
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
                
                int y = 241;
                
                if (_userVar2.alpha) y = 241-49;
                if (_userVar3.alpha) y = 241-98;
            
                _userLabel1.frame = CGRectMake(310, y, 310, 31);
                _userVar1.frame = CGRectMake(81, y, 221, 31);
                
                _userLabel2.frame = CGRectMake(310, y + 49, 310, 31);
                _userVar2.frame = CGRectMake(81, y + 49, 221, 31);
                
                _userLabel3.frame = CGRectMake(310, y + 98, 310, 31);
                _userVar3.frame = CGRectMake(81, y + 98, 221, 31);
                
            } else {
                
                
                int y = 130;
                
                if (_userVar2.alpha) y = 130-38;
                if (_userVar3.alpha) y = 130-76;
                
                _userLabel1.frame = CGRectMake(129, y, 177, 31);
                _userVar1.frame = CGRectMake(22, y, 99, 31);
                
                _userLabel2.frame = CGRectMake(129, y + 38, 177, 31);
                _userVar2.frame = CGRectMake(22, y + 38, 99, 31);
                
                _userLabel3.frame = CGRectMake(129, y + 76, 177, 31);
                _userVar3.frame = CGRectMake(22, y + 76, 99, 31);
                
                
            }
                
        [UIView commitAnimations];
        
        
        //NSLog(@"I failed to pass");
        
        return;
    }
    
    //NSLog(@"I Passed");
    
    
    NSString *totalWithFormatting = [self calculateTotalWithFirst:first second:second third:third];
    
    _finalResult.text = totalWithFormatting;
    

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.7];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];       
    
        _finalResult.alpha = 1;
        _finalResultUnits.alpha = 1;
    
    
        [UIView setAnimationDuration:0.45];
        
        //iPad
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
                
            int y = 200;
            
            if (_userVar2.alpha) y = 200-49;
            if (_userVar3.alpha) y = 200-98;

            _userLabel1.frame = CGRectMake(310, y, 310, 31);
            _userVar1.frame = CGRectMake(81, y, 221, 31);
            
            _userLabel2.frame = CGRectMake(310, y + 49, 310, 31);
            _userVar2.frame = CGRectMake(81, y + 49, 221, 31);
            
            _userLabel3.frame = CGRectMake(310, y + 98, 310, 31);
            _userVar3.frame = CGRectMake(81, y + 98, 221, 31);
            
        } else {
            
            //iPhone
            
            int y = 87;
            
            if (_userVar2.alpha) y = 87-38;
            if (_userVar3.alpha) y = 87-76;
            
            _userLabel1.frame = CGRectMake(129, y, 177, 31);
            _userVar1.frame = CGRectMake(22, y, 99, 31);
            
            _userLabel2.frame = CGRectMake(129, y + 38, 177, 31);
            _userVar2.frame = CGRectMake(22, y + 38, 99, 31);
            
            _userLabel3.frame = CGRectMake(129, y + 76, 177, 31);
            _userVar3.frame = CGRectMake(22, y + 76, 99, 31);
            
            
        }
    
     [UIView commitAnimations];
    
    
    
}






- (IBAction)showMiniConverter:(UIBarButtonItem *)sender {
    
    //NSLog(@"showminiconverter");
    
    if (miniConverter){

        [miniConverter dismissPopoverAnimated:YES];
        
        miniConverter = nil;
        
        sender.tintColor = nil;
        
    } else {

        [self performSegueWithIdentifier:@"showMiniConverter" sender:self];

        sender.tintColor = [UIColor colorWithRed:0.141176f green:0.349020f blue:0.811765f alpha:1.0f];
        
    }
}




- (IBAction)showInfo:(UIBarButtonItem *)sender {
    
    
    if (settingsPopover){
        [settingsPopover dismissPopoverAnimated:YES];
        settingsPopover = nil;
        _showSettings.tintColor = nil;
    }
    
    if (infoPopover){

        [infoPopover dismissPopoverAnimated:YES];
        
        infoPopover = nil;
        
        sender.tintColor = nil;
    } else {
        
        [self performSegueWithIdentifier:@"showInfo" sender:self];
        
        sender.tintColor = [UIColor colorWithRed:0.141176f green:0.349020f blue:0.811765f alpha:1.0f];
        
    }
    
}


- (IBAction)showSettings:(UIBarButtonItem *)sender {
      
    if (infoPopover){
        [infoPopover dismissPopoverAnimated:YES];
        infoPopover = nil;
        _showInfo.tintColor = nil;
    }
    
    if (settingsPopover){
    
        [settingsPopover dismissPopoverAnimated:YES];
    
        settingsPopover = nil;
        
        sender.tintColor = nil;
        
    } else {
 
        [self performSegueWithIdentifier:@"showSettings" sender:self];
        
        sender.tintColor = [UIColor colorWithRed:0.141176f green:0.349020f blue:0.811765f alpha:1.0f];
        
        //_showSettings.tintColor = [UIColor redColor];
        
    }
    
}



- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {

    if (popoverController == infoPopover) {
      
        infoPopover = nil; _showInfo.tintColor = nil;
    }
    
    if (popoverController == miniConverter) {
       
        miniConverter = nil; _convertNumberButton.tintColor = nil;
    }
    
    if (popoverController == settingsPopover) {

        settingsPopover = nil; _showSettings.tintColor = nil;
    }
}




- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    

    if ([[segue identifier] isEqualToString:@"showInfo"]){
        
        infoPopover = [(UIStoryboardPopoverSegue *)segue popoverController];
        infoPopover.delegate = self;
        
    }
    
    
    if ([[segue identifier] isEqualToString:@"showSettings"]){
        
        settingsPopover = [(UIStoryboardPopoverSegue *)segue popoverController];
        settingsPopover.delegate = self;
        
    }

    if ([[segue identifier] isEqualToString:@"showMiniConverter"]){
        

        miniConverter = [(UIStoryboardPopoverSegue *)segue popoverController];
        miniConverter.delegate = self;
        
    }
    
}

//- (bool)presentPopoverFromBarButtonItem:permittedArrowDirections:animated:{
//    return YES;
//}






- (void)viewDidLoad {
    
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearCurrentValues) name:@"clearCurrentValues" object:nil];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    UIInterfaceOrientation orientation = [UIDevice currentDevice].orientation;
    
    
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        _interface.image = [UIImage imageNamed:@"vertical-background.png"];
        _interface.frame = CGRectMake(0, 0, 768, 960);
    } else {
        _interface.image = [UIImage imageNamed:@"horizontal-background.png"];
        _interface.frame = CGRectMake(0, 0, 703, 704);
    }
    
    
    selectedColor = [UIColor cyanColor];
    //colorWithRed:0.905882f green:0.929412f blue:0.890196f alpha:1.0f
    
    [_userVar1 addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [_userVar2 addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
   
    [_userVar3 addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    _userVar1.delegate = self;
    _userVar2.delegate = self;
    _userVar3.delegate = self;
    
    _finalResult.alpha = 0;
    _finalResultUnits.alpha = 0;
    
    [self visuallySelectField:_userVar1];
    [self configureView];

    

//    _userVar1.hidden = YES;
//    _userVar2.hidden = YES;
//    _userVar3.hidden = YES;
//    _userLabel1.hidden = YES;
//    _userLabel2.hidden = YES;
//    _userLabel3.hidden = YES;
    
    
}

- (void)visuallySelectField:(UITextField *) textField {
    
    textField.backgroundColor = selectedColor;
    textField.layer.shadowColor = [selectedColor CGColor];
    textField.layer.shadowRadius = 9.0f;
    textField.layer.shadowOpacity = .9;
    textField.layer.shadowOffset = CGSizeZero;
    textField.layer.masksToBounds = NO;
    
    if (textField != _userVar1){
        _userVar1.backgroundColor = nil;
        _userVar1.layer.shadowColor = nil;
        _userVar1.layer.shadowRadius = 0;
        _userVar1.layer.shadowOpacity = 0;
        _userVar1.layer.shadowOffset = CGSizeZero;
    }
    
    if (textField != _userVar2){
        _userVar2.backgroundColor = nil;
        _userVar2.layer.shadowColor = nil;
        _userVar2.layer.shadowRadius = 0;
        _userVar2.layer.shadowOpacity = 0;
        _userVar2.layer.shadowOffset = CGSizeZero;
      
    }
    
    if (textField != _userVar3){
        _userVar3.backgroundColor = nil;
        _userVar3.layer.shadowColor = nil;
        _userVar3.layer.shadowRadius = 0;
        _userVar3.layer.shadowOpacity = 0;
        _userVar3.layer.shadowOffset = CGSizeZero;
    }

    
    
}



- (void)viewDidUnload {
    
    [self setUserVar1:nil];
    [self setUserVar2:nil];
    [self setUserVar3:nil];

    [self setFinalResult:nil];
    [self setDeleteButton:nil];
    [self setReturnButton:nil];
    
    [self setUserLabel1:nil];
    [self setUserLabel2:nil];
    [self setUserLabel3:nil];

    [self setFinalResultUnits:nil];
    [self setInterface:nil];

    [self setShowSettings:nil];

    [self setCalculator:nil];
    [self setConvertNumberButton:nil];
    [self setShowInfo:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}


- (void)willAnimateRotationToInterfaceOrientation: (UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {

    if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {
        _interface.image = [UIImage imageNamed:@"vertical-background.png"];
        _interface.frame = CGRectMake(0, 0, 768, 960);
    } else {
        _interface.image = [UIImage imageNamed:@"horizontal-background.png"];
        _interface.frame = CGRectMake(0, 0, 703, 704);
    }
    
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {

}


#pragma mark - Split view

//- (BOOL)splitViewController:(UISplitViewController *)sender
//     shouldHideViewController:(UIViewController *)master
//                inOrientation:(UIInterfaceOrientation)orientation
//{
//    return NO;
//}

- (void)resetUI{
    
    [self visuallySelectField:_userVar1];
 
    _userVar1.text = @"";
    _userVar2.text = @"";
    _userVar3.text = @"";
    
    _userLabel1.text = @"";
    _userLabel2.text = @"";
    _userLabel3.text = @"";
  
    _finalResult.text = @"0.00";
    _finalResult.alpha = 0;
    _finalResultUnits.alpha = 0;
    
    [self restoreFromDefaults];
    
}



- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController {
    barButtonItem.title = @"Calculators";
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}



- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
    
    
    
    
//    [self.masterPopoverController presentPopoverFromRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUnknown animated:YES];
    
    
    //masterPopoverController.popoverContentSize =
    
    //NSLog(@"POPOVER");
    
}


- (IBAction)didPressKeypadButton:(UIButton *)sender {

    NSString *pressedButton = sender.titleLabel.text;
    
    if (_userVar3.backgroundColor != nil){
        _focusedTextField = _userVar3;
    } else if (_userVar2.backgroundColor != nil){
        _focusedTextField = _userVar2;
    } else {
        _focusedTextField = _userVar1;
    }
    
    
    NSString *enteredTotal = [NSString stringWithFormat:@"%@%@", _focusedTextField.text, pressedButton];
    
    _focusedTextField.text = enteredTotal;
        
    [self updateFinalResult];
    
}







- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    //NSLog(@"blocked keyboard");
    
    [self visuallySelectField:textField];
    
    return NO;
}









- (IBAction)didDeleteCharacter:(UIButton *)sender {
    

    if (_userVar3.backgroundColor != nil){
        _focusedTextField = _userVar3;
    } else if (_userVar2.backgroundColor != nil){
        _focusedTextField = _userVar2;
    } else {
        _focusedTextField = _userVar1;
    }
    
    
    if (!_focusedTextField.text.length) return;
    
    int newLength = (_focusedTextField.text.length - 1);
    
    //NSLog(@"changing %u to %u", _focusedTextField.text.length, newLength);
    
    NSString *valueAfterDelete = [_focusedTextField.text substringWithRange:NSMakeRange(0, newLength)];
    
    //NSLog(@"%f",valueAfterDelete.floatValue);
    
    
    if (valueAfterDelete.length > 0){
        _focusedTextField.text = valueAfterDelete;
    } else {
        _focusedTextField.text = @"";
    }
    
    

    [self updateFinalResult];

}

- (IBAction)didEnterVariable:(UIButton *)sender {
    if (!_userVar3.text.length && _userVar3.alpha) _focusedTextField = _userVar3;
    if (!_userVar2.text.length && _userVar2.alpha) _focusedTextField = _userVar2;
    if (!_userVar1.text.length && _userVar1.alpha) _focusedTextField = _userVar1;
    [self visuallySelectField:_focusedTextField];
}














- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0:{
            
            //NSLog(@"Copy to Clipboard");
  
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            
            NSString *strip = [_finalResult.text stringByReplacingOccurrencesOfString:@"," withString:@""];

            pasteboard.string = strip;
            
            
        }
            break;
        case 1:{
            
            //NSLog(@"Convert this Number");

            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            NSString *strip = [_finalResult.text stringByReplacingOccurrencesOfString:@"," withString:@""];
            
            [defaults setObject:strip forKey:@"convertedNumber"];
            [defaults synchronize];
            
            //NSLog(@"stored number %@",strip);
            
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                
                self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:1];
                
            } else {
                
                [self showMiniConverter:_convertNumberButton];
                
            }
            
            
            
        }
            break;
        
        case 2:{
            
            //NSLog(@"Cancel");
        }
            break;
            
    }
    
    
}








- (IBAction)tapOptions:(UITapGestureRecognizer *)sender {
    
    //NSLog(@"tapped");

    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles: @"Copy to Clipboard", @"Convert This Number…", nil];
    
	popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    
    CGPoint tapPoint = [sender locationInView:self.view];

    CGRect bounds = CGRectMake(tapPoint.x - 22, tapPoint.y - 22, 44, 44);
    
    
    if (self.tabBarController)
        [popupQuery showInView:self.tabBarController.view];
    else
        [popupQuery showFromRect:bounds inView:self.view animated:YES];
    
    
    
}



@end
