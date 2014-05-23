
#import "CDSAppDelegate.h"

#import "CDSViewController.h"
#import <CoreData/CoreData.h>


@implementation CDSAppDelegate

@synthesize managedObjectContext       = _managedObjectContext;
@synthesize managedObjectModel         = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    // 処理が分かりやすいように作ったダミーのビューコントローラ
    CDSViewController *viewController = [[CDSViewController alloc] init];
    
    [self.window addSubview:viewController.view];
    [self.window makeKeyAndVisible];
    
    return YES;
}


/**
 *  NSManagedObjectContextのgetter
 *
 *  @return コンテキスト
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = self.persistentStoreCoordinator;
    if (coordinator) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        _managedObjectContext.persistentStoreCoordinator = coordinator;
    }
    return _managedObjectContext;
}


/**
 *  NSManagedObjectModelのgetter
 *
 *  @return NSManagedObjectModel
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel) {
        return _managedObjectModel;
    }
    
    // CoreDataで作成したデータファイルのパス。拡張子は「momd」
    // ※ `Model`の部分は任意。サンプルでは「Model.xcdatamodeld」なので`Model`。
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model"
                                              withExtension:@"momd"];

    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}


/**
 *  NSPersistentStoreCoordinatorのgetter
 *
 *  @return 永続ストア
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentDirectory] URLByAppendingPathComponent:@"CoreDataSample2.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                   configuration:nil
                                                             URL:storeURL
                                                         options:nil
                                                           error:&error]) {
        // error!
    }
    
    return _persistentStoreCoordinator;
}

/**
 *  Contextの保存
 */
- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    
    if (!managedObjectContext) {
        return;
    }
    
    if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
        // error!
    }
}

/**
 *  アプリのDocumentsディレクトリのパスを返す
 *
 *  @return Documentsディレクトリのパス
 */
- (NSURL *)applicationDocumentDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                   inDomains:NSUserDomainMask] lastObject];
}

@end
