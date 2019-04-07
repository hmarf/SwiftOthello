//
//  ViewController.swift
//  osero_test
//
//  Created by 岩崎孝佑 on 2019/03/30.
//  Copyright © 2019 Kosuke. All rights reserved.
//

import UIKit
import SwiftyJSON
import Foundation

class ViewController: UIViewController {

    var board = Board()
    var player = Player()
    
    var OnOff: String!
    var player_name: String!
    var boardsize: String!
    var size: Int!
    
    var Stone_count = 0
    let User_color = -1
    let Cpu_color = 1
    let urlCpu = URL(string: "http://192.168.1.4:5000/cpu_osero")!
    var buttonArray: [UIButton] = []
    let baseBoard = UIImage(named: "greenBoard")
    let white = UIImage(named: "white")
    let black = UIImage(named: "black")
    let available = UIImage(named: "availBoard")
    var resetButton = UIButton()
    var passButton = UIButton()
    var viewStoneCount = UILabel()
    
    class buttonClass: UIButton{
        let x: Int
        let y: Int
        init( x:Int, y:Int, frame: CGRect ) {
            self.x = x
            self.y = y
            super.init(frame:frame)
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("error")
        }
    }
    
    func createUI(){
        size = Int(self.boardsize)
        var y = 83
        board.start(size: size)
        let boxSize = (84 / (size!/4))
        print(boxSize)
        viewStoneCount.frame = CGRect(x: 18, y: 430, width: 330, height: 60)
        viewStoneCount.textAlignment = NSTextAlignment.center
        viewStoneCount.font = UIFont.systemFont(ofSize: 25)
        self.view.addSubview(viewStoneCount)
        for i in 0..<size!{
            var x = 19
            for j in 0..<size!{
                let button: UIButton = buttonClass(
                    x: i,
                    y: j,
                    frame:CGRect(x: x,y: y, width: boxSize,height: boxSize))
                button.addTarget(self, action: #selector(ViewController.pushed), for: .touchUpInside)
                self.view.addSubview(button)
                button.isEnabled = false
                buttonArray.append(button)
                x = x + boxSize + 1
            }
            y = y + boxSize + 1
        }
        resetButton.frame = CGRect(x: 125, y: 575, width: 125, height: 45)
        resetButton.addTarget(self, action: #selector(ViewController.pushResetButton), for: .touchUpInside)
        resetButton.isEnabled = false
        resetButton.isHidden = true
        resetButton.setTitle("RESET", for: .normal)
        resetButton.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        resetButton.setTitleColor(.white, for: .normal)
        resetButton.backgroundColor = UIColor(red: 0.3, green: 0.7, blue: 0.6, alpha: 1)
        resetButton.layer.cornerRadius = 25
        resetButton.layer.shadowOpacity = 0.5
        resetButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.view.addSubview(resetButton)
        
        passButton.frame = CGRect(x: 150, y: 500, width: 80, height: 30)
        passButton.addTarget(self, action: #selector(ViewController.pushPassButton), for: .touchUpInside)
        passButton.isEnabled = false
        passButton.isHidden = true
        passButton.setTitle("Pass", for: .normal)
        passButton.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        passButton.setTitleColor(.white, for: .normal)
        passButton.backgroundColor = UIColor(red: 0.3, green: 0.7, blue: 0.6, alpha: 1)
        passButton.layer.cornerRadius = 25
        passButton.layer.shadowOpacity = 0.5
        passButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.view.addSubview(passButton)
        drawBoard()
    }
    
    @objc func pushPassButton() {
        CpuTrun()
        passButton.isEnabled = false
        passButton.isHidden = true
    }
    
    @objc func pushResetButton() {
        board.reset()
        drawBoard()
        resetButton.isEnabled = false
        resetButton.isHidden = true
        passButton.isEnabled = false
        passButton.isHidden = true
    }
    
    @objc func pushed(mybtn: buttonClass){
        mybtn.isEnabled = false
        board.put(x: mybtn.x, y: mybtn.y, stone: User_color)
        drawBoard()
        if( board.gameOver() == true ){
            resetButton.isEnabled = true
            resetButton.isHidden = false
        }
        CpuTrun()
    }
    
    func CpuTrun() {
        if( OnOff == "OFF" ){
            self.CpuTurn_off()
        } else {
            self.CpuTurn_on()
        }
    }
    
    func CpuTurn_off() {
        if( board.available(stone: Cpu_color).count != 0 ){
            let xy = player.play(board: board, stone: Cpu_color)
            board.put(x: xy.0, y: xy.1, stone: Cpu_color)
            drawBoard()
            if( board.gameOver() == true ){
                resetButton.isHidden = false
                resetButton.isEnabled = true
            }
        }
        if( board.gameOver() == true ){
            resetButton.isHidden = false
            resetButton.isEnabled = true
        }
        if( board.available(stone: User_color).count == 0){
            passButton.isHidden = false
            passButton.isEnabled = true
        }
    }
    
    func CpuTurn_on(){
        if( board.available(stone: Cpu_color).count != 0 ){
            let xy = HTTPpython()
            DispatchQueue.main.asyncAfter(deadline: .now()+0.3, execute: {
                self.board.put(x: xy.0, y: xy.1, stone: self.Cpu_color)
                self.drawBoard()
                if( self.board.gameOver() == true ){
                    self.resetButton.isHidden = false
                    self.resetButton.isEnabled = true
                }
                if( self.board.gameOver() == true ){
                    self.resetButton.isHidden = false
                    self.resetButton.isEnabled = true
                }
                if( self.board.available(stone: self.User_color).count == 0){
                    self.passButton.isHidden = false
                    self.passButton.isEnabled = true
                }
            })
        }
    }
    
    func HTTPpython() -> (Int,Int){
        let condition = NSCondition()
        var xy:(Int,Int) = (-1,-1)
        let request = NSMutableURLRequest(url: urlCpu)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        var jsonObj = Dictionary<String,Any>()
        jsonObj["color"] = Cpu_color
        jsonObj["board"] = board.return_board()
        jsonObj["player_name"] = player_name
        do{
            request.httpBody = try! JSONSerialization.data(withJSONObject: jsonObj, options: .prettyPrinted)
            let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {(data,response,error) -> Void in
                condition.lock()
                xy = self.dataToint(data: data!)
                condition.signal()
                condition.unlock()
            })
            condition.lock()
            task.resume()
            condition.wait()
            condition.unlock()
        }
        return xy
    }
    
    func dataToint(data: Data) -> (Int,Int){
        var x:Int = -1
        var y:Int = -1
        let jsonXY = JSON(data)
        for i in 0..<4 {
            if( i == jsonXY["x"].int ){
                x = i
            }
            if( i == jsonXY["y"].int ){
                y = i
            }
        }
        return (x,y)
    }

    func drawBoard(){
        let stonecount = board.returnStone()
        viewStoneCount.text = "● Uer: " + String(stonecount.0) + "     ○ CPU: " + String(stonecount.1)
        var count = 0
        var _board = board.return_board()
        for y in 0..<size!{
            for x in 0..<size!{
                if( _board[y][x] == User_color ){
                    buttonArray[count].setImage(black, for: .normal)
                } else if( _board[y][x] == Cpu_color ){
                    buttonArray[count].setImage(white, for: .normal)
                } else {
                    buttonArray[count].setImage(baseBoard, for: .normal)
                }
                buttonArray[count].isEnabled = false
                count += 1
            }
        }
        let availableList = board.available(stone: User_color)
        for i in 0..<(availableList.count){
            let x = availableList[i][0]
            let y = availableList[i][1]
            buttonArray[x*size!+y].isEnabled = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.createUI()
    }
}

