//
//  ZDYImgDownLoadOpration.m
//  MyDefinedOperation
//
//  Created by hebing on 16/8/24.
//  Copyright © 2016年 hebing. All rights reserved.
//

#import "ZDYImgDownLoadOpration.h"
#import "NSString+Path.h"

@implementation ZDYImgDownLoadOpration

-(void)start{
    
    [super start];
}
//自定义opration代替原有的NSBlockOpration
//相当于模仿系统的此对象写法,代替系统的写法
-(void)main{
    
    

        
        NSURL* url=[NSURL URLWithString:self.urlString];
        
        NSData* data=[NSData dataWithContentsOfURL:url];
        
        //写入沙盒
        [data writeToFile:[self.urlString appendCachePath] atomically:YES];
    if([self isCancelled]){
        //拦截的代码
        NSLog(@"canceled %@",self.urlString);
        return;
    }
    

    
        UIImage* img=[UIImage imageWithData:data];
                NSAssert(_finishImgBlock!=nil,@"finishblock不能为空");
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            
//            调用传值
            _finishImgBlock(img);
         
            
            
            //删除图片下载的操作
//            [self.operationCache removeObjectForKey:modle.icon];
            
            //下载写入缓存
//            [self.cacheIMGs setObject:img forKey:modle.icon];
            
            
            
            //光靠下载,赋值是可以的,解决多次下载后图片跳的问题
            //             cell.imageView.image=img;
            //
            //刚开始赋值数据后刷新,写上下面这句话,结果出现数据,但是图片数据不匹配,而且一直跳
            
            //图片下载成功后自动刷新,不需要赋值操作
            //刷新当前的cell->取已经下载完的图片
            //刷新后入股图片下载好写入到内存缓存,再次走此流程从内存缓存中读取数据,所以不用赋值操作
//            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            
        }];
        
        
        
        
    

    
}


//创建对象
//类方法要在里面创建对象

+(instancetype)oprationWithUrlString:(NSString*)string andBlock:(void(^)(UIImage*))finishImgBlock
{
    
    ZDYImgDownLoadOpration* opration=[[ZDYImgDownLoadOpration alloc]init];
    
    opration.urlString=string;
    
    opration.finishImgBlock=finishImgBlock;
    
    return opration;
        

    
    
    
}

@end
