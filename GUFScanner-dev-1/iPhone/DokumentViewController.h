//
//  DokumentViewController.h
//  BarcodeExample
//
//  Created by Matthias Lukjantschuk on 5/1/13.
//  Copyright (c) 2013 GundF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DokumentViewController : UIViewController <UIWebViewDelegate>

@property (strong, nonatomic) NSString *dokumentURL;

@property (retain, nonatomic) IBOutlet UIWebView *webView;

@end
