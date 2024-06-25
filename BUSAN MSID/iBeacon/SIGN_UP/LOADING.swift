//
//  LOADING.swift
//  iBeacon
//
//  Created by i-Mac on 2020/09/14.
//  Copyright © 2020 장제현. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

class LOADING: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    var LOGIN: Bool = false
    
    var MSID_API: [MSID_DATA] = []
    
    var MEMBER_API: [MEMBER_DATA] = []
    var SC_INFO_API: [SC_INFO_DATA] = []
    
    var LOC_MANAGER = CLLocationManager()
    var BEACONS: [CLBeaconRegion] = []
    var isScanning = false
    
    @IBOutlet weak var TITLE: UILabel!
    @IBOutlet weak var SIGN_UP_VC: UIView!
    
    let TRANSITION = SLIDE_IN_TRANSITION()
    @IBAction func SIGN_UP_VC(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.2, animations: {
            self.TITLE.transform = CGAffineTransform(translationX: -self.view.bounds.width, y: 0.0)
            self.SIGN_UP_VC.transform = CGAffineTransform(translationX: -self.view.bounds.width, y: 0.0)
        })
        
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "SIGN_UP") as! SIGN_UP
        VC.modalPresentationStyle = .overCurrentContext
        VC.transitioningDelegate = self
        present(VC, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { didAllow, Error in })
        
        // 버전 체크
        let STORE_VERSION = UIViewController.APPDELEGATE.NEW_VERSION
        let NOW_VERSION = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String // 현재 버전

        print("최신 버전: \(STORE_VERSION)")
        print("현재 버전: \(NOW_VERSION)")
        
        if STORE_VERSION > NOW_VERSION {
            
            DispatchQueue.main.async {
                
                let ALERT = UIAlertController(title: "Update", message: "최신 업데이트가 있습니다.\n업데이트 하시겠습니까?", preferredStyle: .alert)
                
                ALERT.addAction(UIAlertAction(title: "업데이트", style: .default, handler: { (_) in
                    UIApplication.shared.open(URL(string: "https://apps.apple.com/kr/app/%EB%B6%80%EC%82%B0-%EB%AA%A8%EB%B0%94%EC%9D%BC-%ED%95%99%EC%83%9D%EC%A6%9D/id1534704756")!)
                }))
                
                self.present(ALERT, animated: true, completion: nil)
            }
        }
            
        if LOGIN == false {
            // 회원가입 여부
            SIGN_UP_VC.isHidden = false
        } else {
            // 회원가입 여부
            SIGN_UP_VC.isHidden = true
            DispatchQueue.main.async { self.NETWORK_CHECK() }
        }
    }
    
    func NETWORK_CHECK() {
        // 네트워크 연결 확인
        if SYSTEM_NETWORK_CHECKING() {
            MEMBER_CHECK(ACTION_TYPE: "check_id")
        } else {
            NOT_NETWORK_VC()
        }
    }
}

extension LOADING {
    
