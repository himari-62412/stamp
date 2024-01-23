//
//  ViewController.swift
//  メモ
//
//  Created by 中村日鞠 on 2022/07/12.
//

import UIKit

class ViewController: UIViewController {
    //こんにちは

    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
     
    }

    @IBAction func startButton(_ sender: Any) {
        button.setImage(UIImage(named: "camera"), for: .highlighted)
        
    }
    
    @IBAction func startButtonUP(_ sender: Any) {
        button.setImage(UIImage(named: "camera"), for: .normal)
        
    }
    
    


}

