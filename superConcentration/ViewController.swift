//
//  ViewController.swift
//  superConcentration
//
//  Created by 谷口健一郎 on 2015/12/04.
//  Copyright © 2015年 谷口健一郎. All rights reserved.
//

import UIKit
import iAd
import CoreLocation


class ViewController: UIViewController,CLLocationManagerDelegate {
    
    var lm: CLLocationManager! = nil
    var latitude:CLLocationDegrees?
    var longtude:CLLocationDegrees?
    var json:NSDictionary = [:]
    private var myActivityIndicator: UIActivityIndicatorView!
    
    

    @IBOutlet weak var Vocabulary: UIButton!
    @IBOutlet weak var AdminstrationBtn: UIButton!
    @IBOutlet weak var searchBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lm = CLLocationManager()
        lm.delegate = self
        
        lm.requestAlwaysAuthorization()
        lm.desiredAccuracy = kCLLocationAccuracyBest
        lm.distanceFilter = 300
        lm.startUpdatingLocation()
        
        
        
        // autolayoutに使えるコード
//        var screenSize = self.view.frame
//        myActivityIndicator.frame = CGRectMake(0, 0, screenSize.width, screenSize.height - 100)
        
        myActivityIndicator = UIActivityIndicatorView()
        myActivityIndicator.frame = CGRectMake(0, 0, 50, 50)
        myActivityIndicator.center = self.view.center
        myActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
        // インジケータをViewに追加する.
        self.view.addSubview(myActivityIndicator)
        
       
        let iAdBanner = ADBannerView()
        //画面下に配置
        iAdBanner.frame.origin.y = self.view.frame.height - iAdBanner.frame.height
        //バナー表示前に表示される背景の色を指定
        iAdBanner.backgroundColor = UIColor.blackColor()
        self.view.addSubview(iAdBanner)
        
        
        
        
                
    }
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    
    override func viewDidDisappear(animated: Bool) {
        myActivityIndicator.stopAnimating()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        
        if (self.view.frame.height == 480){
            print("iPhone4s")
            AdminstrationBtn.translatesAutoresizingMaskIntoConstraints = true
            searchBtn.translatesAutoresizingMaskIntoConstraints = true
            Vocabulary.translatesAutoresizingMaskIntoConstraints = true
            AdminstrationBtn.frame = CGRectMake(0, 20, 320, 130)
            searchBtn.frame = CGRectMake(0, 155, 320, 130)
            Vocabulary.frame = CGRectMake(0, 290, 320, 130)
            
        }

        
        // Do any additional setup after loading the view, typically from a nib.
        let reachability: Reachability
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
        } catch {
            print("Unable to create Reachability")
            return
        }
        if reachability.isReachable(){
            searchBtn.enabled = true
            print("接続成功")
        }else{
            searchBtn.enabled = false
            let alert = UIAlertView()
            alert.title = "Wifiが繋がっていません"
            alert.message = "接続を確認してください"
            alert.addButtonWithTitle("OK")
            alert.show()
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func tapAdministration(sender: AnyObject) {
        performSegueWithIdentifier("showAdminVC", sender: nil)
    }

    @IBAction func tapSearch(sender: AnyObject) {
        myActivityIndicator.startAnimating()
        performSegueWithIdentifier("showSeachVC", sender: nil)
        
        
        
    }
    @IBAction func tapVocabrary(sender: AnyObject) {
        performSegueWithIdentifier("showVocabraryVC", sender: nil)
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        print("didChangeAuthorizationStatus");
        
        // 認証のステータスをログで表示.
        var statusStr = "";
        switch (status) {
        case .NotDetermined:
            statusStr = "NotDetermined"
        case .Restricted:
            statusStr = "Restricted"
        case .Denied:
            statusStr = "Denied"
        case .AuthorizedAlways:
            statusStr = "AuthorizedAlways"
        case .AuthorizedWhenInUse:
            statusStr = "AuthorizedWhenInUse"
        }
        print(" CLAuthorizationStatus: \(statusStr)")
    }
    
    
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        latitude = Double(newLocation.coordinate.latitude)
        longtude = Double(newLocation.coordinate.longitude)
        print(latitude!)
        print(longtude!)
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("失敗")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showSeachVC"){
            let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate //AppDelegateのインスタンスを取得
            appDelegate.latitude = latitude
            appDelegate.longtude = longtude
            
        }
        
    }
}

