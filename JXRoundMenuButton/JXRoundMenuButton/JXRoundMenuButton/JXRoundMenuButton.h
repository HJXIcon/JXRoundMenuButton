//
//  JXRoundMenuButton.h
//  JXRoundMenuButton
//
//  Created by 晓梦影 on 2017/8/23.
//  Copyright © 2017年 黄金星. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef NS_OPTIONS(NSInteger, JXRoundMenuButtonIconType) {
    
    JXRoundMenuButtonIconTypePlus = 0, // plus icon
    JXRoundMenuButtonIconTypeUserDraw,  // draw icon by youself
    JXRoundMenuButtonIconTypeCustomImage,
};



@interface JXRoundMenuButton : UIControl

/**
 *  center button size ; default is CGSize(50,50)
 */
@property (nonatomic, assign) CGSize centerButtonSize;

/**
 *  "JXRoundMenuButtonIconTypePlus" is a "plus" icon. "JXRoundMenuButtonIconTypeUserDraw" must use "drawCenterButtonIconBlock" draw with CoreGraphic.
 */
@property (nonatomic, assign) JXRoundMenuButtonIconType centerIconType;

/**
 *  default is nil, only used when centerIconType is JXRoundMenuButtonIconTypeCustomImage
 */
@property (nonatomic, strong) UIImage* centerIcon;


/**
 *  animate style, if you want icon jump out one by one , set it YES, default is NO;
 */
@property (nonatomic, assign) BOOL jumpOutButtonOnebyOne;

/**
 *  main color
 */
@property (nonatomic, strong) UIColor* mainColor;


/**
 *  click block
 */
@property (nonatomic, strong) void (^buttonClickBlock) (NSInteger idx);

/**
 *  draw center icon block
 */
@property (nonatomic, strong) void (^drawCenterButtonIconBlock)(CGRect rect , UIControlState state);


@property (nonatomic, assign) BOOL isOpened;


/**
 Offset after menu is opened.
 */
@property (nonatomic, assign) CGSize offsetAfterOpened;


/**
 Real raduis is frame.size.width/2 - raduisForIcons. raduisForIcons's default is 20.
 */
@property (nonatomic, assign) CGFloat raduisForIcons;


/**
 *  config function
 *
 *  @param icons        array of UIImages
 *  @param degree       start degree
 *  @param layoutDegree angle span
 */
- (void)loadButtonWithIcons:(NSArray<UIImage*>*)icons startDegree:(float)degree layoutDegree:(float)layoutDegree;

@end
