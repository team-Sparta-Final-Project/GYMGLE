import UIKit

class CustomButton: UIButton {
    required init(title:String) {
        super .init(frame: .zero)
        
        self.setTitleColor(.black, for: .normal)
        self.setTitle(title, for: .normal)
        self.backgroundColor = .white
        self.layer.cornerRadius = 12
        self.layer.borderWidth = 1.0
        self.layer.borderColor = ColorGuide.shadowBorder.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func selectAnim(){
        UIView.animate(withDuration: 0.3) {
            self.layer.borderColor = ColorGuide.main.cgColor
        }
    }
    func deselectAnim(){
        UIView.animate(withDuration: 0.3) {
            self.layer.borderColor = ColorGuide.shadowBorder.cgColor
        }
    }
    
}
