//
//  GlenroyConverterViewController.m
//  Calc
//
//  Created by Joel Glovacki on 7/25/12.
//  Copyright (c) 2012 ByteStudios. All rights reserved.
//

#import "GlenroyConverterViewController.h"
#import "Converter.h"
#import "GANTracker.h"


@implementation GlenroyConverterViewController
@synthesize convertThisNumber;
@synthesize finalResult;


int selectedRow = 0;


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0.090196f green:0.207843f blue:0.443137f alpha:1.0f]];
    
    [convertThisNumber addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        convertThisNumber.keyboardType=UIKeyboardTypeDecimalPad;
    
    conversionTypes = [[NSMutableArray alloc] init];
    
    [conversionTypes addObject:@"Length"];
    [conversionTypes addObject:@"Weight"];
    
    lengthConversions = [[NSMutableArray alloc] init];
    
    [lengthConversions addObject:@"Miles"];
    [lengthConversions addObject:@"Inches"];
    [lengthConversions addObject:@"Feet"];
    [lengthConversions addObject:@"Micron"];
    [lengthConversions addObject:@"Milli"];
    [lengthConversions addObject:@"Centi"];
    [lengthConversions addObject:@"Meters"];
    
    weightConversions = [[NSMutableArray alloc] init];
    
    [weightConversions addObject:@"Pounds"];
    [weightConversions addObject:@"Kilograms"];
    
    [self restoreValues];
    
}




- (void)restoreValues {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    if ([defaults objectForKey:@"rememberOldEntries"] == nil || [defaults boolForKey:@"rememberOldEntries"]){

        int storedFrom = ([defaults objectForKey:@"convertedFrom"]) ? [defaults integerForKey:@"convertedFrom"] : 0;
        
        int storedTo = ([defaults objectForKey:@"convertedFrom"]) ? [defaults integerForKey:@"convertedTo"] : 1;
        
        int unitsToPickFromRow = ([defaults objectForKey:@"convertedFrom"]) ? [defaults integerForKey:@"unitsToPickFromRow"] : 0;
        
        unitsToPickFrom = (unitsToPickFromRow == LENGTHS) ? lengthConversions : weightConversions;
        
        selectedRow = unitsToPickFromRow;
        
        currentFrom = ([defaults objectForKey:@"currentFromLabel"]) ? [defaults objectForKey:@"currentFromLabel"] : [unitsToPickFrom objectAtIndex:storedFrom];
        
        currentTo = ([defaults objectForKey:@"currentToLabel"]) ? [defaults objectForKey:@"currentToLabel"] : [unitsToPickFrom objectAtIndex:storedTo];

        [converterPicker selectRow:(storedFrom) inComponent:1 animated:NO];
        [converterPicker selectRow:(storedTo) inComponent:2 animated:NO];
        
        NSString *convertedNumber = ([defaults objectForKey:@"convertedNumber"]) ? [defaults objectForKey:@"convertedNumber"] : @"1";
            
        convertThisNumber.text = convertedNumber;
        
    } else {
        
        convertThisNumber.text = @"1";
        unitsToPickFrom = lengthConversions;
        currentFrom = [unitsToPickFrom objectAtIndex:0];
        currentTo = [unitsToPickFrom objectAtIndex:1];
        
    }
}


- (void)viewDidAppear:(BOOL)animated {
    
    [self restoreValues];
    [self updateDisplay];
    
    NSError *error;
    
    if (![[GANTracker sharedTracker] trackPageview:@"/converter"
                                         withError:&error]) {
        
    }
    
}



- (NSString *)convertNumberWithFormatting:(float)number from:(NSString *)from to:(NSString *)to withUnits:(BOOL)withUnits {
    
    float rawTotal = [self convertNumber:number from:from to:to];
    
    NSString *formattedTotal = (rawTotal > 0.00000000000000000000000000000000000000000001f) ?
    [NSString stringWithFormat:@"%g", rawTotal] : @"0";
    
    NSRange textRange = [formattedTotal rangeOfString:@"-"];
    NSRange decPoint = [formattedTotal rangeOfString:@"."];
    
    if (textRange.location == NSNotFound && decPoint.location != 1){
        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        formattedTotal = [numberFormatter stringFromNumber:[NSNumber numberWithLongLong: rawTotal]];
    }
    
    //NSLog(@"rawTotal: %f, prettyTotal: %@", rawTotal, formattedTotal);
    
    NSString *unit = @"";
    
    if (withUnits){
        
        if ([to caseInsensitiveCompare: @"Miles"] == NSOrderedSame) unit = @"mi";
        if ([to caseInsensitiveCompare: @"Inches"] == NSOrderedSame) unit = @"in";
        if ([to caseInsensitiveCompare: @"Feet"] == NSOrderedSame) unit = @"ft";
        if ([to caseInsensitiveCompare: @"Micron"] == NSOrderedSame) unit = @"µu";
        if ([to caseInsensitiveCompare: @"Milli"] == NSOrderedSame) unit = @"mm";
        if ([to caseInsensitiveCompare: @"Centi"] == NSOrderedSame) unit = @"cm";
        if ([to caseInsensitiveCompare: @"Meters"] == NSOrderedSame) unit = @"m";
        if ([to caseInsensitiveCompare: @"Pounds"] == NSOrderedSame) unit = @"lb";
        if ([to caseInsensitiveCompare: @"Kilograms"] == NSOrderedSame) unit = @"kg";
        
    }
    
    return [NSString stringWithFormat:@"%@%@", formattedTotal, unit];
}


