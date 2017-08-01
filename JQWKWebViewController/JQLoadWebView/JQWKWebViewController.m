//
//  JQWKWebViewController.m
//  JQWKWebViewController
//
//  Created by 韩俊强 on 2017/6/29.
//  Copyright © 2017年 HaRi. All rights reserved.
//

#import "JQWKWebViewController.h"
#import <WebKit/WebKit.h>

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

@interface JQWKWebViewController ()<WKUIDelegate,WKNavigationDelegate>

@property (nonatomic, weak) UIButton *backItem;

@property (nonatomic, weak) UIButton *closeItem;

@property (nonatomic, weak) UIButton *refreshItem;

@property (nonatomic, strong) WKWebView *JQWebView;

@property (nonatomic, strong) UIProgressView *progressView;

@end

@implementation JQWKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setnavigation];
    [self createWebViewNavigation];
    [self initJQWebView];
    
    [_JQWebView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}

// setUpJQWebView
- (void)initJQWebView
{
    _JQWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    _JQWebView.UIDelegate = self;
    _JQWebView.navigationDelegate = self;
    [self.view addSubview:_JQWebView];
    
    _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 2)];
    [self.view addSubview:_progressView];
    
    [_JQWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    NSString *str = [NSString stringWithFormat:@"http://%@",self.h5_urlString];
    NSString *url = [self encodeToPercentEscapeString:str];
    
    [_JQWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

- (void)createWebViewNavigation
{
    self.navigationItem.title = _titleName;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    UIButton * backItem = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 13, 20)];
    [backItem setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backItem addTarget:self action:@selector(clickedBackItem:) forControlEvents:UIControlEventTouchUpInside];
    self.backItem = backItem;
    UIBarButtonItem *leftItem1 = [[UIBarButtonItem alloc] initWithCustomView:backItem];
    
    UIButton * closeItem = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [closeItem setTitle:@"关闭" forState:UIControlStateNormal];
    [closeItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [closeItem addTarget:self action:@selector(clickedCloseItem:) forControlEvents:UIControlEventTouchUpInside];
    closeItem.hidden = YES;
    self.closeItem = closeItem;
    UIBarButtonItem *leftItem2 = [[UIBarButtonItem alloc] initWithCustomView:closeItem];
    self.navigationItem.leftBarButtonItems = @[leftItem1,leftItem2];
    
    UIButton *refreshItem = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [refreshItem setImage:[UIImage imageNamed:@"Refresh"] forState:UIControlStateNormal];
    [refreshItem addTarget:self action:@selector(clickedRefreshItem:) forControlEvents:UIControlEventTouchUpInside];
    self.refreshItem = refreshItem;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:refreshItem];
    self.navigationItem.rightBarButtonItems = @[rightItem];
}

- (void)setnavigation
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavAlpha0"] forBarMetrics:0];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    img.image = [UIImage imageNamed:@"navbgview"];
    [self.view addSubview:img];
}

#pragma mark - clickedBackItem
- (void)clickedBackItem:(UIBarButtonItem *)btn
{
    if (self.JQWebView.canGoBack) {
        [self.JQWebView goBack];
        self.closeItem.hidden = NO;
    }else{
        [self clickedCloseItem:nil];
    }
}

#pragma mark - clickedCloseItem
- (void)clickedCloseItem:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - clickedRefreshItem
- (void)clickedRefreshItem:(UIButton *)btn
{
    NSString *str = [NSString stringWithFormat:@"http://%@",self.h5_urlString];
    NSString *url = [self encodeToPercentEscapeString:str];
    
    [_JQWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

#pragma mark - url编码
- (NSString *)encodeToPercentEscapeString: (NSString *) input
{
    return [input stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSString *urlString = navigationAction.request.URL.absoluteString;
    if ([urlString containsString:@"about"]){
        [[[UIAlertView alloc]initWithTitle:@"关于我" message:@"关于小韩哥" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil]show];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

//WKNavigationDelegate
/**
 *  页面开始加载时调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 */
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    //    NSLog(@"%s", __FUNCTION__);
}
/**
 *  当内容开始返回时调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 */
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
    //    NSLog(@"%s", __FUNCTION__);
}
/**
 *  页面加载完成之后调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    //    NSLog(@"%s", __FUNCTION__);
    NSLog(@"加载成功");
    self.refreshItem.hidden = YES;
    [_progressView setProgress:0.0 animated:false];
}

/**
 *  加载失败时调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 *  @param error      错误
 */
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
    //    NSLog(@"%s", __FUNCTION__);
    NSLog(@"加载失败");
    self.refreshItem.hidden = NO;
    //    [self webViewReloadView];
}

/**
 *  接收到服务器跳转请求之后调用
 *
 *  @param webView      实现该代理的webview
 *  @param navigation   当前navigation
 */
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    
    //    NSLog(@"%s", __FUNCTION__);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    //    NSLog(@" %s,change = %@",__FUNCTION__,change);
    if ([keyPath isEqual: @"estimatedProgress"] && object == _JQWebView) {
        [self.progressView setAlpha:1.0f];
        [self.progressView setProgress:_JQWebView.estimatedProgress animated:YES];
        if(_JQWebView.estimatedProgress >= 1.0f)
        {
            [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }
    } else if (object == _JQWebView.scrollView && [keyPath isEqual:@"contentSize"]) {
        UIScrollView *scrollView = _JQWebView.scrollView;
        NSLog(@"New contentSize: %f x %f", scrollView.contentSize.width, scrollView.contentSize.height);
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)returnToVC:(UIButton*)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc
{
    if (_JQWebView) {
        [_JQWebView.scrollView removeObserver:self forKeyPath:@"contentSize" context:nil];
        [_JQWebView removeObserver:self forKeyPath:@"estimatedProgress"];
        [_JQWebView setNavigationDelegate:nil];
        [_JQWebView setUIDelegate:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
