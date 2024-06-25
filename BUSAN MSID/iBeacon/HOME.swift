//
//  HOME.swift
//  iBeacon
//
//  Created by i-Mac on 2020/09/21.
//  Copyright © 2020 장제현. All rights reserved.
//

import UIKit
import Nuke
import Alamofire

class HOME_TC: UITableViewCell {
    
    @IBOutlet weak var CELL_1: UIView!
    
    @IBOutlet weak var PF_IMAGE: UIImageView!
    @IBOutlet weak var PF_IMAGE_EDIT: UIButton!
    @IBOutlet weak var BK_NAME: UILabel!
    @IBOutlet weak var BK_PHONE: UILabel!
    @IBOutlet weak var SC_NAME: UILabel!
    @IBOutlet weak var C_NUM: UILabel!
    
    @IBOutlet weak var MB_POINT: UILabel!
    @IBOutlet weak var POINT_LIST_VC: UIButton!
}

class HOME: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    @IBOutlet weak var BACK: UIButton!
    @IBAction func BACK(_ sender: Any) {
        
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "LOADING") as! LOADING
        VC.modalTransitionStyle = .crossDissolve
        VC.LOGIN = false
        present(VC, animated: true)
    }
    let TRANSITION = SLIDE_IN_TRANSITION()
    @IBAction func HELP_VC(_ sender: UIButton) {
        
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "HELP") as! HELP
        VC.modalPresentationStyle = .overCurrentContext
        VC.transitioningDelegate = self
        present(VC, animated: true)
    }
    
    var MEMBER_API: [MEMBER_DATA] = []
    var SC_INFO_API: [SC_INFO_DATA] = []
    
    @IBOutlet weak var BARCODE_IMAGE: UIImageView!      // 바코드_이미지
    @IBOutlet weak var BARCODE_NOTDATA: UILabel!        // 사용불가_안내
    @IBOutlet weak var LB_NAME: UILabel!                // 도서관명
    
    var PO_MB_POINT: String = ""
    
    @IBOutlet weak var TABLEVIEW: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 실시간 네트워크 확인
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if !self.SYSTEM_NETWORK_CHECKING() { self.NOT_NETWORK_VC() }
        }
        
        // 위치 접근 권한 설정
        DispatchQueue.main.async { self.LOCATION_ALWAYS() }
        
        if UserDefaults.standard.string(forKey: "mb_id") != "01031870005" {
            BACK.isHidden = true
        } else {
            BACK.isHidden = false
        }
        
        if MEMBER_API.count != 0 {
            
            let DATA = MEMBER_API[0]
            
            // 도서관_대출증_바코드
            let CODE_GENERATOR = BARCODE()
            
            var TYPE: BARCODE_TYPE
            var SIZE: CGSize
            
            TYPE = .CODE_128
            SIZE = CGSize(width: BARCODE_IMAGE.frame.size.width, height: BARCODE_IMAGE.frame.size.height)
            
            if DATA.B_CODE == "" {
                BARCODE_IMAGE.alpha = 0.2
                BARCODE_IMAGE.image = CODE_GENERATOR.BARCODE(CODE: "37ge392r297gf834", TYPE: TYPE, SIZE: SIZE)
                BARCODE_NOTDATA.isHidden = false
            } else {
                BARCODE_IMAGE.alpha = 1.0
                BARCODE_IMAGE.image = CODE_GENERATOR.BARCODE(CODE: DATA.B_CODE, TYPE: TYPE, SIZE: SIZE)
                BARCODE_NOTDATA.isHidden = true
            }
            // 도서관이름
            LB_NAME.text = "\(DATA.SC_NAME)"
        }
        
        TABLEVIEW.delegate = self
        TABLEVIEW.dataSource = self
        TABLEVIEW.separatorStyle = .none
    }
}

extension HOME: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.item == 0 {
            
            let CELL = tableView.dequeueReusableCell(withIdentifier: "HOME_TC", for: indexPath) as! HOME_TC
            
