//
//  MEMBER_INFO.swift
//  iBeacon
//
//  Created by i-Mac on 2020/09/21.
//  Copyright © 2020 장제현. All rights reserved.
//

import UIKit
import Alamofire

class MEMBER_INFO: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func BACK(_ sender: UIButton) { dismiss(animated: true, completion: nil) }
    
    var MEMBER_API: [MEMBER_DATA] = []
    
    var SC_CODE: String = ""
    var C_NUM: String = ""
    
    @IBOutlet weak var PF_IMAGE: UIImageView!       // 이미지
    @IBOutlet weak var PF_NAME: UILabel!            // 이름
    @IBOutlet weak var PF_PHONE: UILabel!           // 전화번호
    @IBOutlet weak var SC_NAME: UILabel!            // 학교이름
    @IBOutlet weak var SC_NUMBER: UILabel!          // 학번
    
    @IBAction func DIFFERENT(_ sender: UIButton) {
        
        let ALERT = UIAlertController(title: "재확인 필요!", message: "본인과 정보가 다르면\n담임 선생님께 알려주세요!", preferredStyle: .alert)
        ALERT.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
        ALERT.addAction(UIAlertAction(title: "새로고침", style: .default) { (_) in
            if !self.SYSTEM_NETWORK_CHECKING() {
                self.NOTIFICATION_VIEW("네트워크 상태를 확인해 주세요")
            } else {
                self.EFFECT_INDICATOR_VIEW(self.VIEW, true)
                self.MEMBER_CHECK(ACTION_TYPE: "check_id")
            }
        })
        present(ALERT, animated: true)
    }
    // 회원가입
    @IBAction func RIGHT(_ sender: UIButton) {
        
        if MEMBER_API.count != 0 {
            
            let ALERT = UIAlertController(title: "회원가입 처리되었습니다!", message: nil, preferredStyle: .alert)
            present(ALERT, animated: true)
            
            dismiss(animated: true) {
                
                let DATE_FORMATTER = DateFormatter()
                DATE_FORMATTER.dateFormat = "yyyy-MM-dd"
                
                UserDefaults.standard.set(self.SC_CODE, forKey: "sc_code")
                UserDefaults.standard.set(self.C_NUM, forKey: "c_num")
                UserDefaults.standard.set(self.MEMBER_API[0].BK_NAME, forKey: "bk_name")
                UserDefaults.standard.set(self.MEMBER_API[0].NEIS_CODE, forKey: "neis_code")
                UserDefaults.standard.set(DATE_FORMATTER.string(from: Date()), forKey: "date")
                UserDefaults.standard.synchronize()
                
                UIViewController.APPDELEGATE.INSERT_DB_MAIN(TIME: "aaaa", CHECK_ID: "false")
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1), execute: {
                    
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "LOADING") as! LOADING
                    VC.modalTransitionStyle = .crossDissolve
                    VC.LOGIN = true
                    self.present(VC, animated: true, completion: nil)
                })
            }
        }
    }
    
    let VIEW = UIView()
    override func loadView() {
        super.loadView()
        
        EFFECT_INDICATOR_VIEW(VIEW, true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PF_IMAGE.layer.cornerRadius = 60.0
        PF_IMAGE.clipsToBounds = true
        
        if !SYSTEM_NETWORK_CHECKING() {
            NOTIFICATION_VIEW("네트워크 상태를 확인해 주세요")
        } else {
            MEMBER_CHECK(ACTION_TYPE: "check_id")
        }
    }
}

extension MEMBER_INFO {
    
    // 학생등록확인
    func MEMBER_CHECK(ACTION_TYPE: String) {
        
        let PARAMETERS: Parameters = [
            "action_type": ACTION_TYPE,
            "mb_id": UserDefaults.standard.string(forKey: "mb_id") ?? "",
            "sc_code": SC_CODE,
            "c_num": C_NUM
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
                    
                    print("[학생정보]", response)
                    
                    guard let MEMBER_ARRAY = response.result.value as? Array<Any> else {
                        print("[학생정보] - FAIL")
                        self.EFFECT_INDICATOR_VIEW(self.VIEW, false)
                        let ALERT = UIAlertController(title: "입력한 정보가 맞지 않습니다", message: nil, preferredStyle: .alert)
                        ALERT.addAction(UIAlertAction(title: "확인", style: .cancel) { (_) in
                            self.dismiss(animated: true, completion: nil)
                        })
                        self.present(ALERT, animated: true, completion: nil)
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
                    
                    self.CSS()
                    self.EFFECT_INDICATOR_VIEW(self.VIEW, false)
                }
            case .failure(let encodingError):
                
                print(encodingError)
                break
            }
        }
    }
    
    func CSS() {
        
        if MEMBER_API.count != 0 {
             
            let DATA = MEMBER_API[0]
            
            // 이미지
            if DATA.MB_FILE == "" {
                PF_IMAGE.image = UIImage(named: "profile.png")
            } else {
                let IMAGE_URL = DATA_URL().NEW_PROFILE_URL + DATA.MB_FILE
                NUKE_IMAGE(IMAGE_URL: IMAGE_URL, PLACEHOLDER: UIImage(named: "busanlogo.png")!, PROFILE: PF_IMAGE, FRAME_SIZE: PF_IMAGE.frame.size)
            }
            // 이름
            if DATA.BK_NAME == "" { PF_NAME.text = "-" } else { PF_NAME.text = DATA.BK_NAME }
            // 전화번호
            if DATA.BK_HP == "" { PF_PHONE.text = "-" } else {
                if DATA.BK_HP.count == 10 {
                    PF_PHONE.text = FORMAT(MASK: "XXX-XXX-XXXX", PHONE: DATA.BK_HP)
                } else {
                    PF_PHONE.text = FORMAT(MASK: "XXX-XXXX-XXXX", PHONE: DATA.BK_HP)
                }
            }
            // 학교
            if DATA.SC_NAME == "" { SC_NAME.text = "-" } else { SC_NAME.text = DATA.SC_NAME }
            // 학번
            if DATA.C_NUM == "" { SC_NUMBER.text = "-" } else { SC_NUMBER.text = DATA.C_NUM }
        }
    }
}
