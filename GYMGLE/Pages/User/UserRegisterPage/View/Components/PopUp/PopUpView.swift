
import UIKit

class PopUpView: UIView {
    var endDateClosure: ((_ date:Date) -> ())?
    
    lazy var backView = UIView().then{
        $0.backgroundColor = .black.withAlphaComponent(CGFloat(0.1))
    }
    lazy var contentView = UIView().then{
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 30
    }
    lazy var datePicker = UIDatePicker().then{
        $0.subviews[0].subviews[0].subviews[0].isHidden = true
        $0.subviews[0].subviews[0].subviews[1].subviews[0].isHidden = true

        $0.minimumDate = .now
        $0.locale = Locale(identifier: "ko-KR")
        $0.datePickerMode = .date
        $0.preferredDatePickerStyle = .compact
        $0.tintColor = ColorGuide.main
    }
    lazy var button = UIButton(type: .system).then{
        $0.setTitle("입력", for: .normal)
    }
    lazy var buttonMonth = UIButton(type: .system).then{
        $0.setTitle("1달", for: .normal)
    }
    lazy var buttonMonthSix = UIButton(type: .system).then{
        $0.setTitle("6달", for: .normal)
    }

    
    
    lazy var label = UILabel()

    
    override init(frame: CGRect) {
        super .init(frame: frame)
        self.backgroundColor = .clear
        
        self.addSubview(backView)
        backView.snp.makeConstraints{
            $0.top.bottom.left.right.equalToSuperview()
        }

        self.addSubview(contentView)
        contentView.snp.makeConstraints{
            $0.top.bottom.equalToSuperview().inset(255)
            $0.left.right.equalToSuperview().inset(20)
        }
        
        contentView.addSubview(datePicker)
        datePicker.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(30)
        }
        
        contentView.addSubview(label)
        label.snp.makeConstraints{
            $0.centerX.equalTo(datePicker)
            $0.top.equalTo(datePicker)
        }
        
        
        contentView.addSubview(button)
        button.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(30)
        }
        
        
        contentView.addSubview(buttonMonth)
        buttonMonth.snp.makeConstraints{
            $0.center.equalToSuperview()
        }

        configure()
        
        
                
    }
    
    
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    private func configure(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissPopUp))
        self.backView.addGestureRecognizer(tap)
        
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        buttonMonth.addTarget(self, action: #selector(buttonMonthTapped), for: .touchUpInside)
        
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
    }
    
    @objc func dismissPopUp(){
        self.removeFromSuperview()
    }
    
    @objc func buttonMonthTapped(){
        let newDate = Date(timeInterval: 60*60*24*31, since: datePicker.date)
        
        datePicker.date = newDate
        self.label.text = datePicker.date.formatted(date:.complete, time: .omitted)
    }
    
    @objc func buttonTapped(){
        
        let temp = superview
                
        let sub = temp?.subviews[2] as? UITableView
        
        let cell = sub?.visibleCells[6] as? UITableViewCell
        
        let cellLabel = cell?.subviews[0].subviews[0] as? UILabel
        
        cellLabel?.text = "등록 마감 : " + datePicker.date.formatted(date:.complete, time: .omitted)
        
        endDateClosure!(datePicker.date)
        
        self.removeFromSuperview()
    }
    
    @objc func dateChanged(_ sender: UIDatePicker){
        self.label.text = sender.date.formatted(date:.complete, time: .omitted)
    }




}
