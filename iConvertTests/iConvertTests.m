//
//  iConvertTests.m
//  iConvertTests
//
//  Created by Michael Borgmann on 09/04/16.
//  Copyright © 2016 Michael Borgmann. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ViewController.h"

@interface iConvertTests : XCTestCase

@property (nonatomic, strong) ViewController *vc;

@end

@implementation iConvertTests

- (void)setUp {
    [super setUp];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.vc = [storyboard instantiateViewControllerWithIdentifier:@"iConvertView"];
    [self.vc performSelectorOnMainThread:@selector(loadView) withObject:nil waitUntilDone:YES];
    
    [self.vc viewDidLoad];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testThatPropertiesForUnitAExist {
    XCTAssertTrue([ViewController instancesRespondToSelector:@selector(unitALabel)], "Label for unit A should exist.");
    XCTAssertTrue([ViewController instancesRespondToSelector:@selector(unitAPicker)], "Picker for unit A should exist.");
    XCTAssertTrue([ViewController instancesRespondToSelector:@selector(unitAValue)], "Value for unit A should exist.");
}

- (void)testThatPropertiesForUnitBExist {
    XCTAssertTrue([ViewController instancesRespondToSelector:@selector(unitBLabel)], "Label for unit B should exist.");
    XCTAssertTrue([ViewController instancesRespondToSelector:@selector(unitBPicker)], "Picker for unit B should exist.");
    XCTAssertTrue([ViewController instancesRespondToSelector:@selector(unitBValue)], "Value for unit B should exist.");
}

- (void)testThatPropertiesForMinTemperatureExist {
    XCTAssertTrue([ViewController instancesRespondToSelector:@selector(minStepper)], "Stepper for minimum temperature should exist.");
    XCTAssertTrue([ViewController instancesRespondToSelector:@selector(minTextField)], "Textfield for minimum temperature should exist.");
}

- (void)testThatPropertiesForMaxTemperatureExist {
    XCTAssertTrue([ViewController instancesRespondToSelector:@selector(maxStepper)], "Stepper for maximum temperature should exist.");
    XCTAssertTrue([ViewController instancesRespondToSelector:@selector(maxTextField)], "Textfield for maximum temperature should exist.");
}

- (void)testConversionFromCelsiusToFahrenheit {
    XCTAssertEqual([self.vc celsiusToFahrenheit:25], 77);
}

- (void)testConversionFromFahrenheitToCelsius {
    XCTAssertEqual([self.vc fahrenheitToCelsius:77], 25);
}

- (void)testThatPickerConformsToPickerDataSourceProtocol {
    XCTAssertTrue([self.vc conformsToProtocol:@protocol(UIPickerViewDataSource) ], @"View should conform to UIPickerViewDataSource datasource protocol");
}

- (void)testThatPickerConformsToPickerDelegate {
    XCTAssertTrue([self.vc conformsToProtocol:@protocol(UIPickerViewDelegate) ], @"View should conform to UIPickerViewDelegate delegate protocol");
}

- (void)testThatPickerDelegateIsConnected {
    XCTAssertNotNil(self.vc.unitAPicker.delegate);
    XCTAssertNotNil(self.vc.unitBPicker.delegate);
}

- (void)testThatPickerDataSourceIsConnected {
    XCTAssertNotNil(self.vc.unitAPicker.dataSource);
    XCTAssertNotNil(self.vc.unitBPicker.dataSource);
}

- (void)testThatPickerHaveOnlyOneComponent {
    XCTAssertEqual([self.vc numberOfComponentsInPickerView:self.vc.unitAPicker], 1);
    XCTAssertEqual([self.vc numberOfComponentsInPickerView:self.vc.unitBPicker], 1);
}

- (void)testThatNumberOfRowsForFirstUnitRangesFromMinToMax {
    int min = [self.vc.minTextField.text intValue];
    int max = [self.vc.maxTextField.text intValue];
    int rows = max - min + 1;
    XCTAssertEqual([self.vc.unitAPicker numberOfRowsInComponent:0], rows);
}

- (void)testThatNumberOfRowsForSecondUnitCorrespondsToMinAndMax {
    int min = [self.vc celsiusToFahrenheit:[self.vc.minTextField.text intValue]];
    int max = [self.vc celsiusToFahrenheit:[self.vc.maxTextField.text intValue]];
    int rows = max - min + 1;
    XCTAssertEqual([self.vc.unitBPicker numberOfRowsInComponent:0], rows);
}

- (void)testThatFirstPickerAdaptsMinValue {
    NSString *rowTitle = [self.vc pickerView:self.vc.unitAPicker titleForRow:0 forComponent:0];
    XCTAssertTrue([rowTitle isEqualToString: @"-273 °C"]);
}

- (void)testThatFirstPickerAdaptsMaxValue {
    int row = [self.vc.maxTextField.text intValue] - [self.vc.minTextField.text intValue];
    NSString *rowTitle = [self.vc pickerView:self.vc.unitAPicker titleForRow:row forComponent:0];
    XCTAssertTrue([rowTitle isEqualToString: @"100 °C"]);
}

- (void)testThatSecondPickerAdaptsMinValue {
    NSString *rowTitle = [self.vc pickerView:self.vc.unitBPicker titleForRow:0 forComponent:0];
    XCTAssertTrue([rowTitle isEqualToString: @"-459 °F"]);
}

- (void)testThatSecondPickerAdaptsMaxValue {
    int min = [self.vc celsiusToFahrenheit:[self.vc.minTextField.text intValue]];
    int max = [self.vc celsiusToFahrenheit:[self.vc.maxTextField.text intValue]];
    int row = max - min;
    
    NSString *rowTitle = [self.vc pickerView:self.vc.unitBPicker titleForRow:row forComponent:0];
    XCTAssertTrue([rowTitle isEqualToString: @"212 °F"]);
}

- (void)testThatChangingFirstPickerUpdatesSecond {
    int zeroDegreeCelsius = 273;
    [self.vc pickerView:self.vc.unitAPicker didSelectRow:zeroDegreeCelsius inComponent:0];
    NSInteger row = [self.vc.unitBPicker selectedRowInComponent:0];
    XCTAssertEqual(row, 491, "Setting to 0 °C should be 32 °F");
}

- (void)testThatChangingSecondPickerUpdatesFirst {
    int thirtyTwoDegreeFahrenheit = 491;
    [self.vc pickerView:self.vc.unitBPicker didSelectRow:thirtyTwoDegreeFahrenheit inComponent:0];
    NSInteger row = [self.vc.unitAPicker selectedRowInComponent:0];
    XCTAssertEqual(row, 273, "Setting to 32 °F should be 0 °F");
}

- (void)testThatUnitLabelsUpdateOnStartup {
    int celsius = [self.vc.unitAPicker selectedRowInComponent:0] + [self.vc.minTextField.text intValue];
    NSString *text = [NSString stringWithFormat: @"%.1f °C", (double)celsius];
    XCTAssertTrue([self.vc.unitAValue.text isEqualToString:text]);
}

- (void)testThatFirstStepperIsConnectedWithTextfield {
    int stepperValue = self.vc.minStepper.value;
    int textfieldValue = round([self.vc.minTextField.text doubleValue]);
    XCTAssertEqual(stepperValue, textfieldValue);
}

- (void)testThatSecondStepperIsConnectedWithTextfield {
    int stepperValue = self.vc.maxStepper.value;
    int textfieldValue = round([self.vc.maxTextField.text doubleValue]);
    XCTAssertEqual(stepperValue, textfieldValue);
}

- (void)testThatChangingValueOfFirstStepperChangesMinValue {
    self.vc.minStepper.value++;
    [self.vc minValueChanged:self.vc.minStepper];
    XCTAssertEqual(self.vc.minStepper.minimumValue + 1, self.vc.minStepper.value);
}

- (void)testThatChaningValueOfSecondStepperChangesMaxValue {
    self.vc.maxStepper.value--;
    [self.vc maxValueChanged:self.vc.maxStepper];
    XCTAssertEqual(self.vc.maxStepper.maximumValue - 1, self.vc.maxStepper.value);
}

- (void)testThatChaningMinTextfieldChangesMinValue {
    [self.vc.minTextField becomeFirstResponder];
    [self.vc changeNumberString];
    [self.vc dismissKeyboard];
    double inputValue = [self.vc.minTextField.text doubleValue];
    XCTAssertEqual(inputValue, 273);
}

@end
