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
    // TODO: 등록일 > 등록 마감일 이면 토스트창 출력하기
    var isOnlyDate = false
    
    typealias Closure = () -> ()
    
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
    
    var minDate = Date()
    var date = Date()
    var endDate = Date()
    
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
            sheetViewDateOnly.datePicker.date = date
            sheetViewDateOnly.datePicker.minimumDate = minDate
            sheetViewDateOnly.datePicker.maximumDate = endDate
            sheetViewDateOnly.doneButton.addTarget(self, action: #selector(clickedDoneButton), for: .touchUpInside)
        }else{
            sheetView.datePicker.date = date
            
            sheetView.datePicker.minimumDate = minDate
            sheetView.doneButton.addTarget(self, action: #selector(clickedDoneButton), for: .touchUpInside)
            sheetView.monthButton.addTarget(self, action: #selector(clickedMonthButton), for: .touchUpInside)
            sheetView.month3Button.addTarget(self, action: #selector(clickedMonth3Button), for: .touchUpInside)
            sheetView.month6Button.addTarget(self, action: #selector(clickedMonth6Button), for: .touchUpInside)
            sheetView.month12Button.addTarget(self, action: #selector(clickedMonth12Button), for: .touchUpInside)
            sheetView.datePicker.addTarget(self, action: #selector(didChangeDate), for: .valueChanged)
        }
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        didChangeDate()
    }
    
    @objc private func clickedDoneButton(){
        
        if isOnlyDate {
            delegate?.didClickDoneButton(date: sheetViewDateOnly.datePicker.date, isOnlyDate: isOnlyDate)
        }else{
            delegate?.didClickDoneButton(date: sheetView.datePicker.date, isOnlyDate: isOnlyDate)
        }
        dismiss(animated: true)
    }
    
    @objc private func clickedMonthButton(){
        sheetView.datePicker.date = minDate.addingTimeInterval(60*60*24*30)
        sheetView.monthButton.selectAnim()
        sheetView.month3Button.deselectAnim()
        sheetView.month6Button.deselectAnim()
        sheetView.month12Button.deselectAnim()
    }
    @objc private func clickedMonth3Button(){
        sheetView.datePicker.date = minDate.addingTimeInterval(60*60*24*30*3)
        sheetView.monthButton.deselectAnim()
        sheetView.month3Button.selectAnim()
        sheetView.month6Button.deselectAnim()
        sheetView.month12Button.deselectAnim()
    }
    @objc private func clickedMonth6Button(){
        sheetView.datePicker.date = minDate.addingTimeInterval(60*60*24*30*6)
        sheetView.monthButton.deselectAnim()
        sheetView.month3Button.deselectAnim()
        sheetView.month6Button.selectAnim()
        sheetView.month12Button.deselectAnim()
    }
    @objc private func clickedMonth12Button(){
        sheetView.datePicker.date = minDate.addingTimeInterval(60*60*24*365)
        sheetView.monthButton.deselectAnim()
        sheetView.month3Button.deselectAnim()
        sheetView.month6Button.deselectAnim()
        sheetView.month12Button.selectAnim()
    }
    @objc private func didChangeDate(){
        if sheetView.datePicker.date.formatted(date: .numeric, time: .omitted) == minDate.addingTimeInterval(60*60*24*30).formatted(date: .numeric, time: .omitted) {
            sheetView.monthButton.selectAnim()
            sheetView.month3Button.deselectAnim()
            sheetView.month6Button.deselectAnim()
            sheetView.month12Button.deselectAnim()
        }else if sheetView.datePicker.date.formatted(date: .numeric, time: .omitted) == minDate.addingTimeInterval(60*60*24*30*3).formatted(date: .numeric, time: .omitted) {
            sheetView.monthButton.deselectAnim()
            sheetView.month3Button.selectAnim()
            sheetView.month6Button.deselectAnim()
            sheetView.month12Button.deselectAnim()
        }else if sheetView.datePicker.date.formatted(date: .numeric, time: .omitted) == minDate.addingTimeInterval(60*60*24*30*6).formatted(date: .numeric, time: .omitted) {
            sheetView.monthButton.deselectAnim()
            sheetView.month3Button.deselectAnim()
            sheetView.month6Button.selectAnim()
            sheetView.month12Button.deselectAnim()
        }else if sheetView.datePicker.date.formatted(date: .numeric, time: .omitted) == minDate.addingTimeInterval(60*60*24*365).formatted(date: .numeric, time: .omitted) {
            sheetView.monthButton.deselectAnim()
            sheetView.month3Button.deselectAnim()
            sheetView.month6Button.deselectAnim()
            sheetView.month12Button.selectAnim()
        }else {
            sheetView.monthButton.deselectAnim()
            sheetView.month3Button.deselectAnim()
            sheetView.month6Button.deselectAnim()
            sheetView.month12Button.deselectAnim()
            
        }
    }
}
