//
//  ViewController.m
//  JQWKWebViewController
//
//  Created by 韩俊强 on 2017/6/29.
//  Copyright © 2017年 HaRi. All rights reserved.
//

#import "ViewController.h"
#import "JQWKWebViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *urlTextField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)enterWkWebViewAction:(UIButton *)sender
{
    JQWKWebViewController *JQWebView = [[JQWKWebViewController alloc]init];
    JQWebView.titleName = _urlTextField.text;
    JQWebView.h5_urlString = _urlTextField.text;
    [self.navigationController pushViewController:JQWebView animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
