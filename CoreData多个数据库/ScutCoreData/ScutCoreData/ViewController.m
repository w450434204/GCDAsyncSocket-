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
#import <CoreData/CoreData.h>
#import "Status.h"

/*
    1.创建模型文件 ［相当于一个数据库里的表］
    2.添加实体 ［一张表］
    3.创建实体类 [相当模型]
    4.生成上下文 关联模型文件生成数据库
    5、关联的时候，如果本地没有数据库文件，Ｃoreadata自己会创建
 */
@interface ViewController ()
@property(nonatomic,strong) NSManagedObjectContext *context;
@property(nonatomic,strong) NSManagedObjectContext *studentContext;
@property(nonatomic,strong) NSManagedObjectContext *weiboContext;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    // 一个数据库对应一个上下文
    _studentContext = [self setupContextWithModelName:@"Student"];
    _weiboContext = [self setupContextWithModelName:@"Weibo"];
}



-(NSManagedObjectContext *)setupContextWithModelName:(NSString *)modelName
{
    // .xcdatamodeld文件相当于数据库文件,里面的实体(Entity)即是"表",一个数据库中可以有多张表格
    
    //1、创建上下文对象,对数据库的所有操作都是通过对应的上下文进行操作的
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    
    //2、实例化模型文件(数据库文件)
    //2.1mergedModelFromBundles这个方法传入nil时,会搜索工程项目中所有的.xcdatamodeld文件,并将这些文件中的所有表格放在一个数据库。当有多个数据库时使用这个方法会造成数据的混乱
//    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
 
    NSLog(@"%@",[[NSBundle mainBundle] bundlePath]);
    //2.2当工程项目中有多个数据库时 要使用这个方法来实例化模型文件。这样可以将不同的数据库分开,而且不同的数据库对应不同的上下文
    NSURL *companyURL = [[NSBundle mainBundle] URLForResource:modelName withExtension:@"momd"];
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:companyURL];
    
    
    //3、创建持久化存储协调器,这个类主要是关联我的数据库文件(模型文件\底层文件)
    NSPersistentStoreCoordinator *store = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    
    //4、通过NSPersistentStoreCoordinator告诉Coredata数据库的名字和路径,并将它关联上下文
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString *sqliteName = [NSString stringWithFormat:@"%@.sqlite",modelName];
    NSString *sqlitePath = [doc stringByAppendingPathComponent:sqliteName];
    NSLog(@"%@",sqlitePath);
    
    NSError *error = nil;
    [store addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:sqlitePath] options:nil error:&error];
    
    context.persistentStoreCoordinator = store; //上下文就是通过持久化存储协调器来修改底层文件保存的数据
    return context;
}


// 数据库的操作 CURD Create Update  Read Delete
#pragma mark 添加学生
-(IBAction)addStudent{

 //通过NSEntityDescription向实体(表)中插入数据,这个方法返回__kindof NSManagedObject *实体类(模型Model)
    Student *student = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:_studentContext];
    //设置实体类的相关属性
    student.name =@"xiaoming";
    student.height = @1.80;
    student.brithday = [NSDate date];
    
    // 直接保存数据库
    NSError *error = nil;
    [_studentContext save:&error];
    
    if (error) {
        NSLog(@"%@",error);
    }
 
    // 发微博
    Status *status =[NSEntityDescription insertNewObjectForEntityForName:@"Status" inManagedObjectContext:_weiboContext];
    status.text = @"毕业，挺激动";
    [_weiboContext save:nil];

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


}

#pragma mark 删除学生
-(IBAction)deleteStudent{

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
