//
//  POINT.swift
//  iBeacon
//
//  Created by i-Mac on 2020/09/23.
//  Copyright © 2020 장제현. All rights reserved.
//

import UIKit
import Alamofire

class POINT_TC: UITableViewCell {
    
    @IBOutlet weak var POINTVIEW: UIView!
    @IBOutlet weak var POINT_BG: UIView!
    @IBOutlet weak var CATE: UILabel!
    @IBOutlet weak var PO_DATETIME: UILabel!
    @IBOutlet weak var PO_CONTENT: UILabel!
    @IBOutlet weak var BK_NAME: UILabel!
    @IBOutlet weak var PO_POINT: UILabel!
    
    @IBOutlet weak var PROGRESS: UIActivityIndicatorView!
}

class POINT: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    @IBOutlet weak var BACKVIEW: UIView!
    @IBAction func BACK(_ sender: UIButton) {
        
        let VC = self.presentingViewController as! HOME
        if POINT_API.count != 0 {
            if POINT_API[0].PO_POINT != "" {
                VC.PO_MB_POINT = POINT_API[0].PO_MB_POINT
                VC.TABLEVIEW.reloadData()
            }
        }
        VC.dismiss(animated: true, completion: nil)
    }
    
    var FETCHING_MORE = false
    var PAGE_NUMBER: Int = 0
    var ITEM_COUNT: Int = 20
    
    var POINT_API: [POINT_DATA] = []
    var NEIS_CODE: String = ""
    
    @IBOutlet weak var NOT_DATA: UIStackView!
    @IBOutlet weak var TABLEVIEW: UITableView!
    
    let VIEW = UIView()
    override func loadView() {
        super.loadView()
        
        NOT_DATA.isHidden = true
        EFFECT_INDICATOR_VIEW(VIEW, true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 실시간 네트워크 확인
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if !self.SYSTEM_NETWORK_CHECKING() { self.NOT_NETWORK_VC() }
        }
        
        BACKVIEW.SHADOW_VIEW(COLOR: .black, OFFSET: CGSize(width: 0.0, height: 5.0), SHADOW_RADIUS: 5.0, OPACITY: 0.2, RADIUS: 25.0)
        
        if !SYSTEM_NETWORK_CHECKING() {
            NOTIFICATION_VIEW("네트워크 상태를 확인해 주세요")
        } else {
            POINT_LIST()
        }
        
        TABLEVIEW.delegate = self
        TABLEVIEW.dataSource = self
        TABLEVIEW.separatorStyle = .none
    }
}

extension POINT: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if POINT_API.count == 0 {
                NOT_DATA.isHidden = false
                TABLEVIEW.isHidden = true
                return 0
            } else {
                NOT_DATA.isHidden = true
                TABLEVIEW.isHidden = false
                return POINT_API.count
            }
        } else if section == 1 && FETCHING_MORE {
            return 1
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
        
            let CELL = tableView.dequeueReusableCell(withIdentifier: "POINT_TC", for: indexPath) as! POINT_TC
            
            let DATA = POINT_API[indexPath.item]
            
            CELL.POINTVIEW.SHADOW_VIEW(COLOR: .black, OFFSET: CGSize(width: 0.0, height: 7.5), SHADOW_RADIUS: 7.5, OPACITY: 0.1, RADIUS: 10.0)
            
            if DATA.CATE == "상점" {
                CELL.POINT_BG.backgroundColor = .SKYBLUE_COLOR
                CELL.CATE.text = "상점"
                CELL.PO_POINT.textColor = .SKYBLUE_COLOR
            } else if DATA.CATE == "벌점" {
                CELL.POINT_BG.backgroundColor = .systemRed
                CELL.CATE.text = "벌점"
                CELL.PO_POINT.textColor = .systemRed
            } else {
                CELL.POINT_BG.backgroundColor = .darkGray
                CELL.CATE.text = "수정 및 삭제"
                CELL.PO_POINT.textColor = .darkGray
            }
            // 날짜
            if DATA.PO_DATETIME == "0000-00-00" || DATA.PO_DATETIME == "" {
                CELL.PO_DATETIME.text = "-"
            } else {
                let DATEFORMATTER = DateFormatter()
                DATEFORMATTER.dateFormat = "yyyy-MM-dd"
                let PO_DATETIME = DATEFORMATTER.date(from: "\(DATA.PO_DATETIME)") ?? Date()
                DATEFORMATTER.dateFormat = "yyyy년 MM월 dd일"
                CELL.PO_DATETIME.text = "\(DATEFORMATTER.string(from: PO_DATETIME))"
            }
            // 내용
            if DATA.PO_CONTENT != "" { CELL.PO_CONTENT.text = DATA.PO_CONTENT }
            // 교사
            if DATA.BK_NAME != "" { CELL.BK_NAME.text = DATA.BK_NAME }
            // 점수
            if DATA.PO_POINT != "" { CELL.PO_POINT.text = DATA.PO_POINT }
            
            return CELL
        } else {
            
            let CELL = tableView.dequeueReusableCell(withIdentifier: "POINT_TC_LOAD", for: indexPath) as! POINT_TC
            
            CELL.PROGRESS.startAnimating()
            
            return CELL
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let OFFSET_Y = scrollView.contentOffset.y
        let CONTENT_HEIGHT = scrollView.contentSize.height
        
        if OFFSET_Y > CONTENT_HEIGHT - scrollView.frame.height { if !FETCHING_MORE { BEGINBATCHFETCH() } }
    }
    
    func BEGINBATCHFETCH() {
        
        FETCHING_MORE = true
        
        TABLEVIEW.reloadSections(IndexSet(integer: 1), with: .none)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            
            self.PAGE_NUMBER = self.PAGE_NUMBER + 1
            if !self.SYSTEM_NETWORK_CHECKING() {
                self.NOTIFICATION_VIEW("네트워크 상태를 확인해 주세요")
            } else {
                self.POINT_LIST()
            }
            self.FETCHING_MORE = false
        })
    }
}

