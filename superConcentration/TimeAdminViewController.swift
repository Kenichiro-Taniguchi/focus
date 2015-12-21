//
//  TimeAdminViewController.swift
//  superConcentration
//
//  Created by 谷口健一郎 on 2015/12/05.
//  Copyright © 2015年 谷口健一郎. All rights reserved.
//

import UIKit
import AudioToolbox
import AVFoundation
import CoreData

class TimeAdminViewController: UIViewController {

    var tmr:NSTimer!
    var backgroundTaskIdentifier: UIBackgroundTaskIdentifier?
    var titleText:String?
    var restPage:Int?
    var averagePage:Int?
    var purpose:String?
    
    
    @IBOutlet var tapAny: UITapGestureRecognizer!
    @IBOutlet weak var add10min: UIButton!
    @IBOutlet weak var fakeLabel1: UILabel!
    @IBOutlet weak var fakeLabel2: UILabel!
    @IBOutlet weak var fakeLabel3: UILabel!
    @IBOutlet weak var fakeLabel4: UILabel!
    @IBOutlet weak var purposeLabel: UILabel!
    @IBOutlet weak var recordLabel: UITextField!
    @IBOutlet weak var averageLabel: UILabel!
    @IBOutlet weak var restLabel: UILabel!
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet weak var clearBtn: UIButton!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var restBtn: UIButton!
    @IBOutlet weak var sleepBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = titleText
        
        // ナビゲーションバーを取得.
        self.navigationController?.navigationBar
        
        // ナビゲーションバーを表示.
        self.navigationController?.navigationBarHidden = false
        
        recordLabel.keyboardType = UIKeyboardType.NumberPad
        
        
        
        backgroundTaskIdentifier = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler({
            UIApplication.sharedApplication().endBackgroundTask(self.backgroundTaskIdentifier!)
        })
        
