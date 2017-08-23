//
//  JXRoundMenuButton.m
//  JXRoundMenuButton
//
//  Created by 晓梦影 on 2017/8/23.
//  Copyright © 2017年 黄金星. All rights reserved.
//

#import "JXRoundMenuButton.h"

static int const RoundMenuButtonTag = 9998;

@class JXRoundMenuButton_roundCircle,JXRoundMenuButton_centerButton;
/*！JXRoundMenuButton */
@interface JXRoundMenuButton ()

@property (nonatomic, strong) NSMutableArray <UIImage *>*icons;
@property (nonatomic, assign) float startDegree;
@property (nonatomic, assign) float layoutDegree;

@property (nonatomic, strong) JXRoundMenuButton_roundCircle
*roundCircle;
@property (nonatomic, strong) JXRoundMenuButton_centerButton *centerButton;


@end


/*！JXRoundMenuButton_centerButton */
@interface JXRoundMenuButton_centerButton : UIButton
@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic, strong) UIImage *centerIcon;
@property (nonatomic, strong) UIImageView *centerIconView;

@property (nonatomic, assign) JXRoundMenuButtonIconType type;
- (instancetype)initWithFrame:(CGRect)frame type:(JXRoundMenuButtonIconType)type;
@end


/*！JXRoundMenuButton_roundCircle */
@interface JXRoundMenuButton_roundCircle : UIView

@property (nonatomic, assign) CGFloat raduisForIcons;
@property (nonatomic, strong) UIColor *circleColor;

- (void)clean;
- (void)animatedLoadIcons:(NSArray<UIImage*>*)icons start:(float)start layoutDegree:(float)layoutDegree oneByOne:(BOOL)onebyone;


@end



///****************************************
@implementation JXRoundMenuButton
#pragma mark - lazy load
- (JXRoundMenuButton_centerButton *)centerButton{
    if (_centerButton == nil) {
        _centerButton = [[JXRoundMenuButton_centerButton alloc]initWithFrame:CGRectMake(0, 0, self.centerButtonSize.width, self.centerButtonSize.height) type:self.centerIconType];
        [_centerButton addTarget:self action:@selector(centerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _centerButton;
}

- (JXRoundMenuButton_roundCircle *)roundCircle{
    if (_roundCircle == nil) {
        _roundCircle = [[JXRoundMenuButton_roundCircle alloc]initWithFrame:CGRectZero];
        _roundCircle.tintColor = self.tintColor;
    }
    return _roundCircle;
}
- (NSMutableArray<UIImage *> *)icons{
    if (_icons == nil) {
        _icons = [NSMutableArray array];
    }
    return _icons;
}


#pragma mark - init
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    [self setup];
}


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setup];
    }
    return self;
}



#pragma mark - Public
- (void)loadButtonWithIcons:(NSArray<UIImage *> *)icons startDegree:(float)degree layoutDegree:(float)layoutDegree{
    
    [self.icons removeAllObjects];
    [self.icons addObjectsFromArray:icons];
    
    self.startDegree = degree;
    self.layoutDegree = layoutDegree;
    
    
}


#pragma mark - private

- (void)drawCentenIconInRect:(CGRect)rect state:(UIControlState)state
{
    if (self.drawCenterButtonIconBlock) {
        self.drawCenterButtonIconBlock(rect,state);
    }
}

- (void)setup{
    self.offsetAfterOpened = CGSizeZero;
    self.raduisForIcons = 20;
    self.mainColor = [UIColor colorWithRed: 0.95 green: 0.2 blue: 0.39 alpha: 1];
    
    self.jumpOutButtonOnebyOne = NO;
    self.centerIconType = JXRoundMenuButtonIconTypePlus;
    self.centerButtonSize = CGSizeMake(50, 50);
    [self addSubview:self.roundCircle];
    [self addSubview:self.centerButton];
}





