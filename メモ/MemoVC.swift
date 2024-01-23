//
//  2枚目.swift
//  メモ
//
//  Created by 中村日鞠 on 2022/07/12.
//

import Foundation
import UIKit

class MemoviewController: UIViewController,UITextFieldDelegate{
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var contentTextView:UITextView!
    

    //メモのタイトルデータが格納される配列
    var titles: [String] = []
    
    //メモの詳細データが格納される配列
    var contents: [String] = []
    
    //let's go とかと一緒で、[レット]と読む。定数宣言に使う。変数
    //セーブデータっていう名前の定数を作ってます。
    
    let saveData: UserDefaults = UserDefaults.standard
    
    //取り出したいもの＝saveData.object(forKey:"キー（鍵）")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveData.register(defaults: ["titles": [], "contents": [] ])
        
        titles = saveData.object(forKey: "titles") as![String]
        contents = saveData.object(forKey:"contents") as! [String]
        
        
        print(titles)
        print(contents)
        
        titleTextField.delegate = self
        
    }
    
    @IBAction func saveMemo() {
        //UserDefaultに書き込み
        //倉庫にタイトルと言う鍵で保存する
        let title = titleTextField.text!
        let content = contentTextView.text!
        
        titles.append(title)
        contents.append(content)
        
        saveData.set(titles,forKey: "titles")
        saveData.set(contents,forKey: "contents")
        
        let alert: UIAlertController = UIAlertController(title: "保存",message: "メモの保存が完了しました",preferredStyle: .alert)
        
      
        
        //OKボタン
        alert.addAction(
            UIAlertAction(
                title: "OK",
                style: .default,
                handler: { action in
                    //ボタンが押された時の動作
                    print("okボタンが押されました！")
                    self.navigationController?.popViewController(animated: true)
                }
            )
        )
        present(alert,animated: true, completion: nil)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
