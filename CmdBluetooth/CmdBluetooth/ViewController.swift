//
//  ViewController.swift
//  CmdBluetooth
//
//  Created by Zero on 16/3/19.
//  Copyright © 2016年 Zero. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var bleTbl: UITableView!
    
    var bleList = [AnyObject]()
    
    let centerManager = CentralManager.manager
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        centerManager.parser = MyParser()
        
        centerManager.centralState { (state) -> Void in
            switch state {
            case .PoweredOn:
                print("蓝牙开启")
                break
            case .PoweredOff:
                print("蓝牙关闭")
                break
            default:
                print("蓝牙Default状态")
                break
            }
        }
        
        centerManager.didScanPeripherals { (peripherals) -> Void in
            self.bleList = peripherals
            self.bleTbl.reloadData()
        }
        
        centerManager.didDisConnectPeripheral { (peripheral, error) -> Void in
            print("断开蓝牙\(peripheral.name)")
        }
        
        centerManager.didConnectPeripheral { (peripheral) -> Void in
            print("连接上蓝牙\(peripheral.name)")
        }
        
        centerManager.failConnectPeripheral { (peripheral, error) -> Void in
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startScan(sender: AnyObject) {
        centerManager.scanWithServices(nil)
    }
    
    @IBAction func synTime(sender: AnyObject) {
        
        SynTimeCmd().setCurrentTime({ () -> Void in
            print("suc")
            
            }) { () -> Void in
                print("fail")
        }
    }
    
    //MARK: - TableView,DataSource Delegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bleList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "BLECELL"
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellId)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellId)
        }
        cell!.textLabel!.text = bleList[indexPath.row].name
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        centerManager.connectBle(bleList[indexPath.row] as! CBPeripheral)
    }
}