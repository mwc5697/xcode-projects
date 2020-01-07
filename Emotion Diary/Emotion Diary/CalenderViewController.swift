//
//  CalenderViewController.swift
//  Emotion Diary
//
//  Created by Chung, MINHO on 11/23/19.
//  Copyright © 2019 Chung, MINHO. All rights reserved.
//

import UIKit

struct OneDiary{
    var month : String
    var image: UIImageView
    var text: String
    var color : UIColor
}

extension UIImageView{
    static var tag : Int {return 0}
}

class CalenderViewController: UIViewController, infoDelegate, UIGestureRecognizerDelegate{
    
    let diaryModel = emotionModel.sharedInstance
    
    fileprivate var longPressGesture : UILongPressGestureRecognizer?
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var monthChangeButton: UIButton!
    @IBOutlet var monthCollections: [UIButton]!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var iconBoard: UIView!
    
    var addButton = UIButton()
    
    var angryButton = UIButton()
    var depressedButton = UIButton()
    var happyButton = UIButton()
    var sadButton = UIButton()
    var sosoButton = UIButton()
    
    var angryImage = UIImage(named: "angry")
    var depressedImage = UIImage(named: "depressed")
    var happyImage = UIImage(named: "happy")
    var sadImage = UIImage(named: "sad")
    var sosoImage = UIImage(named: "soso")
    
    var backgroundColor : UIColor?
    
    var aniTime = 0.5
    var edge : CGFloat = 50
    var nextLine : CGFloat = 20
    
    var selectedButton : UIButton!
    var selectedImage : UIImageView!
    var collection : UICollectionView!
    
    var icons : [OneDiary] = []
    var currentText : String?
    var diaryOrder = 0
    var emotionString = ""
    
    let Today = Date()
    let dateFormat = DateFormatter()
    
    var oneTap : UITapGestureRecognizer?
    var move : UIPanGestureRecognizer?
    let moveScale : CGFloat = 1.2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupMonth()
        //setupCollectionView()
        //collection.dragDelegate = self
        //collection.dropDelegate = self
        //collection.dragInteractionEnabled = true
        
        buttonMaker()
        mainView.addSubview(addButton)
        mainView.addSubview(angryButton)
        mainView.addSubview(depressedButton)
        mainView.addSubview(happyButton)
        mainView.addSubview(sadButton)
        mainView.addSubview(sosoButton)
        
        angryButton.alpha = 0
        depressedButton.alpha = 0
        happyButton.alpha = 0
        sadButton.alpha = 0
        sosoButton.alpha = 0
        
