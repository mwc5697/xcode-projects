//
//  ViewController.swift
//  Word Scramble
//
//  Created by Chung, MINHO on 9/1/19.
//  Copyright © 2019 Chung, MINHO. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let wordModel = WordModel()

    @IBOutlet weak var spellLabel: UILabel!
    @IBOutlet weak var correctionLabel: UILabel!
    @IBOutlet weak var outOfLabel: UILabel!
    @IBOutlet weak var letterSegment: UISegmentedControl!
    @IBOutlet weak var letterNumberSegment: UISegmentedControl!
    @IBOutlet weak var undoButton: UIButton!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var newWordButton: UIButton!
    
    enum PlayingStatus {
        case Ready, Playing, Done
    }
    
    var targetNum = 4
    var status: PlayingStatus = .Ready
    var selectedWord = ""
    var spellHistory:[Int] = []
    var correctedCheck = 0
    var numberOfCheck = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeEnability()
        
        // Do any additional setup after loading the view.
    }
    
    private func changeStatus(to: PlayingStatus){
        status = to
        changeEnability()
    }
    
    private func changeEnability(){
        switch status{
            case .Ready:
                undoButton.isEnabled = false
                checkButton.isEnabled = false
                letterSegment.isEnabled = false
                spellLabel.text = ""
                correctionLabel.text = ""
                outOfLabel.text = ""
            
            case .Playing:
                newWordButton.isEnabled = false
                letterSegment.isEnabled = true
                letterNumberSegment.isEnabled = false
            
            case .Done:
                undoButton.isEnabled = false
                checkButton.isEnabled = false
                letterSegment.isEnabled = false
                newWordButton.isEnabled = true
                letterNumberSegment.isEnabled = true
    
        }
    }
    
    @IBAction func undoButtonFunction(_ sender: Any) {
        //I deleted the last letter on spellLabel
        
        spellLabel.text = String((spellLabel.text!).dropLast())
        letterSegment.setEnabled(true, forSegmentAt: spellHistory[spellHistory.count-1])
        let _ = spellHistory.popLast()
        
        undoButton.isEnabled = spellHistory.count>0
        checkButton.isEnabled = spellHistory.count==targetNum
    }
    
    @IBAction func checkButtonFunction(_ sender: Any) {
        changeStatus(to: .Done)
        
        if wordModel.isDefined(spellLabel.text!) {correctionLabel.text = wordModel.randomCorrect ; correctedCheck += 1}
        else {correctionLabel.text = wordModel.randomIncorrect ; spellLabel.text = selectedWord}
        numberOfCheck += 1
        
        outOfLabel.text = "\(correctedCheck) out of \(numberOfCheck) Correct"
    }

    @IBAction func newWordButtonFunction(_ sender: Any) {
        changeStatus(to: .Playing)
        
        selectedWord = wordModel.randomWord
        let selectedWordCharactorArray:[Character] = [Character](selectedWord).shuffled()
        for i in 0..<targetNum {letterSegment.setTitle(String(selectedWordCharactorArray[i]), forSegmentAt: i)}
        
        spellHistory.removeAll()
        spellLabel.text = ""
        correctionLabel.text = ""
        outOfLabel.text = ""
        for i in 0..<targetNum {letterSegment.setEnabled(true, forSegmentAt: i)}
        
    }
    
    @IBAction func letterSegmentFunction(_ sender: Any) {
        
        let locationSegment = letterSegment.selectedSegmentIndex
        letterSegment.setEnabled(false, forSegmentAt: locationSegment)
        
        spellLabel.text = spellLabel.text! + letterSegment.titleForSegment(at: locationSegment)!
        
        spellHistory.append(locationSegment)
        
        letterSegment.selectedSegmentIndex = -1
        
        undoButton.isEnabled = spellHistory.count>0
        
        checkButton.isEnabled = spellHistory.count==targetNum
    }
    
    
    @IBAction func letterNumberSegmentFunction(_ sender: UISegmentedControl) {
        //change letterSegment to the number chosen
        //erase spellLabel
        //erase letterSegment
        changeStatus(to: .Ready)
        
        let chosenNumber = letterNumberSegment.selectedSegmentIndex
        if chosenNumber == 0 {targetNum = 4}
        if chosenNumber == 1 {targetNum = 5}
        if chosenNumber == 2 {targetNum = 6}
        
        letterSegment.removeAllSegments()
        for _ in 0..<targetNum {letterSegment.insertSegment(withTitle: "", at: 0, animated: false)}
        
        wordModel.setCurrentWordSize(newSize: targetNum)
        
        correctionLabel.text = ""
    }
    
    
    
}

