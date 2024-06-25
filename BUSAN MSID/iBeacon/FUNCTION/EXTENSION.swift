//
//  EXTENSION.swift
//  iBeacon
//
//  Created by i-Mac on 2020/09/14.
//  Copyright © 2020 장제현. All rights reserved.
//

import UIKit
import Nuke
import Alamofire
import Foundation
import CoreLocation
import SystemConfiguration

extension UIViewController {
    
    static var APPDELEGATE = UIApplication.shared.delegate as! AppDelegate
    
    // 네트워크 연결 실패
    func NOT_NETWORK_VC() {
        
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "NOT_NETWORK") as! NOT_NETWORK
        VC.modalTransitionStyle = .crossDissolve
        present(VC, animated: true, completion: nil)
    }
    
    func NOTIFICATION_VIEW(_ MESSAGE: String) {
        
        let NOTIFICATION = UILabel(frame: CGRect(x: view.frame.size.width/2 - 97.5, y: 0.0, width: 195.0, height: 50.0))
            
        NOTIFICATION.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        NOTIFICATION.textColor = .lightGray
        NOTIFICATION.textAlignment = .center
        NOTIFICATION.font = UIFont.boldSystemFont(ofSize: 12)
        NOTIFICATION.text = MESSAGE
        NOTIFICATION.layer.cornerRadius = 25.0
        NOTIFICATION.clipsToBounds = true
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
            
            NOTIFICATION.alpha = 1.0
            NOTIFICATION.transform = CGAffineTransform(translationX: 0, y: 44.0)
//            if self.DEVICE_RATIO() == "Ratio 16:9" {
//                NOTIFICATION.transform = CGAffineTransform(translationX: 0, y: 20.0)
//            } else {
//                NOTIFICATION.transform = CGAffineTransform(translationX: 0, y: 44.0)
//            }
        })
        
        view.addSubview(NOTIFICATION)
        
        UIView.animate(withDuration: 0.2, delay: 2.0, options: .curveEaseOut, animations: {
            
            NOTIFICATION.alpha = 0.0
            NOTIFICATION.transform = CGAffineTransform(translationX: 0, y: 0.0)
        }, completion: {(isCompleted) in
            
            NOTIFICATION.removeFromSuperview()
        })
    }
    
    func EFFECT_INDICATOR_VIEW(_ VIEW: UIView, _ TURN_ON: Bool) {
        
        VIEW.frame = CGRect(x: view.frame.size.width / 2 - 120.0, y: view.frame.size.height / 2 - 25.0, width: 240.0, height: 60.0)
        VIEW.backgroundColor = .clear
        VIEW.layer.cornerRadius = 10.0
        VIEW.clipsToBounds = true
        
        let EFFECT_VIEW = UIVisualEffectView()
        EFFECT_VIEW.frame = VIEW.bounds
        EFFECT_VIEW.effect = UIBlurEffect(style: .extraLight)
        VIEW.addSubview(EFFECT_VIEW)
        
        let LOADING_INDICATOR = UIActivityIndicatorView()
        LOADING_INDICATOR.frame = CGRect(x: 10, y: 5, width: 50, height: 50)
        LOADING_INDICATOR.hidesWhenStopped = true
        if #available(iOS 13.0, *) { LOADING_INDICATOR.style = .large }
        LOADING_INDICATOR.color = .SKYBLUE_COLOR
        if TURN_ON == true { LOADING_INDICATOR.startAnimating() } else { LOADING_INDICATOR.stopAnimating() }
        VIEW.addSubview(LOADING_INDICATOR)
        
        let LABEL = UILabel()
        LABEL.frame = CGRect(x: 60.0, y: 20.0, width: 170.0, height: 20.0)
        LABEL.textColor = .darkGray
        LABEL.textAlignment = .center
        LABEL.font = UIFont.boldSystemFont(ofSize: 14)
        LABEL.text = "데이터 불러오는 중..."
        VIEW.addSubview(LABEL)
        
        if TURN_ON == true {
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
                VIEW.alpha = 1.0
            })
            view.addSubview(VIEW)
        } else {
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
                VIEW.alpha = 0.0
            }, completion: {(isCompleted) in
                VIEW.removeFromSuperview()
            })
        }
        
    }
    
    // 이미지 비동기화
    func NUKE_IMAGE(IMAGE_URL: String, PLACEHOLDER: UIImage, PROFILE: UIImageView, FRAME_SIZE: CGSize) {
        
        let REQUEST = ImageRequest(url: URL(string: IMAGE_URL)!, processors: [ImageProcessors.Resize(size: FRAME_SIZE)])
        let OPTIONS = ImageLoadingOptions(placeholder: PLACEHOLDER, contentModes: .init(success: .scaleAspectFill, failure: .scaleAspectFit, placeholder: .scaleAspectFit))
        Nuke.loadImage(with: REQUEST, options: OPTIONS, into: PROFILE)
    }
    
    // 위치 항상 허용
    func LOCATION_ALWAYS() {
        
        if !(CLLocationManager.authorizationStatus() == .authorizedAlways) {
            
            let ALERT = UIAlertController(title: "\'부산모바일학생증\'이(가) \'위치설정\'을(를) 열려고 합니다", message: "등교 확인하기 위해 위치 접근 권한을 \'항상\'으로 설정해 주세요.", preferredStyle: .alert)
            
            ALERT.addAction(UIAlertAction(title: "열기", style: .default, handler: { (_) in
                UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
            }))
            ALERT.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
            
            present(ALERT, animated: true, completion: nil)
        }
    }
}

extension UIViewController: UITextFieldDelegate {
    
