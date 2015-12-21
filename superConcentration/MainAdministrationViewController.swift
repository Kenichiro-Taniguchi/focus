//
//  MainAdministrationViewController.swift
//  superConcentration
//
//  Created by 谷口健一郎 on 2015/12/04.
//  Copyright © 2015年 谷口健一郎. All rights reserved.
//

import UIKit
import CoreData

class MainAdministrationViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var backBtn: UIBarButtonItem!
    var bookTitleName:[String] = []
    

    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.backgroundColor = UIColor.blackColor()
        self.title = "Administration"
        backBtn = UIBarButtonItem(title: "Back", style: .Plain, target: self, action: "onClickMyButton")
        self.navigationItem.leftBarButtonItem = backBtn
        
    }
    
    override func viewWillAppear(animated: Bool) {
        readCoredata()
        self.tableView.reloadData()
            }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onClickMyButton(){
        dismissViewControllerAnimated(true, completion: nil)
    }
    
   
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookTitleName.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showTime", sender: nil)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "AdminCell")
        cell.textLabel?.text = bookTitleName[indexPath.row]
        cell.backgroundColor = UIColor.blackColor()
        cell.textLabel?.textColor = UIColor.whiteColor()
        return cell
    }
    @IBAction func addBtn(sender: AnyObject) {
    
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        deleteCoredata(bookTitleName[indexPath.row])
        // 先にデータを更新する
        bookTitleName.removeAtIndex(indexPath.row)
        
        
        // それからテーブルの更新
        tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: indexPath.row, inSection: 0)],
            withRowAnimation: UITableViewRowAnimation.Fade)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showTime"){
            let Avc = segue.destinationViewController as! TimeAdminViewController
            let indexPath = self.tableView.indexPathForSelectedRow
            Avc.titleText = bookTitleName[(indexPath?.row)!]
        }
    }
    
    func readCoredata(){
        //AppDelegateをコードで読み込む
        let appDelegata = UIApplication.sharedApplication().delegate as! AppDelegate
        
        //Entityの操作を制御するmanagedObjectContextをappDelegataで作成する
        
        let manageObjectContext = appDelegata.managedObjectContext
        //Entityを指定する設定
        let entityDiscription = NSEntityDescription.entityForName("Settings", inManagedObjectContext: manageObjectContext)
        
        let fetchRequest = NSFetchRequest(entityName: "Settings")
        fetchRequest.entity = entityDiscription
        
        //フェッチリクエスト（データの検索と取得処理）の実行
        var error:NSError? = nil
        do {
            
            let english = try manageObjectContext.executeFetchRequest(fetchRequest) as! [Settings]
            bookTitleName = []
            for managedObject in english {
                bookTitleName.append(managedObject.book!)
                print(bookTitleName)
                
                
                
            }
            
        }catch let error1 as NSError {
            error = error1
        }
    
    }
    func deleteCoredata(delete:String){
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
