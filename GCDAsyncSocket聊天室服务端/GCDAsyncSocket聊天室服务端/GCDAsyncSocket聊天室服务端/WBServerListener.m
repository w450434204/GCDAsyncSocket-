//
//  WBServerListener.m
//  GCDAsyncSocket聊天室服务端
//
//  Created by bwu on 16/5/13.
//  Copyright © 2016年 wubiao. All rights reserved.
//

#import "WBServerListener.h"
#import "GCDAsyncSocket.h"

@interface WBServerListener()

@property(nonatomic,strong) GCDAsyncSocket *serverSocket;
@property(nonatomic,strong) NSMutableArray *clientSocketArray;
@end

@implementation WBServerListener

-(NSMutableArray *)clientSocketArray
{
    if (!_clientSocketArray) {
        _clientSocketArray = [NSMutableArray array];
    }
    
    return _clientSocketArray;
}

//开启服务端监听
-(void) startListener
{
    GCDAsyncSocket *serverSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(0, 0)];
    
    NSError *error = nil;
    //注意真机调试的时,所链接的网络要是局域网
    [serverSocket acceptOnPort:50001 error:&error];
    if (!error) {
        NSLog(@"服务端已经开启");
    } else {
        NSLog(@"服务端开启失败");
    }
    
    self.serverSocket = serverSocket;   //需要对服务端Socket进行强引用,否则创建完就销毁了
}



#pragma mark -  有客户端链接
//sock为服务端socket,newSocket为客户端socket
-(void)socket:(GCDAsyncSocket *)serverceSocket didAcceptNewSocket:(GCDAsyncSocket *)clientSocket
{
    NSLog(@"有客服端连接服务器%@----%@",serverceSocket,clientSocket);
    [self.clientSocketArray addObject:clientSocket];    //需要将客户端的socket保存到数组,这样才能保证newSocket持续存在
    
    //当客户端一连接成功就发送数据给它
    NSMutableString *serverceStr = [NSMutableString string];
    [serverceStr appendString:@"欢迎来到SCUT聊天室,这里都是精英"];
 
    //    向调用方法的socket写入数据即是这里是向客户端socket发送数据
    [clientSocket writeData:[serverceStr dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
    
    
    //监听客户端发送数据
    [clientSocket readDataWithTimeout:-1 tag:0];
    NSLog(@"当前有%ld客户端链接到服务器",self.clientSocketArray.count);
    
}

#pragma mark - 读取客户端请求的数据
//当一个socket已经把数据读入内存中时被调用。如果发生错误则不被调用
-(void)socket:(GCDAsyncSocket *)clientSocket didReadData:(NSData *)data withTag:(long)tag
{
 
    NSString *clientString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    for (GCDAsyncSocket *socket in self.clientSocketArray) {
        if (socket != clientSocket && clientString) {  //不给自己发送消息
            [socket writeData:[clientString dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
        }
    }
    
#warning mark - 每次读完数据后都要调用一次监听数据的方法
    [clientSocket readDataWithTimeout:-1 tag:0];
}

@end
