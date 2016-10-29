//
//  ZDYImgManager.h
//  MyDefinedOperation
//
//  Created by hebing on 16/8/24.
//  Copyright © 2016年 hebing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIkit/UIKit.h"
@interface ZDYImgManager : NSObject

//管理类,用于向整个app提供下载和取消下载的入口.单例
//并且管理图片的缓存,内存&沙盒
+(instancetype)sharedManager;

-(void)downLoadImgWithUrl:(NSString*)url andfinishBlock:(void(^)(UIImage*))finishImgBlock;

-(void)callDownLoad:(NSString*)url;
                                                         
@end
