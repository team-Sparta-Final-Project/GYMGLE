//
//  BottomSheetController.swift
//  GYMGLE
//
//  Created by t2023-m0078 on 2023/10/26.
//

import UIKit

protocol BottomSheetControllerDelegate {
    func didClickDoneButton(date: Date, isOnlyDate: Bool)
}

class BottomSheetController: UIViewController {
    
    var isOnlyDate = false
    
    init(onlyDate:Bool){
        isOnlyDate = onlyDate
        super .init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var sheetView = BottomSheetView()
    var sheetViewDateOnly = BottomSheetViewDateOnly()
    var delegate: BottomSheetControllerDelegate?
    
    var date = Date()
    
    override func loadView() {
        if isOnlyDate {
            self.view = sheetViewDateOnly
        }else{
            self.view = sheetView
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let sheet = self.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        
        if isOnlyDate {
            sheetViewDateOnly.datePicker.minimumDate = date
            sheetViewDateOnly.doneButton.addTarget(self, action: #selector(clickedDoneButton), for: .touchUpInside)
        }else{
            clickedMonthButton()
            didChangeDate()
            
            sheetView.datePicker.minimumDate = date
            sheetView.doneButton.addTarget(self, action: #selector(clickedDoneButton), for: .touchUpInside)
            sheetView.monthButton.addTarget(self, action: #selector(clickedMonthButton), for: .touchUpInside)
            sheetView.month3Button.addTarget(self, action: #selector(clickedMonth3Button), for: .touchUpInside)
            sheetView.month6Button.addTarget(self, action: #selector(clickedMonth6Button), for: .touchUpInside)
            sheetView.month12Button.addTarget(self, action: #selector(clickedMonth12Button), for: .touchUpInside)
            sheetView.datePicker.addTarget(self, action: #selector(didChangeDate), for: .valueChanged)
        }
    }
    
    @objc private func clickedDoneButton(){
        print("테스트 - 눌리냐")
        if isOnlyDate {
            delegate?.didClickDoneButton(date: sheetViewDateOnly.datePicker.date, isOnlyDate: isOnlyDate)
        }else{
            delegate?.didClickDoneButton(date: sheetView.datePicker.date, isOnlyDate: isOnlyDate)
        }
        dismiss(animated: true)
    }
    
    @objc private func clickedMonthButton(){
        sheetView.datePicker.date = date.addingTimeInterval(60*60*24*30)
        sheetView.monthButton.layer.borderColor = ColorGuide.main.cgColor
        sheetView.month3Button.layer.borderColor = ColorGuide.shadowBorder.cgColor
        sheetView.month6Button.layer.borderColor = ColorGuide.shadowBorder.cgColor
        sheetView.month12Button.layer.borderColor = ColorGuide.shadowBorder.cgColor
    }
    @objc private func clickedMonth3Button(){
        sheetView.datePicker.date = date.addingTimeInterval(60*60*24*30*3)
        sheetView.monthButton.layer.borderColor = ColorGuide.shadowBorder.cgColor
        sheetView.month3Button.layer.borderColor = ColorGuide.main.cgColor
        sheetView.month6Button.layer.borderColor = ColorGuide.shadowBorder.cgColor
        sheetView.month12Button.layer.borderColor = ColorGuide.shadowBorder.cgColor
    }
    @objc private func clickedMonth6Button(){
        sheetView.datePicker.date = date.addingTimeInterval(60*60*24*30*6)
        sheetView.monthButton.layer.borderColor = ColorGuide.shadowBorder.cgColor
        sheetView.month3Button.layer.borderColor = ColorGuide.shadowBorder.cgColor
        sheetView.month6Button.layer.borderColor = ColorGuide.main.cgColor
        sheetView.month12Button.layer.borderColor = ColorGuide.shadowBorder.cgColor
    }
    @objc private func clickedMonth12Button(){
        sheetView.datePicker.date = date.addingTimeInterval(60*60*24*365)
        sheetView.monthButton.layer.borderColor = ColorGuide.shadowBorder.cgColor
        sheetView.month3Button.layer.borderColor = ColorGuide.shadowBorder.cgColor
        sheetView.month6Button.layer.borderColor = ColorGuide.shadowBorder.cgColor
        sheetView.month12Button.layer.borderColor = ColorGuide.main.cgColor
    }
    @objc private func didChangeDate(){
        if sheetView.datePicker.date.formatted(date: .numeric, time: .omitted) == date.addingTimeInterval(60*60*24*30).formatted(date: .numeric, time: .omitted) {
            sheetView.monthButton.layer.borderColor = ColorGuide.main.cgColor
            sheetView.month3Button.layer.borderColor = ColorGuide.shadowBorder.cgColor
            sheetView.month6Button.layer.borderColor = ColorGuide.shadowBorder.cgColor
            sheetView.month12Button.layer.borderColor = ColorGuide.shadowBorder.cgColor
        }else if sheetView.datePicker.date.formatted(date: .numeric, time: .omitted) == date.addingTimeInterval(60*60*24*30*3).formatted(date: .numeric, time: .omitted) {
            sheetView.monthButton.layer.borderColor = ColorGuide.shadowBorder.cgColor
            sheetView.month3Button.layer.borderColor = ColorGuide.main.cgColor
            sheetView.month6Button.layer.borderColor = ColorGuide.shadowBorder.cgColor
            sheetView.month12Button.layer.borderColor = ColorGuide.shadowBorder.cgColor
        }else if sheetView.datePicker.date.formatted(date: .numeric, time: .omitted) == date.addingTimeInterval(60*60*24*30*6).formatted(date: .numeric, time: .omitted) {
            sheetView.monthButton.layer.borderColor = ColorGuide.shadowBorder.cgColor
            sheetView.month3Button.layer.borderColor = ColorGuide.shadowBorder.cgColor
            sheetView.month6Button.layer.borderColor = ColorGuide.main.cgColor
            sheetView.month12Button.layer.borderColor = ColorGuide.shadowBorder.cgColor
        }else if sheetView.datePicker.date.formatted(date: .numeric, time: .omitted) == date.addingTimeInterval(60*60*24*365).formatted(date: .numeric, time: .omitted) {
            sheetView.monthButton.layer.borderColor = ColorGuide.shadowBorder.cgColor
            sheetView.month3Button.layer.borderColor = ColorGuide.shadowBorder.cgColor
            sheetView.month6Button.layer.borderColor = ColorGuide.shadowBorder.cgColor
            sheetView.month12Button.layer.borderColor = ColorGuide.main.cgColor
        }else {
            sheetView.monthButton.layer.borderColor = ColorGuide.shadowBorder.cgColor
            sheetView.month3Button.layer.borderColor = ColorGuide.shadowBorder.cgColor
            sheetView.month6Button.layer.borderColor = ColorGuide.shadowBorder.cgColor
            sheetView.month12Button.layer.borderColor = ColorGuide.shadowBorder.cgColor
            
        }
    }
    
    
}
