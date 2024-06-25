//
//  SCHOOL_SEARCH.swift
//  iBeacon
//
//  Created by i-Mac on 2020/09/16.
//  Copyright © 2020 장제현. All rights reserved.
//

import UIKit
import Alamofire

class SCHOOL_SEARCH_TC: UITableViewCell {
    
    @IBOutlet weak var SC_LOGO: UIImageView!
    @IBOutlet weak var SC_NAME: UILabel!
    @IBOutlet weak var SC_ADDRESS: UILabel!
    @IBOutlet weak var SELECT: UIButton!
}

class SCHOOL_SEARCH: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func BACK(_ sender: UIButton) { dismiss(animated: true, completion: nil) }
    
    // 학교 코드
    var FILTER_SCHOOL_DATA_DATA = [SCHOOL_DATA]()
    var SCHOOL_DATA_DATA = [SCHOOL_DATA]()
    var POSITION = 0
    
    @IBOutlet weak var SEARCHBAR: UISearchBar!
    @IBOutlet weak var TABLEVIEW: UITableView!
    
    let VIEW = UIView()
    override func loadView() {
        super.loadView()
        
        EFFECT_INDICATOR_VIEW(VIEW, true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(KEYBOARD_SHOW(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(KEYBOARD_HIDE(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // 검색
        if #available(iOS 13.0, *) { SEARCHBAR.searchTextField.textColor = .white }
        SEARCHBAR.placeholder = "학교명을 입력해주세요."
        SEARCHBAR.delegate = self
        // 통신
        if !SYSTEM_NETWORK_CHECKING() {
            NOTIFICATION_VIEW("네트워크 상태를 확인해 주세요")
        } else {
            SEARCH_SCHOOL_DATA(ACTION_TYPE: "list")
        }
        // 테이블뷰
        TABLEVIEW.delegate = self
        TABLEVIEW.dataSource = self
    }
}

extension SCHOOL_SEARCH: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        FILTER_SCHOOL_DATA_DATA = searchText.isEmpty ? SCHOOL_DATA_DATA : SCHOOL_DATA_DATA.filter({(SCHOOL_DATA_STRING: SCHOOL_DATA) -> Bool in
            return SCHOOL_DATA_STRING.SC_NAME.lowercased().contains(searchText.lowercased())
        })
        
        TABLEVIEW.reloadData()
    }
}

extension SCHOOL_SEARCH: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if FILTER_SCHOOL_DATA_DATA.count == 0 {
            if SCHOOL_DATA_DATA.count == 0 {
                tableView.separatorStyle = .none
                return 0
            } else {
                tableView.separatorStyle = .singleLine
                return SCHOOL_DATA_DATA.count
            }
        } else {
            if FILTER_SCHOOL_DATA_DATA.count == 0 {
                tableView.separatorStyle = .none
                return 0
            } else {
                tableView.separatorStyle = .singleLine
                return FILTER_SCHOOL_DATA_DATA.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let CELL = tableView.dequeueReusableCell(withIdentifier: "SCHOOL_SEARCH_TC", for: indexPath) as! SCHOOL_SEARCH_TC
        
        // 학교이미지
        CELL.SC_LOGO.layer.cornerRadius = 25.0
        CELL.SC_LOGO.clipsToBounds = true
        
        if FILTER_SCHOOL_DATA_DATA.count != 0 {
        
            let DATA = FILTER_SCHOOL_DATA_DATA[indexPath.item]
            
            // 학교이미지
            if DATA.SC_LOGO == "" {
                if DATA.SC_CODE != "" {
                    let IMAGE_URL = DATA_URL().SCHOOL_LOGO_URL + DATA.SC_CODE
                    NUKE_IMAGE(IMAGE_URL: IMAGE_URL, PLACEHOLDER: UIImage(named: "school.png")!, PROFILE: CELL.SC_LOGO, FRAME_SIZE: CELL.SC_LOGO.frame.size)
                }
            } else {
                let IMAGE_URL = DATA_URL().SCHOOL_LOGO_URL + DATA.SC_LOGO
                NUKE_IMAGE(IMAGE_URL: IMAGE_URL, PLACEHOLDER: UIImage(named: "school.png")!, PROFILE: CELL.SC_LOGO, FRAME_SIZE: CELL.SC_LOGO.frame.size)
            }
            // 학교이름
            if DATA.SC_NAME != "" { CELL.SC_NAME.text = DATA.SC_NAME } else { CELL.SC_NAME.text = "-" }
            // 학교주소
            if DATA.SC_ADDRESS != "" { CELL.SC_ADDRESS.text = DATA.SC_ADDRESS } else { CELL.SC_ADDRESS.text = "-" }
            // 학교선택
            CELL.SELECT.tag = indexPath.item
            
        } else {
            
            let DATA = SCHOOL_DATA_DATA[indexPath.item]
            
            // 학교이미지
            if DATA.SC_LOGO == "" {
                if DATA.SC_CODE != "" {
                    let IMAGE_URL = DATA_URL().SCHOOL_LOGO_URL + DATA.SC_CODE
                    NUKE_IMAGE(IMAGE_URL: IMAGE_URL, PLACEHOLDER: UIImage(named: "school.png")!, PROFILE: CELL.SC_LOGO, FRAME_SIZE: CELL.SC_LOGO.frame.size)
                }
            } else {
                let IMAGE_URL = DATA_URL().SCHOOL_LOGO_URL + DATA.SC_LOGO
                NUKE_IMAGE(IMAGE_URL: IMAGE_URL, PLACEHOLDER: UIImage(named: "school.png")!, PROFILE: CELL.SC_LOGO, FRAME_SIZE: CELL.SC_LOGO.frame.size)
            }
            // 학교이름
            if DATA.SC_NAME != "" { CELL.SC_NAME.text = DATA.SC_NAME } else { CELL.SC_NAME.text = "-" }
            // 학교주소
            if DATA.SC_ADDRESS != "" { CELL.SC_ADDRESS.text = DATA.SC_ADDRESS } else { CELL.SC_ADDRESS.text = "-" }
            // 학교선택
            CELL.SELECT.tag = indexPath.item
        }
        
        CELL.SELECT.addTarget(self, action: #selector(SELECT(_:)), for: .touchUpInside)
        
        return CELL
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        SEARCHBAR.resignFirstResponder()
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    @objc func SELECT(_ sender: UIButton) {
        
        let VC = self.presentingViewController as! SIGN_UP

        if FILTER_SCHOOL_DATA_DATA.count != 0 {

            let DATA = FILTER_SCHOOL_DATA_DATA[sender.tag]
            
            VC.SC_CODE = DATA.SC_CODE
            VC.SC_NAME.text = DATA.SC_NAME
            VC.SC_GRADE = DATA.SC_GRADE
        } else {

            let DATA = SCHOOL_DATA_DATA[sender.tag]
            
            VC.SC_CODE = DATA.SC_CODE
            VC.SC_NAME.text = DATA.SC_NAME
            VC.SC_GRADE = DATA.SC_GRADE
        }
        
        VC.dismiss(animated: false, completion: nil)
    }
}

// MARK: - 통신
extension SCHOOL_SEARCH {
    
    func SEARCH_SCHOOL_DATA(ACTION_TYPE: String) {
        
        let URL = DATA_URL().NEW_SCHOOL_URL + "school/get_school_list.php"
        
        let PARAMETERS: Parameters = [
            "action_type": ACTION_TYPE
        ]
        
        print("PARAMETERS -", PARAMETERS)
        
        Alamofire.request(URL, method: .post, parameters: PARAMETERS).responseJSON { response in
            
//            print("[학교목록]", response)
            
            guard let SCHOOL_ARRAY = response.result.value as? Array<Any> else {
                
                print("[학교목록] FAIL")
                self.EFFECT_INDICATOR_VIEW(self.VIEW, false)
                self.NOTIFICATION_VIEW("서버 요청 실패")
                return
            }
            
            for (_, DATA) in SCHOOL_ARRAY.enumerated() {
                
                let DATADICT = DATA as? [String: Any]
                
                if String(DATADICT?["sc_name"] as? String ?? "").contains("유치원") == false {
                    
                    self.SCHOOL_DATA_DATA.append(SCHOOL_DATA(
                    SC_CODE: DATADICT?["sc_code"] as? String ?? "",
                    SC_GRADE: DATADICT?["sc_grade"] as? String ?? "",
                    SC_GROUP: DATADICT?["sc_group"] as? String ?? "",
                    SC_LOCATION: DATADICT?["sc_location"] as? String ?? "",
                    SC_NAME: DATADICT?["sc_name"] as? String ?? "",
                    SC_ADDRESS: DATADICT?["sc_address"] as? String ?? ""))
                }
            }
            
            self.TABLEVIEW.reloadData()
            self.EFFECT_INDICATOR_VIEW(self.VIEW, false)
        }
    }
}
