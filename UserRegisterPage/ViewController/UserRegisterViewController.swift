import UIKit

class UserRegisterViewController: UIViewController {
    
    let pageTitle = "회원 등록"
    let buttonTitle = "등록"
    
    let cells = ["회원 이름","회원 전화번호","회원 아이디","회원 비밀번호","등록 기간","추가 정보"]
    let labelCells = ["등록 기간", "추가 정보"]
    let buttonCells = ["회원 전화번호","회원 아이디"]
    let buttonText = ["확인","중복 확인"]
    
    
    let cellHeight = 45
    let emptyCellHeight = 24
    
    override func loadView() {
        let viewConfigure = UserRegisterView()
        
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
        
//        view = AdminRegisterView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