extension POINT {
    
    func POINT_LIST() {
        
        let PARAMETERS: Parameters = [
            "limit_start": PAGE_NUMBER * ITEM_COUNT,
            "neis_code": NEIS_CODE
        ]
        
        print("파라미터 -", PARAMETERS)
        
        Alamofire.upload(multipartFormData: { multipartFormData in

            for (KEY, VALUE) in PARAMETERS {

                print("KEY: \(KEY)", "VALUE: \(VALUE)")
                multipartFormData.append("\(VALUE)".data(using: String.Encoding.utf8)!, withName: KEY as String)
            }
        }, to: DATA_URL().NEW_SCHOOL_URL + "checker/point.php") { (result) in
            
            switch result {
            case .success(let upload, _, _):
                
                upload.responseJSON { response in
                    
                    print("[상.벌점]", response)
                    
                    guard let POINT_ARRAY = response.result.value as? Array<Any> else {
                        print("[상.벌점] - FAIL")
                        self.TABLEVIEW.reloadData()
                        self.EFFECT_INDICATOR_VIEW(self.VIEW, false)
                        return
                    }
                    
                    for (_, DATA) in POINT_ARRAY.enumerated() {
                        
                        let POST_POINT_DATA = POINT_DATA()
                        
                        let DATADICT = DATA as? [String: Any]
                        
                        POST_POINT_DATA.SET_PO_ID(PO_ID: DATADICT?["po_id"] as Any)
                        POST_POINT_DATA.SET_PO_DATETIME(PO_DATETIME: DATADICT?["po_datetime"] as Any)
                        POST_POINT_DATA.SET_PO_CONTENT(PO_CONTENT: DATADICT?["po_content"] as Any)
                        POST_POINT_DATA.SET_PO_POINT(PO_POINT: DATADICT?["po_point"] as Any)
                        POST_POINT_DATA.SET_PO_USE_POINT(PO_USE_POINT: DATADICT?["po_use_point"] as Any)
                        POST_POINT_DATA.SET_PO_EXPIRED(PO_EXPIRED: DATADICT?["po_expired"] as Any)
                        POST_POINT_DATA.SET_PO_EXPIRE_DATE(PO_EXPIRE_DATE: DATADICT?["po_expire_date"] as Any)
                        POST_POINT_DATA.SET_PO_MB_POINT(PO_MB_POINT: DATADICT?["po_mb_point"] as Any)
                        POST_POINT_DATA.SET_PO_REL_TABLE(PO_REL_TABLE: DATADICT?["po_rel_table"] as Any)
                        POST_POINT_DATA.SET_PO_REL_ID(PO_REL_ID: DATADICT?["po_rel_id"] as Any)
                        POST_POINT_DATA.SET_PO_REL_ACTION(PO_REL_ACTION: DATADICT?["po_rel_action"] as Any)
                        POST_POINT_DATA.SET_C_NUM(C_NUM: DATADICT?["c_num"] as Any)
                        POST_POINT_DATA.SET_BK_HP(BK_HP: DATADICT?["bk_hp"] as Any)
                        POST_POINT_DATA.SET_SC_CODE(SC_CODE: DATADICT?["sc_code"] as Any)
                        POST_POINT_DATA.SET_MB_GRADE(MB_GRADE: DATADICT?["mb_grade"] as Any)
                        POST_POINT_DATA.SET_MB_CLASS(MB_CLASS: DATADICT?["mb_class"] as Any)
                        POST_POINT_DATA.SET_C_NAME(C_NAME: DATADICT?["c_name"] as Any)
                        POST_POINT_DATA.SET_CATE(CATE: DATADICT?["cate"] as Any)
                        POST_POINT_DATA.SET_PO_CAT(PO_CAT: DATADICT?["po_cat"] as Any)
                        POST_POINT_DATA.SET_MB_NO(MB_NO: DATADICT?["mb_no"] as Any)
                        POST_POINT_DATA.SET_TEACHER_NAME(TEACHER_NAME: DATADICT?["teacher_name"] as Any)
                        POST_POINT_DATA.SET_BK_NAME(BK_NAME: DATADICT?["bk_name"] as Any)
                        POST_POINT_DATA.SET_POINT_DEL(POINT_DEL: DATADICT?["point_del"] as Any)
                        POST_POINT_DATA.SET_MB_ID(MB_ID: DATADICT?["mb_id"] as Any)
                        POST_POINT_DATA.SET_PO_SUM(PO_SUM: DATADICT?["po_sum"] as Any)
                        POST_POINT_DATA.SET_NEIS_CODE(NEIS_CODE: DATADICT?["neis_code"] as Any)
                        POST_POINT_DATA.SET_BG_NO(BG_NO: DATADICT?["bg_no"] as Any)
                        POST_POINT_DATA.SET_YEAR(YEAR: DATADICT?["year"] as Any)
                        
                        self.POINT_API.append(POST_POINT_DATA)
                    }
                    
                    self.TABLEVIEW.reloadData()
                    self.EFFECT_INDICATOR_VIEW(self.VIEW, false)
                }
            case .failure(let encodingError):
                
                print(encodingError)
                break
            }
        }
    }
}