        buttonCentered()
        
//        for i in 0..<diaryModel.emotionCount{
//            let aDiary = diaryModel.diary(atIndex: i)
//
//            let image = UIImage(named: aDiary.imageName)
//            let imageView = UIImageView(image: image)
//
//            let text = aDiary.text
//
//            let colorName = aDiary.imageName
//            var color = UIColor()
//            if colorName == "angry"{ color = .angry}
//            if colorName == "depressed"{color = .depressed}
//            if colorName == "happy"{color = .happy}
//            if colorName == "sad"{color = .sad}
//            if colorName == "soso"{color = .soso}
//
//            let convertedDiary = OneDiary(month: monthChangeButton.titleLabel!.text!, image: imageView, text: text, color: color)
//            icons.append(convertedDiary)
//            settingIcons()
//        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //setupCollectionView()
        settingIcons()
        
    }
    
    override func viewDidLayoutSubviews() {
        settingIcons()
    }
    
    //selecting month shown above will show options to change to other months
    @IBAction func monthSelectionAction(_ sender: UIButton) {
        monthCollections.forEach { (button) in
            UIView.animate(withDuration: aniTime, animations: {
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
//                let origin = CGPoint(x: self.edge, y: self.stackView.frame.maxY + self.nextLine)
                //self.collection.frame.origin = origin
            })
        }
    }
    
    //When we select month from month option, monthview will change and show correspond icons
    @IBAction func monthTapped(_ sender: UIButton) {
        UIView.animate(withDuration: aniTime, animations: {
            self.monthChangeButton.setTitle(sender.titleLabel!.text, for: .normal)
            self.monthCollections.forEach({ (button) in
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
                //let origin = CGPoint(x: self.edge, y: self.stackView.frame.maxY + self.nextLine)
                //self.collection.frame.origin = origin
                
                //                let filter = sender.titleLabel!.text!
                //                self.diaryModel.filter(filter: filter)
            })
        }) { (finished) in
            for i in 0..<self.icons.count{
                self.icons[i].image.removeFromSuperview()
                if self.icons[i].month == self.monthChangeButton.titleLabel!.text!{
                    self.iconBoard.addSubview(self.icons[i].image)
                }
            }
        }
    }
    
    //For setting up month, it will only show present month and 2 previous months
    func setupMonth(){
        dateFormat.dateFormat = "LLLL"
        let todayMonth = dateFormat.string(from: Today)
        
        monthChangeButton.setTitle(todayMonth, for: .normal)
        monthCollections[2].setTitle(todayMonth, for: .normal)
        
        let last = Calendar.current.date(byAdding: .month, value: -1, to: Today)
        let previousMonth = dateFormat.string(from: last!)
        monthCollections[1].setTitle(previousMonth, for: .normal)
        
        let twoMonth = Calendar.current.date(byAdding: .month, value: -2, to: Today)
        let twoMonthAgo = dateFormat.string(from: twoMonth!)
        monthCollections[0].setTitle(twoMonthAgo, for: .normal)
        
//        let filter = todayMonth
//        diaryModel.filter(filter: filter)
        
    }
    
    private func settingIcons(){
        
        let boardWidthSize = iconBoard.frame.size.width
        
        let gap : CGFloat = boardWidthSize/31
        
        var locationX : CGFloat = gap
        var locationY : CGFloat = gap
        
        let iconWidth : CGFloat = gap*5
        let iconHeight : CGFloat = gap*5
        
        for i in 0..<icons.count{
            if icons[i].image.superview == iconBoard{
                if locationX + iconWidth + gap > boardWidthSize{
                    locationY = locationY + iconHeight + gap
                    locationX = gap
                }
        
                let frame = CGRect(x: locationX,
                                    y: locationY,
                                    width: iconWidth,
                                    height: iconHeight)
            
                locationX = locationX + iconWidth + gap
        
                self.icons[i].image.frame = frame
            }
        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        diaryOrder = indexPath.row
//    }
 
//    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
//        let item = self.diaryArray[indexPath.row].icon.tag
//        let itemProvider = NSItemProvider(object: item as NSInteger as! NSItemProviderWriting)
//        let dragItem = UIDragItem(itemProvider: itemProvider)
//        dragItem.localObject = item
//        return [dragItem]
//
//    }
    
//    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
//        var destinationIndexPath : IndexPath
//        if let indexPath = coordinator.destinationIndexPath{
//            destinationIndexPath = indexPath
//        } else {
//            let row = collectionView.numberOfItems(inSection: 0)
//            destinationIndexPath = IndexPath(item: row-1, section: 0)
//        }
//        if coordinator.proposal.operation == .move {
//            self.reorderItems(coordinator: coordinator, destinationIndexPath: destinationIndexPath, collectionView: collectionView)
//        }
//    }
    
//    fileprivate func reorderItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView){
//        if let item = coordinator.items.first,
//            let sourceIndexPath = item.sourceIndexPath {
//            collectionView.performBatchUpdates({
//                self.diaryArray.remove(at: sourceIndexPath.item)
//                self.diaryArray.insert(item.dragItem.localObject as! OneDiary, at: destinationIndexPath.item)
//
//                collectionView.deleteItems(at: [sourceIndexPath])
//                collectionView.insertItems(at: [destinationIndexPath])
//            }, completion: nil)
//            coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
//        }
//
//    }
//
//    @objc func gestureLong(touch: UILongPressGestureRecognizer){
//        switch touch.state {
//        case .began:
//            if let chosenIndexPath = collection.indexPathForItem(at: touch.location(in: collection)){
//                collection.beginInteractiveMovementForItem(at: chosenIndexPath)
//            } else {break}
//        case .changed:
//            collection.updateInteractiveMovementTargetPosition(touch.location(in: touch.view))
//
//        case .ended:
//            collection.endInteractiveMovement()
//
//        default:
//            collection.cancelInteractiveMovement()
//        }
//    }
//
//    func setupCollectionView(){
//        let origin = CGPoint(x: edge, y: stackView.frame.maxY + nextLine)
//        let size = CGSize(width: mainView.frame.width-100, height: mainView.frame.height/2)
//
//        collection = UICollectionView(frame: CGRect(origin: origin, size: size), collectionViewLayout: UICollectionViewFlowLayout())
//        collection.backgroundColor = .clear
//        mainView.addSubview(collection)
//
//        collection.delegate = self
//        collection.dataSource = self
//
//        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
//    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: edge, height: edge)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return diaryArray.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//
//    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//        let item = diaryArray.remove(at: sourceIndexPath.item)
//        diaryArray.insert(item, at: destinationIndexPath.item)
//    }
    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
//
//        let buttonForCell = diaryArray[indexPath.row].icon
//        cell.addSubview(buttonForCell)
//        buttonForCell.frame.origin = CGPoint(x: 0, y: 0)
//        buttonForCell.isEnabled = true
//
//        return cell
//    }
    
    
    func buttonMaker(){
        // #frame setup
        buttonFrameSetup()
        
        // #image setup
        let addImage = UIImage(named: "offAddButton")
        addButton.setImage(addImage, for: UIControl.State.normal)
        addButton.setImage(addImage, for: UIControl.State.disabled)
        
        let angryImage = UIImage(named: "angry")
        angryButton.setImage(angryImage, for: UIControl.State.normal)
        angryButton.setImage(angryImage, for: UIControl.State.disabled)
        let depressedImage = UIImage(named: "depressed")
        depressedButton.setImage(depressedImage, for: UIControl.State.normal)
        depressedButton.setImage(depressedImage, for: UIControl.State.disabled)
        let happyImage = UIImage(named: "happy")
        happyButton.setImage(happyImage, for: UIControl.State.normal)
        happyButton.setImage(happyImage, for: UIControl.State.disabled)
        let sadImage = UIImage(named: "sad")
        sadButton.setImage(sadImage, for: UIControl.State.normal)
        sadButton.setImage(sadImage, for: UIControl.State.disabled)
        let sosoImage = UIImage(named: "soso")
        sosoButton.setImage(sosoImage, for: UIControl.State.normal)
        sosoButton.setImage(sosoImage, for: UIControl.State.disabled)
        
        // #action setup
        addButton.addTarget(self, action: #selector(addDiaryButton(sender:)), for: .touchUpInside)
        angryButton.addTarget(self, action: #selector(selectedEmotionButton(sender:)), for: .touchUpInside)
        depressedButton.addTarget(self, action: #selector(selectedEmotionButton(sender:)), for: .touchUpInside)
        happyButton.addTarget(self, action: #selector(selectedEmotionButton(sender:)), for: .touchUpInside)
        sadButton.addTarget(self, action: #selector(selectedEmotionButton(sender:)), for: .touchUpInside)
        sosoButton.addTarget(self, action: #selector(selectedEmotionButton(sender:)), for: .touchUpInside)
    }
    
    func buttonCentered(){
        angryButton.center = addButton.center
        depressedButton.center = addButton.center
        happyButton.center = addButton.center
        sadButton.center = addButton.center
        sosoButton.center = addButton.center
        mainView.bringSubviewToFront(addButton)
    }
    
    func buttonFrameSetup(){
        let allSize = CGSize(width: edge, height: edge)
        
        let addOrigin = CGPoint(x: mainView.frame.size.width/2-25, y: mainView.frame.size.height-100)
        addButton.frame = CGRect(origin: addOrigin, size: allSize)
        
        let angryOrigin = CGPoint(x: addOrigin.x-80, y: addOrigin.y)
        angryButton.frame = CGRect(origin: angryOrigin, size: allSize)
        angryButton.alpha = 1
        let depressedOrigin = CGPoint(x: addOrigin.x-55, y: addOrigin.y-55)
        depressedButton.frame = CGRect(origin: depressedOrigin, size: allSize)
        depressedButton.alpha = 1
        let happyOrigin = CGPoint(x: addOrigin.x, y: addOrigin.y-80)
        happyButton.frame = CGRect(origin: happyOrigin, size: allSize)
        happyButton.alpha = 1
        let sadOrigin = CGPoint(x: addOrigin.x+55, y: addOrigin.y-55)
        sadButton.frame = CGRect(origin: sadOrigin, size: allSize)
        sadButton.alpha = 1
        let sosoOrigin = CGPoint(x: addOrigin.x+80, y: addOrigin.y)
        sosoButton.frame = CGRect(origin: sosoOrigin, size: allSize)
        sosoButton.alpha = 1
    }
    
    @objc func addDiaryButton(sender: UIButton){
        if sender.currentImage == UIImage(named: "offAddButton"){
            addButton.isEnabled = false
            angryButton.isEnabled = false
            depressedButton.isEnabled = false
            happyButton.isEnabled = false
            sadButton.isEnabled = false
            sosoButton.isEnabled = false
            
            self.mainView.bringSubviewToFront(angryButton)
            self.mainView.bringSubviewToFront(depressedButton)
            self.mainView.bringSubviewToFront(happyButton)
            self.mainView.bringSubviewToFront(sadButton)
            self.mainView.bringSubviewToFront(sosoButton)
            
            UIView.animate(withDuration: aniTime, animations: {
                self.buttonFrameSetup()
            }) { (true) in
                self.addButton.isEnabled = true
                self.angryButton.isEnabled = true
                self.depressedButton.isEnabled = true
                self.happyButton.isEnabled = true
                self.sadButton.isEnabled = true
                self.sosoButton.isEnabled = true
                sender.setImage(UIImage(named: "onAddButton"), for: .normal)
            }
        }
        else{
            addButton.isEnabled = false
            angryButton.isEnabled = false
            depressedButton.isEnabled = false
            happyButton.isEnabled = false
            sadButton.isEnabled = false
            sosoButton.isEnabled = false
            sender.setImage(UIImage(named: "onAddButton"), for: .disabled)
            UIView.animate(withDuration: aniTime, animations: {
                self.buttonCentered()
                
                if self.selectedButton != self.angryButton{self.angryButton.alpha = 0}
                if self.selectedButton != self.depressedButton{self.depressedButton.alpha = 0}
                if self.selectedButton != self.happyButton{self.happyButton.alpha = 0}
                if self.selectedButton != self.sadButton{self.sadButton.alpha = 0}
                if self.selectedButton != self.sosoButton{self.sosoButton.alpha = 0}
                
            }) { (true) in
                self.addButton.isEnabled = true
                sender.setImage(UIImage(named: "offAddButton"), for: .normal)
            }
        }
    }
    
    @objc func selectedEmotionButton(sender: UIButton){
        selectedButton = sender
        if sender == angryButton{ backgroundColor = .angry}
        else if sender == depressedButton{ backgroundColor = .depressed}
        else if sender == happyButton{ backgroundColor = .happy}
        else if sender == sadButton{ backgroundColor = .sad}
        else{ backgroundColor = .soso}
        
        for i in 0..<icons.count{
            icons[i].image.alpha = 0.5
        }
        
        self.mainView.bringSubviewToFront(selectedButton)
        UIView.animate(withDuration: aniTime*2, animations: {
            self.addDiaryButton(sender: self.addButton)
        }) { (true) in
            UIView.animate(withDuration: self.aniTime*2.8, animations: {
                let newCenter = CGPoint(x: self.mainView.frame.midX, y: 100)
                self.selectedButton.center = newCenter
            }) { (true) in
                self.performSegue(withIdentifier: "createDiarySegue", sender: self.selectedButton)
            }
        }
        
    }
    
    private func gestureSetting(imageView : UIImageView){
        imageView.isUserInteractionEnabled = true
        
        oneTap = UITapGestureRecognizer(target: self, action: #selector(readEmotion(_:)))
        move = UIPanGestureRecognizer(target: self, action: #selector(moveIcon(_:)))
        
        oneTap?.delegate = self
        move?.delegate = self
        
        imageView.addGestureRecognizer(oneTap!)
        imageView.addGestureRecognizer(move!)
    }
    
    @objc func readEmotion(_ sender: UITapGestureRecognizer){
        
        selectedImage = sender.view as? UIImageView
        diaryOrder = selectedImage.tag
        
        if selectedImage.image == angryImage{emotionString = "angry"; backgroundColor = .angry}
        else if selectedImage.image == depressedImage{emotionString = "depressed"; backgroundColor = .depressed}
        else if selectedImage.image == happyImage{emotionString = "happy"; backgroundColor = .happy}
        else if selectedImage.image == sadImage{emotionString = "sad"; backgroundColor = .sad}
        else{emotionString = "soso"; backgroundColor = .soso}
        
        let chosenImage = UIImage(named: emotionString)
        let chosenImageView = UIImageView(image: chosenImage)
        
        self.performSegue(withIdentifier: "readDiarySegue", sender: chosenImageView)
    }
    
    @objc func moveIcon(_ sender:UIPanGestureRecognizer){
        let icon = sender.view!
        let iconOrder = icon.tag
        
        switch sender.state {
        case .began:
            moveView(icon, toSuperview: mainView)
            UIView.animate(withDuration: aniTime) {
                let trashImage = UIImage(named: "trashicon")
                self.addButton.setImage(trashImage, for: .normal)
                self.addButton.transform = self.addButton.transform.scaledBy(x: self.moveScale, y: self.moveScale)
                self.settingIcons()
            }
            
            icon.transform = icon.transform.scaledBy(x: moveScale, y: moveScale)
        case .changed:
            let location = sender.location(in: self.mainView)
            icon.center = location
        case .ended:
            icon.transform = icon.transform.scaledBy(x: 1/moveScale, y: 1/moveScale)
            UIView.animate(withDuration: aniTime) {
                let addImage = UIImage(named: "offAddButton")
                self.addButton.setImage(addImage, for: .normal)
                self.addButton.transform = self.addButton.transform.scaledBy(x: 1/self.moveScale, y: 1/self.moveScale)
            }
            
            let iconFrame = icon.superview!.convert(icon.frame, to: mainView)
            if checkPosition(iconFrame: iconFrame){
                moveView(icon, toSuperview: iconBoard)
                UIView.animate(withDuration: aniTime) {
                    self.settingIcons()
                }
            }
            else{
//                diaryModel.deleteEmotion(atIndex: iconOrder)
                
                icon.removeFromSuperview()
                icons.remove(at: iconOrder)
                for i in icons{
                    if i.image.tag > iconOrder{
                        i.image.tag -= 1
                    }
                }
                UIView.animate(withDuration: aniTime) {
                    self.settingIcons()
                }
            }
        default:
            break
        }
    }
    
    private func checkPosition(iconFrame: CGRect) -> Bool{
        let iconPosition = iconFrame.origin
        let iconSize = iconFrame.size
        let trashPosition = addButton.frame.origin
        let trashSize = addButton.frame.size
        return (iconPosition.x + iconSize.width < trashPosition.x) ||
            (iconPosition.y + iconSize.height < trashPosition.y) ||
            (iconPosition.x >= trashPosition.x + trashSize.width) ||
            (iconPosition.y >= trashPosition.y + trashSize.height)
    }
    
    //credit by Dr.Hannan - moveView function in Move Views project
    func moveView(_ view:UIView, toSuperview superView: UIView) {
        let newCenter = superView.convert(view.center, from: view.superview)
        view.center = newCenter
        superView.addSubview(view)
    }
    
    func saveInfoFromUser(emotion: UIButton, text: String) {
        
        mainView.addSubview(emotion)
        emotion.alpha = 0
        buttonCentered()
        
        for i in 0..<icons.count{
            icons[i].image.alpha = 1
        }
        
        if emotion == angryButton{emotionString = "angry"; backgroundColor = .angry}
        else if emotion == depressedButton{emotionString = "depressed"; backgroundColor = .depressed}
        else if emotion == happyButton{emotionString = "happy"; backgroundColor = .happy}
        else if emotion == sadButton{emotionString = "sad"; backgroundColor = .sad}
        else{emotionString = "soso"; backgroundColor = .soso}
        
//        let addingDiary = oneDiary(month: monthChangeButton.titleLabel!.text!, imageName: emotionString, text: text)
//        diaryModel.addEmotion(diary: addingDiary)
        
        let image = UIImage(named: emotionString)
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect.zero

        gestureSetting(imageView: imageView)
        
        imageView.tag = icons.count
        iconBoard.addSubview(imageView)
        
        let aDiary : OneDiary = OneDiary(month: monthChangeButton.titleLabel!.text!, image: imageView, text: text, color: backgroundColor!)
        icons.append(aDiary)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        
        case "createDiarySegue":
            let createController = segue.destination as! CreateDiaryController
            createController.configureWith(emotion: sender as! UIButton, color: backgroundColor!)
            createController.delegate = self
            
            let button = sender as! UIButton
            (segue as! OHCircleSegue).circleOrigin = button.center
            
            self.selectedButton = nil
            
        case "readDiarySegue":
            let readController = segue.destination as! ReadDiaryController
            readController.configureWith(emotion: sender as! UIImageView, text: icons[diaryOrder].text, color: icons[diaryOrder].color)
            break
            
        default:
            assert(false, "Unhandled Segue")
        }
        
    }
    
}
