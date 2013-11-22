//
//  GlenroyMasterViewController.m
//  Calc
//
//  Created by Joel Glovacki on 7/24/12.
//  Copyright (c) 2012 ByteStudios. All rights reserved.
//

#import "GlenroyMasterViewController.h"
#import "GlenroyDetailViewController.h"

@implementation GlenroyMasterViewController;

@synthesize shareButton, clearTableValues, shareSelectedTableItems;
@synthesize calculation_categories, calculations;
@synthesize var2o, var3o;

- (void)awakeFromNib {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}


- (void)buildCalculations {

    //metrics uses a different plist
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *plist = ([defaults boolForKey:@"useMetricSystem"]) ?
    @"calculations_metric" : @"calculations";
    
    self.calculations = [NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:plist ofType:@"plist"]];

    self.calculation_categories = [[NSMutableDictionary alloc] init];
    
    NSString *keys = [NSString stringWithFormat:@"Calculations"];
    [self.calculation_categories setValue:[[NSMutableArray alloc] init] forKey:keys];
    
    keys = [NSString stringWithFormat:@"Conversions"];
    [self.calculation_categories setValue:[[NSMutableArray alloc] init] forKey:keys];
    
    //NSLog(@"%@",self.calculation_categories);
    
    // Loop again and sort the books into their respective keys
    for (NSDictionary *calculation in self.calculations){
        //NSLog(@"group: %@",[calculation objectForKey:@"group"]);
        [[self.calculation_categories objectForKey:[calculation objectForKey:@"group"]] addObject:calculation];
    }
    
    
    // Sort each section array
    for (NSString *key in [self.calculation_categories allKeys]){
        [[self.calculation_categories objectForKey:key] sortUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]]];
    }
}



- (void)viewDidAppear:(BOOL)animated {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    if (lastSelection){
        UITableViewCell *lastCell = [self.tableView cellForRowAtIndexPath:lastSelection];
        lastCell.imageView.alpha = 0.4;
    }
    [UIView commitAnimations];
}



- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    var2o = 0;
    var3o = 0;

    [self.navigationController setToolbarHidden:YES animated:NO];
    
    self.title = @"Calculators";
    
    [self buildCalculations];
    
    self.detailViewController = (GlenroyDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload) name:@"reload" object:nil];
    
}




- (void)reload {

    NSArray *selectedRows = [self.tableView indexPathsForSelectedRows];
    NSIndexPath *indexPath = [selectedRows objectAtIndex:0];
    //NSLog(@"row: %d",indexPath.row);
    
    [self buildCalculations];
    [self.tableView reloadData];
    
    //leave editmode
    if (self.tableView.isEditing){
        [self.navigationController setToolbarHidden:YES animated:YES];
        [self.tableView setEditing:NO animated:YES];
    }
    
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        cell.imageView.alpha = 1;
        
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0] animated:NO scrollPosition:0];
        
        [self.tableView.delegate tableView:self.tableView didSelectRowAtIndexPath:indexPath];
            
    }


}







- (void)viewDidUnload{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setClearTableValues:nil];
    [self setShareSelectedTableItems:nil];
    [self setShareButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}



#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //NSLog(@"section count %d",self.calculation_categories.count);
    return [[self.calculation_categories allKeys] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[self.calculation_categories valueForKey:[[[self.calculation_categories allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section]] count];
}






- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

    NSDictionary *calculation = [[self.calculation_categories valueForKey:[[[self.calculation_categories allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    
    //cell.imageView.highlightedImage;
    
    
    
    
    cell.textLabel.text = [calculation objectForKey:@"title"];
    cell.imageView.image = [UIImage imageNamed:[calculation objectForKey:@"icon"]];
    cell.imageView.alpha = 0.4;
    cell.textLabel.textColor = [UIColor colorWithRed:1.000000f green:1.000000f blue:1.000000f alpha:0.7f];
    cell.textLabel.highlightedTextColor = [UIColor whiteColor];
    cell.textLabel.shadowColor = [UIColor blackColor];
    cell.textLabel.shadowOffset = CGSizeMake(0, -1);
    cell.backgroundColor = [UIColor colorWithRed:1.000000f green:1.000000f blue:1.000000f alpha:0.05f];
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.minimumFontSize = 10;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        cell.backgroundColor = [UIColor colorWithRed:0.141176f green:0.141176f blue:0.141176f alpha:1.0f];
    }

    
    if (!indexPath.row){

        CGRect rootViewBounds = self.parentViewController.view.bounds;
    
        UIView *background = [[UIView alloc] initWithFrame:rootViewBounds];
        
        background.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"robots.png"]];
        
        self.tableView.backgroundView = background;
        

    }
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        if (!presetTableCell){
            cell.imageView.alpha = 1;
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:0];
            presetTableCell = YES;
            //set
        }
    }
    
    //cell.textLabel.text = @"";
    
    return cell;
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}





- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}




- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
}

- (void)finishAnimation:(NSString *)animationId finished:(BOOL)finished context:(void *)context {
    //NSLog(@"finished! %@ = %@",animationId, context);
    [self.detailViewController updateFinalResult];
}


- (NSArray *)fetchSelectedRows {
    
    NSArray *selectedRows = [self.tableView indexPathsForSelectedRows];
    
    //NSLog(@"%@",selectedRows);
    //NSLog(@"Found rows %d",[selectedRows count]);

    shareSelectedTableItems.title = [NSString stringWithFormat:@"Share Values (%d)", [selectedRows count]];
    
    clearTableValues.title = [NSString stringWithFormat:@"Clear Values (%d)", [selectedRows count]];

    return selectedRows;
    
}









- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath: (NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    cell.imageView.alpha = 0.4;
    
    [UIView commitAnimations];
    
    if (self.tableView.isEditing) {
        cell.textLabel.textColor = [UIColor colorWithRed:1.000000f green:1.000000f blue:1.000000f alpha:0.7f];
        [self fetchSelectedRows];
        return;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];

    //[UIView beginAnimations:nil context:NULL];
    //[UIView setAnimationDuration:0.2];
    //[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    cell.imageView.alpha = 1;
    
    //[UIView commitAnimations];
    
    if (self.tableView.isEditing) {
        cell.textLabel.textColor = [UIColor whiteColor];
        [self fetchSelectedRows];
        return;
    }

    if ([lastSelection isEqual:indexPath]){
        return;
    }
    
    lastSelection = indexPath;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self showDetail];
        return;
    }
    
    //iPad Actions:
    NSDictionary *dict = [[self.calculation_categories valueForKey:[[[self.calculation_categories allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    
    self.detailViewController.title = [NSString stringWithFormat:@"%@",[dict objectForKey: @"title"]];
    
    [self.detailViewController resetUI];
    
    int i = 0;

    self.detailViewController.finalResultUnits.text = [NSString stringWithFormat:@"%@",[dict objectForKey: @"result"]];
    
    for (NSDictionary *userVar in [dict objectForKey: @"variables"]){
       
        i++;

        NSString *uLabel = [userVar objectForKey: @"title"];
        NSString *uUnit = [userVar objectForKey: @"unit"];
        
        if (i == 1) self.detailViewController.userLabel1.text = [NSString stringWithFormat:@"%@ – %@", uLabel, uUnit];
        
        if (i == 2) self.detailViewController.userLabel2.text = [NSString stringWithFormat:@"%@ – %@", uLabel, uUnit];
        
        if (i == 3) self.detailViewController.userLabel3.text = [NSString stringWithFormat:@"%@ – %@", uLabel, uUnit];
        
    }
    
    //NSLog(@"WE HAVE FOUND: %d",i);


    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    

    switch (i){
            
        case 3:
            
            if (!var2o) {
                self.detailViewController.userVar2.alpha = 1;
                self.detailViewController.userLabel2.alpha = 1;
            }
            
            if (!var3o) {
                self.detailViewController.userVar3.alpha = 1;
                self.detailViewController.userLabel3.alpha = 1;
            }

            [UIView setAnimationDuration:0.5];
            
            self.detailViewController.userLabel1.frame = CGRectMake(310,143,310,31);
            self.detailViewController.userVar1.frame = CGRectMake(81,143,221,31);
            
            [UIView setAnimationDuration:0.65];
            self.detailViewController.userLabel2.frame = CGRectMake(310,143 + 49,310,31);
            self.detailViewController.userVar2.frame = CGRectMake(81,143 + 49,221,31);
            
            [UIView setAnimationDuration:0.75];
            self.detailViewController.userLabel3.frame = CGRectMake(310,143 + 98,310,31);
            self.detailViewController.userVar3.frame = CGRectMake(81,143 + 98,221,31);
            
            break;
            
        case 2:


            if (!var2o) {
                self.detailViewController.userVar2.alpha = 1;
                self.detailViewController.userLabel2.alpha = 1;
            }
            
            if (var3o) {
                self.detailViewController.userLabel3.alpha = 0;
                self.detailViewController.userVar3.alpha = 0;
            }
            
            [UIView setAnimationDuration:0.5];
            self.detailViewController.userLabel1.frame = CGRectMake(310, 192, 310,31);
            self.detailViewController.userVar1.frame = CGRectMake(81, 192, 221,31);
            
            [UIView setAnimationDuration:0.65];
            self.detailViewController.userLabel2.frame = CGRectMake(310, 192 + 49,310,31);
            self.detailViewController.userVar2.frame = CGRectMake(81, 192 + 49,221,31);
            
            [UIView setAnimationDuration:0.75];
            self.detailViewController.userLabel3.frame = CGRectMake(310, 192 + 98,310,31);
            self.detailViewController.userVar3.frame = CGRectMake(81, 192 + 98,221,31);
            
            
            break;
            
        case 1:

            if (var2o) {
                self.detailViewController.userVar2.alpha = 0;
                self.detailViewController.userLabel2.alpha = 0;
            }
            if (var3o) {
                self.detailViewController.userVar3.alpha = 0;
                self.detailViewController.userLabel3.alpha = 0;
            }
            

            [UIView setAnimationDuration:0.5];
            self.detailViewController.userLabel1.frame = CGRectMake(310, 241, 310,31);
            self.detailViewController.userVar1.frame = CGRectMake(81, 241, 221,31);
            
            [UIView setAnimationDuration:0.65];
            self.detailViewController.userLabel2.frame = CGRectMake(310, 241 + 49,310,31);
            self.detailViewController.userVar2.frame = CGRectMake(81, 241 + 49,221,31);
            
            [UIView setAnimationDuration:0.75];
            self.detailViewController.userLabel3.frame = CGRectMake(310, 241 + 98,310,31);
            self.detailViewController.userVar3.frame = CGRectMake(81, 241 + 98,221,31);
            
            break;
    }
    
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(finishAnimation:finished:context:)];
    
    [UIView commitAnimations];
    
    var2o = 0; var3o = 0;
    
    if (i >= 2) var2o = 1;
    if (i >= 3) var3o = 1;

}


- (void)showDetail {
    [self performSegueWithIdentifier:@"showDetail" sender:self];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    
    if ([[segue identifier] isEqualToString:@"showDetail"]){

        GlenroyDetailViewController *detailViewController = [segue destinationViewController];
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];

        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        NSDictionary *dict = [[self.calculation_categories valueForKey:[[[self.calculation_categories allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        
        [detailViewController setTransPickedCalculation: cell.textLabel.text];
        
        [detailViewController setTransPickedCalculationUnits: [dict objectForKey: @"result"]];
        
        //NSLog(@"result is: %@",[dict objectForKey: @"result"]);
        

        int i = 0;
        
        for (NSDictionary *userVar in [dict objectForKey: @"variables"]){
            
            i++;
            
            NSString *uLabel = [userVar objectForKey: @"title"];
            NSString *uUnit = [userVar objectForKey: @"unit"];
            
            if (i == 1) [detailViewController setTransUserLabel1:[NSString stringWithFormat:@"%@ – %@", uLabel, uUnit]];
            
            if (i == 2) [detailViewController setTransUserLabel2:[NSString stringWithFormat:@"%@ – %@", uLabel, uUnit]];
            
            if (i == 3) [detailViewController setTransUserLabel3:[NSString stringWithFormat:@"%@ – %@", uLabel, uUnit]];

        }
        
        [detailViewController setTransTotalVariables:i];
        
    }

}

- (IBAction)clearTableValues:(UIBarButtonItem *)sender {
    
    if (shareSheet) {
        [shareSheet dismissWithClickedButtonIndex:[shareSheet cancelButtonIndex] animated:YES];
        return;
    }
    
    shareSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Clear Values" otherButtonTitles:nil];
    
    shareSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [shareSheet showFromBarButtonItem:sender animated:YES];
    shareSheet.tag = ClearValues;
    
}



- (IBAction)shareSelectedTableItems:(UIBarButtonItem *)sender {
    
    [self prepareForEmail];

    /*
     
    //bypass the action sheet!
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) return [self prepareForEmail];
     
    if (shareSheet) {
        [shareSheet dismissWithClickedButtonIndex:[shareSheet cancelButtonIndex] animated:YES];
        return;
    }
    
    shareSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Open in Mail…", nil];
    
    shareSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [shareSheet showFromBarButtonItem:sender animated:YES];
    shareSheet.tag = ShareItems;
    
    */
    
}











-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    shareSheet = nil;
}



- (void)prepareForEmail {

    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    
	if (mailClass != nil && [mailClass canSendMail])
        [self displayComposerSheet];
	else 
        [self launchMailAppOnDevice];
	
    
}








- (NSString *)generateHTML {
    
  
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
	NSString *path = [[NSBundle mainBundle] pathForResource:@"email" ofType:@"html"];
    NSString *layout = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];

	path = [[NSBundle mainBundle] pathForResource:@"email_section" ofType:@"html"];
    NSString *section = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];

	path = [[NSBundle mainBundle] pathForResource:@"email_variable" ofType:@"html"];
    NSString *variable = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];

    NSArray *selectedRows = [self.tableView indexPathsForSelectedRows];
    NSString *all_sections = @"";
    NSString *all_variables = @"";
    NSString *calculation = @"";
    NSString *result = @"";
    NSString *section_body = @"";
    NSString *value = @"";
    NSString *title = @"";
    NSString *unit = @"";
    NSString *variable_body = @"";
    NSMutableArray *values = [[NSMutableArray alloc] init];
    NSString *answer = @"0";
    
    for (int i=0; i < [selectedRows count]; i++) {
        
        NSIndexPath *indexPath = [selectedRows objectAtIndex:i];
        
        NSDictionary *dict = [[self.calculation_categories valueForKey:[[[self.calculation_categories allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        
        
        calculation = [dict objectForKey: @"title"];
        
        values = [defaults objectForKey:calculation];
        
        //NSLog(@"VAlues for %@: %@",calculation, values);
    
        result = [dict objectForKey: @"result"];
        
        //NSLog(@"%@",values);
        
        //NSLog(@"count is: %d",[values count]);
        
        answer = ([values count] >= 4 && [values objectAtIndex:3]) ? [values objectAtIndex:3] : @"0";
        
        //NSLog(@"%@ value = %@",calculation, answer);
        
        section_body = [section stringByReplacingOccurrencesOfString:@"{{title}}" withString: calculation];
        
        section_body = [section_body stringByReplacingOccurrencesOfString:@"{{unit}}" withString: result];
        
        section_body = [section_body stringByReplacingOccurrencesOfString:@"{{value}}" withString: answer];
        
        all_variables = @"";
        
        int i = 0;
        
        for (NSDictionary *userVar in [dict objectForKey: @"variables"]){

            variable_body = @"";
            
            if (values) value = [values objectAtIndex:i];

            NSString *formattedTotal = value;
            
            NSRange textRange = [formattedTotal rangeOfString:@"-"];
            NSRange decPoint = [formattedTotal rangeOfString:@"."];
            
            if (textRange.location == NSNotFound && decPoint.location != 1){
                NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
                [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
                formattedTotal = [numberFormatter stringFromNumber:[NSNumber numberWithLongLong: formattedTotal.floatValue]];
            }

            
            value = formattedTotal;
            
            title = [userVar objectForKey: @"title"];
            unit = [userVar objectForKey: @"unit"];
        
            //NSLog(@"%@ %@ %@",value,title,unit);
            
            variable_body = [variable stringByReplacingOccurrencesOfString:@"{{title}}" withString:title];
            
            variable_body = [variable_body stringByReplacingOccurrencesOfString:@"{{value}}" withString:value];
            
            //NSLog(@"%@",variable_body);
            
            variable_body = [variable_body stringByReplacingOccurrencesOfString:@"{{unit}}" withString:unit];

            //NSLog(@"%@",variable_body);
            
            //all_variables = [NSString stringWithFormat:@"%@%@", all_variables, variable_body];
            i++;
            
            if (i == 1) section_body = [section_body stringByReplacingOccurrencesOfString:@"{{variable_1}}" withString:variable_body];
            
            if (i == 2) section_body = [section_body stringByReplacingOccurrencesOfString:@"{{variable_2}}" withString:variable_body];
            
            if (i == 3) section_body = [section_body stringByReplacingOccurrencesOfString:@"{{variable_3}}" withString:variable_body];
             
        }
        
        
        if (i < 3){
           section_body = [section_body stringByReplacingOccurrencesOfString:@"{{variable_3}}" withString:@""];
           
        }
        
        if (i < 2){
            section_body = [section_body stringByReplacingOccurrencesOfString:@"{{variable_2}}" withString:@""];
        }
        
        
        
        all_sections = [NSString stringWithFormat:@"%@%@", all_sections, section_body];
        

    }


    NSString *body = [layout stringByReplacingOccurrencesOfString:@"{{rows}}" withString:all_sections];
    
    
    return body;

    
}



// Displays an email composition interface inside the application. Populates all the Mail fields.
- (void)displayComposerSheet {
	
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    
	picker.mailComposeDelegate = self;
	
	[picker setSubject:@"Glenroy Calculations"];
	

	//NSArray *bccRecipients = [NSArray arrayWithObject:@"joel@bytestudios.com"];
	//[picker setBccRecipients:bccRecipients];
	
	NSString *path = [[NSBundle mainBundle] pathForResource:@"badge-on-black" ofType:@"png"];
    
    NSData *myData = [NSData dataWithContentsOfFile:path];
    
	[picker addAttachmentData:myData mimeType:@"image/png" fileName:@"logo"];
	
    NSString *emailBody = [self generateHTML];
    
	[picker setMessageBody:emailBody isHTML:YES];
	
	[self presentModalViewController:picker animated:YES];
 
}


// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {

	// Notifies users about errors associated with the interface
	switch (result) {
		case MFMailComposeResultCancelled:
			//NSLog(@"Result: canceled");
			break;
		case MFMailComposeResultSaved:
			//NSLog(@"Result: saved");
			break;
		case MFMailComposeResultSent:
			//NSLog(@"Result: sent");
			break;
		case MFMailComposeResultFailed:
			//NSLog(@"Result: failed");
			break;
		default:
			//NSLog(@"Result: not sent");
			break;
	}
	[self dismissModalViewControllerAnimated:YES];
}





// Launches the Mail application on the device.
-(void)launchMailAppOnDevice {
        
    UIAlertView *alert =
    [[UIAlertView alloc] initWithTitle: @"No Email Support"
                               message: @"Sorry, We weren't able to use your mail app"
                              delegate: self
                     cancelButtonTitle: @"OK"
                     otherButtonTitles: nil];
    [alert show];
    
    return;
    
    
    
    
	NSString *recipients = @"subject=Glenroy Calculations";
	NSString *body = @"&body=Hello";
	
	NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
	email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}













- (void)clearValues {

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //NSArray *array = [[NSArray alloc] init];

    NSArray *selectedRows = [self.tableView indexPathsForSelectedRows];

    
    for (int i=0; i < [selectedRows count]; i++) {
        
        NSIndexPath *indexPath = [selectedRows objectAtIndex:i];

        NSDictionary *dict = [[self.calculation_categories valueForKey:[[[self.calculation_categories allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
            
        NSString *recordToClearOut = [NSString stringWithFormat:@"%@",[dict objectForKey: @"title"]];
        
        //NSLog(@"Clear Out: %@",recordToClearOut);
        
        [defaults setObject:nil forKey:recordToClearOut];

    
        if ([self.detailViewController.title isEqualToString: recordToClearOut]){
            //NSLog(@"clear current");
            NSNotification *notif = [NSNotification notificationWithName:@"clearCurrentValues" object:self];
            [[NSNotificationCenter defaultCenter] postNotification:notif];
        }

    }
    
    shareButton.tintColor = nil;
    [self.navigationController setToolbarHidden:YES animated:YES];
    [self.tableView setEditing:NO animated:YES];

}





- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

    switch (buttonIndex) {
        case 0:
            
            if (actionSheet.tag == ShareItems) [self prepareForEmail];
            if (actionSheet.tag == ClearValues) [self clearValues];
            
            break;
        case 1:
            
            //NSLog(@"Cancel");
            break;
        
    }
    
    
}











- (IBAction)shareTableItems:(UIBarButtonItem *)sender {

    for (UITableViewCell *cell in [self.tableView visibleCells]){
        cell.imageView.alpha = 0.4;
        cell.textLabel.textColor = [UIColor colorWithRed:1.000000f green:1.000000f blue:1.000000f alpha:0.7f];
    }
    
    if (self.tableView.isEditing){
    
        sender.tintColor = nil;
        [self.navigationController setToolbarHidden:YES animated:YES];
        [self.tableView setEditing:NO animated:YES];
        [self performSelector:@selector(restoreSelectedCell) withObject:self afterDelay:0.32];
        return;
        
    }
    
    sender.tintColor = [UIColor colorWithRed:0.141176f green:0.349020f blue:0.811765f alpha:1.0f];
    
    shareSelectedTableItems.title = @"Share Values (0)";
    clearTableValues.title = @"Clear Values (0)";
    
    [self.tableView setEditing:YES animated:YES];
    [self.navigationController setToolbarHidden:NO animated:YES];

}

- (void)restoreSelectedCell {
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPad) return;
 
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:lastSelection];
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:lastSelection.row inSection:0] animated:YES scrollPosition:0];
    cell.imageView.alpha = 1;
}

@end
