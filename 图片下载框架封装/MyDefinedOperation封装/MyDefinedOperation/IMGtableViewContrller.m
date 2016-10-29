//
//  IMGtableViewContrller.m
//  MyDefinedOperation
//
//  Created by hebing on 16/8/24.
//  Copyright © 2016年 hebing. All rights reserved.
//

#import "IMGtableViewContrller.h"

/*
 1.准备数据
 2.搭建UI
 3.异步下载->问题:点击界面,或者拖动 图片才出来
 原因:在cellForRowAtIndexPath返回的时候没有图片,不会对imageview进行布局 frame 0 0 0 0,过了一点时间图片下载完成,点击界面-layoutsubviews,用于布局子控件,原生的cell imageview是懒加载的 没有图片不进行布局
 解决:占位图片->先把imageview的位置确定下来
 4.自定义cell
 5.来回滑动->图片"跳"
 解释:由于来回去滑动,cell的复用造成一个cell的身上有多个异步下载的任务在执行,当所有的异步任务都执行完,有可能同一时间都去更新统一个imageview,刷新图片平很频繁,"造成跳的现象"
 6.图片缓存
 7.问题:网很慢,来回滚动,一个图片开启了多个下载的操作
 如何判断一个图片已经开启了对应的操作????
 操作缓存
 省流量
 */
#import "ImgUrlModle.h"
#import "NSString+Path.h"
#import "ZDYImgDownLoadOpration.h"
#import "ZDYImgManager.h"
#import "UIImageView+DownLoadImg.h"

@interface IMGtableViewContrller ()

//这个位置的代码块设置方法,为什么打不出来?
@property(nonatomic,strong)NSMutableArray* dataAry;

@property(nonatomic,strong) NSOperationQueue *queue;

//图片缓存
@property(nonatomic,strong) NSMutableDictionary *cacheIMGs;

//操作缓存
@property(nonatomic,strong) NSMutableDictionary *operationCache;

@end
static NSString* useId=@"cell";
@implementation IMGtableViewContrller


-(NSMutableArray*)dataAry{
    if (_dataAry==nil) {
        _dataAry=[ImgUrlModle urlWithPlistFileName:@"apps.plist"];
        
    }
    return _dataAry;
}
-(NSMutableDictionary *)operationCache{
    if(!_operationCache){
        _operationCache = [NSMutableDictionary dictionary];
    }
    return _operationCache;
}
-(NSMutableDictionary *)cacheIMGs{
    if(!_cacheIMGs){
        _cacheIMGs = [NSMutableDictionary dictionary];
    }
    return _cacheIMGs;
}

-(NSOperationQueue *)queue{
    if(!_queue){
        _queue = [[NSOperationQueue alloc] init];
    }
    return _queue;
}


-(void)viewDidLoad{
//    NSLog(@"%@",self.dataAry);
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:useId];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataAry.count;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:useId forIndexPath:indexPath];
    
    ImgUrlModle* modle=self.dataAry[indexPath.row];
    cell.textLabel.text=modle.name;
    //占位图片,有了这个能自动下载图片,有他frame;
    cell.imageView.image=[UIImage imageNamed:@"user_default"];
//    cell.detailTextLabel.text=modle.name;
    
//    
//    //判断顺序,先缓存中下载,再沙盒下载,再判断操作缓存有无正在下载,否则不需要下载(缓存下载速度比沙盒快)
//    
//    //从缓存中读取数据
//    UIImage* img=self.cacheIMGs[modle.icon];
//    if (img) {
//        cell.imageView.image=img;
//        return cell;
//    }else{
//        UIImage* bocImg=[UIImage imageWithContentsOfFile:[modle.icon appendCachePath]];
//        if (bocImg) {
//            
//            
//            cell.imageView.image=bocImg;
//            //沙盒有图片写入缓存
//            //3.优化 sandBoxIMG放到内存缓存中,由于沙盒的速度比内存慢很多,所以要尽量减少从沙盒读取的次数
//            [self.cacheIMGs setObject:bocImg forKey:modle.icon];
//            return cell;
//        }
//        
//    }
//    if(self.operationCache[modle.icon]){
//          NSLog(@"正在下载,请稍后 %@",modle.name);
//        return cell;
//    }
    
    
//    -------------------下载图片
    //开启子线程下载,防止影响界面卡顿
  
    
//    原因:在cellForRowAtIndexPath返回的时候没有图片,不会对imageview进行布局 frame 0 0 0 0,过了一点时间图片下载完成,点击界面-layoutsubviews,用于布局子控件,原生的cell imageview是懒加载的 没有图片不进行布局
//    解决:占位图片->先把imageview的位置确定下来
//   NSOperationQueue* queue= [[NSOperationQueue alloc]init];
    
//       NSBlockOperation* downLoadopration= [NSBlockOperation blockOperationWithBlock:^{
//        
//        NSURL* url=[NSURL URLWithString:modle.icon];
//        
//        NSData* data=[NSData dataWithContentsOfURL:url];
//           
//           //写入沙盒
//           [data writeToFile:[modle.icon appendCachePath] atomically:YES];
//        
//        UIImage* img=[UIImage imageWithData:data];
//        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
//            
//              //删除图片下载的操作
//            [self.operationCache removeObjectForKey:modle.icon];
//            
//            //下载写入缓存
//            [self.cacheIMGs setObject:img forKey:modle.icon];
//            
//           
//     
//            //光靠下载,赋值是可以的,解决多次下载后图片跳的问题
////             cell.imageView.image=img;
//            //
//            //刚开始赋值数据后刷新,写上下面这句话,结果出现数据,但是图片数据不匹配,而且一直跳
//            
//            //图片下载成功后自动刷新,不需要赋值操作
//            //刷新当前的cell->取已经下载完的图片
//            //刷新后入股图片下载好写入到内存缓存,再次走此流程从内存缓存中读取数据,所以不用赋值操作
//            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//            
//        }];
    
        
        
        
//    }];
    
//    //封装自定义opration写法
//    ZDYImgDownLoadOpration* downLoadopration=[ZDYImgDownLoadOpration oprationWithUrlString:modle.icon andBlock:^(UIImage *img) {
//        cell.imageView.image=img;
//    }];
//    ////把操作加入操作缓存中
////    [self.operationCache setObject:downLoadopration forKey:modle.icon];
//    [self.queue addOperation:downLoadopration];

    //manager封装后写法
//    //这样在下载的时候每下载一次都会赋值,还需要进行判断,结局图片跳的问题
//    [[ZDYImgManager sharedManager] downLoadImgWithUrl:modle.icon andfinishBlock:^(UIImage *img) {
//        cell.imageView.image=img;
//        
//    }];
    //最后封装
    NSLog(@"%@",NSHomeDirectory());
    [cell.imageView  downLoadImgWithUrl:modle.icon];
    
    return cell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
//-(void)didReceiveMemoryWarning{
//    //系统警告内存不够,第二次调用闪退
//    //清理一切可以被清理的资源
//    
//    [self.cacheIMGs removeAllObjects];
//    [self.operationCache removeAllObjects];
//    
//    [super didReceiveMemoryWarning];
//}


@end
