//
//  UIImageView+DownLoadImg.m
//  MyDefinedOperation
//
//  Created by hebing on 16/8/24.
//  Copyright © 2016年 hebing. All rights reserved.
//

#import "UIImageView+DownLoadImg.h"
#import "ZDYImgManager.h"
#import "objc/runtime.h"

@implementation UIImageView (DownLoadImg)
//const void * key="url";
static char* key ="url";
-(void)setUrl:(NSString *)url{
    
//    _url=
    objc_setAssociatedObject(self, key, url,  OBJC_ASSOCIATION_COPY_NONATOMIC);
}
-(NSString *)url{
    return objc_getAssociatedObject(self, key);
}

//对象方法
-(void)downLoadImgWithUrl:(NSString*)url{
    //写法1
     //记录之前点击的下载地址,与当前的地址比较,如果不一样,一定可以确认之前开启了下载操作
    if (![self.url isEqualToString:url] ) {
        
        //取消之前的操作,不是取消当前的操作//以最后一次为准
        //如果是取消最后一次,这个数据在字典里面有,会出现没图片;
        [[ZDYImgManager sharedManager]callDownLoad:self.url];
    }
        //不要加else判断
    //不管之前是否有这个下载都一定要下载图片
        self.url=url;
        [[ZDYImgManager sharedManager] downLoadImgWithUrl:url andfinishBlock:^(UIImage *img) {
            self.image=img;}];
//法2
    //如果之前有这个下载,取消当前这个下载,以第一次下载为准
//    //这个流程能少赋值和取消流程,比原代码少走很多流程,同时完成功能
//    if ([self.url isEqualToString:url] ) {
//        
//        
//        [[ZDYImgManager sharedManager]callDownLoad:url];
//    }else{
//    //如果是第一次下载,则下载图片
//    self.url=url;
//    [[ZDYImgManager sharedManager] downLoadImgWithUrl:url andfinishBlock:^(UIImage *img) {
//        self.image=img;}];
//    }
//
//    
    
    
 
}
////类方法
////类方法不能访问属性,不行
//+(instancetype)downLoadImgWithUrl:(NSString*)url{
//    //记录之前点击的下载地址,与当前的地址比较,如果不一样,一定可以确认之前开启了下载操作
//    UIImageView* img=[[UIImageView alloc]init];
//    if (![self.url isEqualToString:url] ) {
//        [[ZDYImgManager sharedManager]callDownLoad:url];
//    }else{
//        
//        self->url=url;
//        [[ZDYImgManager sharedManager] downLoadImgWithUrl:url andfinishBlock:^(UIImage *img) {
//            self->image=img;}];
//        
//    }
//  
//}
@end
