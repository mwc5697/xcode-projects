//
//  CreateDiaryController.swift
//  Emotion Diary
//
//  Created by Chung, MINHO on 11/24/19.
//  Copyright © 2019 Chung, MINHO. All rights reserved.
//

import UIKit

protocol infoDelegate : NSObject {
    func saveInfoFromUser(emotion: UIButton, text:String)
}

class CreateDiaryController: UIViewController {

    weak var delegate : infoDelegate?
    var backgroundColor : UIColor?
    var chosenIcon : UIButton?
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = backgroundColor
        textView.isEditable = true
        chosenIcon!.frame = CGRect(x: 182, y: 163, width: 50, height: 50)
        view.addSubview(chosenIcon!)
        // Do any additional setup after loading the view.
    }
    
    func configureWith(emotion: UIButton, color: UIColor){
        
        chosenIcon = emotion
        backgroundColor = color
        
    }
    
    @IBAction func addingAction(_ sender: Any) {
        delegate?.saveInfoFromUser(emotion: chosenIcon!, text: textView.text)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
