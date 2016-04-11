//
//  ViewController.h
//  iConvert
//
//  Created by Michael Borgmann on 09/04/16.
//  Copyright © 2016 Michael Borgmann. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *unitALabel;
@property (weak, nonatomic) IBOutlet UILabel *unitBLabel;
@property (weak, nonatomic) IBOutlet UIPickerView *unitAPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *unitBPicker;
@property (weak, nonatomic) IBOutlet UILabel *unitAValue;
@property (weak, nonatomic) IBOutlet UILabel *unitBValue;
@property (weak, nonatomic) IBOutlet UIStepper *minStepper;
@property (weak, nonatomic) IBOutlet UIStepper *maxStepper;
@property (weak, nonatomic) IBOutlet UITextField *minTextField;
@property (weak, nonatomic) IBOutlet UITextField *maxTextField;

@property (strong) id <UIPickerViewDelegate> delegate;
@property (strong) id <UIPickerViewDataSource> dataSource;

- (IBAction)minValueChanged:(UIStepper *)sender;
- (IBAction)maxValueChanged:(UIStepper *)sender;

- (double)celsiusToFahrenheit:(double)celsius;
- (double)fahrenheitToCelsius:(double)fahrenheit;
- (void)changeNumberString;
- (void)dismissKeyboard;

@end

