//
//  WebViewViewController.h
//  UIWebViewTutorial
//
//  Created by iOsDevGermany
//

#import <UIKit/UIKit.h>

@interface WebViewViewController : UIViewController <UIWebViewDelegate> {
    NSString *websiteName;
}
@property (copy, nonatomic) NSString * websiteName;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingSign;
@end