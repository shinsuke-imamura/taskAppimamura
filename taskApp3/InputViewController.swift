//
//  InputViewController.swift
//  taskApp
//
//  Created by 今村仁亮 on 2016/06/07.
//  Copyright © 2016年 shinsuke.imamura. All rights reserved.
//

import UIKit
import RealmSwift

class InputViewController: UIViewController {
    @IBOutlet weak var titleTextField:UITextField!
    @IBOutlet weak var contentsTextView:UITextView!
    @IBOutlet weak var datePicker:UIDatePicker!
    @IBOutlet weak var categoryTextField: UITextField!
    
    let realm = try! Realm()
    var task : Task!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //背景をタップしたらdismissKeyboadメソッドを呼ぶように設定
        let tapGesture: UITapGestureRecognizer =  UITapGestureRecognizer(target: self,action: #selector(InputViewController.dismisskeyboard))
        view.addGestureRecognizer(tapGesture)
        
        titleTextField.text=task.title
        contentsTextView.text = task.contents
        datePicker.date = task.date
        categoryTextField.text=task.category
        
        contentsTextView.layer.borderColor = UIColor.grayColor().CGColor
        contentsTextView.layer.borderWidth = 1
        contentsTextView.layer.cornerRadius = 10
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        try! realm.write{
            self.task.title = self.titleTextField.text!
            self.task.contents = self.contentsTextView.text
            self.task.date = self.datePicker.date
            self.realm.add(self.task,update: true)
            self.task.category = self.categoryTextField.text!
            
        }
        super.viewWillDisappear(animated)
    }
    
    func dismisskeyboard(){
        //キーボードを閉じる
        view.endEditing(true)
    }
    //タスクのローカル通知を設定する
    func setNotification(task: Task){
        //すでに同じタスクが登録されていたらキャンセルする
        for notification in UIApplication.sharedApplication().scheduledLocalNotifications!{
            if notification.userInfo!["id"] as! Int == task.id{
                UIApplication.sharedApplication().cancelLocalNotification(notification)
                break   // breakに来るとforループから抜け出せる
            }
        }
        let notification = UILocalNotification()
        
        notification.fireDate = task.date
        notification.timeZone = NSTimeZone.defaultTimeZone()
        notification.alertBody = "\(task.title)"
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = ["id":task.id]
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
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
