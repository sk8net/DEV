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
@property (retain, nonatomic) IBOutlet UIWebView *webView;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *loadingSign;
@end