    // 로그인
    func MEMBER_CHECK(ACTION_TYPE: String) {
        
        let PARAMETERS: Parameters = [
            "action_type": ACTION_TYPE,
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
                    
                    print("[로그인]", response)
                    
                    guard let MEMBER_DICT = response.result.value as? [String: Any] else {
                        
                        guard let MEMBER_ARRAY = response.result.value as? Array<Any> else {
                            print("[로그인] - FAIL")
                            self.NOT_NETWORK_VC()
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
                        
                        self.ALARM(SC_CODE: UserDefaults.standard.string(forKey: "sc_code") ?? "")
                        
                        // 홈으로
                        let VC = self.storyboard?.instantiateViewController(withIdentifier: "HOME") as! HOME
                        VC.modalTransitionStyle = .crossDissolve
                        VC.MEMBER_API = self.MEMBER_API
                        self.present(VC, animated: true, completion: nil)
                        
                        return
                    }
                    
                    if MEMBER_DICT["result"] as? String ?? "" == "false" {
                        
                        let ALERT = UIAlertController(title: "정보 변경!", message: "정보 변경으로 로그아웃 처리 되었습니다.", preferredStyle: .alert)
                        
                        ALERT.addAction(UIAlertAction(title: "확인", style: .default, handler: { (_) in
                            
                            let VC = self.storyboard?.instantiateViewController(withIdentifier: "LOADING") as! LOADING
                            VC.modalTransitionStyle = .crossDissolve
                            VC.LOGIN = false
                            self.present(VC, animated: true, completion: nil)
                        }))
                        
                        self.present(ALERT, animated: true, completion: nil)
                    }
                }
            case .failure(let encodingError):
                
                print(encodingError)
                break
            }
        }
    }
    
    func ALARM(SC_CODE: String) {
        
        let BASE_URL = DATA_URL().NEW_SCHOOL_URL + "checker/school_info.php"
        
        let PARAMETERS: Parameters = [
            "action_type": "sc_info",
            "sc_code": SC_CODE
        ]
        
        print("파라미터 - \(PARAMETERS)")
        
        Alamofire.request(BASE_URL, method: .post, parameters: PARAMETERS).responseJSON { response in
            
            print("[알림시간]", response)
            
            guard let DATADICT = response.result.value as? [String: Any] else {
                print("[알림시간] - FAIL")
                return
            }
            
            let POST_SC_INFO_DATA = SC_INFO_DATA()
            
            POST_SC_INFO_DATA.SET_SC_IN(SC_IN: DATADICT["sc_in"] as Any)
            POST_SC_INFO_DATA.SET_SC_IN_BTE(SC_IN_BTE: DATADICT["sc_in_bte"] as Any)
            POST_SC_INFO_DATA.SET_SC_IN_BTS(SC_IN_BTS: DATADICT["sc_in_bts"] as Any)
            POST_SC_INFO_DATA.SET_BEACON_DATA(BEACON_DATA: self.SET_BEACON_DATA(BEACON_ARRAY: DATADICT["beacon_info"] as? [Any] ?? []))
            
            self.SC_INFO_API.append(POST_SC_INFO_DATA)
            
            self.PUSH()
        }
    }
    
    func SET_BEACON_DATA(BEACON_ARRAY: [Any]) -> [BEACON_DATA] {
        
        var BEACON_API: [BEACON_DATA] = []
        
        for (_, DATA) in BEACON_ARRAY.enumerated() {
            
            let DATADICT = DATA as? [String: Any]
            let POST_BEACON_DATA = BEACON_DATA()
            
            if DATADICT?["device_type"] as? String ?? "" == "BLE" {
            
                POST_BEACON_DATA.SET_BEACON_MAC(BEACON_MAC: DATADICT?["beacon_mac"] as Any)
                POST_BEACON_DATA.SET_BEACON_MAJOR(BEACON_MAJOR: DATADICT?["beacon_major"] as Any)
                POST_BEACON_DATA.SET_BEACON_MINOR(BEACON_MINOR: DATADICT?["beacon_minor"] as Any)
                POST_BEACON_DATA.SET_BEACON_UUID(BEACON_UUID: DATADICT?["beacon_uuid"] as Any)
                POST_BEACON_DATA.SET_CHECKER_BEACON(CHECKER_BEACON: DATADICT?["checker_beacon"] as Any)
                POST_BEACON_DATA.SET_DEVICE_TYPE(DEVICE_TYPE: DATADICT?["device_type"] as Any)
                POST_BEACON_DATA.SET_IDX(IDX: DATADICT?["idx"] as Any)
                POST_BEACON_DATA.SET_INSTALLED_AT(INSTALLED_AT: DATADICT?["installed_at"] as Any)
                POST_BEACON_DATA.SET_PUBLIC_IP(PUBLIC_IP: DATADICT?["public_ip"] as Any)
                POST_BEACON_DATA.SET_PASSWORD(PASSWORD: DATADICT?["pw"] as Any)
                POST_BEACON_DATA.SET_SC_CODE(SC_CODE: DATADICT?["sc_code"] as Any)
                POST_BEACON_DATA.SET_SC_NAME(SC_NAME: DATADICT?["sc_name"] as Any)
                POST_BEACON_DATA.SET_SSID(SSID: DATADICT?["ssid"] as Any)
                
                BEACON_API.append(POST_BEACON_DATA)
            }
        }
        
        return BEACON_API
    }
    
    func PUSH() {
        
        if SC_INFO_API.count != 0 {
            
            // 백그라운드 위치 업데이트 허용
            LOC_MANAGER.allowsBackgroundLocationUpdates = true
            // 자동으로 위치 업데이트 일시 중지
            LOC_MANAGER.pausesLocationUpdatesAutomatically = false
//            // 위치 정확도
//            LOC_MANAGER.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
//            // 최소 이동 거리
//            LOC_MANAGER.distanceFilter = 100.0
            
            LOC_MANAGER.delegate = self
            LOC_MANAGER.requestAlwaysAuthorization()
            // 위치 업데이트 시작
            LOC_MANAGER.startUpdatingLocation()
            // 중요한 위치 변경 모니터링 시작
            LOC_MANAGER.startMonitoringSignificantLocationChanges()
            
            let DATA = SC_INFO_API[0]
            
            // 위치 접근 권한 설정
            DispatchQueue.main.async { self.LOCATION_ALWAYS() }
            
            // 알림 설정
            if DATA.SC_IN_BTS == " " && DATA.SC_IN_BTE == " " {
                UserDefaults.standard.set("05:00:00", forKey: "start_time")
                UserDefaults.standard.set("22:00:00", forKey: "end_time")
                UserDefaults.standard.synchronize()
            } else {
                UserDefaults.standard.set(DATA.SC_IN_BTS, forKey: "start_time")
                UserDefaults.standard.set(DATA.SC_IN_BTE, forKey: "end_time")
                UserDefaults.standard.synchronize()
            }
            UserDefaults.standard.set(DATA.SC_IN, forKey: "late_time")
            UserDefaults.standard.synchronize()
            
            if SC_INFO_API.count != 0 {
                
                for i in 0 ..< SC_INFO_API[0].BEACON_DATA.count {
                    
                    let DATA = SC_INFO_API[0].BEACON_DATA[i]
                    
                    if (DATA.BEACON_UUID != "") && (DATA.BEACON_MAJOR != "") && (DATA.BEACON_MINOR != "") && (DATA.BEACON_UUID.count == 36) {
                        
                        print("NAME: \(DATA.CHECKER_BEACON)\(i) | UUID: \(DATA.BEACON_UUID)")
                        BEACONS.append(CLBeaconRegion(proximityUUID: UUID(uuidString: DATA.BEACON_UUID)!, identifier: "\(DATA.CHECKER_BEACON)\(i)"))
                    }
                }
            }
            
            for i in 0 ..< BEACONS.count {
                
                LOC_MANAGER.startMonitoring(for: BEACONS[i])
                LOC_MANAGER.startRangingBeacons(in: BEACONS[i])
            }
        }
        
        if MEMBER_API.count != 0 {
            
            UserDefaults.standard.set(self.MEMBER_API[0].B_CODE, forKey: "b_code")
            UserDefaults.standard.synchronize()
        }
    }
}

