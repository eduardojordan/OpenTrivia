//
//  GameVC.swift
//  OpenT
//
//  Created by MAC on 04/09/2019.
//  Copyright © 2019 EdJordan. All rights reserved.
//

import UIKit

class GameVC: UIViewController {
    
    
    struct TriviaQuestion: Codable {
        let responseCode: Int
        let results: [Result]
    }
    
    
    struct Result: Codable {
        let category, type, difficulty, question: String
        let correctAnswer: String
        let incorrectAnswers: [String]
    }
    
    var apodoUno:String = ""
    var apodoDos:String = ""
    
    @IBOutlet weak var gameNickDisplayOne: UILabel!
    @IBOutlet weak var gameNickDisplayTwo: UILabel!
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var optionA: UIButton!
    @IBOutlet weak var optionB: UIButton!
    @IBOutlet weak var optionC: UIButton!
    @IBOutlet weak var optionD: UIButton!
    
    
    @IBAction func nextQuestion(_ sender: UIButton) {
        fetchApi()
    }
    
    var questionArray = [String]()
    
    func fetchApi(){
        let urlPath = "https://opentdb.com/api.php?amount=10&type=multiple"
        let apiURL = URL(string: urlPath)!
        
        URLSession.shared.dataTask(with: apiURL) { (data, response, error) in
            guard let data = data else {return}
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let json =  try decoder.decode(TriviaQuestion.self, from: data)
                
                for item in json.results{
                    print(item.question)
                    DispatchQueue.main.async {
                        self.questionLabel.text = item.question
                    }
                    //  self.questionLabel.text = item.question
                    print(item.incorrectAnswers)
                    self.questionArray.append(item.incorrectAnswers[0])
                    self.questionArray.append(item.incorrectAnswers[1])
                    self.questionArray.append(item.incorrectAnswers[2])
                    
                    print(item.correctAnswer)
                    self.questionArray.append(item.correctAnswer)
                    
                    self.questionArray.shuffle()
                    print("+",self.questionArray)
                    
                    let text1 = self.questionArray[0]
                    let text2 = self.questionArray[1]
                    let text3 = self.questionArray[2]
                    let text4 = self.questionArray[3]
                    
                    DispatchQueue.main.async {
                        self.optionA.setTitle(text1, for: .normal)
                        self.optionB.setTitle(text2, for: .normal)
                        self.optionC.setTitle(text3, for: .normal)
                        self.optionD.setTitle(text4, for: .normal)
                    }
                    
                    self.questionArray.removeAll()
                    
                    //***** Pendiente *******
                    // REGRESIVE COUNT 10
                    // COUNT + WHEN SELECT CORRECT ANSWER
                    // INCREMENT PUNTUATION
                    // Contraints
                    
                }
                
            }
            catch {
                print(error)
            }
            }.resume()
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchApi()
        
        gameNickDisplayOne.text = apodoUno
        gameNickDisplayTwo.text = apodoDos
        
        
        
        
    }
    
}
