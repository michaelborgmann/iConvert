//
//  ViewController.m
//  iConvert
//
//  Created by Michael Borgmann on 09/04/16.
//  Copyright © 2016 Michael Borgmann. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

- (void)updateUnitLabels:(double)degree;
- (void)createCustomNumberpad;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.unitAPicker.delegate = self;
    self.unitBPicker.delegate = self;
    
    self.unitAPicker.dataSource = self;
    self.unitBPicker.dataSource = self;
    
    double minValue = [self.minTextField.text doubleValue];
    double maxValue = [self.maxTextField.text doubleValue];
    
    self.minStepper.minimumValue = minValue - 1;
    self.minStepper.maximumValue = maxValue;
    self.minStepper.value = minValue;
    
    
    self.maxStepper.minimumValue = minValue;
    self.maxStepper.maximumValue = maxValue + 1;
    self.maxStepper.value = maxValue;
    
    int celsius = [self.unitAPicker selectedRowInComponent:0] + [self.minTextField.text intValue];
    [self updateUnitLabels:celsius];
    
    [self createCustomNumberpad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (double)celsiusToFahrenheit:(double)celsius {
    return celsius * 9/5 + 32;
}

- (double)fahrenheitToCelsius:(double)fahrenheit {
    return (fahrenheit - 32) * 5/9;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    int min = [self.minTextField.text intValue];
    int max = [self.maxTextField.text intValue] + 1;

    if (pickerView == self.unitBPicker) {
        min = [self celsiusToFahrenheit:min];
        max = [self celsiusToFahrenheit:max];
    }
    
    return max - min;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    int min = [self.minTextField.text intValue];
    
    if (pickerView == self.unitBPicker) {
        min = [self celsiusToFahrenheit:min];
        return [NSString stringWithFormat:@"%d °F", (row + min)];
    }
    
    return [NSString stringWithFormat:@"%d °C", (row + min)];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    int min = [self.minTextField.text intValue];

    if (pickerView == self.unitAPicker) {
        int degree = row + min;
        [self updateUnitLabels:degree];
        degree = round([self celsiusToFahrenheit:degree]);
        min = round([self celsiusToFahrenheit:min]);
        int otherPickerRow = degree - min;
        [self.unitBPicker selectRow:otherPickerRow inComponent:0 animated:YES];
        
    } else if (pickerView == self.unitBPicker) {
        min = [self celsiusToFahrenheit:min];
        int degree = row + min;
        [self updateUnitLabels:[self fahrenheitToCelsius:degree]];
        int otherPickerRow = round([self fahrenheitToCelsius:degree] - [self fahrenheitToCelsius:min]);
        [self.unitAPicker selectRow:otherPickerRow inComponent:0 animated:YES];
    }
}

- (void)updateUnitLabels:(double)celsius {
    self.unitAValue.text = [NSString stringWithFormat:@"%.1f °C", celsius];
    self.unitBValue.text = [NSString stringWithFormat:@"%.1f °F", [self celsiusToFahrenheit:celsius]];;
}

- (IBAction)maxValueChanged:(UIStepper *)sender {
    int newValue = round(sender.value);
    self.maxTextField.text = [NSString stringWithFormat:@"%.1d", newValue];
    self.maxStepper.maximumValue = newValue + 1;
    self.minStepper.maximumValue = newValue;
    [self.unitAPicker reloadAllComponents];
    [self.unitBPicker reloadAllComponents];
}

- (IBAction)minValueChanged:(UIStepper *)sender {
    int newValue = round(sender.value);
    self.minTextField.text = [NSString stringWithFormat:@"%.1d", newValue];
    self.minStepper.minimumValue = newValue - 1;
    self.maxStepper.minimumValue = newValue;
    [self.unitAPicker reloadAllComponents];
    [self.unitBPicker reloadAllComponents];
}

- (void)createCustomNumberpad {
    UIView *inputAccesoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
    inputAccesoryView.backgroundColor = [UIColor lightGrayColor];

    UIButton *minusButton = [[UIButton alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width-150)/2, 5, 150, 30)];
    [minusButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [minusButton setTitle:@"+/-" forState:UIControlStateNormal];
    [minusButton addTarget:self action:@selector(changeNumberString) forControlEvents:UIControlEventTouchUpInside];
    [inputAccesoryView addSubview:minusButton];
    
    self.minTextField.inputAccessoryView = inputAccesoryView;
    self.maxTextField.inputAccessoryView = inputAccesoryView;
}

- (void)changeNumberString {
    if (self.minTextField.isFirstResponder) {
        if ([self.minTextField.text hasPrefix:@"-"]) {
            self.minTextField.text = [self.minTextField.text substringFromIndex:1];
        } else {
            self.minTextField.text = [NSString stringWithFormat:@"-%@",self.minTextField.text];
        }
    } else if (self.maxTextField.isFirstResponder) {
        if ([self.maxTextField.text hasPrefix:@"-"]) {
            self.maxTextField.text = [self.maxTextField.text substringFromIndex:1];
        } else {
            self.maxTextField.text = [NSString stringWithFormat:@"-%@",self.maxTextField.text];
        }
    }
}

- (void)dismissKeyboard {
    [self.minTextField resignFirstResponder];
    [self.maxTextField resignFirstResponder];
    
    int newMinValue = [self.minTextField.text doubleValue];
    int newMaxValue = [self.maxTextField.text doubleValue];
    
    if (newMinValue > newMaxValue) {
        newMinValue = newMaxValue;
        self.minTextField.text = [NSString stringWithFormat:@"%d",newMinValue];
    }
    
    if (newMaxValue < newMinValue) {
        newMaxValue = newMinValue;
        self.maxTextField.text = [NSString stringWithFormat:@"%d",newMaxValue];
    }
    
    self.minStepper.minimumValue = newMinValue - 1;
    self.maxStepper.minimumValue = newMinValue;
    
    self.maxStepper.maximumValue = newMaxValue + 1;
    self.minStepper.maximumValue = newMaxValue;
    
    [self.unitAPicker reloadAllComponents];
    [self.unitBPicker reloadAllComponents];
}

@end
