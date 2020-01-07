//
//  ReadDiaryController.swift
//  Emotion Diary
//
//  Created by Chung, MINHO on 11/24/19.
//  Copyright © 2019 Chung, MINHO. All rights reserved.
//

import UIKit

class ReadDiaryController: UIViewController {

    var emotionImage : UIImageView?
    var story : String?
    var backgroundColor : UIColor?
    @IBOutlet weak var textField: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = backgroundColor
        
        emotionImage!.frame = CGRect(x: 182, y: 163, width: 50, height: 50)
        view.addSubview(emotionImage!)
        
        textField.text = story
        // Do any additional setup after loading the view.
    }
    
    
    func configureWith(emotion: UIImageView, text: String, color: UIColor){
        
        emotionImage = emotion
        story = text
        backgroundColor = color
        
    }

    @IBAction func backAction(_ sender: Any) {
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