            CELL.CELL_1.SHADOW_VIEW(COLOR: .black, OFFSET: CGSize(width: 0, height: 0), SHADOW_RADIUS: 10, OPACITY: 0.2, RADIUS: 20.0)
            
            if MEMBER_API.count != 0 {
                
                let DATA = MEMBER_API[0]
                
                // 이미지
                CELL.PF_IMAGE.layer.cornerRadius = 40.0
                CELL.PF_IMAGE.clipsToBounds = true
                if DATA.MB_FILE != "" {
                    NUKE_IMAGE(IMAGE_URL: DATA.MB_FILE, PLACEHOLDER: UIImage(named: "user.png")!, PROFILE: CELL.PF_IMAGE, FRAME_SIZE: CGSize(width: CELL.PF_IMAGE.frame.width, height: CELL.PF_IMAGE.frame.height))
                }
                // 사진_편집
                CELL.PF_IMAGE_EDIT.addTarget(self, action: #selector(PF_IMAGE_UPDATE(_:)), for: .touchUpInside)
                // 이름
                CELL.BK_NAME.text = DATA.BK_NAME
                // 전화번호
                if DATA.BK_HP.count == 10 {
                    CELL.BK_PHONE.text = FORMAT(MASK: "XXX-XXX-XXXX", PHONE: DATA.BK_HP)
                } else {
                    CELL.BK_PHONE.text = FORMAT(MASK: "XXX-XXXX-XXXX", PHONE: DATA.BK_HP)
                }
                // 학교
                CELL.SC_NAME.text = DATA.SC_NAME
                // 학번
                CELL.C_NUM.text = DATA.C_NUM
            }
            
            return CELL
        } else {
            
            let CELL = tableView.dequeueReusableCell(withIdentifier: "HOME_TC_P", for: indexPath) as! HOME_TC
            
            if MEMBER_API.count != 0 {
                
                let DATA = MEMBER_API[0]
                
                // 총점
                if PO_MB_POINT == "" {
                    if DATA.MB_POINT != "" { CELL.MB_POINT.text = "\(DATA.MB_POINT) 점" }
                } else {
                    CELL.MB_POINT.text = "\(PO_MB_POINT) 점"
                }
                // 상.벌점_현황
                CELL.POINT_LIST_VC.layer.cornerRadius = 22.5
                CELL.POINT_LIST_VC.layer.borderColor = UIColor.SKYBLUE_COLOR.cgColor
                CELL.POINT_LIST_VC.layer.borderWidth = 2.0
                CELL.POINT_LIST_VC.clipsToBounds = true
                CELL.POINT_LIST_VC.setTitleColor(.SKYBLUE_COLOR, for: .normal)
                CELL.POINT_LIST_VC.addTarget(self, action: #selector(POINT_LIST_VC(_:)), for: .touchUpInside)
            }
            
            return CELL
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    @objc func POINT_LIST_VC(_ sender: UIButton) {
        
        // 진동 이벤트
        UIImpactFeedbackGenerator().impactOccurred()
        
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "POINT") as! POINT
        VC.modalTransitionStyle = .crossDissolve
//        VC.modalPresentationStyle = .automatic
        if MEMBER_API.count != 0 { VC.NEIS_CODE = MEMBER_API[0].NEIS_CODE }
        present(VC, animated: true, completion: nil)
    }
    
    @objc func PF_IMAGE_UPDATE(_ sender: UIButton) {
        
        if self.MEMBER_API.count == 0 {
            
            self.NOTIFICATION_VIEW("로그인을 해주세요")
        } else {
            
            let ALERT = UIAlertController(title: "프로필 사진 변경", message: nil, preferredStyle: .actionSheet)
                                    
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                ALERT.addAction(UIAlertAction(title: "카메라", style: .default) { (_) in self.IMAGE_PICKER(.camera) })
            }
            if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
                ALERT.addAction(UIAlertAction(title: "저장된 앨범", style: .default) { (_) in self.IMAGE_PICKER(.savedPhotosAlbum) })
            }
            let CANCEL = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            
            ALERT.addAction(CANCEL)
            CANCEL.setValue(UIColor.red, forKey: "titleTextColor")
        
            self.present(ALERT, animated: true)
        }
    }
}

