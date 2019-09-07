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
    
    // VARIABLES
    var apodoUno:String = ""
    var apodoDos:String = ""
    var correctAnswer:String = ""
    var questionArray = [String]()
    var score = 0
    var questionNumber = 10
    var currentPlayer = 0
    var scores = [0,0]
    
    // IBOUTLET
    @IBOutlet weak var gameNickDisplayOne: UILabel!
    @IBOutlet weak var gameNickDisplayTwo: UILabel!
    @IBOutlet weak var playerLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var countDownLabel: UILabel!
    @IBOutlet weak var optionA: UIButton!
    @IBOutlet weak var optionB: UIButton!
    @IBOutlet weak var optionC: UIButton!
    @IBOutlet weak var optionD: UIButton!
    @IBOutlet weak var scoreOneLabel: UILabel!
    @IBOutlet weak var scoreTwoLabel: UILabel!
    
    
    @IBAction func nextQuestion(_ sender: UIButton) {
        
        // Alerta fin de Partida
        if questionNumber == 1{
            let alert = UIAlertController(title: "FIN DE LA PARTIDA", message: "😎z", preferredStyle: .alert)
            
            let message = "\n😎"
            var messageMutableString = NSMutableAttributedString()
            messageMutableString = NSMutableAttributedString(string: message as String, attributes: [NSAttributedString.Key.font:UIFont(name: "Georgia", size: 45.0)!])
            alert.setValue(messageMutableString, forKey: "attributedMessage")
            
            let okAction =  UIAlertAction(title: "Reinicia Partida", style: .cancel){
                (action) in
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                
                let vc = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                self.present(vc, animated:true, completion:nil)
            }
            
            alert.addAction(okAction)
            self.present(alert, animated: true)
        }
        
        fetchApi()
        updatePlayer()
        changePlayer()
        
        questionNumber = questionNumber - 1
        countDownLabel.text = String(questionNumber)
        
        optionA.isEnabled = true
        optionB.isEnabled = true
        optionC.isEnabled = true
        optionD.isEnabled = true
    }
    
    
    // Llamada a Api
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
                    let question = item.question
                    let cleanQuestion = question.replacingOccurrences(of: "&quot;|\ns&#039;|\nacute;|\n&|\n&#039;s", with: "", options: .regularExpression, range: nil)
                    print(item.question)
                    DispatchQueue.main.async {
                        self.questionLabel.text = cleanQuestion//item.question
                    }
                    //print(item.incorrectAnswers)
                    self.questionArray.append(item.incorrectAnswers[0])
                    self.questionArray.append(item.incorrectAnswers[1])
                    self.questionArray.append(item.incorrectAnswers[2])
                    
                    print(item.correctAnswer)
                    self.correctAnswer = item.correctAnswer
                    self.questionArray.append(item.correctAnswer)
                    
                    self.questionArray.shuffle()
                    //print("+",self.questionArray)
                    
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
                }
            }
            catch {
                print(error)
            }
            }.resume()
    }
    
    //MARK:ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchApi()
        updatePlayer()
        // roundOne()
        
        optionA.addTarget(self, action: #selector(touchButton), for: .touchUpInside)
        optionB.addTarget(self, action: #selector(touchButton), for: .touchUpInside)
        optionC.addTarget(self, action: #selector(touchButton), for: .touchUpInside)
        optionD.addTarget(self, action: #selector(touchButton), for: .touchUpInside)
        self.scoreOneLabel.text = "\(self.score)"
        
        gameNickDisplayOne.text = apodoUno
        gameNickDisplayTwo.text = apodoDos
        countDownLabel.text = String(questionNumber)
        
    }
        
    @objc func touchButton(sender: UIButton) {
        print("Press Click")
        DispatchQueue.main.async {
            let correcta = self.correctAnswer
            let probable = sender.currentTitle!
            
            if correcta == probable {
                // Alerta cuando es Correcta
                let alert = UIAlertController(title: "¡CORRECTO!", message: "😃", preferredStyle: .alert)
                let message = "\n😃"
                var messageMutableString = NSMutableAttributedString()
                messageMutableString = NSMutableAttributedString(string: message as String, attributes: [NSAttributedString.Key.font:UIFont(name: "Georgia", size: 45.0)!])
                alert.setValue(messageMutableString, forKey: "attributedMessage")
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
                
                self.hit()
                
            }else{  // IF NOT WIN
                // Alerta cuando es NO Correcta
                let alert = UIAlertController(title: "¡INCORRECTO!", message: "😤", preferredStyle: .alert)
                let message = "\n😤"
                var messageMutableString = NSMutableAttributedString()
                messageMutableString = NSMutableAttributedString(string: message as String, attributes: [NSAttributedString.Key.font:UIFont(name: "Georgia", size: 45.0)!])
                alert.setValue(messageMutableString, forKey: "attributedMessage")
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
                
            }
        }
        optionA.isEnabled = false
        optionB.isEnabled = false
        optionC.isEnabled = false
        optionD.isEnabled = false
        
    }
    
    
    func updatePlayer(){
        var players = [apodoUno, apodoDos]
        playerLabel.text = players[currentPlayer]
        scoreOneLabel.text = "\(scores[0])"
        scoreTwoLabel.text = "\(scores[1])"
    }
    func changePlayer(){
        currentPlayer = 1 - currentPlayer
        updatePlayer()
        
    }
    
    func hit(){
        scores[currentPlayer]+=1
        updatePlayer()
    }
    
}
