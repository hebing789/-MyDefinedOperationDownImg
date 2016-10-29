//
//  UIImageView+DownLoadImg.h
//  MyDefinedOperation
//
//  Created by hebing on 16/8/24.
//  Copyright © 2016年 hebing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (DownLoadImg)
@property(nonatomic,copy)NSString* url;

//对象方法
-(void)downLoadImgWithUrl:(NSString*)url;
//类方法
//+(instancetype)downLoadImgWithUrl:(NSString*)url;
@end
