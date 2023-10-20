import UIKit

class UserManageViewController: UIViewController {
    
    let pageTitle = "회원 관리"
    let buttonTitle = "등록하기"
    
    var cells:[User] = []
    var phones = ["","","",""]
    
    let cellHeight = 45
    
    override func loadView() {
        
        let viewConfigure = UserManageView()
        
        cells = DataManager.shared.gymInfo.gymUserList
        
        viewConfigure.dataSourceConfigure(cells: cells)
        viewConfigure.label.text = pageTitle
//        viewConfigure.button.setTitle(buttonTitle, for: .normal)
        
        view = viewConfigure
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
    }
    
    override func viewWillAppear(_ animated: Bool) { // 네비게이션바 보여주기
        navigationController?.navigationBar.isHidden = false
    }

}
