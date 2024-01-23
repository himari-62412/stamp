//
//  MmoCollectiViewController.swift
//  メモ
//
//  Created by 中村日鞠 on 2022/11/15.
//

import UIKit

class MemoCollectiViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var backgorundImageView: UIImageView!
    @IBOutlet  var collectionView: UICollectionView!
    // @IBOutlet var collectionViewFlowLayout:  UICollectiontViewFlowLayout!
    
    var saveData: UserDefaults = UserDefaults.standard
    var titles: [String]!
    var contents: [String] = []
    var stampImageView: UIImageView! //貼り付けるスタンプの変数
    var selectedIndex: Int = 0
    var stampHistory: [UIImageView] = []
    
    //自分が用意した画像の名前が入ってる配列を作る
    var CollectionViewCell: [String] = ["pinnkunoneko","aoineko","kiiroineko","oniwasoto","kappanasi neko","magukappu","siroineko","panda"]
    
    let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
    
    var panGestureRecognizer: UIPanGestureRecognizer!
    var selectionBorderView: UIView?
    var isSelected: Bool = false
    var pinchGestureRecognizer: UIPinchGestureRecognizer?
    
    var pinchGesture = UIPinchGestureRecognizer()
    
    
    override func viewDidLoad() {
        navigationItem.title = "SCREEN 1"
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "Back To 1",
            style: .plain,
            target: nil,
            action: nil)
        super.viewDidLoad()
        
        
        saveData.register(defaults: [ "titles": [], "contents" :[]] )
        titles = saveData.object(forKey: "titles") as? [String]
        contents = saveData.object(forKey: "contents") as! [String]
        
        print(saveData.object(forKey: "titles")as? [String])
        
        
        //セルの再利用のための設定
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        
        // デリゲート設定
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 90, height: 90)
        collectionView.collectionViewLayout = layout
        
        
        // UICollectionView を表示
        self.view.addSubview(collectionView)
        
        // 点線や選択状態を表すビジュアルエフェクトを設定
        setupSelectionVisualEffect()
        
        //
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        presentingViewController?.beginAppearanceTransition(false, animated: animated)
        super.viewWillAppear(animated)
        
        saveData.register(defaults: [ "titles": [], "contents" :[]] )
        titles = saveData.object(forKey: "titles") as? [String]
        contents = saveData.object(forKey: "contents") as! [String]
        
        
        
    }
    
    
    // ステータスバーの高さ
    let statusBarHeight = UIApplication.shared.statusBarFrame.height

    // アイテムタッチ時の処理（UICollectionViewDelegate が必要）
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        //インデックスパス.ロー
        print("タップされた番号は\(indexPath.row)")
    }
    
    
    
    //ナンバー of アイテムin セクション
    //セクション内に、何個のアイテムがあるか。
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CollectionViewCell.count
    }
    
    //各セルの中身を指定するメソッド
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        
        cell.UllmageView.image = UIImage(named: CollectionViewCell[indexPath.row])
        
        
        // スタンプの拡大・縮小を可能にする
        cell.UllmageView.isUserInteractionEnabled = true
        
        return cell
        
    }
    
    //背景画像を選ぶ
    @IBAction func sekectBackground() {
        
        //UIImagePickerControllerのインスタンスを作る
        let imagePickerController: UIImagePickerController = UIImagePickerController()
        
        
        //フォトライブを使う設定をする
        imagePickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = true
        
        //フォトライブを呼ぶだす
        self.present(imagePickerController,animated: true, completion: nil)
        
        
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as? UIImage
        
        backgorundImageView.image = image
        
        
        
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: スタンプを貼り付けする
    override  func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            
            let location = touch.location(in: self.view)
            if let touchedViw = touch.view as? UIImageView, stampHistory.contains(touchedViw) {
                stampImageView = touchedViw
            }else {
                
                
                
                stampImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
                stampImageView.image = UIImage(named: CollectionViewCell[selectedIndex])
                stampImageView.center = location
                stampImageView.isUserInteractionEnabled = true  // Enable user interaction
                self.view.addSubview(stampImageView)
                
                
                let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(_:)))
                                        stampImageView.addGestureRecognizer(pinchGesture)
            }
        }
        
        
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) { if let touch = touches.first {
        let location = touch.location(in: self.view)
        if isStampArea(location), let stampImageView = stampImageView {
            stampImageView.center = location
        }
    }
        
    }
    
    //指を離した時に呼ばれるメソッド
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch: UITouch = touches.first!
        let location:CGPoint = touch.location(in: self.view)
        
        if touches.first?.view == backgorundImageView{
            
            UIView.animate(withDuration: 0.1, animations: {
                
                self.stampImageView.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
                self.stampImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                
            }) { (Bool) in
                
            }
            
            
            let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.handlePinchGesture(_:)))
            pinchGesture.cancelsTouchesInView = false
            stampImageView.addGestureRecognizer(pinchGesture)
            
        }
        
        
        
        //スタンプサイズを40pxの正方形に指定
        //width（ウィズ）: 横
        //height（ハイト）: 縦
        var gamennnoiro = UIImageView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
        
        //押されたスタンプの画像を設定
        let image = UIImage(named:CollectionViewCell[selectedIndex])!
        
        //タッチされた画像を置く
        if let stampImageView = stampImageView {
            stampImageView.center = CGPoint(x: location.x, y: location.y)
            self.view.addSubview(stampImageView)
            
            //画像を表示する
            self.view.addSubview(stampImageView)
            stampHistory.append(stampImageView)
            
            print(stampHistory)
            
        }
        
        
    }
    
    //0. ドラッグしたら動くのメソッドを作る
    //1. imageView変数 の中身を最新からタップした画像に変更する
    //2. サイズを変える
    @IBAction func save() {
        //画面上のスクリーンショットを取得
        //ここの数字を変える
        let rect:CGRect = CGRect(x: 0, y: 88, width: 414, height: 455)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        if let context = UIGraphicsGetCurrentContext() {
            context.translateBy(x: -rect.origin.x, y: -rect.origin.y)
            view.layer.render(in: context)
            let captureImage = UIGraphicsGetImageFromCurrentImageContext()
            
            // スクリーンショットを保存
            if let image = captureImage {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                let alert = UIAlertController(title: "保存", message: "写真の保存が完了しました", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
            }
        }
        UIGraphicsEndImageContext()
        
    }
    
    
    
    
    // 戻るボタンを押したときのアクション
    @IBAction func backButtonTapped(_ sender: UIButton) {
        guard let lastStamp = stampHistory.popLast() else {
            // 履歴がない場合は何もしない
            return
        }
        
        print("消すスタンプ", lastStamp)
        print(stampHistory)
        lastStamp.removeFromSuperview()
    }
    
    
    func isStampArea(_ location: CGPoint) -> Bool {
        let stampAreaRect = CGRect(x: 0, y: 88, width: 414, height: 455)  // スタンプを押せる範囲の矩形を指定
        return stampAreaRect.contains(location)
    }
    
    @objc func handlePinchGesture(_ gestureRecognizer: UIPinchGestureRecognizer) {
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            let currentScale = gestureRecognizer.view!.frame.size.width / gestureRecognizer.view!.bounds.size.width
            var newScale = currentScale * gestureRecognizer.scale
            
            if newScale < 0.5 {
                newScale = 0.5
            }
            if newScale > 2.0 {
                newScale = 2.0
            }
            
            let transform = CGAffineTransform(scaleX: newScale, y: newScale)
            gestureRecognizer.view?.transform = transform
            gestureRecognizer.scale = 1.0
        }
    }
    
    
    
    
    
    func setupSelectionVisualEffect() {
        if stampImageView != nil {
            // 選択状態を示すビジュアルエフェクトとして点線の枠線を追加
            let selectionBorderLayer = CAShapeLayer()
            selectionBorderLayer.strokeColor = UIColor.blue.cgColor
            selectionBorderLayer.lineWidth = 2.0
            selectionBorderLayer.lineDashPattern = [4, 4]
            selectionBorderLayer.fillColor = nil
            
            selectionBorderLayer.path = UIBezierPath(rect: stampImageView.bounds).cgPath
            
            
            // 点線の枠線を追加するビューを作成し、ビューにレイヤーを追加
            let selectionBorderView = UIView(frame: stampImageView.bounds)
            selectionBorderView.layer.addSublayer(selectionBorderLayer)
            selectionBorderView.isHidden = true
            
            // スタンプ画像の上にビューを配置
            stampImageView.addSubview(selectionBorderView)
            
            // インスタンス変数にビューを保持
            self.selectionBorderView = selectionBorderView
        }
    }
    
    private func updateSelectionVisualEffect() {
        // 選択状態に応じてビジュアルエフェクトの表示を更新
        selectionBorderView?.isHidden = !isSelected
    }
}

