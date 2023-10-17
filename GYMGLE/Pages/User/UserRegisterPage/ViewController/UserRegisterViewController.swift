import UIKit

class UserRegisterViewController: UIViewController {
    
    let pageTitle = "회원 등록"
    let buttonTitle = "등록하기"
    
    let cells = ["회원 이름","회원 전화번호","등록 기간","추가 정보"]
    let labelCells = ["등록 기간", "추가 정보"]
    let buttonCells = ["추가 정보"]
    let buttonText = ["성별"]
    
    
    let cellHeight = 45
    let emptyCellHeight = 24
    
    let viewConfigure = UserRegisterView()
    
    override func loadView() {
        viewConfigure.heightConfigure(cellHeight: cellHeight, emptyCellHeight: emptyCellHeight)
        viewConfigure.dataSourceConfigure(
            cells: cells,
            labels: labelCells,
            buttons: buttonCells,
            buttonText: buttonText
        )
        viewConfigure.label.text = pageTitle
        viewConfigure.button.setTitle(buttonTitle, for: .normal)
        
        view = viewConfigure
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        viewConfigure.button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        
    }
    
    override func viewWillAppear(_ animated: Bool) { // 네비게이션바 보여주기
        navigationController?.navigationBar.isHidden = false
    }

    
    @objc func buttonClicked(){
        print("buttonClicked")
        let nameCell = self.viewConfigure.tableView.subviews[6] as? UITableViewCell
        let nameTextField = nameCell?.contentView.subviews[1] as? UITextField
        guard let nameText = nameTextField?.text else { return }
        let phoneCell = self.viewConfigure.tableView.subviews[4] as? UITableViewCell
        let phoneTextField = phoneCell?.contentView.subviews[1] as? UITextField
        guard let phoneText = phoneTextField?.text else { return }
        
        DataManager.addGymUser(name: nameText, number: phoneText)
    }
}
