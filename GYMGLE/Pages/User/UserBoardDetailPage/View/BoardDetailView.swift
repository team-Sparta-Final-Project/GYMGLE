import UIKit
import SnapKit

class BoardDetailView: UIView {
    
    let tableView = BoardDetailTableView()
//    let contentView = BoardDetailContentView()
    let commentSection = BoardDetailCommentSection()
        
    override init(frame: CGRect) {
        super .init(frame: frame)
        
        self.backgroundColor = ColorGuide.background
        
        
        //MARK: - main
    
        self.addSubview(commentSection)
        commentSection.snp.makeConstraints{
            $0.bottom.equalTo(self.keyboardLayoutGuide.snp.top)
            $0.left.right.equalToSuperview()
        }
        
        self.addSubview(tableView)
        tableView.snp.makeConstraints{
            $0.top.equalToSuperview().inset(52)
            $0.bottom.equalTo(commentSection.snp.top)
            $0.left.right.equalToSuperview()
        }
        
    }
    
    //MARK: - 업데이트 뷰
    
//    override func updateConstraints() {
//
//    }
    
    
    //MARK: - 키보드
    
    func addKeyboardNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardNotification(){
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillAppear(_ noti: NSNotification){
        print("테스트 - up")
    }
    @objc func keyboardWillDisappear(_ noti: NSNotification){
        print("테스트 - down")
    }
    

    
    
    deinit{
        removeKeyboardNotification()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
