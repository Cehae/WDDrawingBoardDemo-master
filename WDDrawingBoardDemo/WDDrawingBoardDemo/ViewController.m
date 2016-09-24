//
//  ViewController.m
//  WDDrawingBoardDemo
//
//  Created by WD on 16/9/21.
//  Copyright © 2016年 WD. All rights reserved.
//

#import "ViewController.h"
#import "WDDrawView.h"

@interface ViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet WDDrawView *drawView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
#pragma mark - 清除
- (IBAction)clearBtnClick:(id)sender {
    [_drawView clear];
}
#pragma mark - 撤销
- (IBAction)undoBtnClick:(id)sender {
    [_drawView undo];
}
#pragma mark - 橡皮擦
- (IBAction)eraserBtnClick:(id)sender {
    _drawView.pathColor = [UIColor whiteColor];
}

#pragma mark - 选择照片
- (IBAction)photoBtnClick:(id)sender {
    // 弹出系统的相册
    // 选择控制器（系统相册）
    UIImagePickerController *picekerVc = [[UIImagePickerController alloc] init];
    
    // 设置选择控制器的来源
    // UIImagePickerControllerSourceTypePhotoLibrary 相册集
    // UIImagePickerControllerSourceTypeSavedPhotosAlbum:照片库
    picekerVc.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    // 设置代理
    picekerVc.delegate = self;
    
    // modal
    [self presentViewController:picekerVc animated:YES completion:nil];
}
#pragma mark - 保存
- (IBAction)saveBtnClick:(id)sender {
    // 截屏
    // 开启上下文
    UIGraphicsBeginImageContextWithOptions(_drawView.bounds.size, NO, 0);
    
    // 获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 渲染图层
    [_drawView.layer renderInContext:ctx];
    
    // 获取上下文中的图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭上下文
    UIGraphicsEndImageContext();
    
    
    // 保存画板的内容放入相册
    // image:写入的图片
    // completionTarget图片保存监听者
    // 注意：以后写入相册方法中，想要监听图片有没有保存完成，保存完成的方法不能随意乱写
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
}
// 监听保存完成，必须实现这个方法
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSLog(@"保存图片成功");
}


#pragma mark - UIImagePickerControllerDelegate
// 当用户选择一张图片的时候调用
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // 获取选中的照片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    // 把选中的照片画到画板上
    
    _drawView.image = image;
    
    // dismiss
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (IBAction)redBtnClick:(UIButton *)sender {
    // 给画板传递颜色
    _drawView.pathColor = sender.backgroundColor;
}
- (IBAction)greenBtnClick:(UIButton *)sender {
    // 给画板传递颜色
    _drawView.pathColor = sender.backgroundColor;
}
- (IBAction)yellowBtnClick:(UIButton *)sender {
    // 给画板传递颜色
    _drawView.pathColor = sender.backgroundColor;
}

- (IBAction)Slider:(UISlider *)sender {
    // 给画板传递线宽
    _drawView.lineWidth = sender.value;

}


@end
