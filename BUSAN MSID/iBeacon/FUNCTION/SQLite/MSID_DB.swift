//
//  MSID_DB.swift
//  DAMOA
//
//  Created by 장제현 on 2020/04/05.
//  Copyright © 2020 장제현. All rights reserved.
//

import Foundation

class SQLITE_MSID {
    
    var DB: OpaquePointer?          // SQLite 연결 정보를 담을 객체
    var STMT: OpaquePointer?        // 컴파일된 SQL을 담을 객체
}

public class MSID_DATA {
    
    var TIME: String = ""
    var CHECK_ID: String = ""
    
    func SET_TIME(TIME: Any) { self.TIME = TIME as? String ?? "" }
    func SET_CHECK_ID(CHECK_ID: Any) { self.CHECK_ID = CHECK_ID as? String ?? "false" }
}