        // Do any additional setup after loading the view.
        tmr = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "tickTimer:", userInfo: nil, repeats: true)
        tmr.invalidate()
        
        readCoredata(titleText!)
        restLabel.text = " 残数:\(String(restPage!))P"
        averageLabel.text = "1日最低:\(String(averagePage!))P"
        purposeLabel.text = "目標:\(purpose!)"
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        if (self.view.frame.height == 480){
            print("iPhone4s")
            timeLabel.translatesAutoresizingMaskIntoConstraints = true
            startBtn.translatesAutoresizingMaskIntoConstraints = true
            add10min.translatesAutoresizingMaskIntoConstraints = true
            restBtn.translatesAutoresizingMaskIntoConstraints = true
            sleepBtn.translatesAutoresizingMaskIntoConstraints = true
            clearBtn.translatesAutoresizingMaskIntoConstraints = true
            purposeLabel.translatesAutoresizingMaskIntoConstraints = true
            restLabel.translatesAutoresizingMaskIntoConstraints = true
            averageLabel.translatesAutoresizingMaskIntoConstraints = true
            todayLabel.translatesAutoresizingMaskIntoConstraints = true
            recordLabel.translatesAutoresizingMaskIntoConstraints = true
            recordBtn.translatesAutoresizingMaskIntoConstraints = true
            fakeLabel1.backgroundColor = UIColor.clearColor()
            fakeLabel2.backgroundColor = UIColor.clearColor()
            fakeLabel3.backgroundColor = UIColor.clearColor()
            fakeLabel4.backgroundColor = UIColor.clearColor()
            timeLabel.frame = CGRectMake(0, 64, 320,116)
            startBtn.frame = CGRectMake(0, 180, 107, 70)
            add10min.frame = CGRectMake(107, 180, 107, 70)
            restBtn.frame = CGRectMake(214, 180, 106, 70)
            sleepBtn.frame = CGRectMake(0, 250, 320, 40)
            clearBtn.frame = CGRectMake(0, 290, 320, 40)
            purposeLabel.frame = CGRectMake(0, 330, 320, 40)
            restLabel.frame = CGRectMake(0, 370, 320, 35)
            averageLabel.frame = CGRectMake(0, 405, 320, 40)
            todayLabel.frame = CGRectMake(0, 445, 100, 35)
            recordLabel.frame = CGRectMake(100, 445, 120, 35)
            recordBtn.frame = CGRectMake(220, 445, 100, 35)
            
            
            
            
        
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func dateAdd(number: Int, date: NSDate) -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        let comp = NSDateComponents()
        let opt = NSCalendarOptions()
        comp.minute = number
        return calendar.dateByAddingComponents(comp, toDate: date, options: opt)!
        
    }
    @IBAction func startTap(sender: AnyObject) {
        self.navigationController?.navigationBarHidden = true
        sleepBtn.hidden = true
        restBtn.hidden = true
        if startBtn.titleLabel?.text == "Start"{
        startBtn.setTitle("Stop", forState: .Normal)
        }else if startBtn.titleLabel?.text == "Stop"{
        startBtn.setTitle("Start", forState: .Normal)
        }
        if tmr.valid == true{
            tmr.invalidate()
        }else{
            if self.timeLabel.text == "00:00"{
                timeLabel.text = "30:01"
                tmr = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "tickTimer:", userInfo: nil, repeats: true)
                tmr.fire()
                
            }else{
                tmr = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "tickTimer:", userInfo: nil, repeats: true)
                tmr.fire()}
            
        }
    }
    @IBAction func addTap(sender: AnyObject) {
        let df:NSDateFormatter = NSDateFormatter()
        df.dateFormat = "mm:ss"
        
        // 基準日時の設定 ３分を日付型に変換
        var dt:NSDate = df.dateFromString(timeLabel.text!)!
        
        let new = dateAddAdmin(10, date: dt)
        
        self.timeLabel.text = df.stringFromDate(new)
    }
    @IBAction func restTap(sender: AnyObject) {
        self.navigationController?.navigationBarHidden = true
        startBtn.hidden = true
        timeAdmin("10:01")
    }
    @IBAction func sleepTap(sender: AnyObject) {
        self.navigationController?.navigationBarHidden = true
        startBtn.hidden = true
        timeAdmin("20:01")
    }
    @IBAction func clearTap(sender: AnyObject) {
        tmr.invalidate()
        self.timeLabel.text = "00:00"
        sleepBtn.hidden = false
        restBtn.hidden = false
        startBtn.hidden = false
        self.navigationController?.navigationBarHidden = false
        startBtn.setTitle("Start", forState: .Normal)
    }
    @IBAction func recordTap(sender: AnyObject) {
        if (recordLabel.text != ""){
            let renew = restPage! - Int(recordLabel.text!)!
            updataCoredata(titleText!, renew: renew)
            
            readCoredata(titleText!)
            restLabel.text = " 残数:\(String(restPage!))P"
            recordLabel.text = ""
            if (restPage <= 0){
                let alert = UIAlertView()
                alert.title = "Conguratulation!"
                alert.message = "あなたはこの本を完遂しました"
                alert.addButtonWithTitle("OK")
                alert.show()
            }else{
                let alert = UIAlertView()
                alert.title = "Complete"
                alert.message = "記録しました"
                alert.addButtonWithTitle("OK")
                alert.show()
            }
            
            
            
        }else{
            let alert = UIAlertView()
            alert.title = "空欄があります"
            alert.message = "今日の成果を埋めてください"
            alert.addButtonWithTitle("OK")
            alert.show()
            
        }
    }
    
    func timeAdmin(text:String){
        if tmr.valid == true{
            tmr.invalidate()
            self.timeLabel.text = text
            tmr = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "tickTimer:", userInfo: nil, repeats: true)
            tmr.fire()
            
        }else if tmr.valid == false{
            self.timeLabel.text = text
            tmr = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "tickTimer:", userInfo: nil, repeats: true)
            tmr.fire()
        }
    }
    
    func dateAddAdmin(number:Int,date:NSDate) ->NSDate{
        let calendar = NSCalendar.currentCalendar()
        let comp = NSDateComponents()
        let opt = NSCalendarOptions()
        comp.minute = number
        return calendar.dateByAddingComponents(comp, toDate: date, options: opt)!
        
    }
    
    func tickTimer(timer: NSTimer){
        // 時間書式の設定
        let df:NSDateFormatter = NSDateFormatter()
        df.dateFormat = "mm:ss"
        
        // 基準日時の設定 ３分を日付型に変換
        var dt:NSDate = df.dateFromString(timeLabel.text!)!
        
        // カウントダウン
        var dt02 = NSDate(timeInterval: -1.0, sinceDate: dt)
        
        self.timeLabel.text = df.stringFromDate(dt02)
        
        // 終了判定 3分が00:00になったら isEqualToString:文字の比較
        if self.timeLabel.text == "00:00" {
            let soundIdRing:SystemSoundID = 1005  // new-mail.caf
            AudioServicesPlaySystemSound(soundIdRing)
            
            ////Notificationを生成
            let notification:UILocalNotification = UILocalNotification()
            self.navigationController?.navigationBarHidden = false
            ////タイトルの代入
            if #available(iOS 8.2, *) {
                notification.alertTitle = "Time!"
                
                ////　メッセージを代入
                notification.alertBody = "時間になりました！"
                
                notification.soundName = UILocalNotificationDefaultSoundName
                
                /// Notificationを表示する
                UIApplication.sharedApplication().scheduleLocalNotification(notification)
            } else {
                // Fallback on earlier versions
                print("バージョンアップしてください")
            }
            
            
            
            
            timer.invalidate()
            let alertController = UIAlertController(title: "Finish!!", message: "", preferredStyle: .Alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            
            presentViewController(alertController, animated: true, completion: nil)
            sleepBtn.hidden = false
            restBtn.hidden = false
            startBtn.hidden = false
            startBtn.setTitle("Start", forState: UIControlState.Normal)
        }
    }
    
    func readCoredata(read:String){
        //AppDelegateをコードで読み込む
        let appDelegata = UIApplication.sharedApplication().delegate as! AppDelegate
        
        //Entityの操作を制御するmanagedObjectContextをappDelegataで作成する
        
        let manageObjectContext = appDelegata.managedObjectContext
        //Entityを指定する設定
        let entityDiscription = NSEntityDescription.entityForName("Settings", inManagedObjectContext: manageObjectContext)
        
        let fetchRequest = NSFetchRequest(entityName: "Settings")
        fetchRequest.entity = entityDiscription
        
        let predicate = NSPredicate(format: "%K = %@", "book","\(read)")
        fetchRequest.predicate = predicate
        
        
        //フェッチリクエスト（データの検索と取得処理）の実行
        var error:NSError? = nil
        do {
            
            let english = try manageObjectContext.executeFetchRequest(fetchRequest) as! [Settings]
            
            for managedObject in english {
                //削除処理の本体
                restPage = Int(managedObject.page!)
                averagePage = Int(managedObject.result!)
                purpose = managedObject.purpose
            }
            
        }catch let error1 as NSError {
            error = error1
        }
    }
    @IBAction func tapAnywhere(sender: AnyObject) {
        self.view.endEditing(true)
    }
    func updataCoredata(delete:String, renew:Int){
        //AppDelegateをコードで読み込む
        let appDelegata = UIApplication.sharedApplication().delegate as! AppDelegate
        
        //Entityの操作を制御するmanagedObjectContextをappDelegataで作成する
        
        let manageObjectContext = appDelegata.managedObjectContext
        //Entityを指定する設定
        let entityDiscription = NSEntityDescription.entityForName("Settings", inManagedObjectContext: manageObjectContext)
        
        let fetchRequest = NSFetchRequest(entityName: "Settings")
        fetchRequest.entity = entityDiscription
        
        let predicate = NSPredicate(format: "%K = %@", "book","\(delete)")
        fetchRequest.predicate = predicate
        
        
        //フェッチリクエスト（データの検索と取得処理）の実行
        var error:NSError? = nil
        do {
            
            let english = try manageObjectContext.executeFetchRequest(fetchRequest) as! [Settings]
            
            for managedObject in english {
                //削除処理の本体
                managedObject.page = renew
                
                appDelegata.saveContext()
                
                
                
                
            }
            
        }catch let error1 as NSError {
            error = error1
        }
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
