//
//  ViewController.m
//  ScutCoreData
//
//  Created by bwu on 16/5/19.
//  Copyright © 2016年 wubiao. All rights reserved.
//

#import "ViewController.h"
#import "Student.h"
#import "Student+CoreDataProperties.h"
#include <CoreData/CoreData.h>

/*
    1.创建模型文件 ［相当于一个数据库里的表］
    2.添加实体 ［一张表］
    3.创建实体类 [相当模型]
    4.生成上下文 关联模型文件生成数据库
    5、关联的时候，如果本地没有数据库文件，Ｃoreadata自己会创建
 */
@interface ViewController ()
@property(nonatomic,strong) NSManagedObjectContext *context;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // .xcdatamodeld文件相当于数据库文件,里面的实体(Entity)即是"表",一个数据库中可以有多张表格
    
    //1、创建上下文对象,对数据库的所有操作都是通过对应的上下文进行操作的
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    
    //2、实例化模型文件(数据库文件)
    //mergedModelFromBundles这个方法传入nil时,会搜索工程项目中所有的.xcdatamodeld文件,并将这些文件中的所有表格放在一个数据库。当有多个数据库时使用这个方法会造成数据的混乱
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    
    //3、创建持久化存储协调器,这个类主要是关联我的数据库文件(模型文件\底层文件)
    NSPersistentStoreCoordinator *store = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    
    //4、通过NSPersistentStoreCoordinator告诉Coredata数据库的名字和路径,并将它关联上下文
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString *sqlitePath = [doc stringByAppendingPathComponent:@"student.sqlite"];
    NSLog(@"%@",sqlitePath);
    
    NSError *error = nil;
    [store addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:sqlitePath] options:nil error:&error];
    
    context.persistentStoreCoordinator = store; //上下文就是通过持久化存储协调器来修改底层文件保存的数据
    self.context = context;
}


// 数据库的操作 CURD Create Update  Read Delete
#pragma mark 添加学生
-(IBAction)addStudent{
    
    
    for (int i =0 ; i < 20; i++) {
        
 //通过NSEntityDescription向实体(表)中插入数据,这个方法返回__kindof NSManagedObject *实体类(模型Model)
        Student *student = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:self.context];
        //设置实体类的相关属性
        student.name =[NSString stringWithFormat:@"xiaoming%d",i];
        student.height = @1.80;
        student.brithday = [NSDate date];
        
        // 直接保存数据库
        NSError *error = nil;
        [_context save:&error];
        
        if (error) {
            NSLog(@"%@",error);
        }
        
    }

    
    
    
 
}

#pragma mark 读取学生信息
-(IBAction)readStudent{
    
    // 1.FectchRequest 抓取请求对象
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Student"];
    
    // 2.设置过滤条件
    // 查找zhangsan
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"name = %@",
                        @"xiaoming1"];
     request.predicate = pre;
    
    // 3.设置排序
    // 身高的升序排序
    NSSortDescriptor *heigtSort = [NSSortDescriptor sortDescriptorWithKey:@"height" ascending:NO];
    request.sortDescriptors = @[heigtSort];
    
    
    // 4.执行请求
    NSError *error = nil;
    
    NSArray *emps = [_context executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"error");
    }
    
    //NSLog(@"%@",emps);
    //遍历员工
    for (Student *emp in emps) {
        NSLog(@"名字 %@ 身高 %@ 生日 %@",emp.name,emp.height,emp.brithday);
    }
    
}

#pragma mark 更新学生信息
-(IBAction)updateStudent{
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Student"];
    
    // 1.2设置过滤条件
    // 查找xiaoming2
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"name = %@",
                        @"xiaoming2"];
    request.predicate = pre;
    
    // 1.3执行请求
    NSArray *emps = [_context executeFetchRequest:request error:nil];
    
    
    // 2.更新身高
    for (Student *e in emps) {
        e.height = @2.0;
    }
    
    // 3.保存
    [_context save:nil];

}

#pragma mark 删除学生
-(IBAction)deleteStudent{
    
    // 1.1FectchRequest 抓取请求对象
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Student"];
    
    // 1.2设置过滤条件
    // 查找xiaoming3
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"name = %@",
                        @"xiaoming3"];
    request.predicate = pre;
    
    // 1.3执行请求
    NSArray *emps = [_context executeFetchRequest:request error:nil];
    
    // 2.删除
    for (Student *e in emps) {
        [_context deleteObject:e];
    }
    
    // 3.保存
    [_context save:nil];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
