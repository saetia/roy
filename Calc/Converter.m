//
//  Converter.m
//  Calc
//
//  Created by Joel Glovacki on 8/1/12.
//  Copyright (c) 2012 ByteStudios. All rights reserved.
//

#import "Converter.h"

@implementation Converter


- (NSString *)convertNumberWithFormatting:(float)number from:(NSString *)from to:(NSString *)to withUnits:(BOOL)withUnits {
    
    float rawTotal = [self convertNumber:number from:from to:to];
    
    
    NSString *formattedTotal = (rawTotal > 0.00000000000001f) ?
    [NSString stringWithFormat:@"%g", rawTotal] : @"0";
    
    NSRange textRange = [formattedTotal rangeOfString:@"-"];
    NSRange decPoint = [formattedTotal rangeOfString:@"."];
    
    if (textRange.location == NSNotFound && decPoint.location != 1){
        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        formattedTotal = [numberFormatter stringFromNumber:[NSNumber numberWithLongLong: rawTotal]];
    }
    
    //NSLog(@"rawTotal: %f, prettyTotal: %@",rawTotal, formattedTotal);
    
    NSString *unit = @"";
    
    if (withUnits){
        
        if ([to caseInsensitiveCompare: @"Miles"]) unit = @"mi";
        if ([to caseInsensitiveCompare: @"Inches"]) unit = @"in";
        if ([to caseInsensitiveCompare: @"Feet"]) unit = @"ft";
        if ([to caseInsensitiveCompare: @"Micron"]) unit = @"µu";
        if ([to caseInsensitiveCompare: @"Milli"]) unit = @"mm";
        if ([to caseInsensitiveCompare: @"Centi"]) unit = @"cm";
        if ([to caseInsensitiveCompare: @"Meters"]) unit = @"m";
        if ([to caseInsensitiveCompare: @"Pounds"]) unit = @"lb";
        if ([to caseInsensitiveCompare: @"Kilograms"]) unit = @"kg";
        
    }
    
    return [NSString stringWithFormat:@"%@%@", formattedTotal, unit];
}


- (float)convertNumber:(float)number from:(NSString *)from to:(NSString *)to {
    
    
    if ([from caseInsensitiveCompare: @"Pounds"]){
        if ([to caseInsensitiveCompare: @"Kilograms"]) number = number * 0.453592;
    }
    
    if ([from caseInsensitiveCompare: @"Kilograms"]){
        if ([to caseInsensitiveCompare: @"Pounds"]) number = number * 2.20462;
    }
    
    if ([from caseInsensitiveCompare: @"Miles"]){
        
        if ([to caseInsensitiveCompare: @"Inches"]) number = number * 63360;
        if ([to caseInsensitiveCompare: @"Feet"]) number = number * 5280;
        if ([to caseInsensitiveCompare: @"Micron"]) number = number * 1609344000;
        if ([to caseInsensitiveCompare: @"Milli"]) number = number * 1609344;
        if ([to caseInsensitiveCompare: @"Centi"]) number = number * 160934;
        if ([to caseInsensitiveCompare: @"Meters"]) number = number * 1609.34;
    }
    
    if ([from caseInsensitiveCompare: @"Inches"]){
        
        if ([to caseInsensitiveCompare: @"Miles"]) number = number * 0.0000157828283;
        if ([to caseInsensitiveCompare: @"Feet"]) number = number * 0.0833333;
        if ([to caseInsensitiveCompare: @"Micron"]) number = number * 1609344000;
        if ([to caseInsensitiveCompare: @"Milli"]) number = number * 25.4;
        if ([to caseInsensitiveCompare: @"Centi"]) number = number * 2.54;
        if ([to caseInsensitiveCompare: @"Meters"]) number = number * 0.0254;
    }
    if ([from caseInsensitiveCompare: @"Feet"]){
        if ([to caseInsensitiveCompare: @"Miles"]) number = number * 0.000189394;
        if ([to caseInsensitiveCompare: @"Inches"]) number = number * 12;
        if ([to caseInsensitiveCompare: @"Micron"]) number = number * 304800;
        if ([to caseInsensitiveCompare: @"Milli"]) number = number * 304.8;
        if ([to caseInsensitiveCompare: @"Centi"]) number = number * 30.48;
        if ([to caseInsensitiveCompare: @"Meters"]) number = number * 0.3048;
    }
    if ([from caseInsensitiveCompare: @"Micron"]){
        if ([to caseInsensitiveCompare: @"Miles"]) number = number * 62137110000;
        if ([to caseInsensitiveCompare: @"Inches"]) number = number * 0.00003937007874;
        if ([to caseInsensitiveCompare: @"Feet"]) number = number * 0.000003280839895;
        if ([to caseInsensitiveCompare: @"Milli"]) number = number * 0.001;
        if ([to caseInsensitiveCompare: @"Centi"]) number = number * 0.0001;
        if ([to caseInsensitiveCompare: @"Meters"]) number = number * 0.000001;
    }
    if ([from caseInsensitiveCompare: @"Milli"]){
        if ([to caseInsensitiveCompare: @"Miles"]) number = number * 62137119.224;
        if ([to caseInsensitiveCompare: @"Inches"]) number = number * 0.03937007874;
        if ([to caseInsensitiveCompare: @"Feet"]) number = number * 0.003280839895;
        if ([to caseInsensitiveCompare: @"Micron"]) number = number * 1000;
        if ([to caseInsensitiveCompare: @"Centi"]) number = number * 0.1;
        if ([to caseInsensitiveCompare: @"Meters"]) number = number * 0.001;
    }
    if ([from caseInsensitiveCompare: @"Centi"]){
        if ([to caseInsensitiveCompare: @"Miles"]) number = number * 0.0000062137119224;
        if ([to caseInsensitiveCompare: @"Inches"]) number = number * 0.3937007874;
        if ([to caseInsensitiveCompare: @"Feet"]) number = number * 0.03280839895;
        if ([to caseInsensitiveCompare: @"Micron"]) number = number * 10000;
        if ([to caseInsensitiveCompare: @"Milli"]) number = number * 10;
        if ([to caseInsensitiveCompare: @"Meters"]) number = number * 1609.34;
    }
    if ([from caseInsensitiveCompare: @"Meters"]){
        if ([to caseInsensitiveCompare: @"Miles"]) number = number * 0.00062137119224;
        if ([to caseInsensitiveCompare: @"Inches"]) number = number * 39.37007874;
        if ([to caseInsensitiveCompare: @"Feet"]) number = number * 3.280839895;
        if ([to caseInsensitiveCompare: @"Micron"]) number = number * 1000000;
        if ([to caseInsensitiveCompare: @"Milli"]) number = number * 1000;
        if ([to caseInsensitiveCompare: @"Centi"]) number = number * 100;
        
    }
    
    return number;
}


@end
