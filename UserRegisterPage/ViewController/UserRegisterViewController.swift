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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }
    
}
//
