//
//  WDDrawView.m
//  WDDrawingBoardDemo
//
//  Created by WD on 16/9/21.
//  Copyright © 2016年 WD. All rights reserved.
//

#import "WDDrawView.h"
#import "WDDrawPath.h"

@interface WDDrawView ()
@property (nonatomic, strong) WDDrawPath *path;
@property (nonatomic, strong) NSMutableArray *paths;

@end

@implementation WDDrawView

- (void)awakeFromNib
{
    [self setUp];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}
// 初始化设置
- (void)setUp
{
    // 添加pan手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    
    [self addGestureRecognizer:pan];
    
    _lineWidth = 1;
    _pathColor = [UIColor blackColor];
}


// 当手指拖动的时候调用
- (void)pan:(UIPanGestureRecognizer *)pan
{
    
    // 获取当前手指触摸点
    CGPoint curP = [pan locationInView:self];
    
    // 获取开始点
    if (pan.state == UIGestureRecognizerStateBegan) {
        // 创建贝瑟尔路径
        _path = [[WDDrawPath alloc] init];
        
        // 设置线宽
        _path.lineWidth = _lineWidth;
        
        // 给路径设置颜色
        _path.pathColor = _pathColor;
        
        // 设置路径的起点
        [_path moveToPoint:curP];
        
        // 保存描述好的路径
        [self.paths addObject:_path];
        
    }
    
    // 手指一直在拖动
    // 添加线到当前触摸点
    [_path addLineToPoint:curP];
    
    // 重绘
    [self setNeedsDisplay];
    
}


- (void)setImage:(UIImage *)image
{
    _image = image;
    
    [self.paths addObject:_image];
    
    // 重绘
    [self setNeedsDisplay];
}
- (void)clear
{
    [self.paths removeAllObjects];
    
    [self setNeedsDisplay];
}

- (void)undo
{
    [self.paths removeLastObject];
    
    [self setNeedsDisplay];
}

- (NSMutableArray *)paths
{
    if (_paths == nil) {
        _paths = [NSMutableArray array];
    }
    return _paths;
}

// 绘制图形
// 只要调用drawRect方法就会把之前的内容全部清空
- (void)drawRect:(CGRect)rect
{
    for (WDDrawPath *path in self.paths) {
        
        if ([path isKindOfClass:[UIImage class]]) {
            // 绘制图片
            UIImage *image = (UIImage *)path;
            
            [image drawInRect:rect];
        }else{
            
            // 画线
            [path.pathColor set];
            
            [path stroke];
        }
        
    }
}

@end
