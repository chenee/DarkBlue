//
//  ShowServiceViewController.m
//  DarkBlue
//
//  Created by chenee on 14-3-27.
//  Copyright (c) 2014年 chenee. All rights reserved.
//

#import "ShowServiceViewController.h"
#import "ProgressHUD.h"

@interface ShowServiceViewController ()<UITableViewDataSource,UITableViewDelegate,BTServerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lbPeripheral;
@property (weak, nonatomic) IBOutlet UILabel *lbService;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (strong,nonatomic) BTServer *defaultBTServer;
@end

@implementation ShowServiceViewController{
    BOOL readLock;
}

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
    self.lbPeripheral.text = self.defaultBTServer.selectPeripheral.name;
    self.lbService.text = [self.defaultBTServer.discoveredSevice.UUID UUIDString];
    
    readLock = false;
    
}
-(void)viewDidAppear:(BOOL)animated{
    self.defaultBTServer.delegate = self;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];

}
-(void)didDisconnect
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [ProgressHUD showSuccess:@"disconnect from peripheral"];
        [self.navigationController popToRootViewControllerAnimated:YES];
    });
}
-(void)didReadvalue
{
    dispatch_async(dispatch_get_main_queue(), ^{
        readLock = false;
        [ProgressHUD dismiss];
        [self performSegueWithIdentifier:@"readValue" sender:self];
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
#pragma mark -- table delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.defaultBTServer getCharacteristicState] == KING) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [tableView reloadData];
        });
        return 0;
    }else if([self.defaultBTServer getCharacteristicState] == KFAILED){
        return 0;
    }
    
    int n = [self.defaultBTServer.discoveredSevice.characteristics count];
    return n;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSLog(@"click at :%d, with lockstate:%@",indexPath.row,readLock?@"lock":@"unlock");
    
    if (readLock == true) {
        return;
    }

    CBCharacteristic* ch = self.defaultBTServer.discoveredSevice.characteristics[indexPath.row];
    [self.defaultBTServer readValue:ch];
    [ProgressHUD show:@"reading characteristic"];
    readLock = true;
}
-(NSString*)getPropertiesString:(CBCharacteristicProperties)properties
{
    NSMutableString *s = [[NSMutableString alloc]init];
    [s appendString:@""];
    
    if ((properties & CBCharacteristicPropertyBroadcast) == CBCharacteristicPropertyBroadcast) {
        [s appendString:@" Broadcast"];
    }
    if ((properties & CBCharacteristicPropertyRead) == CBCharacteristicPropertyRead) {
        [s appendString:@" Read"];
    }
    if ((properties & CBCharacteristicPropertyWriteWithoutResponse) == CBCharacteristicPropertyWriteWithoutResponse) {
        [s appendString:@" WriteWithoutResponse"];
    }
    
    if ((properties & CBCharacteristicPropertyWrite) == CBCharacteristicPropertyWrite) {
        [s appendString:@" Write"];
    }
    if ((properties & CBCharacteristicPropertyNotify) == CBCharacteristicPropertyNotify) {
        [s appendString:@" Notify"];
    }
    if ((properties & CBCharacteristicPropertyIndicate) == CBCharacteristicPropertyIndicate) {
        [s appendString:@" Indicate"];
    }
    if ((properties & CBCharacteristicPropertyAuthenticatedSignedWrites) == CBCharacteristicPropertyAuthenticatedSignedWrites) {
        [s appendString:@" AuthenticatedSignedWrites"];
    }
    if ((properties & CBCharacteristicPropertyExtendedProperties) == CBCharacteristicPropertyExtendedProperties) {
        [s appendString:@" ExtendedProperties"];
    }
    if ((properties & CBCharacteristicPropertyNotifyEncryptionRequired) == CBCharacteristicPropertyNotifyEncryptionRequired) {
        [s appendString:@" NotifyEncryptionRequired"];
    }
    if ((properties & CBCharacteristicPropertyIndicateEncryptionRequired) == CBCharacteristicPropertyIndicateEncryptionRequired) {
        [s appendString:@" IndicateEncryptionRequired"];
    }

    if ([s length]<2) {
        [s appendString:@"unknow"];
    }
    return s;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"CharacteristicCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    }
    
    CBCharacteristic* ch = self.defaultBTServer.discoveredSevice.characteristics[indexPath.row];
    cell.textLabel.text = [ch.UUID UUIDString];
    
    
    NSString *s = [self getPropertiesString:ch.properties];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"UUID:%@  Properities(%d):%@",[ch.UUID UUIDString],ch.properties,s];
    
    return cell;
}

@end
