//
//  ViewController.m
//  MyDefinedImgDownloadOperation
//
//  Created by hebing on 16/8/24.
//  Copyright © 2016年 hebing. All rights reserved.
//

#import "ViewController.h"
#import "AppModle.h"
#import "UIImageView+DownLoadImg.h"
//导入一个框架就可以
#import "UIImage+GIF.h"
//#import "UIImage+WebP.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property(nonatomic,strong)NSMutableArray* dataAry;

@end

@implementation ViewController
-(NSMutableArray*)dataAry{
    if (_dataAry==nil) {
        
        
        _dataAry=[AppModle urlWithPlistFileName:@"apps.plist"];
        
        
    }
    return _dataAry;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    AppModle* modle=self.dataAry[(unsigned long)arc4random_uniform(self.dataAry.count)];
    [self.imgView downLoadImgWithUrl:modle.icon];
    NSLog(@"%@",NSHomeDirectory());
    //可以读取图片,但是没有动画.
//    self.imgView.image=[UIImage imageNamed:@"sb.gif"];
    //依然没有动画效果,有待研究?
//    self.imgView.image =[UIImage sd_animatedGIFNamed:@"sb.gif"];
    
//    //下面这句话有效果,上面这句话没效果,估计是内存释放
//    UIImage *gifImage = [UIImage sd_animatedGIFNamed:@"sb"];
//    self.imgView.image = gifImage;


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    
    
    
}

@end
