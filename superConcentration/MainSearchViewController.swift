//
//  MainSearchViewController.swift
//  superConcentration
//
//  Created by 谷口健一郎 on 2015/12/04.
//  Copyright © 2015年 谷口健一郎. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
class MainSearchViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var latitude:CLLocationDegrees?
    var longitude:CLLocationDegrees?
    var jsonDict:NSDictionary = [:]
    var storeLatitude:String?
    var storeLongitude:String?
    var storeAddress:String?
    var restArray:NSArray = []
    var nearDict:NSMutableDictionary = [:]
    var name:String?
    var trueArray:[String] = []
    var keysArray:[Double] = []
    var backBtn: UIBarButtonItem!
    var myGeocoder: CLGeocoder = CLGeocoder()

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Search"
        
        var alert = UIAlertView()
        alert.title = "カフェの検索"
        alert.message = "今の現在地から近い順にカフェを検索しています"
        alert.addButtonWithTitle("OK")
        alert.show()
        
        tableView.backgroundColor = UIColor.blackColor()
        tableView.separatorColor = UIColor.whiteColor()
        
        backBtn = UIBarButtonItem(title: "Back", style: .Plain, target: self, action: "onClickMyButton")
        self.navigationItem.leftBarButtonItem = backBtn
        
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        //AppDelegateのインスタンスを取得
        latitude = appDelegate.latitude
        longitude = appDelegate.longtude 
                print(latitude!)
                print(longitude!)
        
                // Do any additional setup after loading the view.
        
        let urlStr = "http://api.gnavi.co.jp/RestSearchAPI/20150630/?keyid=16152aa86fd92715782b9c74b71ea434&format=json&latitude=\(latitude!)&longitude=\(longitude!)&range=5&hit_per_page=100&category_s=RSFST18001"
        let url = NSURL(string: urlStr)
        
        let apiData = NSData(contentsOfURL: url!)
        
        jsonDict = (try! NSJSONSerialization.JSONObjectWithData(apiData!, options: [])) as! NSDictionary
        
        sort()
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trueArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "searchCell")
        cell.textLabel?.text = trueArray[indexPath.row]
        cell.backgroundColor = UIColor.blackColor()
        cell.textLabel?.textColor = UIColor.whiteColor()
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        if (jsonDict["rest"] != nil){
        performSegueWithIdentifier("showMap", sender: nil)
        
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let tvc = segue.destinationViewController as! mapViewController
        let indexPath = self.tableView.indexPathForSelectedRow
        let nameSelect = trueArray[(indexPath?.row)!]
        if (jsonDict["rest"] != nil){
            for i in 0...(jsonDict["rest"]?.count)!-1{
                if nameSelect == jsonDict["rest"]![i]["name"] as! String{
                    tvc.storeAddress = jsonDict["rest"]![i]["address"] as! String
                    
                    
                    
                }
            }
        }
        
        
    }
    
    func sort(){
        
        

        if (jsonDict["rest"] != nil){
            for i in 0...(jsonDict["rest"]?.count)!-1{
                storeLatitude = jsonDict["rest"]![i]["latitude"] as! String
                storeLongitude = jsonDict["rest"]![i]["longitude"] as! String
                let x = Double(storeLatitude!)
                let y = Double(storeLongitude!)
                print(x!)
                print(y!)
                name = jsonDict["rest"]![i]["name"] as! String
                print(name!)
                let z = Double(latitude!)-x!
                let w = Double(longitude!)-y!
                let distance = z*z+w*w
                nearDict.setValue(name!, forKey: "\(distance)")
                
                
                
                
            }
            for i in 0...nearDict.allKeys.count-1{
                let
                check = String(nearDict.allKeys[i])
                let core = Double(check)
                keysArray.append(core!)
                
            }
            keysArray.sortInPlace(){$0 < $1}
            print(keysArray)
            
            for softkey in keysArray{
                for (key,value) in nearDict{
                    var check = String(key)
                    let core = Double(check)
                    if softkey == core{
                        trueArray.append(String(value))
                        
                    }
                    
                    
                }
            }
            print(trueArray)
        }else{
        trueArray.append("周辺にお店はございません")
        }
        
       
    
    }
    
    func onClickMyButton(){
        dismissViewControllerAnimated(true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