- (UIColor *)add_darkerColorWithValue:(CGFloat)value origin:(UIColor*)origin
{
    size_t totalComponents = CGColorGetNumberOfComponents(origin.CGColor);
    BOOL isGreyscale = (totalComponents == 2) ? YES : NO;
    
    CGFloat const * oldComponents = (CGFloat *)CGColorGetComponents(origin.CGColor);
    CGFloat newComponents[4];
    
    CGFloat (^actionBlock)(CGFloat component) = ^CGFloat(CGFloat component) {
        
        CGFloat newComponent = component * (1.0 - value);
        
        // CGFloat newComponent = component - value < 0.0 ? 0.0 : component - value;
        
        return newComponent;
    };
    
    if (isGreyscale)
    {
        newComponents[0] = actionBlock(oldComponents[0]);
        newComponents[1] = actionBlock(oldComponents[0]);
        newComponents[2] = actionBlock(oldComponents[0]);
        newComponents[3] = oldComponents[1];
    }
    else
    {
        newComponents[0] = actionBlock(oldComponents[0]);
        newComponents[1] = actionBlock(oldComponents[1]);
        newComponents[2] = actionBlock(oldComponents[2]);
        newComponents[3] = oldComponents[3];
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef newColor = CGColorCreate(colorSpace, newComponents);
    CGColorSpaceRelease(colorSpace);
    
    UIColor *retColor = [UIColor colorWithCGColor:newColor];
    CGColorRelease(newColor);
    
    return retColor;
}


#pragma mark Actions
- (void)centerButtonClicked:(UIButton*)sender{
    sender.selected = !sender.selected;
}

- (void)buttonClick:(id)sender{
    self.centerButton.selected = NO;
    
    if (self.buttonClickBlock) {
        self.buttonClickBlock([sender tag] - RoundMenuButtonTag);
    }
}


#pragma mark - setter/getter
- (void)setRaduisForIcons:(CGFloat)raduisForIcons{
    _raduisForIcons = raduisForIcons;
    [self.roundCircle setRaduisForIcons:raduisForIcons];
}

- (void)setMainColor:(UIColor *)mainColor{
    _mainColor = mainColor;
    self.centerButton.normalColor = mainColor;
    self.centerButton.selectedColor = [self add_darkerColorWithValue:0.2 origin:mainColor];
    self.roundCircle.circleColor = mainColor;
}
- (void)setTintColor:(UIColor *)tintColor{
    [super setTintColor:tintColor];
    [self.roundCircle setTintColor:tintColor];
}

- (void)setCenterButtonSize:(CGSize)centerButtonSize{
    _centerButtonSize = centerButtonSize;
    
    [self layoutSubviews];
}

- (void)setCenterIcon:(UIImage *)centerIcon{
    [self.centerButton setCenterIcon:centerIcon];
    [self.centerButton setNeedsDisplay];
}

- (UIImage *)centerIcon{
    return [self.centerButton centerIcon];
}

- (void)setCenterIconType:(JXRoundMenuButtonIconType)centerIconType{
    _centerIconType = centerIconType;
    
    [self.centerButton setType:centerIconType];
}



#pragma mark - overried
- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.centerButton.bounds = CGRectMake(0, 0, self.centerButtonSize.width, self.centerButtonSize.height);
    
    self.centerButton.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
    if (self.selected) {
        
        self.roundCircle.frame = self.bounds;
    }
    else
    {
        self.roundCircle.frame = self.centerButton.frame;
    }
    
    [self.roundCircle setNeedsDisplay];
    
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    
    if (!selected) {
        [self.roundCircle clean];
    }
    
    self.isOpened = selected;
    [UIView animateWithDuration:0.24
                          delay:0
         usingSpringWithDamping:0.6 initialSpringVelocity:5
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         
                         if (selected) {
                             self.transform = CGAffineTransformConcat(self.transform, CGAffineTransformMakeTranslation(self.offsetAfterOpened.width, self.offsetAfterOpened.height));
                             self.roundCircle.frame = self.bounds;
                         }
                         else
                         {
                             self.transform = CGAffineTransformConcat(self.transform, CGAffineTransformMakeTranslation(-self.offsetAfterOpened.width, -self.offsetAfterOpened.height));
                             self.roundCircle.frame = self.centerButton.frame;
                         }
                         
                     } completion:^(BOOL finished) {
                         
                         
                         [self.roundCircle setNeedsDisplay];
                         
                         if (selected) {
                             [self.roundCircle animatedLoadIcons:self.icons start:self.startDegree layoutDegree:self.layoutDegree oneByOne:self.jumpOutButtonOnebyOne];
                         }
                         
                     }];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *view = [super hitTest:point withEvent:event];
    
    if (self.isOpened) {
        
        return view;
    }
    
    if (CGRectContainsPoint(self.centerButton.frame, point)) {
        return self.centerButton;
    }
    return nil;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    
}


