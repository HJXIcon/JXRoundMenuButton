//
//  ViewController.m
//  JXRoundMenuButton
//
//  Created by 晓梦影 on 2017/8/23.
//  Copyright © 2017年 黄金星. All rights reserved.
//

#import "ViewController.h"
#import "JXRoundMenuButton.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet JXRoundMenuButton *roundMenu;
@property (weak, nonatomic) IBOutlet JXRoundMenuButton *roundMenu2;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.roundMenu.centerButtonSize = CGSizeMake(44, 44);
    self.roundMenu.centerIconType = JXRoundMenuButtonIconTypeUserDraw;
    self.roundMenu.tintColor = [UIColor whiteColor];
    self.roundMenu.jumpOutButtonOnebyOne = YES;
    
    [self.roundMenu setDrawCenterButtonIconBlock:^(CGRect rect, UIControlState state) {
        
        if (state == UIControlStateNormal)
        {
            UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake((rect.size.width - 15)/2, rect.size.height/2 - 5, 15, 1)];
            [UIColor.whiteColor setFill];
            [rectanglePath fill];
            
            UIBezierPath* rectangle2Path = [UIBezierPath bezierPathWithRect: CGRectMake((rect.size.width - 15)/2, rect.size.height/2, 15, 1)];
            [UIColor.whiteColor setFill];
            [rectangle2Path fill];
            
            UIBezierPath* rectangle3Path = [UIBezierPath bezierPathWithRect: CGRectMake((rect.size.width - 15)/2, rect.size.height/2 + 5, 15, 1)];
            [UIColor.whiteColor setFill];
            [rectangle3Path fill];
        }
    }];
    
    [self.roundMenu loadButtonWithIcons:@[
                                          [UIImage imageNamed:@"icon_can"],
                                          [UIImage imageNamed:@"icon_pos"],
                                          [UIImage imageNamed:@"icon_img"],
                                          [UIImage imageNamed:@"icon_can"],
                                          [UIImage imageNamed:@"icon_pos"],
                                          [UIImage imageNamed:@"icon_img"],
                                          [UIImage imageNamed:@"icon_can"],
                                          [UIImage imageNamed:@"icon_pos"],
                                          [UIImage imageNamed:@"icon_img"]
                                          
                                          ] startDegree:0 layoutDegree:M_PI*2*7/8];
    
    [self.roundMenu setButtonClickBlock:^(NSInteger idx) {
        
        NSLog(@"button %@ clicked !",@(idx));
    }];
    
    
    
    
    
    /**
     *  RoundMenu2 config
     */
    [self.roundMenu2 loadButtonWithIcons:@[
                                           [UIImage imageNamed:@"icon_can"],
                                           [UIImage imageNamed:@"icon_pos"],
                                           [UIImage imageNamed:@"icon_img"],
                                           [UIImage imageNamed:@"icon_can"],
                                           [UIImage imageNamed:@"icon_pos"],
                                           [UIImage imageNamed:@"icon_img"]
                                           
                                           ] startDegree:-M_PI layoutDegree:M_PI];
    [self.roundMenu2 setButtonClickBlock:^(NSInteger idx) {
        
        NSLog(@"button %@ clicked !",@(idx));
    }];
    
    [self.roundMenu2 setCenterIcon:[UIImage imageNamed:@"icon_pos"]];
    [self.roundMenu2 setCenterIconType:JXRoundMenuButtonIconTypeCustomImage];
    
    self.roundMenu2.tintColor = [UIColor whiteColor];
    
    self.roundMenu2.mainColor = [UIColor colorWithRed:0.13 green:0.58 blue:0.95 alpha:1];
    
    self.roundMenu2.offsetAfterOpened = CGSizeMake(-80, -80);
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
