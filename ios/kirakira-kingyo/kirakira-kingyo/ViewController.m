//
//  ViewController.m
//  kirakira-kingyo
//
//  Created by A12642 on 2013/10/24.
//  Copyright (c) 2013年 yuyaohshimo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
<UIWebViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// webview
	NSURLRequest* req = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://localhost:8888"]];
	[_webView loadRequest:req];
	_webView.scrollView.scrollEnabled = NO;
	_webView.scrollView.bounces = NO;
	_webView.delegate = self;
	
	
	UIApplication *application = [UIApplication sharedApplication];
	
	// stop auto sleep
	application.idleTimerDisabled = YES;
	
	// prevent typing event with gesture
	application.applicationSupportsShakeToEdit = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	NSLog(@"url:%@", request);
	return YES;
}

@end
