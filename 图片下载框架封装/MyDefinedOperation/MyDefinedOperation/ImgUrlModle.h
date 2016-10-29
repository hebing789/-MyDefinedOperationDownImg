//
//  ImgUrlModle.h
//  MyDefinedOperation
//
//  Created by hebing on 16/8/24.
//  Copyright © 2016年 hebing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImgUrlModle : NSObject

@property(nonatomic,copy) NSString*name,*icon,*download;

/**
 *  对象初始化方法,对象方法
 *
 *  @param dict 传入字典数据
 *
 *  @return 返回当前类的对象
 */
- (instancetype)initWithDict:(NSDictionary *)dict;

/**
 *  对象初始化方法,类方法
 *
 *  @param dict 传入字典数据
 *
 *  @return 返回当前类
 */
+(instancetype) urlWithDict:(NSDictionary *)dict;


/**
 *  根据plist文件返回一个模型数组
 *
 *  @param fileName 传入plist文件的名字
 *
 *  @return 模型数组
 */
+ (NSMutableArray *)urlWithPlistFileName:(NSString *)fileName;


//- (void)setValue:(id)value forUndefinedKey:(NSString *)key;

@end
