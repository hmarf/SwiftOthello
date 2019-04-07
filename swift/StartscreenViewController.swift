//
//  StartscreenViewController.swift
//  osero_test
//
//  Created by 岩崎孝佑 on 2019/04/05.
//  Copyright © 2019 Kosuke. All rights reserved.
//

import UIKit

class StartscreenViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var pickerView = UIPickerView()
    var pickerBoard = UIPickerView()
    var submitButton = UIButton()
    var label = UILabel()
    
    var player_name: String = ""
    var OnOff:String = ""
    var boardsize:String = ""
    
    var onoff = ["ON Line","OFF Line"]
    var dataList:[String] = []
    let OnLine = ["Random","CountStone","Naive"]
    let OffLine = ["Random"]
    let onBoardsize = ["4"]
    let offBoardsize = ["4","8","12"]
    var Boardsize:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createSegmented()
    }
    
    func createSegmented() {
        let segmented = UISegmentedControl(items: onoff as [AnyObject])
        segmented.frame = CGRect(x: 104, y: 50, width: 167, height: 40)
        segmented.backgroundColor = UIColor.gray
        segmented.tintColor = UIColor.white
        segmented.addTarget(self, action: #selector(StartscreenViewController.pushSegmented), for: UIControl.Event.valueChanged)
        self.view.addSubview(segmented)
    }
    
    func SelectandSubmit() {
        
        submitButton.frame = CGRect(x: 125, y: 575, width: 125, height: 45)
        submitButton.addTarget(self, action: #selector(StartscreenViewController.pushSubmitButton), for: .touchUpInside)
        submitButton.setTitle("SUBMIT", for: .normal)
        submitButton.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.backgroundColor = UIColor(red: 0.3, green: 0.7, blue: 0.6, alpha: 1)
        submitButton.layer.cornerRadius = 25
        submitButton.layer.shadowOpacity = 0.5
        submitButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        
        pickerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 150)
        pickerView.tag = 0
        pickerView.backgroundColor = UIColor(red: 0.69, green: 0.93, blue: 0.9, alpha: 1.0)
        pickerView.center = self.view.center
        pickerView.delegate = self
        pickerView.dataSource = self
        
        let yPosition = pickerView.frame.origin.y
        pickerBoard.frame = CGRect(x: 0, y: yPosition + 200, width: self.view.frame.width, height: 100)
        pickerView.tag = 1
        pickerBoard.backgroundColor = UIColor(red: 0.69, green: 0.93, blue: 0.9, alpha: 1.0)
        pickerBoard.delegate = self
        pickerBoard.dataSource = self
        
        label.frame = CGRect(x: 0, y: yPosition - 100, width: self.view.frame.width, height: 100)
        label.numberOfLines = 2
        label.text = "Select CPU player"
        label.font = UIFont.systemFont(ofSize: 36)
        label.textAlignment = NSTextAlignment.center
        
        self.view.addSubview(submitButton)
        self.view.addSubview(pickerBoard)
        self.view.addSubview(pickerView)
        self.view.addSubview(label)
    }
    
    @objc func pushSegmented(segcon: UISegmentedControl){
        switch segcon.selectedSegmentIndex {
        case 0:
            OnOff = "ON"
            dataList = OnLine
            Boardsize = onBoardsize
            SelectandSubmit()
        default:
            OnOff = "OFF"
            dataList = OffLine
            Boardsize = offBoardsize
            SelectandSubmit()
        }
    }
    
    @objc func pushSubmitButton(){
        self.performSegue(withIdentifier: "toMain", sender: player_name)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMain" {
            let ViewController = segue.destination as! ViewController
            ViewController.player_name = self.player_name
            ViewController.OnOff = self.OnOff
            ViewController.boardsize = self.boardsize
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        if( pickerView.tag == 1){
            return dataList.count
        } else{
            return Boardsize.count
        }
    }

    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        if( pickerView.tag == 1 ){
            player_name = dataList[row]
            return dataList[row]
        } else{
            boardsize = Boardsize[row]
            return Boardsize[row]
        }
    }

    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        if( pickerView.tag == 1 ){
            label.text = dataList[row]
            player_name = dataList[row]
        } else{
            boardsize = Boardsize[row]
        }
    }
}
