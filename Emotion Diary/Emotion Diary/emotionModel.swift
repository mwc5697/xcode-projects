//
//  emotionModel.swift
//  Emotion Diary
//
//  Created by Chung, MINHO on 11/23/19.
//  Copyright © 2019 Chung, MINHO. All rights reserved.
//



import Foundation


class emotionModel {
    
    static let sharedInstance = emotionModel()
    
    typealias Diaries = [oneDiary]
    var emotions : Diaries
    var allEmotions : Diaries
    let destinationURL : URL
    
    fileprivate init() {
        let filename = "months"

        let fileManager = FileManager.default
        let documentURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        destinationURL =  documentURL.appendingPathComponent(filename + ".json")
        
        let fileExists = fileManager.fileExists(atPath: destinationURL.path)
        
        if !fileExists {
            let mainBundle = Bundle.main
            let emotionURL = mainBundle.url(forResource: filename, withExtension: "json")
            try! fileManager.copyItem(at: emotionURL!, to: destinationURL)
        }
            
        do {
            
            let data = try Data(contentsOf: destinationURL)
            
            let decoder = JSONDecoder()
            emotions = try decoder.decode(Diaries.self, from: data)
        } catch {
            print(error)
            emotions = []
        }
        
        allEmotions = emotions
    }
    
    func saveData() {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(emotions)
            try data.write(to: destinationURL)
        } catch {
            print("Error")
        }
    }
    
    var emotionCount : Int { get {return emotions.count}}
    
    func diary(atIndex i:Int) -> Diary {
        return emotions[i]
    }
    
    func addEmotion(diary:oneDiary) {
        emotions.append(diary)
        saveData()
    }
    
    func deleteEmotion(atIndex index:Int) {
        emotions.remove(at: index)
        saveData()
    }
    
    func filter(filter: String){
        emotions.removeAll()
        for i in allEmotions{
            if i.month == filter{
                emotions.append(i)
            }
        }
    }

}
