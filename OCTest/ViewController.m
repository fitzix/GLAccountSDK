//
//  ViewController.m
//  OCTest
//
//  Created by fitz on 2018/7/25.
//  Copyright © 2018年 Fitz Leo. All rights reserved.
//

#import "ViewController.h"
#import <GameleySDK/GameleySDK-Swift.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    GameleySDK.shared.delegate = self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)login:(UIButton *)sender {
    [GameleySDK login];
}

- (void)didLoginWithUserInfo:(GLUserInfo *)userInfo {
    NSLog(@"%@", userInfo);
}
- (IBAction)logout:(UIButton *)sender {
    NSLog(@"退出了");
}

@end
