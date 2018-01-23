//
//  HNWebViewController.m
//  Linkesvape
//
//  Created by make on 2018/1/4.
//  Copyright © 2018年 make. All rights reserved.
//

#import "HNWebViewController.h"

@interface HNWebViewController ()<UIWebViewDelegate>

@property (nonatomic,strong)UIWebView * webView;
@end

@implementation HNWebViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [MBProgressHUD showMessage:NSLocalizedString(@"正在加载数据...", nil) toView:self.view];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    

}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    [MBProgressHUD hideHUDForView:self.view];
}

- (void)masLayoutSubview{
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.edges.equalTo(self.view.mas_safeAreaLayoutGuide);
        } else {
            make.edges.equalTo(self.view);
        }
    }];
}

- (UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc]init];
        _webView.delegate = self;
        [self.view addSubview:_webView];
        NSURL *url  = [NSURL URLWithString:self.urlString];
        [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    }
    return _webView;
}
@end
