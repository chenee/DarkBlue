//
//  CentralScanViewController.m
//  DarkBlue
//
//  Created by chenee on 14-3-26.
//  Copyright (c) 2014年 chenee. All rights reserved.
//

#import "CentralScanViewController.h"
#import "myTableViewCell.h"
#import "BTServer.h"
#import "PeriperalInfo.h"
#import "ProgressHUD.h"
#import "ShowPeripheralViewController.h"

@interface CentralScanViewController ()<UITableViewDataSource,UITableViewDelegate,BTServerDelegate>
@property (strong,nonatomic)BTServer *defaultBTServer;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UITextField *txtInfo;

@end

@implementation CentralScanViewController

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
    [self.defaultBTServer startScan];
    [ProgressHUD dismiss];
    
    self.txtInfo.text = @"scanning ...";

}
#pragma mark -- btserver delegate
-(void)didStopScan
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.txtInfo.text = @"scan stoped";
    });
}
-(void)didFoundPeripheral
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.myTableView reloadData];
    });
}
-(void)didDisconnect
{
    [ProgressHUD show:@"disconnect from peripheral"];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark -- table delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int n = [self.defaultBTServer.discoveredPeripherals count];
    return n;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    
    [self.defaultBTServer stopScan:YES];

    [ProgressHUD show:@"connecting ..."];
    
    [self.defaultBTServer connect:self.defaultBTServer.discoveredPeripherals[indexPath.row] withFinishCB:^(CBPeripheral *peripheral, BOOL status, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
//            [ProgressHUD dismiss];

            if (status) {
                [ProgressHUD showSuccess:@"connected success!"];
                [self performSegueWithIdentifier:@"getService" sender:self];
            }else{
                [ProgressHUD showError:@"connected failed!"];
            }
        });


    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"PeripheralCell";
    myTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[myTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    }
    
    PeriperalInfo *pi = self.defaultBTServer.discoveredPeripherals[indexPath.row];
    
    cell.topName.text = pi.name;
    cell.uuid.text = pi.uuid;
    cell.name.text = pi.localName;
    cell.service.text = pi.serviceUUIDS;
    cell.RSSI.text = [pi.RSSI stringValue];
    cell.RSSI.textColor = [UIColor blackColor];
    int rssi = [pi.RSSI intValue];
    if(rssi>-60){
        cell.RSSI.textColor = [UIColor redColor];
    }else if(rssi > -70){
        cell.RSSI.textColor = [UIColor orangeColor];
    }else if(rssi > -80){
        cell.RSSI.textColor = [UIColor blueColor];
    }else if(rssi > -90){
        cell.RSSI.textColor = [UIColor blackColor];
    }
    
    return cell;
}
-(void)KeyboardDisappear:(BOOL)isUP
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    CGRect rect;
    if(isUP){
        rect = CGRectMake(0.0f, -216,width,height);
    }else{
        rect = CGRectMake(0.0f, 0,width,height);
        
    }
    self.view.frame = rect;
    [UIView commitAnimations];
}

- (IBAction)reFresh:(id)sender {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];

    [self.defaultBTServer stopScan:TRUE];
    
    self.txtInfo.text = @"scanning ...";
    self.defaultBTServer.delegate = (id)self;
    [self.defaultBTServer startScan];
    [self.myTableView reloadData];

}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

@end