    // 키보드 나타남
    @objc func KEYBOARD_SHOW(_ NOTIFICATION: Notification) {
        
        let KEY = NOTIFICATION.userInfo![UIResponder.keyboardFrameEndUserInfoKey]
        let RECT = (KEY! as AnyObject).cgRectValue
        
        let KEYBOARD_FRAME_END = view!.convert(RECT!, to: nil)
        view.frame = CGRect(x: 0, y: 0, width: KEYBOARD_FRAME_END.size.width, height: KEYBOARD_FRAME_END.origin.y)
        view.layoutIfNeeded()
    }
    // 키보드 사라짐
    @objc func KEYBOARD_HIDE(_ NOTIFICATION: Notification) {
        
        let KEY = NOTIFICATION.userInfo![UIResponder.keyboardFrameBeginUserInfoKey]
        let RECT = (KEY! as AnyObject).cgRectValue
        
        view.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.width, height: view.frame.height + RECT!.height)
        view.layoutIfNeeded()
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // PLACEHOLDER 표시
    func PLACEHOLDER(TEXT_FILELD: UITextField, PLACEHOLDER: String, WHITE: CGFloat) {
        
        TEXT_FILELD.attributedPlaceholder = NSAttributedString(string: PLACEHOLDER, attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(white: WHITE, alpha: 0.5)])
    }
    
    // 완료 버튼
    func TOOL_BAR_DONE(TEXT_FILELD: UITextField) {
        
        let TOOL_BAR = UIToolbar()
        TOOL_BAR.sizeToFit()
        
        let SPACE = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let DONE = UIBarButtonItem(title: "완료", style: .done, target: self, action:  #selector(DONE_CLICKED))
        if #available(iOS 13.0, *) { TOOL_BAR.tintColor = .label } else { TOOL_BAR.tintColor = .black }
        TOOL_BAR.setItems([SPACE, DONE], animated: false)
        
        TEXT_FILELD.inputAccessoryView = TOOL_BAR
    }
    
    // 완료 버튼
    func TOOL_BAR_DONE(TEXT_VIEW: UITextView) {
        
        let TOOL_BAR = UIToolbar()
        TOOL_BAR.sizeToFit()
        
        let SPACE = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let DONE = UIBarButtonItem(title: "완료", style: .done, target: self, action:  #selector(DONE_CLICKED))
        if #available(iOS 13.0, *) { TOOL_BAR.tintColor = .label } else { TOOL_BAR.tintColor = .black }
        TOOL_BAR.setItems([SPACE, DONE], animated: false)
        
        TEXT_VIEW.inputAccessoryView = TOOL_BAR
    }
    
    @objc func DONE_CLICKED() { view.endEditing(true) }
    
    // 하이픈
    func FORMAT(MASK: String, PHONE: String) -> String {
        
        let NUMBERS = PHONE.replacingOccurrences(of: "[^0-9*#]", with: "", options: .regularExpression)
        var RESULT: String = ""
        var INDEX = NUMBERS.startIndex
        
        for CH in MASK where INDEX < NUMBERS.endIndex {
            
            if CH == "X" {
                RESULT.append(NUMBERS[INDEX])
                INDEX = NUMBERS.index(after: INDEX)
            } else {
                RESULT.append(CH)
            }
        }
        
        return RESULT
    }
    
    // 전화번호 형식 체크
    func PHONE_NUM_CHECK(PHONE_NUM: String) -> Bool {
        
        let REGEX = "^01([0|1|6|7|8|9]?)-?([0-9]{3,4})-?([0-9]{4})$"
        return NSPredicate(format: "SELF MATCHES %@", REGEX).evaluate(with: PHONE_NUM)
    }
    
    // 인증번호 형식 체크
    func SMS_NUM_CHECK(PHONE_NUM: String) -> Bool {
        
        let REGEX = "^([0-9]{6})$"
        return NSPredicate(format: "SELF MATCHES %@", REGEX).evaluate(with: PHONE_NUM)
    }
    
    // 네트워크 연결 확인
    func SYSTEM_NETWORK_CHECKING() -> Bool {
        
        var ZERO_ADDRESS = sockaddr_in()
        ZERO_ADDRESS.sin_len = UInt8(MemoryLayout.size(ofValue: ZERO_ADDRESS))
        ZERO_ADDRESS.sin_family = sa_family_t(AF_INET)
        
        let DEFAULT_ROUTE_REACHABILITY = withUnsafePointer(to: &ZERO_ADDRESS, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1, { zero_Sock_Address in
                SCNetworkReachabilityCreateWithAddress(nil, zero_Sock_Address)
            })
        })
        
        var FLAGS = SCNetworkReachabilityFlags()
        
        if !SCNetworkReachabilityGetFlags(DEFAULT_ROUTE_REACHABILITY!, &FLAGS) {
            return false
        }
        
        let IS_REACHABLE = FLAGS.contains(.reachable)
        let NEEDS_CONNECTION = FLAGS.contains(.connectionRequired)
        
        return (IS_REACHABLE && !NEEDS_CONNECTION)
    }
}

extension UITableViewCell {
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
}

extension UIView {
    
    public func SHADOW_VIEW(COLOR: UIColor, OFFSET: CGSize, SHADOW_RADIUS: CGFloat, OPACITY: Float, RADIUS: CGFloat) {
        
        layer.shadowColor = COLOR.cgColor
        layer.shadowOffset = OFFSET
        layer.shadowOpacity = OPACITY
        layer.shadowRadius = SHADOW_RADIUS
        layer.cornerRadius = RADIUS
    }
}

extension UIColor {
    
    static var SKYBLUE_COLOR = UIColor.init(red: 92/255, green: 187/255, blue: 255/255, alpha: 1.0)
}
