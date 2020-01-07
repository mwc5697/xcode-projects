//
//  oneDiary.swift
//  Emotion Diary
//
//  Created by Chung, MINHO on 11/23/19.
//  Copyright © 2019 Chung, MINHO. All rights reserved.
//



import Foundation

protocol Diary {
    var month : String {get}
    var imageName : String {get}
    var text : String {get set}
}

struct oneDiary : Diary, Codable{
    
    var month : String
    var imageName : String
    var text : String
    
    init(month: String, imageName: String, text: String) {
        self.month = month
        self.imageName = imageName
        self.text = text
        
    }
}
