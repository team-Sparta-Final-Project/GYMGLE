import UIKit
import FirebaseDatabase


final class UserRegisterDateViewController: UIViewController {
    
    let viewModel = UserRegisterViewModel()
    
    let buttonTitle = "등록"
    
    let cells = ["등록일","마감일","추가 정보","textView"]
    let labelCells = ["등록일","마감일","추가 정보"]
    let buttonText = ["날짜","날짜"]
    
    let userUid = "9CNxzPW1abevRkJTJPB9dvPRRZw2"
    
    var emptyUser = User(account: Account(id: "", password: "", accountType: 2), name: "", number: "", startSubscriptionDate: Date(), endSubscriptionDate: Date(), userInfo: "", isInGym: false, adminUid: "")
        
    var startCell:LabelCell = LabelCell()
    var endCell:LabelCell = LabelCell()
    var textViewCell:CustomTextCell = CustomTextCell()
    
    private var isEndDateEmpty = true
    
    var startDate = Date()
    var endDate = Date(timeIntervalSinceNow: 60*60*24*30)
    let viewConfigure = UserRegisterView()
    
    override func loadView() {
        cellTypeConfigure(cell: cells, labelOrder: labelCells, buttonText: buttonText)

        heightConfigure(height: 45, empty: 24)

        viewConfigure.button.setTitle(buttonTitle, for: .normal)
        
        viewConfigure.tableView.myDelegate = self
        
        view = viewConfigure
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.viewConfigure.button.backgroundColor = .lightGray
        self.viewConfigure.button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(endEdit))
        self.viewConfigure.addGestureRecognizer(tap)
        
        startCell.label.text = "등록일 : " + startDate.formatted(date:.complete, time: .omitted)
        
        viewModel.observe(uid: userUid)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        setCustomBackButton()
    }
    override func viewDidAppear(_ animated: Bool) {
        startCell.label.text = "등록일 : " + startDate.formatted(date:.complete, time: .omitted)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        viewConfigure.endEditing(true)
    }
}

// MARK: - extension custom func

private extension UserRegisterDateViewController {
    //updatedUser
    func userDataUpdate(completion: @escaping() -> Void) {
        if isEndDateEmpty {
            showToastStatic(message: "등록 마감 날짜가 지정되어 있지 않습니다.", view: self.view)
        }
        else {
            guard let info = self.textViewCell.textView.text else {return}
            viewModel.register(uid: userUid ,start: startDate, end: endDate, userInfo: info)
        }
    }
    
    func setCustomBackButton() {
        navigationController?.navigationBar.topItem?.title = "회원등록"
        navigationController?.navigationBar.tintColor = .black
    }
}

extension UserRegisterDateViewController {
    @objc private func endEdit(){
        self.view.endEditing(true)
    }
    
    //MARK: - 바텀시트
    @objc private func presentBottomSheetSetStartDate(){
        let bottomSheet = BottomSheetController(onlyDate: true)
        bottomSheet.delegate = self
        bottomSheet.date = startDate
        bottomSheet.endDate = endDate
        present(bottomSheet, animated: true)
    }
    
    @objc private func presentBottomSheetSetEndDate(){
        let bottomSheet = BottomSheetController(onlyDate: false)
        bottomSheet.delegate = self
        bottomSheet.minDate = startDate
        bottomSheet.date = endDate
        present(bottomSheet, animated: true)
    }
    
    
    
    @objc private func trainerRegister(){
        viewConfigure.textView.isHidden.toggle()
        
    }
    @objc private func buttonClicked(){
        DispatchQueue.main.async {
            self.userDataUpdate {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

extension UserRegisterDateViewController: BottomSheetControllerDelegate {
    func didClickDoneButton(date: Date, isOnlyDate: Bool) {
        if isOnlyDate {
            startCell.label.text = "등록일 : " + date.formatted(date:.complete, time: .omitted)
            self.startDate = date
        } else {
            endCell.label.text = "등록 기간 : " + date.formatted(date:.complete, time: .omitted)
            self.endDate = date
            self.isEndDateEmpty = false
        }
    }
    
}

extension UserRegisterDateViewController: UserTableViewDelegate {
    func textFieldTarget(cell: TextFieldCell) {

    }
    
    func textViewTarget(cell: CustomTextCell) {
        self.textViewCell = cell
    }
    
    func dateButtonTarget(cell: LabelCell, text:String) {
        if text == "등록일" {
            startCell = cell
            cell.CheckButton.addTarget(self, action: #selector(presentBottomSheetSetStartDate), for: .touchUpInside)
        }else if text == "마감일" {
            endCell = cell
            cell.CheckButton.addTarget(self, action: #selector(presentBottomSheetSetEndDate), for: .touchUpInside)
        }
        
    }
        
    func heightConfigure(height: Int, empty: Int) {
        viewConfigure.tableView.cellHeight = height
        viewConfigure.tableView.emptyCellHeight = empty
    }
    
    func cellTypeConfigure(cell: [String], labelOrder: [String], buttonText: [String]) {
        let maped = cell.map{ [$0] }
        let joined = Array(maped.joined(separator: [""]))
        viewConfigure.tableView.cellData = joined
        viewConfigure.tableView.labelCellData = labelOrder
        viewConfigure.tableView.buttonText = buttonText
    }
}

