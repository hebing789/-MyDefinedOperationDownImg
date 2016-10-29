//
//  ZDYImgManager.m
//  MyDefinedOperation
//
//  Created by hebing on 16/8/24.
//  Copyright © 2016年 hebing. All rights reserved.
//

#import "ZDYImgManager.h"
#import "NSString+Path.h"
#import "ZDYImgDownLoadOpration.h"

//管理类,用于向整个app提供下载和取消下载的入口.单例
//并且管理图片的缓存,内存&沙盒

@interface ZDYImgManager()
@property(nonatomic,strong) NSOperationQueue *queue;

//图片缓存
@property(nonatomic,strong) NSMutableDictionary *cacheIMGs;

//操作缓存
@property(nonatomic,strong) NSMutableDictionary *operationCache;

@end
@implementation ZDYImgManager


-(NSOperationQueue *)queue{
    
    if (!_queue) {
        _queue=[[NSOperationQueue alloc]init];
    }
    return _queue;
}

+(instancetype)sharedManager{
    
    static  id instance;//不能加__block
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance=[[self alloc]init];
    });
    return instance;
    
    
    
}
-(NSMutableDictionary *)operationCache{
    
    if (!_operationCache) {
        _operationCache=[[NSMutableDictionary alloc]init];
    }
    return _operationCache;
}

-(NSMutableDictionary *)cacheIMGs{
    if(!_cacheIMGs){
        _cacheIMGs = [NSMutableDictionary dictionary];
    }
    return _cacheIMGs;
}


-(void)downLoadImgWithUrl:(NSString*)url andfinishBlock:(void(^)(UIImage*))finishImgBlock{
    
    
    //从缓存中读取数据
    UIImage* img=self.cacheIMGs[url];
    if (img) {
        finishImgBlock(img);
//        NSLog(@"内存缓存%@",url);

        return;
    }else{
        UIImage* bocImg=[UIImage imageWithContentsOfFile:[url appendCachePath]];
        //沙盒拦截
        if (bocImg) {
            
            
           finishImgBlock(bocImg);
//            NSLog(@"沙盒缓存%@",url);

            //沙盒有图片写入缓存
            //3.优化 sandBoxIMG放到内存缓存中,由于沙盒的速度比内存慢很多,所以要尽量减少从沙盒读取的次数
            [self.cacheIMGs setObject:bocImg forKey:url];
            return;
            
        }
        
    }
//    //缓存拦截//感觉写了这个不写最后一个类,也能拦截多次下载,想知道,图片跳的具体现象
//    if(self.operationCache[url]){//操作是否一样,解决图片多次下载跳的问题
//         NSLog(@"操作缓存%@",url);
//        return;
//        
//        
//    }
    
    //下载图片
    
    ZDYImgDownLoadOpration* op=[ZDYImgDownLoadOpration oprationWithUrlString:url andBlock:^(UIImage *img) {
        
        finishImgBlock(img);
        
        //下载成功后移除操作
        [self.operationCache removeObjectForKey:url];
        //下载成功后写入缓存
        [self.cacheIMGs setObject:img forKey:url];
        //
//        NSLog(@"下载图片");
        
        
    }];
    
    //加入队列
    [self.queue addOperation:op];
    
    //下载完成记录操作缓存
    [self.operationCache setObject:op forKey:url];


    
}

-(void)callDownLoad:(NSString*)url{
    
    //取出之前的opration
    ZDYImgDownLoadOpration* lastOp=self.operationCache[url];
    //2取消之前的操作,调用cancel方法不能停止操作的运行,需要判断cancel变量来退出执行(多线程的套路)
    //在opration里写
//    NSLog(@"cancle");
    [lastOp cancel];
    
    
    
    
}

                                                         

@end
