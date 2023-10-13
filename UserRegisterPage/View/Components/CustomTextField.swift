import UIKit


class CustomTextField: UITextField {
    override init(frame: CGRect) {
        super .init(frame: frame)
        
        self.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}

extension CustomTextField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("테스트 - 수정시작됨")
        print(textField.text)
        
    }
    
    
}
//
//// MARK: - UITextFieldDelegate
//
//extension CustomTextField: UITextFieldDelegate {
//    // 텍스트필드 터치시 플레이스홀더 텍스트 사라짐
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        if textField == emailTextField && textField.placeholder == emailPlaceholder {
//            textField.placeholder = ""
//
//        } else if textField == nameTextField && textField.placeholder == namePlaceholder {
//            textField.placeholder = ""
//
//        } else if textField == passwordTextField && textField.placeholder == passwordPlaceholder {
//            textField.placeholder = ""
//
//        } else if textField == passwordCheckTextField && textField.placeholder == passwordCheckPlaceholder {
//            textField.placeholder = ""
//        }
//    }
//
//    func textFieldDidEndEditing(_ textfield: UITextField) {
//        if textfield == emailTextField && (textfield.text?.isEmpty ?? true) {
//            textfield.placeholder = emailPlaceholder
//
//        } else if textfield == nameTextField && (textfield.text?.isEmpty ?? true) {
//            textfield.placeholder = namePlaceholder
//
//        } else if textfield == passwordTextField && (textfield.text?.isEmpty ?? true) {
//            textfield.placeholder = passwordPlaceholder
//
//        } else if textfield == passwordCheckTextField && (textfield.text?.isEmpty ?? true) {
//            textfield.placeholder = passwordCheckPlaceholder
//        }
//    }
//
//    // 키보드 엔터버튼 return으로 변경, return 버튼 누를시 키보드 내려감
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//
//        dismiss(animated: true, completion: nil)
//
//        return true
//    }
//
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if textField == passwordTextField || textField == passwordCheckTextField, !string.isEmpty {
//            let allowedCharacters = CharacterSet.alphanumerics
//
//            let characterSet = CharacterSet(charactersIn: string)
//
//            return allowedCharacters.isSuperset(of: characterSet)
//        }
//
//        return true
//    }
//
//    // 비밀번호와 비밀번호 확인 일치할때 텍스트 색변화
//    func textFieldDidChangeSelection(_ textField: UITextField) {
//        if textField == passwordCheckTextField {
//            if passwordTextField.text == passwordCheckTextField.text {
//                passwordCheckTextField.backgroundColor = .white
//            } else {
//                passwordCheckTextField.backgroundColor = UIColor.systemGray4
//            }
//        }
//    }
//}
