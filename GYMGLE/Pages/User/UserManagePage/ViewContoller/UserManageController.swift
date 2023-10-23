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
        
        //❗️ 서치델리게이트와 테이블뷰델리게이트 대리자 선언
        viewConfigure.customSearchBar.delegate = self
        viewConfigure.customSearchBar.showsCancelButton = false
        viewConfigure.customSearchBar.setValue("취소", forKey: "cancelButtonText")
        viewConfigure.tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) { // 네비게이션바 보여주기
        navigationController?.navigationBar.isHidden = false
        
        
//        var ref = Database.database().reference()
//        ref.child("users/\(DataManager.shared.gymUid!)/noticeList").observeSingleEvent(of: .value) { DataSnapshot in
//            guard let value = DataSnapshot.value as? [String:Any] else { return }
//            print("테스트 - 스냅샷 밸류. \(DataSnapshot.value)")
//            print("테스트 밸류 - \(value)")
//            print("테스트 밸류.밸류스 - \(value.values)")
//
//        }
        
        
        var ref = Database.database().reference()
        ref.child("users/\(DataManager.shared.gymUid!)/gymInfo/gymUserList").queryOrdered(byChild: "name").observeSingleEvent(of: .value) { DataSnapshot in
            guard let value = DataSnapshot.value as? [String:Any] else { return }
            var temp:[User] = []
            for i in value.values {
                do {
                    let JSONdata = try JSONSerialization.data(withJSONObject: i)
                    let user = try JSONDecoder().decode(User.self, from: JSONdata)
                    temp.append(user)
                } catch let error {
                    print("테스트 - \(error)")
                }
            }
//            DataManager.shared.realGymInfo?.gymUserList = temp
//            self.cells = DataManager.shared.realGymInfo?.gymUserList ?? []
            self.viewConfigure.tableView.reloadData()
        }
        
        
//        ref.child("users/\(DataManager.shared.gymUid!)/gymInfo/gymUserList").queryOrdered(byChild: "name").observeSingleEvent(of: .value) { snapshot in
//            guard let value = snapshot.value as? [String:Any] else {
//                print("테스트 - 응 에러야")
//                return
//            }
//            do {
//                let JSONdata = try JSONSerialization.data(withJSONObject: value)
//                let List = try JSONDecoder().decode([User].self, from: JSONdata)
//                DataManager.shared.realGymInfo?.gymUserList = List
//            } catch let error {
//                print("테스트 - \(error)")
//            }
//            self.cells = DataManager.shared.realGymInfo?.gymUserList ?? []
//            self.viewConfigure.tableView.reloadData()
//
//        }

        
    }

    
    func searchBarIsEmpty() -> Bool {
        return viewConfigure.customSearchBar.text?.isEmpty ?? true
    }
    func isFiltering() -> Bool {
        return viewConfigure.customSearchBar.isFirstResponder && !searchBarIsEmpty()
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




extension UserManageViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == .delete {
            
            let ref = Database.database().reference()
            ref.child("users/\(cells[indexPath.row].adminUid)/gymInfo/gymUserList/\(indexPath.row)").removeValue()

            
//            do {
//                let userData = try JSONEncoder().encode(cells[indexPath.row])
//                let userJSON = try JSONSerialization.jsonObject(with: userData, options: [])
//
//                let ref = Database.database().reference()
//                ref.child("users/\(emptyUser.adminUid)/gymInfo/gymUserList/\(editIndex)").setValue(userJSON)
//            }catch{
//                print("JSON 인코딩 에러")
//            }
            
            cells.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)

        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellInfo = cells[indexPath.row]
        
        let userRegisterVC = UserRegisterViewController()
        
        userRegisterVC.emptyUser = cellInfo
        userRegisterVC.nowEdit = true
        userRegisterVC.editIndex = indexPath.row
        
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