- (float)convertNumber:(float)number from:(NSString *)from to:(NSString *)to {
    
    
    //NSLog(@"i want to convert %@ to %@",from,to);
    
    if ([from caseInsensitiveCompare: @"Pounds"] == NSOrderedSame){
        if ([to caseInsensitiveCompare: @"Kilograms"] == NSOrderedSame) number = number * 0.453592;
    }
    
    if ([from caseInsensitiveCompare: @"Kilograms"] == NSOrderedSame){
        if ([to caseInsensitiveCompare: @"Pounds"] == NSOrderedSame) number = number * 2.20462;
    }
    
    if ([from caseInsensitiveCompare: @"Miles"] == NSOrderedSame){
        
        //NSLog(@"miles to %@",to);
        
 
        
        
        if ([to caseInsensitiveCompare: @"Inches"] == NSOrderedSame) number = number * 63360;
        if ([to caseInsensitiveCompare: @"Feet"] == NSOrderedSame) number = number * 5280;
        if ([to caseInsensitiveCompare: @"Micron"] == NSOrderedSame) number = number * 1609344000;
        if ([to caseInsensitiveCompare: @"Milli"] == NSOrderedSame) number = number * 1609344;
        if ([to caseInsensitiveCompare: @"Centi"] == NSOrderedSame) number = number * 160934;
        if ([to caseInsensitiveCompare: @"Meters"] == NSOrderedSame) number = number * 1609.34;
    }
    
    if ([from caseInsensitiveCompare: @"Inches"] == NSOrderedSame){
        //NSLog(@"inches to %@",to);
        if ([to caseInsensitiveCompare: @"Miles"] == NSOrderedSame) number = number * 0.0000157828283;
        if ([to caseInsensitiveCompare: @"Feet"] == NSOrderedSame) number = number * 0.0833333;
        if ([to caseInsensitiveCompare: @"Micron"] == NSOrderedSame) number = number * 25400;
        if ([to caseInsensitiveCompare: @"Milli"] == NSOrderedSame) number = number * 25.4;
        if ([to caseInsensitiveCompare: @"Centi"] == NSOrderedSame) number = number * 2.54;
        if ([to caseInsensitiveCompare: @"Meters"] == NSOrderedSame) number = number * 0.0254;
    }
    if ([from caseInsensitiveCompare: @"Feet"] == NSOrderedSame){
        if ([to caseInsensitiveCompare: @"Miles"] == NSOrderedSame) number = number * 0.000189394;
        if ([to caseInsensitiveCompare: @"Inches"] == NSOrderedSame) number = number * 12;
        if ([to caseInsensitiveCompare: @"Micron"] == NSOrderedSame) number = number * 304800;
        if ([to caseInsensitiveCompare: @"Milli"] == NSOrderedSame) number = number * 304.8;
        if ([to caseInsensitiveCompare: @"Centi"] == NSOrderedSame) number = number * 30.48;
        if ([to caseInsensitiveCompare: @"Meters"] == NSOrderedSame) number = number * 0.3048;
    }
    if ([from caseInsensitiveCompare: @"Micron"] == NSOrderedSame){
        if ([to caseInsensitiveCompare: @"Miles"] == NSOrderedSame) number = number * 0.000000000621371192;
        if ([to caseInsensitiveCompare: @"Inches"] == NSOrderedSame) number = number * 0.000039370078700000006;
        if ([to caseInsensitiveCompare: @"Feet"] == NSOrderedSame) number = number * 0.000003280839895;
        if ([to caseInsensitiveCompare: @"Milli"] == NSOrderedSame) number = number * 0.001;
        if ([to caseInsensitiveCompare: @"Centi"] == NSOrderedSame) number = number * 0.0001;
        if ([to caseInsensitiveCompare: @"Meters"] == NSOrderedSame) number = number * 0.000001;
    }
    if ([from caseInsensitiveCompare: @"Milli"] == NSOrderedSame){
        if ([to caseInsensitiveCompare: @"Miles"] == NSOrderedSame) number = number * 0.0000006213711922;
        if ([to caseInsensitiveCompare: @"Inches"] == NSOrderedSame) number = number * 0.03937007874;
        if ([to caseInsensitiveCompare: @"Feet"] == NSOrderedSame) number = number * 0.003280839895;
        if ([to caseInsensitiveCompare: @"Micron"] == NSOrderedSame) number = number * 1000;
        if ([to caseInsensitiveCompare: @"Centi"] == NSOrderedSame) number = number * 0.1;
        if ([to caseInsensitiveCompare: @"Meters"] == NSOrderedSame) number = number * 0.001;
    }
    if ([from caseInsensitiveCompare: @"Centi"] == NSOrderedSame){
        if ([to caseInsensitiveCompare: @"Miles"] == NSOrderedSame) number = number * 0.0000062137119224;
        if ([to caseInsensitiveCompare: @"Inches"] == NSOrderedSame) number = number * 0.3937007874;
        if ([to caseInsensitiveCompare: @"Feet"] == NSOrderedSame) number = number * 0.03280839895;
        if ([to caseInsensitiveCompare: @"Micron"] == NSOrderedSame) number = number * 10000;
        if ([to caseInsensitiveCompare: @"Milli"] == NSOrderedSame) number = number * 10;
        if ([to caseInsensitiveCompare: @"Meters"] == NSOrderedSame) number = number * 0.01;
    }
    if ([from caseInsensitiveCompare: @"Meters"] == NSOrderedSame){
        if ([to caseInsensitiveCompare: @"Miles"] == NSOrderedSame) number = number * 0.00062137119224;
        if ([to caseInsensitiveCompare: @"Inches"] == NSOrderedSame) number = number * 39.37007874;
        if ([to caseInsensitiveCompare: @"Feet"] == NSOrderedSame) number = number * 3.280839895;
        if ([to caseInsensitiveCompare: @"Micron"] == NSOrderedSame) number = number * 1000000;
        if ([to caseInsensitiveCompare: @"Milli"] == NSOrderedSame) number = number * 1000;
        if ([to caseInsensitiveCompare: @"Centi"] == NSOrderedSame) number = number * 100;
        
    }
    
    //NSLog(@"returning: %f",number);
    
    return number;
}










- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) return [conversionTypes count];
    if (component == 1) return [unitsToPickFrom count];
    if (component == 2) return [unitsToPickFrom count];
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) return [conversionTypes objectAtIndex:row];
    if (component == 1) return [unitsToPickFrom objectAtIndex:row];
    if (component == 2) return [unitsToPickFrom objectAtIndex:row];
    return 0;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}




//Glenroy Packaging Calculator

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (component == 0) {
        
        unitsToPickFrom = (row == 0) ? lengthConversions : weightConversions;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setInteger:row forKey:@"unitsToPickFromRow"];
        [defaults synchronize];
        
        if (row == selectedRow){
            return;
        }
        
        selectedRow = row;
        
        [pickerView selectRow:0 inComponent:1 animated:YES];
        [pickerView reloadComponent:1];
        
        [pickerView selectRow:0 inComponent:2 animated:YES];
        [pickerView reloadComponent:2];
        
    }
    
    if ([pickerView selectedRowInComponent: 1] == [pickerView selectedRowInComponent: 2]){
        
        //make sure we can't be on the same unit
        if ([pickerView selectedRowInComponent: 2] == (unitsToPickFrom.count - 1)){
            [pickerView selectRow:([pickerView selectedRowInComponent: 2] - 1) inComponent:2 animated:YES];
        } else {
            
            [pickerView selectRow:([pickerView selectedRowInComponent: 2] + 1) inComponent:2 animated:YES];
            
        }

    }

    currentFrom = [unitsToPickFrom objectAtIndex:[pickerView selectedRowInComponent: 1]];
    currentTo = [unitsToPickFrom objectAtIndex:[pickerView selectedRowInComponent: 2]];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setInteger:[pickerView selectedRowInComponent: 1] forKey:@"convertedFrom"];
    [defaults setInteger:[pickerView selectedRowInComponent: 2] forKey:@"convertedTo"];
    
    [defaults setObject:currentFrom forKey:@"convertedFromLabel"];
    [defaults setObject:currentTo forKey:@"convertedToLabel"];
    
    [defaults synchronize];
    
    [self updateDisplay];
    
}










- (void)updateDisplay {
    
    NSString *convertedTotal = [self convertNumberWithFormatting:convertThisNumber.text.floatValue from:currentFrom to:currentTo withUnits:YES];
    
    //NSString *convertedTotalUnitless = [self convertNumberWithFormatting:convertThisNumber.text.floatValue from:currentFrom to:currentTo withUnits:NO];
    
    float convertedTotalRaw = [self convertNumber:convertThisNumber.text.floatValue from:currentFrom to:currentTo];
    
   
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:convertThisNumber.text forKey:@"convertedNumber"];

    [defaults synchronize];


    finalResult.text = convertedTotal;

    
    NSError *error;
    
    NSString *fromTo = [NSString stringWithFormat:@"%@ to %@",currentFrom, currentTo];
    
    if (![[GANTracker sharedTracker] trackEvent:@"converter"
                                         action:@"conversion"
                                          label:fromTo
                                          value:convertedTotalRaw
                                      withError:&error]) {
       
    }
    
    
}




- (void)textFieldDidChange:(NSString *)myText {
    [self updateDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [convertThisNumber resignFirstResponder];
}








- (void)viewDidUnload {
    [self setConvertThisNumber:nil];
    [self setFinalResult:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end