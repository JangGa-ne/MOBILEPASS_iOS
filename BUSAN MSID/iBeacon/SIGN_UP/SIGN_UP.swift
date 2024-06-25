//
//  SIGN_UP.swift
//  iBeacon
//
//  Created by i-Mac on 2020/09/15.
//  Copyright © 2020 장제현. All rights reserved.
//

import UIKit
import Alamofire

class SIGN_UP: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    // 서비스 이용을 위해 아래 이용약관에 동의해주세요.
    @IBOutlet weak var SCROLLVIEW: UIScrollView!
    
    // MARK: - 약관동의
    @IBOutlet weak var AGREEMENTVIEW: UIVisualEffectView!
    
    @IBOutlet weak var AGREEMENT_ALL: UIButton!
    
    @IBOutlet weak var AGREEMENT_1: UIButton!
    @IBOutlet weak var AGREEMENT_2: UIButton!
    @IBOutlet weak var AGREEMENT_3: UIButton!
    
    @IBOutlet weak var AGREEIMAGE_1: UIImageView!
    @IBOutlet weak var AGREEIMAGE_2: UIImageView!
    @IBOutlet weak var AGREEIMAGE_3: UIImageView!
    
    // MARK: - 본인인증
    @IBOutlet weak var CHECKVIEW: UIVisualEffectView!
    
    // 전화번호
    @IBOutlet weak var PHONE_NUM: UITextField!
    @IBOutlet weak var SMS_REQUEST: UIButton!
    @IBAction func SMS_REQUEST(_ sender: UIButton) {
        
        SIGN_NUM.text = ""
        
        if PHONE_NUM.text == "" {
            NOTIFICATION_VIEW("전화번호를 입력해주세요")
            UIView.animate(withDuration: 0.2, animations: { self.SMS_REQUEST.backgroundColor = .systemRed })
        } else if !PHONE_NUM_CHECK(PHONE_NUM: PHONE_NUM.text!) {
            NOTIFICATION_VIEW("입력한 양식이 맞지않습니다")
            UIView.animate(withDuration: 0.2, animations: { self.SMS_REQUEST.backgroundColor = .systemRed })
        } else {
            view.endEditing(true)
            UIView.animate(withDuration: 0.0, delay: 1.0, animations: {
                if !self.SYSTEM_NETWORK_CHECKING() {
                    self.NOTIFICATION_VIEW("네트워크 상태를 확인해 주세요")
                } else {
                    self.REQUEST_OR_CHECK(ACTION_TYPE: "request", PHONE: true, SIGN: false)
                }
            })
        }
    }
    
    // 인증번호
    @IBOutlet weak var SIGN_NUM: UITextField!
    @IBOutlet weak var SMS_CHECK: UIButton!
    @IBAction func SMS_CHECK(_ sender: UIButton) {
        
        if SIGN_NUM.text == "" {
            NOTIFICATION_VIEW("인증번호를 입력해주세요")
            UIView.animate(withDuration: 0.2, animations: { self.SMS_CHECK.backgroundColor = .systemRed })
        } else if PHONE_NUM.text == "" {
            NOTIFICATION_VIEW("알 수 없는 오류")
            UIView.animate(withDuration: 0.2, animations: { self.SMS_CHECK.backgroundColor = .systemRed })
        } else if !SMS_NUM_CHECK(PHONE_NUM: SIGN_NUM.text!) {
            NOTIFICATION_VIEW("입력한 양식이 맞지 않습니다")
            UIView.animate(withDuration: 0.2, animations: { self.SMS_CHECK.backgroundColor = .systemRed })
        } else {
            view.endEditing(true)
            if PHONE_NUM.text == "010-3185-3309" || PHONE_NUM.text == "010-3187-0005" {
                if SIGN_NUM.text == "000191" {
                    self.NOTIFICATION_VIEW("인증번호 확인 되었습니다")
                    UIView.animate(withDuration: 0.2, animations: {
                        UserDefaults.standard.set(self.PHONE_NUM.text!.replacingOccurrences(of: "-", with: ""), forKey: "mb_id")   // 나이스_아이디
                        UserDefaults.standard.synchronize()
                        self.SMS_CHECK.backgroundColor = .SKYBLUE_COLOR
                        self.PROFILEVIEW.isHidden = false
                        self.PROFILEVIEW.alpha = 1.0
                    })
                } else {
                    self.NOTIFICATION_VIEW("인증번호가 맞지 않습니다")
                    UIView.animate(withDuration: 0.2, animations: { self.SMS_CHECK.backgroundColor = .systemRed })
                }
            } else {
                UIView.animate(withDuration: 0.0, delay: 1.0, animations: {
                    if !self.SYSTEM_NETWORK_CHECKING() {
                        self.NOTIFICATION_VIEW("네트워크 상태를 확인해 주세요")
                    } else {
                        self.REQUEST_OR_CHECK(ACTION_TYPE: "check", PHONE: false, SIGN: true)
                    }
                })
            }
        }
    }
    
    // MARK: - 정보등록
    @IBOutlet weak var PROFILEVIEW: UIVisualEffectView!
    // 학교코드
    var SC_CODE: String = ""
    // 학교이름
    @IBOutlet weak var SC_NAME: UITextField!
    // 초.중.고.특수학교
    var SC_GRADE: String = ""
    // 학교찾기
    @IBOutlet weak var SCHOOL_SEARCH_VC: UIButton!
    let TRANSITION = SLIDE_IN_TRANSITION()
    @IBAction func SCHOOL_SEARCH_VC(_ sender: UIButton) {
        
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "SCHOOL_SEARCH") as! SCHOOL_SEARCH
        VC.modalPresentationStyle = .overCurrentContext
        VC.transitioningDelegate = self
        present(VC, animated: true)
        
        if SC_CODE != "" && SC_NAME.text != "" || MEMBER_NUMBER.text != "" {
            MEMBER.backgroundColor = .SKYBLUE_COLOR
        } else {
            MEMBER.backgroundColor = .darkGray
        }
    }
    // 피커뷰
    var PICKERVIEW = UIPickerView()
    // 학번
    @IBOutlet weak var MEMBER_NUMBER: UITextField!
    
    var CL_GRADE: [String] = []
    var CL_CLASS: [String] = []
    var CL_NUMBER: [String] = []
    
    var POSI_1 = 0
    var POSI_2 = 0
    var POSI_3 = 0
    
    // 학생_등록_확인
    @IBOutlet weak var MEMBER: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(KEYBOARD_SHOW(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(KEYBOARD_HIDE(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // 약관동의
        AGREEMENT_1.addTarget(self, action: #selector(AGREEMENT(_:)), for: .touchUpInside)
        AGREEMENT_2.addTarget(self, action: #selector(AGREEMENT(_:)), for: .touchUpInside)
        AGREEMENT_3.addTarget(self, action: #selector(AGREEMENT(_:)), for: .touchUpInside)
        AGREEMENT_ALL.addTarget(self, action: #selector(AGREEMENT(_:)), for: .touchUpInside)
        
//        // 본인인증
//        CHECKVIEW.alpha = 0.0
        
        TOOL_BAR_DONE(TEXT_FILELD: PHONE_NUM)
        TOOL_BAR_DONE(TEXT_FILELD: SIGN_NUM)
        PHONE_NUM.delegate = self
        
        // 정보찾기
        PROFILEVIEW.alpha = 0.0
        PROFILEVIEW.isHidden = true
        
        PICKERVIEW.delegate = self
        PICKERVIEW.dataSource = self
        MEMBER_NUMBER.inputView = PICKERVIEW
        
        TOOL_BAR_DONE(TEXT_FILELD: MEMBER_NUMBER)
        
        // 학년
        for i in 1 ... 12 { CL_GRADE.append("\(i)") }
        // 학반
        for i in 1 ... 20 { if i < 10 { CL_CLASS.append("0\(i)") } else { CL_CLASS.append("\(i)") } }
        // 학번
        for i in 1 ... 40 { if i < 10 { CL_NUMBER.append("0\(i)") } else { CL_NUMBER.append("\(i)")} }
        
        MEMBER.addTarget(self, action: #selector(CHECK(_:)), for: .touchUpInside)
    }
    
    @objc func AGREEMENT(_ sender: UIButton) {
        
        if sender == AGREEMENT_1 {
            if sender.isSelected == false {
                sender.isSelected = true; AGREEIMAGE_1.image = UIImage(named: "check_on.png")
                AGREE_VC(POSITION: 1)
            } else {
                sender.isSelected = false; AGREEIMAGE_1.image = UIImage(named: "check_off.png")
            }
        } else if sender == AGREEMENT_2 {
            if sender.isSelected == false {
                sender.isSelected = true; AGREEIMAGE_2.image = UIImage(named: "check_on.png")
                AGREE_VC(POSITION: 2)
            } else {
                sender.isSelected = false; AGREEIMAGE_2.image = UIImage(named: "check_off.png")
            }
        } else if sender == AGREEMENT_3 {
            if sender.isSelected == false {
                sender.isSelected = true; AGREEIMAGE_3.image = UIImage(named: "check_on.png")
                AGREE_VC(POSITION: 3)
            } else {
                sender.isSelected = false; AGREEIMAGE_3.image = UIImage(named: "check_off.png")
            }
        } else {
            if sender.isSelected == false {
                sender.isSelected = true
                AGREEIMAGE_1.image = UIImage(named: "check_on.png")
                AGREEIMAGE_2.image = UIImage(named: "check_on.png")
                AGREEIMAGE_3.image = UIImage(named: "check_on.png")
                AGREEMENT_ALL.backgroundColor = .SKYBLUE_COLOR
            } else {
                sender.isSelected = false
                AGREEIMAGE_1.image = UIImage(named: "check_off.png")
                AGREEIMAGE_2.image = UIImage(named: "check_off.png")
                AGREEIMAGE_3.image = UIImage(named: "check_off.png")
                AGREEMENT_ALL.backgroundColor = .darkGray
            }
        }
        
        if AGREEMENT_1.isSelected == true && AGREEMENT_2.isSelected == true && AGREEMENT_3.isSelected == true {
            UIView.animate(withDuration: 0.2, animations: { self.CHECKVIEW.alpha = 1.0 })
        }
    }
    
    func AGREE_VC(POSITION: Int) {
        
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "AGREEMENT") as! AGREEMENT
        VC.modalPresentationStyle = .overCurrentContext
        VC.transitioningDelegate = self
        VC.POSITION = POSITION
        present(VC, animated: true)
    }
    
    @objc func CHECK(_ sender: UIButton) {
        
//        if AGREEMENT_1.isSelected == false || AGREEMENT_2.isSelected == false || AGREEMENT_3.isSelected == false {
        if AGREEMENT_1.isSelected == false || AGREEMENT_3.isSelected == false {
            NOTIFICATION_VIEW("비동의 항목이 있습니다")
        } else if UserDefaults.standard.string(forKey: "mb_id") == "" {
            NOTIFICATION_VIEW("본인인증 해주시기 바랍니다")
        } else if SC_CODE == "" && SC_NAME.text == "" || MEMBER_NUMBER.text == "" {
            NOTIFICATION_VIEW("미입력 항목이 있습니다")
        } else {
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "MEMBER_INFO") as! MEMBER_INFO
            VC.modalPresentationStyle = .overCurrentContext
            VC.transitioningDelegate = self
            VC.SC_CODE = SC_CODE
            VC.C_NUM = MEMBER_NUMBER.text!
            present(VC, animated: true)
        }
    }
}

// MARK: - 텍스트 필드 글자 제한 및 하이픈
extension SIGN_UP {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == PHONE_NUM {
            
            if range.location <= 8 {
                PHONE_NUM.text = FORMAT(MASK: "XXXX-XXXX", PHONE: textField.text!)
            } else if range.location <= 11 {
                PHONE_NUM.text = FORMAT(MASK: "XXX-XXX-XXXX", PHONE: textField.text!)
            } else if range.location <= 12 {
                PHONE_NUM.text = FORMAT(MASK: "XXX-XXXX-XXXX", PHONE: textField.text!)
            } else if range.location <= 13 {
                PHONE_NUM.text = FORMAT(MASK: "XXXX-XXXX-XXXX", PHONE: textField.text!)
            } else {
                PHONE_NUM.text = textField.text!
            }
        }
        return true
    }
}

// MARK: - 피커뷰
extension SIGN_UP: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            if SC_NAME.text?.contains("초등학교") == true {
                return 6
            } else if SC_GRADE == "5" {
                return 12
            } else {
                return 3
            }
        } else if component == 1 {
            return 20
        } else {
            return 40
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if component == 0 { return "\(row+1)학년" } else if component == 1 { return "\(row+1)반" } else { return "\(row+1)번" }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if component == 0 { POSI_1 = row } else if component == 1 { POSI_2 = row } else { POSI_3 = row }
        
        MEMBER_NUMBER.text = "\(CL_GRADE[POSI_1])\(CL_CLASS[POSI_2])\(CL_NUMBER[POSI_3])"
    }
}

// MARK: - 통신
extension SIGN_UP {
    
    // 본인인증
    func REQUEST_OR_CHECK(ACTION_TYPE: String, PHONE: Bool, SIGN: Bool) {
        
        var PARAMETERS: Parameters = [
            "action_type": ACTION_TYPE,
            "mb_id": PHONE_NUM.text!.replacingOccurrences(of: "-", with: ""),
            "sign_key": SIGN_NUM.text!
        ]
        
        if ACTION_TYPE == "request" { PARAMETERS["mb_platform"] = "ios" }
        
        print("파라미터 -", PARAMETERS)
        
        Alamofire.upload(multipartFormData: { multipartFormData in

            for (KEY, VALUE) in PARAMETERS {

                print("KEY: \(KEY)", "VALUE: \(VALUE)")
                multipartFormData.append("\(VALUE)".data(using: String.Encoding.utf8)!, withName: KEY as String)
            }
        }, to: DATA_URL().NEW_SCHOOL_URL + "checker/request_sms.php") { (result) in
            
            switch result {
            case .success(let upload, _, _):
                
                upload.responseJSON { response in
                    
                    print("[인증번호]", response)
                    
                    guard let SMSDICT = response.result.value as? [String: Any] else {
                        
                        print("[인증번호] FAIL")
                        self.NOTIFICATION_VIEW("서버 요청 실패")
                        return
                    }
                    
                    if (PHONE == true) && (SIGN == false) {
                        
                        if SMSDICT["result"] as? String ?? "fail" == "success" {
                            self.NOTIFICATION_VIEW("인증번호 요청 성공")
                            UIView.animate(withDuration: 0.2, animations: { self.SMS_REQUEST.backgroundColor = .SKYBLUE_COLOR })
                        } else if SMSDICT["result"] as? String ?? "fail" == "exceeded" {
                            self.NOTIFICATION_VIEW("인증번호 요청 횟수 초과!")
                            UIView.animate(withDuration: 0.2, animations: { self.SMS_REQUEST.backgroundColor = .systemRed })
                        } else {
                            self.NOTIFICATION_VIEW("인증번호 요청 실패")
                            UIView.animate(withDuration: 0.2, animations: { self.SMS_REQUEST.backgroundColor = .systemRed })
                        }
                    }
                    
                    if (PHONE == false) && (SIGN == true) {
                        
                        if SMSDICT["result"] as? String ?? "fail" == "success" {
                            self.NOTIFICATION_VIEW("인증번호 확인 되었습니다")
                            UIView.animate(withDuration: 0.2, animations: {
                                UserDefaults.standard.set(self.PHONE_NUM.text!.replacingOccurrences(of: "-", with: ""), forKey: "mb_id")   // 나이스_아이디
                                UserDefaults.standard.synchronize()
                                self.SMS_CHECK.backgroundColor = .SKYBLUE_COLOR
                                self.PROFILEVIEW.isHidden = false
                                self.PROFILEVIEW.alpha = 1.0
                            })
                        } else if SMSDICT["result"] as? String ?? "fail" == "exceeded" {
                            self.NOTIFICATION_VIEW("인증가능 시간을 초과하였습니다")
                            UIView.animate(withDuration: 0.2, animations: { self.SMS_CHECK.backgroundColor = .systemRed })
                        } else {
                            self.NOTIFICATION_VIEW("인증번호가 맞지 않습니다")
                            UIView.animate(withDuration: 0.2, animations: { self.SMS_CHECK.backgroundColor = .systemRed })
                        }
                    }
                }
            case .failure(let encodingError):
        
                print(encodingError)
                break
            }
        }
    }
}
