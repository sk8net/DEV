//
//  PureCenterViewControlleriPhone.h
//  Untitled
//
//  Created by Neo on 2011/1/21.
//  Copyright 2011 Mobilogics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"


@interface PureCenterViewControlleriPhone : UIViewController<UITextFieldDelegate, ReceiveCommandHandler, NotificationHandler, ZBarReaderDelegate> {
}

@property (retain, nonatomic) IBOutlet UITextField *oderBarcodeEintippen;
@property (retain, nonatomic) IBOutlet UITextField *mitarbeiterID;
- (IBAction)manual:(id)sender;
-(IBAction)scan:(id)sender;
- (void)checkConnected;
- (IBAction)kommen:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *updateStatusButton;

@property (retain, nonatomic) IBOutlet UITextField *textField;


@end