@end


///****************************************
@implementation JXRoundMenuButton_centerButton
- (UIImageView *)centerIconView{
    if (_centerIconView == nil) {
        _centerIconView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:_centerIconView];
        _centerIconView.alpha = 0;
        _centerIconView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _centerIconView;
}


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame type:(JXRoundMenuButtonIconType)type{
    if (self = [self initWithFrame:frame]) {
        self.type = type;
    }
    return self;
}

#pragma mark setter/getter

- (void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    
    [self setNeedsDisplay];
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    
    [self setNeedsDisplay];
    
    [UIView animateWithDuration:0.24
                          delay:0
         usingSpringWithDamping:0.6 initialSpringVelocity:10
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.transform = CGAffineTransformMakeRotation(selected?M_PI_2/2:0);
                         
                     } completion:^(BOOL finished) {
                         
                     }];
    
    if ([self.superview respondsToSelector:@selector(setSelected:)]) {
        [(id)self.superview setSelected:selected];
    }
}
- (void)setType:(JXRoundMenuButtonIconType)type
{
    _type = type;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    //// Color Declarations
    
    UIColor* color = self.normalColor;
    if (self.highlighted || self.selected) {
        color = self.selectedColor;
    }
    
    //// Oval Drawing
    UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(0, 0, rect.size.width, rect.size.height)];
    [color setFill];
    [ovalPath fill];
    self.centerIconView.alpha = 0;
    
    if (self.type == JXRoundMenuButtonIconTypePlus || self.state == UIControlStateSelected) {
        //// Rectangle Drawing
        UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(15, rect.size.height/2 - 0.5, rect.size.width - 30, 1)];
        [UIColor.whiteColor setFill];
        [rectanglePath fill];
        
        
        //// Rectangle 2 Drawing
        UIBezierPath* rectangle2Path = [UIBezierPath bezierPathWithRect: CGRectMake(rect.size.width/2 - 0.5, 15, 1, rect.size.height - 30)];
        [UIColor.whiteColor setFill];
        [rectangle2Path fill];
    }
    else if (self.type == JXRoundMenuButtonIconTypeUserDraw)
    {
        if ([self.superview respondsToSelector:@selector(drawCentenIconInRect:state:)]) {
            [(id)self.superview drawCentenIconInRect:rect state:self.state];
        }
    }
    else if (self.type == JXRoundMenuButtonIconTypeCustomImage){
        
        if (self.centerIcon) {
            [self.centerIconView setImage:self.centerIcon];
            self.centerIconView.alpha = 1;
        }
        
    }
}



@end

///****************************************
@implementation JXRoundMenuButton_roundCircle

- (void)animatedLoadIcons:(NSArray<UIImage*>*)icons start:(float)start layoutDegree:(float)layoutDegree oneByOne:(BOOL)onebyone{

     [self clean];
    
    CGFloat raduis = self.frame.size.width / 2 - self.raduisForIcons;
    
    [icons enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [button setImage:obj forState:UIControlStateNormal];
        button.tintColor = self.tintColor;
        [self addSubview:button];
        
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        button.alpha = 0;
        button.tag = idx + RoundMenuButtonTag;
        button.transform = CGAffineTransformMakeScale(0.5, 0.5);
        button.center = self.center;
        
        [UIView animateWithDuration:0.2
                              delay:onebyone?idx*0.02:0
             usingSpringWithDamping:0.5
              initialSpringVelocity:5
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             button.alpha = 1;
                             button.transform = CGAffineTransformIdentity;
                             button.center = CGPointMake(self.center.x + raduis * sin(start + layoutDegree/(icons.count-1)*idx), self.center.y + raduis * cos(start + layoutDegree/(icons.count-1)*idx));
                         } completion:^(BOOL finished) {
                             
                         }];
        
        
    }];
    
    
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    //// Color Declarations
    UIColor *color = self.circleColor;
    
    //// Oval Drawing
    UIBezierPath *ovalPath = [UIBezierPath bezierPathWithOvalInRect: rect];
    [color setFill];
    [ovalPath fill];
}



- (void)clean
{
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
}

- (void)buttonClick:(id)sender
{
    if ([self.superview respondsToSelector:@selector(buttonClick:)]) {
        [(id)self.superview buttonClick:sender];
    }
}

@end
