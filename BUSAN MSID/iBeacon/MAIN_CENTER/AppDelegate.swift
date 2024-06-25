//
//  AppDelegate.swift
//  iBeacon
//
//  Created by i-Mac on 2020/09/14.
//  Copyright © 2020 장제현. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
    
    var position = 0
    var NEW_VERSION: String = ""
    
    var SQL_MSID = SQLITE_MSID()
    
    var MEMBER_API: [MEMBER_DATA] = []
    
    var WINDOW: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
    var STORYBOARD: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    let APP = UIApplication.shared
    var TASK_ID = UIBackgroundTaskIdentifier.invalid

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        // 내부DB 연결
        OPEN_DB_MAIN()
        // 버전 체크
        HTTP_VERSION_CHECK()
        
        return true
    }
    
    // 버전 체크
    func HTTP_VERSION_CHECK() {
        
        let VERSION_CHECK = DATA_URL().NEW_SCHOOL_URL + "checker/version_check.php"
        
        let PARAMETERS: Parameters = [ "os": "ios" ]
        
        print("PARAMETERS -" , PARAMETERS)

        Alamofire.request(VERSION_CHECK, method: .post, parameters: PARAMETERS).responseJSON { response in

            print("[버전체크]", response)
            
            guard let VERSIONDICT = response.result.value as? [String: Any] else {
                print("[버전체크] FAIL")
                self.LOGIN_CHECK()
                return
            }
            
            self.NEW_VERSION.append(VERSIONDICT["version_name"] as? String ?? "1.0.0")
            self.LOGIN_CHECK()
        }
    }
    
    func LOGIN_CHECK() {
        
        // 임시 데이터
//        UserDefaults.standard.set("01031870005", forKey: "mb_id")
//        UserDefaults.standard.set("iOS테스트", forKey: "bk_name")
//        UserDefaults.standard.set("C100000459", forKey: "sc_code")
//        UserDefaults.standard.set("10140", forKey: "c_num")
//        UserDefaults.standard.set("C1000004591601349369", forKey: "neis_code")
//        UserDefaults.standard.removeObject(forKey: "date")
//        UserDefaults.standard.synchronize()
        
        if UserDefaults.standard.string(forKey: "c_num") ?? "" != "" {
            
            let VC = STORYBOARD.instantiateViewController(withIdentifier: "LOADING") as! LOADING
            VC.modalTransitionStyle = .crossDissolve
            VC.LOGIN = true
            WINDOW?.rootViewController = VC
            WINDOW?.makeKeyAndVisible()
        } else {
            
            let VC = STORYBOARD.instantiateViewController(withIdentifier: "LOADING") as! LOADING
            VC.modalTransitionStyle = .crossDissolve
            VC.LOGIN = false
            WINDOW?.rootViewController = VC
            WINDOW?.makeKeyAndVisible()
        }
    }
}

extension AppDelegate {
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // 콘솔에 오류를 인쇄하십시오 (등록에 실패했음을 사용자에게 알려야합니다)
        // print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // 응용 프로그램이 활성 상태에서 비활성 상태로 이동하려고 할 때 전송됩니다. 이는 특정 유형의 일시적인 중단 (예 : 전화 또는 SMS 메시지 수신) 또는 사용자가 응용 프로그램을 종료하고 백그라운드 상태로 전환하기 시작할 때 발생할 수 있습니다.
        // 이 방법을 사용하여 진행중인 작업을 일시 중지하고 타이머를 비활성화하고 그래픽 렌더링 콜백을 무효화하십시오. 게임은이 방법을 사용하여 게임을 일시 중지해야합니다.
        print("applicationWillResignActive")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // 이 방법을 사용하여 공유 리소스를 해제하고, 사용자 데이터를 저장하고, 타이머를 무효화하고, 애플리케이션이 나중에 종료 될 경우 애플리케이션을 현재 상태로 복원 할 수있는 충분한 애플리케이션 상태 정보를 저장하십시오.
        // 애플리케이션이 백그라운드 실행을 지원하는 경우 사용자가 종료 할 때 applicationWillTerminate: 대신이 메소드가 호출됩니다.
        print("applicationDidEnterBackground")
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // 응용 프로그램이 비활성화 된 동안 일시 중지되었거나 아직 시작되지 않은 작업을 다시 시작하십시오. 응용 프로그램이 이전에 백그라운드에 있었던 경우 선택적으로 사용자 인터페이스를 새로 고칩니다. :.
        print("applicationWillEnterForeground")
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // 응용 프로그램이 비활성화 된 동안 일시 중지되었거나 아직 시작되지 않은 작업을 다시 시작하십시오. 애플리케이션이 이전에 백그라운드에 있었던 경우 선택적으로 사용자 인터페이스를 새로 고칩니다.
        print("applicationDidBecomeActive")
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // 응용 프로그램이 종료 되려고 할 때 호출됩니다. 적절한 경우 데이터를 저장하십시오. applicationDidEnterBackground: 참조하십시오.
        print("applicationWillTerminate")
    }
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        print("applicationDidFinishLaunching")
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        completionHandler(.newData)
    }
    
    func OPEN_DB_MAIN() {
        
        let FILE_URL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("NSID_DB.sqlite")
        
        if sqlite3_open(FILE_URL.path, &SQL_MSID.DB) != SQLITE_OK {
            print("DB 연결 실패")
        }
        
        // KEY_ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        
        let CREATE_TABLE = "CREATE TABLE IF NOT EXISTS NSID_DB (TIME TEXT, CHECK_ID TEXT)"
        
        if sqlite3_exec(SQL_MSID.DB, CREATE_TABLE, nil, nil, nil) != SQLITE_OK {
            let ERROR_MESSAGE = String(cString: sqlite3_errmsg(SQL_MSID.DB)!)
            print("ERROR CREATING TABLE : \(ERROR_MESSAGE)")
        }
    }
    
    func INSERT_DB_MAIN(TIME: String, CHECK_ID: String) {
        
        let INSERT_TABLE = "INSERT INTO NSID_DB (TIME, CHECK_ID) VALUES ('\(TIME)', '\(CHECK_ID)')"
        
        if sqlite3_prepare_v2(self.SQL_MSID.DB, INSERT_TABLE, -1, &self.SQL_MSID.STMT, nil) != SQLITE_OK {
            let ERROR_MESSAGE = String(cString: sqlite3_errmsg(self.SQL_MSID.DB)!)
            print("ERROR PREPARING INSERT : \(ERROR_MESSAGE)")
            return
        }
        
        if sqlite3_step(self.SQL_MSID.STMT) != SQLITE_DONE {
            print("FAILURE SAVED")
        }
    }
    
    func DELETE_DB() {
        
        let DELETE_TABLE = "DELETE FROM NSID_DB"
        
        if sqlite3_exec(SQL_MSID.DB, DELETE_TABLE, nil, nil, nil) != SQLITE_OK {
            let ERROR_MESSAGE = String(cString: sqlite3_errmsg(SQL_MSID.DB)!)
            print("ERROR DELETE TABLE : \(ERROR_MESSAGE)")
        }
    }
}

extension LOADING: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        UIApplication.shared.applicationIconBadgeNumber += 1
        
        completionHandler([.alert, .sound, .badge])
    }
}