extension HOME {
    
    func UPDATE_PROFILE() {
        
        let PARAMETERS: Parameters = [
            "action_type": "update",
            "mb_id": UserDefaults.standard.string(forKey: "mb_id") ?? "",
            "sc_code": UserDefaults.standard.string(forKey: "sc_code") ?? "",
            "c_num": UserDefaults.standard.string(forKey: "c_num") ?? "",
            "neis_code": UserDefaults.standard.string(forKey: "neis_code") ?? ""
        ]
        
        print("파라미터 -", PARAMETERS)
        
        Alamofire.upload(multipartFormData: { multipartFormData in

            if UserDefaults.standard.data(forKey: "image_data") == nil {
                
                for (KEY, VALUE) in PARAMETERS {

                    print("key: \(KEY)", "value: \(VALUE)")
                    multipartFormData.append("\(VALUE)".data(using: String.Encoding.utf8)!, withName: KEY as String)
                }
            } else {
                
                multipartFormData.append(UserDefaults.standard.data(forKey: "image_data")!, withName: "mb_file", fileName: "\(UserDefaults.standard.string(forKey: "mb_id") ?? "").jpg", mimeType: "image/jpg")

                print((UserDefaults.standard.data(forKey: "image_data")!, withName: "mb_file", fileName: "\(UserDefaults.standard.string(forKey: "mb_id") ?? "").jpg", mimeType: "image/jpg"))
                for (KEY, VALUE) in PARAMETERS {

                    print("key: \(KEY)", "value: \(VALUE)")
                    multipartFormData.append("\(VALUE)".data(using: String.Encoding.utf8)!, withName: KEY as String)
                }
            }
        }, to: "https://sms.pen.go.kr/pages/_atten/profile_upload.php") { (result) in
            
            switch result {
            case .success(let upload, _, _):
                
                upload.responseJSON { response in
                    
                    print("[프로필 업데이트]", response)
                    
                    guard let UPDATEDICT = response.result.value as? [String: Any] else {
                        print("[프로필 업데이트] - FAIL")
                        return
                    }
                    
                    if UPDATEDICT["status"] as? String ?? "" == "COMPLETE" {
                        if !self.SYSTEM_NETWORK_CHECKING() {
                            self.NOTIFICATION_VIEW("네트워크 상태를 확인해 주세요")
                        } else {
                            self.MEMBER_CHECK_RELOAD()
                        }
                    } else {
                        self.TABLEVIEW.reloadData()
                    }
                }
            case .failure(let encodingError):
                
                print(encodingError)
                break
            }
        }
    }
    
