import UIKit
import FirebaseDatabase

final class UserManageViewController: UIViewController {
    
    let viewConfigure = UserManageView()
    let pageTitle = "회원 관리"
    let buttonTitle = "등록하기"
    
    let shared = DataManager.shared
    
    //❗️서치를 하기 위한 변수 생성
    var cells:[User] = []

    var filteredUserList: [User] = []

    let cellHeight = 56

    override func loadView() {
        viewConfigure.label.text = pageTitle
        view = viewConfigure
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        viewConfigure.customSearchBar.delegate = self
        viewConfigure.customSearchBar.showsCancelButton = false
        viewConfigure.customSearchBar.setValue("취소", forKey: "cancelButtonText")
        viewConfigure.tableView.dataSource = self
        viewConfigure.tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) { 
        navigationController?.navigationBar.isHidden = false
        userDataRead {
            self.cells = DataManager.shared.userList.sorted(by: { $0.startSubscriptionDate < $1.startSubscriptionDate })
            self.viewConfigure.tableView.reloadData()
        }
    }
}

// MARK: - extension custom func

private extension UserManageViewController {
    
    func searchBarIsEmpty() -> Bool {
        return viewConfigure.customSearchBar.text?.isEmpty ?? true
    }
    func isFiltering() -> Bool {
        return viewConfigure.customSearchBar.isFirstResponder && !searchBarIsEmpty()
    }
    func userDataRead(completion: @escaping () -> Void) {
        let ref = Database.database().reference()
        ref.child("accounts").queryOrdered(byChild: "adminUid").queryEqual(toValue: DataManager.shared.gymUid!).observeSingleEvent(of: .value) { DataSnapshot  in
            guard let value = DataSnapshot.value as? [String:Any] else { return }
            var temp:[User] = []
            for i in value.values {
                do {
                    let JSONdata = try JSONSerialization.data(withJSONObject: i)
                    let user = try JSONDecoder().decode(User.self, from: JSONdata)
                    temp.append(user)
                } catch let error {
                    print("테스트 - \(error)")
                    completion()
                }
            }
            DataManager.shared.userList = temp
            completion()
        }
    }
    func userDeleted(completion: @escaping () -> Void, id: String) {
        // 회원삭제 - 서버
        if isFiltering() {
            let ref = Database.database().reference()
            ref.child("accounts").queryOrdered(byChild: "account/id").queryEqual(toValue: "\(id)").observeSingleEvent(of: .value) { DataSnapshot in
                guard let value = DataSnapshot.value as? [String:Any] else { return }
                var uid = ""
                for i in value.keys {
                    uid = i
                }
                ref.child("accounts/\(uid)").removeValue()
                completion()
            }
        } else {
            let ref = Database.database().reference()
            ref.child("accounts").queryOrdered(byChild: "account/id").queryEqual(toValue: "\(id)").observeSingleEvent(of: .value) { DataSnapshot in
                guard let value = DataSnapshot.value as? [String:Any] else { return }
                var uid = ""
                for i in value.keys {
                    uid = i
                }
                ref.child("accounts/\(uid)").removeValue()
                completion()
            }
        }
    }
}

// MARK: - TableViewDataSource

extension UserManageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.isFiltering() ? self.filteredUserList.count : self.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = ManageLabelCell()
        
        if isFiltering() {
            cell.name.text = filteredUserList[indexPath.row].name
            cell.phone.text = filteredUserList[indexPath.row].number
            cell.gender.text = "남"
        } else {
            cell.name.text = cells[indexPath.row].name
            cell.phone.text = cells[indexPath.row].number
            cell.gender.text = "남"
        }
        
        if cells.count == (indexPath.row + 1) || filteredUserList.count == (indexPath.row + 1) {
            cell.contentView.layer.addBorder([.bottom], color: ColorGuide.shadowBorder, width: 1.0)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(cellHeight)
        
    }

}

// MARK: - UITableViewDelegate
extension UserManageViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == .delete {
            if isFiltering() {
                DispatchQueue.main.async {
                    self.userDeleted(completion: {
                        self.filteredUserList.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                        
                    }, id: self.filteredUserList[indexPath.row].account.id)
                }
            } else {
                DispatchQueue.main.async {
                    self.userDeleted(completion: {
                        self.cells.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                    }, id: self.cells[indexPath.row].account.id)
                }
            }
            self.viewConfigure.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userRegisterVC = UserRegisterViewController()
        
        if isFiltering() {
            let filterCellInfo = filteredUserList[indexPath.row]
            userRegisterVC.emptyUser = filterCellInfo
            userRegisterVC.nowEdit = true
            userRegisterVC.editIndex = indexPath.row
        } else {
            let cellInfo = cells[indexPath.row]
            userRegisterVC.emptyUser = cellInfo
            userRegisterVC.nowEdit = true
            userRegisterVC.editIndex = indexPath.row
        }
        
        self.navigationController?.pushViewController(userRegisterVC, animated: true)
    }
}

// MARK: - searchbar Delegate
extension UserManageViewController: UISearchBarDelegate {

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        viewConfigure.customSearchBar.setShowsCancelButton(true, animated: true)
        viewConfigure.tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        guard let text = searchBar.searchTextField.text?.lowercased() else { return }
        filteredUserList = self.cells.filter { $0.name.lowercased().contains(text)}.sorted {$0.startSubscriptionDate > $1.startSubscriptionDate}
        viewConfigure.tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewConfigure.customSearchBar.searchTextField.text = ""
        viewConfigure.customSearchBar.resignFirstResponder()
        viewConfigure.customSearchBar.showsCancelButton = false
        viewConfigure.tableView.reloadData()
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        viewConfigure.customSearchBar.setShowsCancelButton(false, animated: true)
        return true
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        viewConfigure.customSearchBar.showsCancelButton = false
        viewConfigure.tableView.reloadData()
    }
    
    func dismissKeyboard() {
        viewConfigure.customSearchBar.resignFirstResponder()
    }
}
