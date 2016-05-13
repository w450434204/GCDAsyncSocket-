//
//  ViewController.m
//  GCDAsyncSocket聊天室客户端
//
//  Created by bwu on 16/5/13.
//  Copyright © 2016年 wubiao. All rights reserved.
//

#import "ViewController.h"
#import "GCDAsyncSocket.h"

@interface ViewController ()<GCDAsyncSocketDelegate,UITableViewDataSource>
- (IBAction)sendIMessage:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) GCDAsyncSocket *clientSocket;
@property(nonatomic,strong) NSMutableArray *dataSource;

@end


@implementation ViewController

-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    
    return  _dataSource;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //连接到群聊天室SCUT
    GCDAsyncSocket *clientSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(0, 0)];
    
    self.clientSocket = clientSocket;
    
    NSError *error = nil;
    [self.clientSocket connectToHost:@"10.0.173.32" onPort:50001 error:&error];
    
    if (!error) {
        NSLog(@"链接成功。。。。");
    } else
    {
        NSLog(@"链接失败。。。");
    }
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return [self.dataSource count];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId= @"cell";
    UITableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!tableViewCell) {
         tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier: cellId] ;
    }
    
    tableViewCell.textLabel.text = self.dataSource[indexPath.row];
    
    return tableViewCell;
}

#pragma mark - 判断与服务器是否正确链接
-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    //监听读取数据
    [sock readDataWithTimeout:-1 tag:0];
    NSLog(@"与服务器链接成功");
}


-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    NSLog(@"与服务器断开链接,%@",err);
}


//接受其他客户端发送的数据
-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    if (str) {
        
        [self.dataSource addObject:str];
        
        //在主线程中刷新界面
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.tableView reloadData];
        }];
    }
    
    //监听读取数据
    [sock readDataWithTimeout:-1 tag:0];
}


- (IBAction)sendIMessage:(id)sender {
    //发送数据给服务器,让其转发给其他客户端
    NSString *text = self.textField.text;
    if (text.length == 0) {
        return;
    }
    [self.clientSocket writeData:[text dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0 ];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
