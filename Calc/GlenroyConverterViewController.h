//
//  GlenroyConverterViewController.h
//  Calc
//
//  Created by Joel Glovacki on 7/25/12.
//  Copyright (c) 2012 ByteStudios. All rights reserved.
//

#import <UIKit/UIKit.h>

#define LENGTHS 0
#define WEIGHTS 1

@interface GlenroyConverterViewController : UIViewController <UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>  {
   
    IBOutlet UIPickerView *converterPicker;
    
    NSMutableArray *conversionTypes;
    NSMutableArray *lengthConversions;
    NSMutableArray *weightConversions;
    NSMutableArray *unitsToPickFrom;
    NSString *currentFrom;
    NSString *currentTo;
    
}

@property (weak, nonatomic) IBOutlet UITextField *convertThisNumber;
@property (weak, nonatomic) IBOutlet UILabel *finalResult;

@end
