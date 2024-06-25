//
//  NOT_NETWORK.swift
//  iBeacon
//
//  Created by 부산광역시교육청 on 2020/10/26.
//  Copyright © 2020 장제현. All rights reserved.
//

import UIKit

class NOT_NETWORK: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet weak var BARCODE_IMAGE: UIImageView!      // 바코드_이미지
    @IBOutlet weak var BARCODE_NOTDATA: UILabel!        // 사용불가_안내
    @IBOutlet weak var LB_NAME: UILabel!                // 도서관명

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let B_CODE = UserDefaults.standard.string(forKey: "b_code") ?? ""
        
        // 도서관_대출증_바코드
        let CODE_GENERATOR = BARCODE()
        
        var TYPE: BARCODE_TYPE
        var SIZE: CGSize
        
        TYPE = .CODE_128
        SIZE = CGSize(width: BARCODE_IMAGE.frame.size.width, height: BARCODE_IMAGE.frame.size.height)
        
        if B_CODE == "" {
            BARCODE_IMAGE.alpha = 0.2
            BARCODE_IMAGE.image = CODE_GENERATOR.BARCODE(CODE: "37ge392r297gf834", TYPE: TYPE, SIZE: SIZE)
            BARCODE_NOTDATA.isHidden = false
        } else {
            BARCODE_IMAGE.alpha = 1.0
            BARCODE_IMAGE.image = CODE_GENERATOR.BARCODE(CODE: B_CODE, TYPE: TYPE, SIZE: SIZE)
            BARCODE_NOTDATA.isHidden = true
        }
//        // 도서관이름
//        LB_NAME.text = "\(DATA.SC_NAME)"
        
        // 실시간 네트워크 확인
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if self.SYSTEM_NETWORK_CHECKING() {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
