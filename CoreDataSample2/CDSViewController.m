
#import "CDSViewController.h"

#import <CoreData/CoreData.h>
#import "CDSAppDelegate.h"
#import "Entity.h"

@interface CDSViewController ()

@end

@implementation CDSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];

    // contextの取得
    CDSAppDelegate *delegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = delegate.managedObjectContext;
    
    // Entityの生成
    
    // ※ こちらのコメントアウトのほうを利用すると実際に保存される
    // Entity *entity = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(Entity.class)
    //                                                inManagedObjectContext:context];
    
    // 使い捨て用。挿入先contextにnilを指定している
    NSEntityDescription *description = [NSEntityDescription entityForName:NSStringFromClass(Entity.class)
                                                   inManagedObjectContext:context];
    Entity *entity = [[Entity alloc] initWithEntity:description
                     insertIntoManagedObjectContext:nil];
    
    // Entityに情報を設定
    entity.name = @"名前";
    entity.age  = @16;
    
    // 保存を試みる
    // ※ 上記の部分で、挿入先に正規のcontextを指定すると、保存時にしっかりとDBに値が保存される。
    [delegate saveContext];
}

@end
