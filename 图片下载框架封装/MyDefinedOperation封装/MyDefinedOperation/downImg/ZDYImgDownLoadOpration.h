//
//  ZDYImgDownLoadOpration.h
//  MyDefinedOperation
//
//  Created by hebing on 16/8/24.
//  Copyright © 2016年 hebing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"
@interface ZDYImgDownLoadOpration : NSOperation
@property(nonatomic,copy) NSString* urlString;
@property(nonatomic,copy) void(^finishImgBlock)(UIImage*) ;
//创建对象,实现下载任务
+(instancetype)oprationWithUrlString:(NSString*)string andBlock:(void(^)(UIImage*))finishImgBlock;
@end
