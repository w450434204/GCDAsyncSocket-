//
//  main.m
//  GCDAsyncSocket聊天室服务端
//
//  Created by bwu on 16/5/13.
//  Copyright © 2016年 wubiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBServerListener.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        WBServerListener *wbServerListener = [[WBServerListener alloc] init];
        [wbServerListener startListener];
        
        //[[NSRunLoop mainRunLoop] run]; //保持主函数一直在允许循环
        [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] run];
        
    }
    return 0;
}
