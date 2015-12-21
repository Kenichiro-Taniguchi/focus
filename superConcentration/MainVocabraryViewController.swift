//
//  MainVocabraryViewController.swift
//  superConcentration
//
//  Created by 谷口健一郎 on 2015/12/04.
//  Copyright © 2015年 谷口健一郎. All rights reserved.
//

import UIKit
import CoreData

class MainVocabraryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var titleArray:[String] = []
    var titleName = ""
    var backBtn:UIBarButtonItem!

   
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = UIColor.blackColor()
       tableView.separatorColor = UIColor.whiteColor()
        
        
        self.title = "Vocabulary"
        
        // ナビゲーションバーを取得.
        self.navigationController?.navigationBar
        
        // ナビゲーションバーを表示.
        self.navigationController?.navigationBarHidden = false
        
        readCoredata()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        backBtn = UIBarButtonItem(title: "Back", style: .Plain, target: self, action: "onClickMyButton")
        self.navigationItem.leftBarButtonItem = backBtn
        let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "addCell:")
        self.navigationItem.setRightBarButtonItem(addButton, animated: true)
        
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "collectionCell")
        cell.textLabel?.text = titleArray[indexPath.row]
        cell.backgroundColor = UIColor.blackColor()
        cell.textLabel?.textColor = UIColor.whiteColor()
        return cell
        
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        deleteCoredata(titleArray[indexPath.row])
        titleArray.removeAtIndex(indexPath.row)
        
        // それからテーブルの更新
        tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: indexPath.row, inSection: 0)],
            withRowAnimation: UITableViewRowAnimation.Fade)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showWord", sender: nil)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let svc = segue.destinationViewController as! CollectionViewController
        let indexPath = self.tableView.indexPathForSelectedRow
        let object = titleArray[(indexPath?.row)!]
        svc.titleName = object
    }
    
    func readCoredata(){
        //AppDelegateをコードで読み込む
        let appDelegata = UIApplication.sharedApplication().delegate as! AppDelegate
        
        //Entityの操作を制御するmanagedObjectContextをappDelegataで作成する
        
        let manageObjectContext = appDelegata.managedObjectContext
        //Entityを指定する設定
        let entityDiscription = NSEntityDescription.entityForName("Title", inManagedObjectContext: manageObjectContext)
        
        let fetchRequest = NSFetchRequest(entityName: "Title")
        fetchRequest.entity = entityDiscription
        
        //フェッチリクエスト（データの検索と取得処理）の実行
        var error:NSError? = nil
        do {
            
            let english = try manageObjectContext.executeFetchRequest(fetchRequest) as! [Title]
            
            for managedObject in english {
                titleArray.append(managedObject.name!)
                print(titleArray)
                
                
                
                
            }
            
        }catch let error1 as NSError {
            error = error1
        }
    
    }
    
    func addCoreData(title:String){
        //AppDelegateをコードで読み込む
        let appDelegata = UIApplication.sharedApplication().delegate as! AppDelegate
        
        //Entityの操作を制御するmanagedObjectContextをappDelegataで作成する
        
        let manageObjectContext = appDelegata.managedObjectContext
        
        //新しくデータを追加するためのEntityを作成します
        let entity = NSEntityDescription.entityForName("Title", inManagedObjectContext: manageObjectContext)
        let english = Title(entity: entity!, insertIntoManagedObjectContext: manageObjectContext)
        english.name = title
        
        //コアデータに保存
        appDelegata.saveContext()
    
    }
    
    func deleteCoredata(delete:String){
        //AppDelegateをコードで読み込む
        let appDelegata = UIApplication.sharedApplication().delegate as! AppDelegate
        
        //Entityの操作を制御するmanagedObjectContextをappDelegataで作成する
        
        let manageObjectContext = appDelegata.managedObjectContext
        //Entityを指定する設定
        let entityDiscription = NSEntityDescription.entityForName("Title", inManagedObjectContext: manageObjectContext)
        let entityDiscription2 = NSEntityDescription.entityForName("English", inManagedObjectContext: manageObjectContext)
        
        let fetchRequest = NSFetchRequest(entityName: "Title")
        fetchRequest.entity = entityDiscription
        let fetchRequest2 = NSFetchRequest(entityName: "English")
        fetchRequest2.entity = entityDiscription2
        
        let predicate = NSPredicate(format: "%K = %@", "name","\(delete)")
        fetchRequest.predicate = predicate
        let predicate2 = NSPredicate(format: "%K = %@", "category","\(delete)")
        fetchRequest2.predicate = predicate2
        
        
        //フェッチリクエスト（データの検索と取得処理）の実行
        var error:NSError? = nil
        do {
            
            let titleCoredata = try manageObjectContext.executeFetchRequest(fetchRequest) as! [Title]
            
            for managedObject in titleCoredata {
                //削除処理の本体
                manageObjectContext.deleteObject(managedObject as NSManagedObject)
                
                //削除したことも保存しておかないと反映されないので注意
                appDelegata.saveContext()
                }
        }catch let error1 as NSError {
            error = error1
        }
        do {
            
            let english = try manageObjectContext.executeFetchRequest(fetchRequest2) as! [English]
            
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
    
    func addCell(sender: AnyObject){
        print("追加")
        let alert:UIAlertController = UIAlertController(title:"単語帳の追加",
            message: "単語帳の名前を書いてください",
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
                if textFields != nil {
                    for textField:UITextField in textFields! {
                        self.titleName = textField.text!
                        self.addCoreData(textField.text!)
                    }
                }
                // myItemsに追加.
                self.titleArray.append("\(self.titleName)")
                self.tableView.reloadData()
        })
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        
        //textfiledの追加
        alert.addTextFieldWithConfigurationHandler({(vocabrary:UITextField) -> Void in
            
        })
        //AlertViewの表示
        presentViewController(alert, animated: true, completion: nil)
    
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
