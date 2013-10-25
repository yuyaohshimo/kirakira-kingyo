//
//  ViewController.m
//  kirakira-kingyo
//
//  Created by A12642 on 2013/10/24.
//  Copyright (c) 2013年 yuyaohshimo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	NSURLRequest* req = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.11.7:8888"]];
	[self.webView loadRequest:req];
	self.webView.scrollView.scrollEnabled = NO;
	self.webView.scrollView.bounces = NO;
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

- (void)dealloc
{
	self.webView.delegate = nil;
}

@end
