import UIKit

class UserRegisterViewIDPWController: UIViewController {
    
    let pageTitle = "회원 등록"
    let buttonTitle = "등록하기"
    
    let cells = ["회원 아이디","회원 비밀번호"]
    let labelCells = [""]
    let buttonCells = ["회원 아이디"]
    let buttonText = ["중복 확인"]
    
    
    let cellHeight = 45
    let emptyCellHeight = 24
    
    let viewConfigure = UserRegisterView()
    
    
    
    override func loadView() {
        viewConfigure.textView.isHidden = true
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
//        let nameCell = self.viewConfigure.tableView.subviews[6] as? UITableViewCell
//        let nameTextField = nameCell?.contentView.subviews[1] as? UITextField
//        guard let nameText = nameTextField?.text else { return }
//        let phoneCell = self.viewConfigure.tableView.subviews[4] as? UITableViewCell
//        let phoneTextField = phoneCell?.contentView.subviews[1] as? UITextField
//        guard let phoneText = phoneTextField?.text else { return }
        
//        DataManager.addGymUser(name: nameText, number: phoneText)
//        navigationController?.popToRootViewController(animated: true)
        
        let adminRootVC = navigationController!.viewControllers[2]
        navigationController?.popToViewController(adminRootVC, animated: true)
        
    }
    
    
}
