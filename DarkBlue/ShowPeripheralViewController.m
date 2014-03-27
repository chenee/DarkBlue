//
//  ShowPeripheralViewController.m
//  DarkBlue
//
//  Created by chenee on 14-3-26.
//  Copyright (c) 2014年 chenee. All rights reserved.
//

#import "ShowPeripheralViewController.h"
#import "BTServer.h"
#import "ProgressHUD.h"

@interface ShowPeripheralViewController ()<UITableViewDataSource,UITableViewDelegate,BTServerDelegate>
@property(strong,nonatomic)BTServer *defaultBTServer;
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@end

@implementation ShowPeripheralViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.defaultBTServer = [BTServer defaultBTServer];
    self.defaultBTServer.delegate = (id)self;
    self.lbName.text = self.defaultBTServer.selectPeripheral.name;
}
-(void)viewDidAppear:(BOOL)animated{
    self.defaultBTServer.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)didDisconnect
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [ProgressHUD showSuccess:@"disconnect from peripheral"];
        [self.navigationController popToRootViewControllerAnimated:YES];
    });
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)goBack:(id)sender {
    [self.defaultBTServer disConnect];

//    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- table delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.defaultBTServer getServiceState] == KING) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [tableView reloadData];
        });
        return 0;
    }else if([self.defaultBTServer getServiceState] == KFAILED){
        return 0;
    }
    
    int n = [self.defaultBTServer.selectPeripheral.services count];
    return n;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    NSLog(@"click at :%d",indexPath.row);
    CBService* ser = self.defaultBTServer.selectPeripheral.services[indexPath.row];
    [self.defaultBTServer discoverService:ser];
    
    [self performSegueWithIdentifier:@"getCharacteristic" sender:self];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"ServiceCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    }
    
    CBService* ser = self.defaultBTServer.selectPeripheral.services[indexPath.row];
    cell.textLabel.text = [ser.UUID UUIDString];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"UUID:%@",[ser.UUID UUIDString]];
    
    return cell;
}

@end
