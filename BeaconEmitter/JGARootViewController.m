//
//  JGARootViewController.m
//  BeaconEmitter
//
//  Created by John Grant on 2014-03-02.
//  Copyright (c) 2014 John Grant. All rights reserved.
//

#import "JGARootViewController.h"
#import "JGABroadcastController.h"

@interface JGARootViewController () <UITextFieldDelegate>
@property (nonatomic, weak) IBOutlet UITextField *beaconNumberInput;
@property (nonatomic, weak) IBOutlet UIButton *broadcastButton;
@property (nonatomic, strong) JGABroadcastController *broadcastController;
@end

@implementation JGARootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.broadcastController = [[JGABroadcastController alloc] init];
    self.title = NSLocalizedString(@"Beacon Setup", @"The title of the root view controller");
    [self.beaconNumberInput becomeFirstResponder];
    
    [self.beaconNumberInput addTarget:self action:@selector(inputDidChangeValue:) forControlEvents:UIControlEventEditingChanged];
    [self toggleButtonEnabledState];
}

- (IBAction)broadcastButtonTapped:(id)sender
{
    if (![self inputIsEmpty]){
        [self toggleBroadcastState];
    }
}

- (BOOL)inputIsEmpty
{
    return self.beaconNumberInput.text.length == 0;
}

- (void)toggleBroadcastState
{
    [self.broadcastButton setTitle:[self toggledTitleForButton] forState:UIControlStateNormal];
    [self.broadcastButton setTitleColor:[self toggledColorForButton] forState:UIControlStateNormal];
    [self toggleBroadcasting];
}
- (void)toggleButtonEnabledState
{
    self.broadcastButton.enabled = ![self inputIsEmpty];
}

- (NSString *)toggledTitleForButton
{
    if (self.broadcastController.isBroadcasting){
        return NSLocalizedString(@"Start Broadcasting", @"Button text when inactive");
    }
    return NSLocalizedString(@"Stop Broadcasting", @"button text when active");
}

- (UIColor *)toggledColorForButton
{
    return self.broadcastController.isBroadcasting ? [UIColor blueColor] : [UIColor redColor];
}

- (void)toggleBroadcasting
{
    if (self.broadcastController.isBroadcasting) {
        [self.broadcastController stopBroadcasting];
    }else{
        [self.broadcastController startBroadcastingWithNumber:[self.beaconNumberInput.text intValue]];
    }
}

#pragma mark - UITextFieldDelegate
- (NSCharacterSet *)notDigitsOrDots
{
    static NSCharacterSet *characterSet;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableCharacterSet *digitsAndDots = [NSMutableCharacterSet decimalDigitCharacterSet];
        [digitsAndDots addCharactersInString:@"."];
        characterSet = [digitsAndDots invertedSet];
    });
    
    return characterSet;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return [string rangeOfCharacterFromSet:[self notDigitsOrDots]].location == NSNotFound;
}

- (void)inputDidChangeValue:(id)sender
{
    [self toggleButtonEnabledState];
}

@end
