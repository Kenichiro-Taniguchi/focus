//
//  SettingViewController.swift
//  superConcentration
//
//  Created by 谷口健一郎 on 2015/12/05.
//  Copyright © 2015年 谷口健一郎. All rights reserved.
//

import UIKit
import CoreData

class SettingViewController: UIViewController {

    @IBOutlet weak var purposeLabel: UITextField!
    @IBOutlet weak var bookLabel: UITextField!
    @IBOutlet weak var bookPageLabel: UITextField!
    @IBOutlet weak var dayTimeLabel: UITextField!
    @IBOutlet weak var bookAlertLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        bookAlertLabel.text = "本・参考書は成果達成に大きく関わってきます\n情報をしっかりと集めた上で\n本を選択しましょう。"
        bookPageLabel.keyboardType = UIKeyboardType.NumberPad
        dayTimeLabel.keyboardType = UIKeyboardType.NumberPad
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func subscribeBtn(sender: AnyObject) {
        if (purposeLabel.text != ""&&bookLabel.text != ""&&bookPageLabel.text != ""&&dayTimeLabel.text != ""){
            addCoreData()
            print("登録成功")
            self.navigationController?.popViewControllerAnimated(true)
            
        }else{
            let alert = UIAlertView()
            alert.title = "空欄があります"
            alert.message = "全ての項目を埋めてください"
            alert.addButtonWithTitle("OK")
            alert.show()
    }
    }
    @IBAction func tapAny(sender: AnyObject) {
        self.view.endEditing(true)
    }
    func addCoreData(){
        
        //AppDelegateをコードで読み込む
        let appDelegata = UIApplication.sharedApplication().delegate as! AppDelegate
        
        //Entityの操作を制御するmanagedObjectContextをappDelegataで作成する
        
        let manageObjectContext = appDelegata.managedObjectContext
        
        //新しくデータを追加するためのEntityを作成します
        let entity = NSEntityDescription.entityForName("Settings", inManagedObjectContext: manageObjectContext)
        let english = Settings(entity: entity!, insertIntoManagedObjectContext: manageObjectContext)
        english.purpose = purposeLabel.text
        english.book = bookLabel.text
        english.page = Int(bookPageLabel.text!)
        english.day = Int(dayTimeLabel.text!)
        let suprite:Double = Double(bookPageLabel.text!)!/Double(dayTimeLabel.text!)!
        round(suprite)
        english.result = Int(suprite)
        
        //コアデータに保存
        appDelegata.saveContext()
        
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