extension LOADING: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        let APPDELEGATE = UIViewController.APPDELEGATE

        APPDELEGATE.TASK_ID = APPDELEGATE.APP.beginBackgroundTask(expirationHandler: {
            // 백그라운드 시작
            DispatchQueue.main.async { if APPDELEGATE.TASK_ID != .invalid { APPDELEGATE.APP.endBackgroundTask(APPDELEGATE.TASK_ID); APPDELEGATE.TASK_ID = .invalid } }
        })

        for LOCATION in locations { print("LAT: \(LOCATION.coordinate.latitude) / LNG: \(LOCATION.coordinate.longitude)") }

        // 백그라운드 종료
        DispatchQueue.global(qos: .default).async { DispatchQueue.main.async { APPDELEGATE.APP.endBackgroundTask(APPDELEGATE.TASK_ID); APPDELEGATE.TASK_ID = .invalid } }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        print("didRangeBeacons")
        
        let SQL_EDIT: String = "SELECT * FROM NSID_DB"
        let SQL_MSID = UIViewController.APPDELEGATE.SQL_MSID
        
        // QUERY 준비
        if sqlite3_prepare(SQL_MSID.DB, SQL_EDIT, -1, &SQL_MSID.STMT, nil) != SQLITE_OK {
            
            let ERROR_MESSAGE = String(cString: sqlite3_errmsg(SQL_MSID.DB)!)
            print("ERROR PREPARING INSERT: \(ERROR_MESSAGE)")
            return
        }
        
        while sqlite3_step(SQL_MSID.STMT) == SQLITE_ROW {
            
            let POST_MSID_DATA = MSID_DATA()
            
            POST_MSID_DATA.SET_TIME(TIME: String(cString: sqlite3_column_text(SQL_MSID.STMT, 0)) as Any)
            POST_MSID_DATA.SET_CHECK_ID(CHECK_ID: String(cString: sqlite3_column_text(SQL_MSID.STMT, 1)) as Any)
            
            MSID_API.removeAll()
            MSID_API.append(POST_MSID_DATA)
        }
        
        print("beacon: \(beacons)")
        
        let DATE_FORMATTER = DateFormatter()
        DATE_FORMATTER.locale = Locale(identifier: "ko-kr")
        
        // 1. 주말 확인
        DATE_FORMATTER.dateFormat = "E"
        if (DATE_FORMATTER.string(from: Date()) != "토") && (DATE_FORMATTER.string(from: Date()) != "일") {
            
            // 시간
            DATE_FORMATTER.dateFormat = "HH:mm:ss"
            let START_TIME = UserDefaults.standard.string(forKey: "start_time") ?? ""
            let NOW_TIME = DATE_FORMATTER.string(from: Date())
            let END_TIME = UserDefaults.standard.string(forKey: "end_time") ?? ""
            let LATE_TIME = UserDefaults.standard.string(forKey: "late_time") ?? ""
            
            print(MSID_API[0].TIME, DATE_FORMATTER.string(from: Date()), MSID_API[0].CHECK_ID)
            print("시작: \(START_TIME) | 지금: \(NOW_TIME) | 종료: \(END_TIME) | 지각: \(LATE_TIME)")
            
            DATE_FORMATTER.dateFormat = "yyyy-MM-dd"
            if MSID_API[0].TIME != DATE_FORMATTER.string(from: Date()) {
                
                // 3. 시작 <= 지금 <= 종료
                if (START_TIME <= NOW_TIME && NOW_TIME <= END_TIME) {
                    
                    UIViewController.APPDELEGATE.INSERT_DB_MAIN(TIME: "aaaa", CHECK_ID: "false")
                    
                    // 4. 현재
                    if (NOW_TIME <= LATE_TIME) {
                        
                        // 5. 등교체크
                        for i in 0 ..< beacons.count {
                            
                            for ii in 0 ..< SC_INFO_API[0].BEACON_DATA.count {
                                
                                /// 테스트 비콘 - CHECK( MAJOR: 23931, MINOR: 1526 )
                                let DATA = SC_INFO_API[0].BEACON_DATA[ii]
                                if (DATA.BEACON_MAJOR == "\(beacons[i].major)" && DATA.BEACON_MINOR == "\(beacons[i].minor)") || (DATA.BEACON_MAJOR == "1526" && DATA.BEACON_MINOR == "1526") {
                                    if MSID_API[0].CHECK_ID == "false" { CHECK(CHECK_STATUS: "Normal") }; break
                                }
                            }
                        }
                    // 4. 지각
                    } else {
                        
                        // 5. 등교체크
                        for i in 0 ..< beacons.count {
                            
                            for ii in 0 ..< SC_INFO_API[0].BEACON_DATA.count {
                                
                                /// 테스트 비콘 - CHECK( MAJOR: 23931, MINOR: 1526 )
                                let DATA = SC_INFO_API[0].BEACON_DATA[ii]
                                if (DATA.BEACON_MAJOR == "\(beacons[i].major)" && DATA.BEACON_MINOR == "\(beacons[i].minor)") || (DATA.BEACON_MAJOR == "1526" && DATA.BEACON_MINOR == "1526") {
                                    if MSID_API[0].CHECK_ID == "false" { CHECK(CHECK_STATUS: "Late") }; break
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func CHECK(CHECK_STATUS: String) {
        
        let DATE_FORMATTER = DateFormatter()
        DATE_FORMATTER.dateFormat = "yyyy-MM-dd"
        UIViewController.APPDELEGATE.INSERT_DB_MAIN(TIME: DATE_FORMATTER.string(from: Date()), CHECK_ID: "true")
        
        DATE_FORMATTER.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let PARAMETERS: Parameters = [
            "sc_code": UserDefaults.standard.string(forKey: "sc_code") ?? "",
            "c_num": UserDefaults.standard.string(forKey: "c_num") ?? "",
            "check_in": DATE_FORMATTER.string(from: Date()),
            "check_status": CHECK_STATUS,
            "neis_code": UserDefaults.standard.string(forKey: "neis_code") ?? "",
            "lo_status": "Y"
        ]
        
        print("파라미터 -", PARAMETERS)
        
        Alamofire.upload(multipartFormData: { multipartFormData in

            for (KEY, VALUE) in PARAMETERS {

                print("KEY: \(KEY)", "VALUE: \(VALUE)")
                multipartFormData.append("\(VALUE)".data(using: String.Encoding.utf8)!, withName: KEY as String)
            }
        }, to: "https://damoadata.pen.go.kr/_check_monitor/check_result_app.php") { (result) in
            
            switch result {
            case .success(let upload, _, _):
                
                upload.responseString { response in
            
                    print("[등교체크]", response)
                    
                    if "\(response)" == "SUCCESS: SUCCESS" {
                        self.LOCAL_NOTIFICATION(DATE: Date(), NETWORK: true)
                    } else {
                        self.LOCAL_NOTIFICATION(DATE: Date(), NETWORK: false)
                    }
                    // 비콘 확인시 체크
                    DATE_FORMATTER.dateFormat = "yyyy-MM-dd"
                    UIViewController.APPDELEGATE.INSERT_DB_MAIN(TIME: DATE_FORMATTER.string(from: Date()), CHECK_ID: "true")
                }
                
            case .failure(let encodingError):
                
                print(encodingError)
                break
            }
        }
    }
}

extension LOADING {
    
    func LOCAL_NOTIFICATION(DATE: Date, NETWORK: Bool) {
        
        let CHECK_CONTENT = UNMutableNotificationContent()
        
        if NETWORK == false {
            
            CHECK_CONTENT.title = "부산 모바일 학생증"
            CHECK_CONTENT.body = "[알림] 등교(출결) 확인 실패\n학생증(바코드)으로 확인해주세요!"
            CHECK_CONTENT.sound = .default
        } else {
            
            CHECK_CONTENT.title = "부산 모바일 학생증"
            CHECK_CONTENT.body = "[알림] 등교(출결) 확인 성공"
            CHECK_CONTENT.sound = .default
        }
        
        let TRIGGER = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let REQUEST = UNNotificationRequest(identifier: "timerdone", content: CHECK_CONTENT, trigger: TRIGGER)
        UNUserNotificationCenter.current().add(REQUEST)
    }
}
