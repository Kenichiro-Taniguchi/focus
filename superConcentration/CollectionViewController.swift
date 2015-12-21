//
//  CollectionViewController.swift
//  superConcentration
//
//  Created by 谷口健一郎 on 2015/12/06.
//  Copyright © 2015年 谷口健一郎. All rights reserved.
//

import UIKit
import CoreData
import CoreMotion

class CollectionViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var titleName = ""
    var word = ""
    var titleArray:[String] = []
    var meaning = ""

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = titleName
        
        // ナビゲーションバーを取得.
        self.navigationController?.navigationBar
        
        tableView.backgroundColor = UIColor.blackColor()
        
        // ナビゲーションバーを表示.
        self.navigationController?.navigationBarHidden = false
        let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "addCell:")
        self.navigationItem.setRightBarButtonItem(addButton, animated: true)

    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if event!.type == UIEventType.Motion && event!.subtype == UIEventSubtype.MotionShake {
            // シェイク動作終了時の処理
            titleArray.shuffle(titleArray.count)
            tableView.reloadData()
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        readCoredata()
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "myCellSecond")
        cell.textLabel?.text = titleArray[indexPath.row]
        cell.backgroundColor = UIColor.blackColor()
        cell.textLabel?.textColor = UIColor.whiteColor()
        return cell
    }
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        deleteCoredata(titleArray[indexPath.row])
        titleArray.removeAtIndex(indexPath.row)
        tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: indexPath.row, inSection: 0)],
            withRowAnimation: UITableViewRowAnimation.Fade)
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        appearMeaning(titleArray[indexPath.row])
        
        let alert:UIAlertController = UIAlertController(title:"\(titleArray[indexPath.row])",
            message: "\(meaning)",
            preferredStyle: UIAlertControllerStyle.Alert)
        let defaultAction:UIAlertAction = UIAlertAction(title: "OK",
            style: UIAlertActionStyle.Default,
            handler:{
                (action:UIAlertAction) -> Void in
                
        })
        
        
        
        
        alert.addAction(defaultAction)
        
        //AlertViewの表示
        presentViewController(alert, animated: true, completion: nil)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    func readCoredata(){
        //AppDelegateをコードで読み込む
        let appDelegata = UIApplication.sharedApplication().delegate as! AppDelegate
        
        //Entityの操作を制御するmanagedObjectContextをappDelegataで作成する
        
        let manageObjectContext = appDelegata.managedObjectContext
        //Entityを指定する設定
        let entityDiscription = NSEntityDescription.entityForName("English", inManagedObjectContext: manageObjectContext)
        
        let fetchRequest = NSFetchRequest(entityName: "English")
        fetchRequest.entity = entityDiscription
        
        // NSPredicateを使用して検索の条件をつける
        let predicate = NSPredicate(format: "%K = %@", "category","\(titleName)")
        fetchRequest.predicate = predicate
        
        //フェッチリクエスト（データの検索と取得処理）の実行
        var error:NSError? = nil
        do {
            
            let english = try manageObjectContext.executeFetchRequest(fetchRequest) as! [English]
            
            
            for managedObject in english {
                
                // managedObjectはそのままでは使えない
                
                titleArray.append(managedObject.word!)
                print(titleArray)
                
                
                
            }
            
        }catch let error1 as NSError {
            error = error1
        }
    
    }
    
    func appearMeaning(wordUnknown:String){
        //AppDelegateをコードで読み込む
        let appDelegata = UIApplication.sharedApplication().delegate as! AppDelegate
        
        //Entityの操作を制御するmanagedObjectContextをappDelegataで作成する
        
        let manageObjectContext = appDelegata.managedObjectContext
        //Entityを指定する設定
        let entityDiscription = NSEntityDescription.entityForName("English", inManagedObjectContext: manageObjectContext)
        
        let fetchRequest = NSFetchRequest(entityName: "English")
        fetchRequest.entity = entityDiscription
        
        // NSPredicateを使用して検索の条件をつける
        let predicate = NSPredicate(format: "%K = %@", "word","\(wordUnknown)")
        fetchRequest.predicate = predicate
        
        //フェッチリクエスト（データの検索と取得処理）の実行
        var error:NSError? = nil
        do {
            
            let english = try manageObjectContext.executeFetchRequest(fetchRequest) as! [English]
            
            
            for managedObject in english {
                
                // managedObjectはそのままでは使えない
                
                meaning = managedObject.meaning!
                
                
            }
            
        }catch let error1 as NSError {
            error = error1
        }
    
    }
    
    func addCoreData(word:String,meaning:String){
        //AppDelegateをコードで読み込む
        let appDelegata = UIApplication.sharedApplication().delegate as! AppDelegate
        
        //Entityの操作を制御するmanagedObjectContextをappDelegataで作成する
        
        let manageObjectContext = appDelegata.managedObjectContext
        
        //新しくデータを追加するためのEntityを作成します
        let entity = NSEntityDescription.entityForName("English", inManagedObjectContext: manageObjectContext)
        let english = English(entity: entity!, insertIntoManagedObjectContext: manageObjectContext)
        english.word = word
        english.meaning = meaning
        english.category = titleName
        
        //コアデータに保存
        appDelegata.saveContext()
    
    }
    
    
    
    func addCell(sender: AnyObject) {
        print("追加")
        let alert:UIAlertController = UIAlertController(title:"単語の追加",
            message: "言葉と意味を入力してください。",
            preferredStyle: UIAlertControllerStyle.Alert)
        
        let cancelAction:UIAlertAction = UIAlertAction(title: "Cancel",
            style: UIAlertActionStyle.Cancel,
            handler:{
                (action:UIAlertAction) -> Void in
                print("Cancel")
        })
        let defaultAction:UIAlertAction = UIAlertAction(title: "OK",
            style: UIAlertActionStyle.Default,
            handler:{
                (action:UIAlertAction) -> Void in
                let textFields:Array<UITextField>? =  alert.textFields as Array<UITextField>?
                self.word = textFields![0].text!
                self.addCoreData(textFields![0].text!, meaning: textFields![1].text!)
                
                // myItemsに追加.
                self.titleArray.append("\(self.word)")
                self.tableView.reloadData()
        })
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        
        //textfiledの追加
        alert.addTextFieldWithConfigurationHandler({(vocabrary:UITextField) -> Void in
            vocabrary.placeholder = "word"
        })
        alert.addTextFieldWithConfigurationHandler({(meaning:UITextField) -> Void in
            meaning.placeholder = "meaning"
        })
        //AlertViewの表示
        presentViewController(alert, animated: true, completion: nil)
    
    }
    
    func deleteCoredata(delete:String){
        //AppDelegateをコードで読み込む
        let appDelegata = UIApplication.sharedApplication().delegate as! AppDelegate
        
        //Entityの操作を制御するmanagedObjectContextをappDelegataで作成する
        
        let manageObjectContext = appDelegata.managedObjectContext
        //Entityを指定する設定
        let entityDiscription = NSEntityDescription.entityForName("English", inManagedObjectContext: manageObjectContext)
        
        let fetchRequest = NSFetchRequest(entityName: "English")
        fetchRequest.entity = entityDiscription
        
        let predicate = NSPredicate(format: "%K = %@", "word","\(delete)")
        fetchRequest.predicate = predicate
        
        
        //フェッチリクエスト（データの検索と取得処理）の実行
        var error:NSError? = nil
        do {
            
            let english = try manageObjectContext.executeFetchRequest(fetchRequest) as! [English]
            
            for managedObject in english {
                //削除処理の本体
                manageObjectContext.deleteObject(managedObject as NSManagedObject)
                
                //削除したことも保存しておかないと反映されないので注意
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