    // 학생등록확인
    func MEMBER_CHECK_RELOAD() {
        
        Nuke.ImageCache.shared.removeAll()
        Nuke.DataLoader.sharedUrlCache.removeAllCachedResponses()
        
        let PARAMETERS: Parameters = [
            "action_type": "check_id",
            "mb_id": UserDefaults.standard.string(forKey: "mb_id") ?? "",
            "sc_code": UserDefaults.standard.string(forKey: "sc_code") ?? "",
            "c_num": UserDefaults.standard.string(forKey: "c_num") ?? ""
        ]
        
        print("파라미터 -", PARAMETERS)
        
        Alamofire.upload(multipartFormData: { multipartFormData in

            for (KEY, VALUE) in PARAMETERS {

                print("KEY: \(KEY)", "VALUE: \(VALUE)")
                multipartFormData.append("\(VALUE)".data(using: String.Encoding.utf8)!, withName: KEY as String)
            }
        }, to: DATA_URL().NEW_SCHOOL_URL + "checker/member.php") { (result) in
            
            switch result {
            case .success(let upload, _, _):
                
                upload.responseJSON { response in
                    
                    self.MEMBER_API.removeAll()
                    
                    print("[업데이트]", response)
                    
                    guard let MEMBER_ARRAY = response.result.value as? Array<Any> else {
                        print("[업데이트] - FAIL")
                        return
                    }
                    
                    for (_, DATA) in MEMBER_ARRAY.enumerated() {
                        
                        let POST_MEMBER_DATA = MEMBER_DATA()
                        
                        let DATADICT = DATA as? [String: Any]
                        
                        POST_MEMBER_DATA.SET_APP_PARENT_01(APP_PARENT_01: DATADICT?["app_parent_01"] as Any)
                        POST_MEMBER_DATA.SET_APP_ST(APP_ST: DATADICT?["app_st"] as Any)
                        POST_MEMBER_DATA.SET_B_CODE(B_CODE: DATADICT?["b_code"] as Any)
                        POST_MEMBER_DATA.SET_BG_NO(BG_NO: DATADICT?["bg_no"] as Any)
                        POST_MEMBER_DATA.SET_BK_DATETIME(BK_DATETIME: DATADICT?["bk_datetime"] as Any)
                        POST_MEMBER_DATA.SET_BK_HP(BK_HP: DATADICT?["bk_hp"] as Any)
                        POST_MEMBER_DATA.SET_BK_MEMO(BK_MEMO: DATADICT?["bk_memo"] as Any)
                        POST_MEMBER_DATA.SET_BK_NAME(BK_NAME: DATADICT?["bk_name"] as Any)
                        POST_MEMBER_DATA.SET_BK_NO(BK_NO: DATADICT?["bk_no"] as Any)
                        POST_MEMBER_DATA.SET_BOOK_YEAR(BOOK_YEAR: DATADICT?["book_year"] as Any)
                        POST_MEMBER_DATA.SET_C_NUM(C_NUM: DATADICT?["c_num"] as Any)
                        POST_MEMBER_DATA.SET_COIN_MAC(COIN_MAC: DATADICT?["coin_mac"] as Any)
                        POST_MEMBER_DATA.SET_DEL_PER(DEL_PER: DATADICT?["del_per"] as Any)
                        POST_MEMBER_DATA.SET_DORM(DORM: DATADICT?["dorm"] as Any)
                        POST_MEMBER_DATA.SET_DORM_CHECKOUT(DORM_CHECKOUT: DATADICT?["dorm_checkout"] as Any)
                        POST_MEMBER_DATA.SET_DORM_STATUS(DORM_STATUS: DATADICT?["dorm_status"] as Any)
                        POST_MEMBER_DATA.SET_FCM_CHECK(FCM_CHECK: DATADICT?["fcm_check"] as Any)
                        POST_MEMBER_DATA.SET_FCM_KEY(FCM_KEY: DATADICT?["fcm_kek"] as Any)
                        POST_MEMBER_DATA.SET_FCM_KEY_P1(FCM_KEY_P1: DATADICT?["fcm_key_01"] as Any)
                        POST_MEMBER_DATA.SET_FCM_KEY_P2(FCM_KEY_P2: DATADICT?["fcm_key_02"] as Any)
                        POST_MEMBER_DATA.SET_FOOD_KEY(FOOD_KEY: DATADICT?["food_key"] as Any)
                        POST_MEMBER_DATA.SET_FOOD_KEY_P1(FOOD_KEY_P1: DATADICT?["food_key_01"] as Any)
                        POST_MEMBER_DATA.SET_FOOD_KEY_P2(FOOD_KEY_P2: DATADICT?["food_key_02"] as Any)
                        POST_MEMBER_DATA.SET_FOOD_PAY_EVE(FOOD_PAY_EVE: DATADICT?["food_pay_eve"] as Any)
                        POST_MEMBER_DATA.SET_FOOD_PAY_MOR(FOOD_PAY_MOR: DATADICT?["food_pay_mor"] as Any)
                        POST_MEMBER_DATA.SET_FOOD_PAY_MOON(FOOD_PAY_MOON: DATADICT?["food_pay_moon"] as Any)
                        POST_MEMBER_DATA.SET_INPUT_MONTH(INPUT_MONTH: DATADICT?["input_month"] as Any)
                        POST_MEMBER_DATA.SET_INPUT_YEAR(INPUT_YEAR: DATADICT?["input_year"] as Any)
                        POST_MEMBER_DATA.SET_COIN_MAC(COIN_MAC: DATADICT?["coin_mac"] as Any)
                        POST_MEMBER_DATA.SET_MB_CLASS(MB_CLASS: DATADICT?["mb_class"] as Any)
                        POST_MEMBER_DATA.SET_MB_FILE(MB_FILE: DATADICT?["mb_file"] as Any)
                        POST_MEMBER_DATA.SET_MB_GRADE(MB_GRADE: DATADICT?["mb_grade"] as Any)
                        POST_MEMBER_DATA.SET_MB_NO(MB_NO: DATADICT?["mb_no"] as Any)
                        POST_MEMBER_DATA.SET_MB_OUT_PLAN(MB_OUT_PLAN: DATADICT?["mb_out_plan"] as Any)
                        POST_MEMBER_DATA.SET_MB_PLAN_IN_DATE(MB_PLAN_IN_DATE: DATADICT?["mb_plan_in_date"] as Any)
                        POST_MEMBER_DATA.SET_MB_PLAN_OUT_DATE(MB_PLAN_OUT_DATE: DATADICT?["mb_plan_out_date"] as Any)
                        POST_MEMBER_DATA.SET_MB_POINT(MB_POINT: DATADICT?["mb_point"] as Any)
                        POST_MEMBER_DATA.SET_MINUS_POINT(MINUS_POINT: DATADICT?["minus_point"] as Any)
                        POST_MEMBER_DATA.SET_NEIS_CODE(NEIS_CODE: DATADICT?["neis_code"] as Any)
                        POST_MEMBER_DATA.SET_NFIX_POINT(NFIX_POINT: DATADICT?["nfix_point"] as Any)
                        POST_MEMBER_DATA.SET_P_PHONE_01(P_PHONE_01: DATADICT?["p_phone_01"] as Any)
                        POST_MEMBER_DATA.SET_P_PHONE_02(P_PHONE_02: DATADICT?["p_phone_02"] as Any)
                        POST_MEMBER_DATA.SET_PLUS_POINT(PLUS_POINT: DATADICT?["plus_point"] as Any)
                        POST_MEMBER_DATA.SET_SC_CODE(SC_CODE: DATADICT?["sc_code"] as Any)
                        POST_MEMBER_DATA.SET_SC_GRADE(SC_GRADE: DATADICT?["sc_grade"] as Any)
                        POST_MEMBER_DATA.SET_SC_GROUP(SC_GROUP: DATADICT?["sc_group"] as Any)
                        POST_MEMBER_DATA.SET_SC_LOCATION(SC_LOCATION: DATADICT?["sc_location"] as Any)
                        POST_MEMBER_DATA.SET_SC_NAME(SC_NAME: DATADICT?["sc_name"] as Any)
                        
                        self.MEMBER_API.append(POST_MEMBER_DATA)
                    }
                    
                    self.TABLEVIEW.reloadData()
                }
            case .failure(let encodingError):
                
                print(encodingError)
                break
            }
        }
    }
}

extension HOME: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // 프로필이미지추가
    func IMAGE_PICKER(_ SOURCE: UIImagePickerController.SourceType) {
        
        let PICKER = UIImagePickerController()
        PICKER.sourceType = SOURCE
        PICKER.delegate = self
        PICKER.allowsEditing = true
        present(PICKER, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
//        if let IMAGE = info[UIImagePickerController.InfoKey.editedImage] as? UIImage { PROFILE_IMAGE = IMAGE }
        if let IMAGE_UPLOAD = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            UserDefaults.standard.set(IMAGE_UPLOAD.pngData(), forKey: "image_data")
            UserDefaults.standard.synchronize()
        }
        
        if !SYSTEM_NETWORK_CHECKING() {
            NOTIFICATION_VIEW("네트워크 상태를 확인해 주세요")
        } else {
            if MEMBER_API.count == 0 {
                NOTIFICATION_VIEW("오류: 로그인 데이터 없음")
            } else {
                UPDATE_PROFILE()
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}
