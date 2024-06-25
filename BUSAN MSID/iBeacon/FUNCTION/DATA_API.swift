//
//  DATA_API.swift
//  iBeacon
//
//  Created by i-Mac on 2020/09/16.
//  Copyright © 2020 장제현. All rights reserved.
//

import Foundation

// MARK: - 통신 주소
class DATA_URL {
    
    var SCHOOL_URL = "https://damoaapp.pen.go.kr/conn/"
    var SCHOOL_LOGO_URL = "https://sms.pen.go.kr/files/school_logo/"
    var SCHOOL_LOCATION_URL = "http://damoalbs.pen.go.kr/conn/location/"
    
    var NEW_SCHOOL_URL = "https://dapp.uic.me/conn/"
    var NEW_PROFILE_URL = "https://dapp.uic.me/member_img/"
}

// MARK: - 학교 목록 (검색)
struct SCHOOL_DATA {
    
    var SC_CODE: String = ""
    var SC_GRADE: String = ""
    var SC_GROUP: String = ""
    var SC_LOCATION: String = ""
    var SC_LOGO: String = ""
    var SC_NAME: String = ""
    var SC_ADDRESS: String = ""
}

// MARK: - 멤버 확인
public class MEMBER_DATA {

    var APP_PARENT_01: String = ""
    var APP_ST: String = ""
    var B_CODE: String = ""
    var BG_NO: String = ""
    var BK_DATETIME: String = ""
    var BK_HP: String = ""
    var BK_MEMO: String = ""
    var BK_NAME: String = ""
    var BK_NO: String = ""
    var BOOK_YEAR: String = ""
    var C_NUM: String = ""
    var COIN_MAC: String = ""
    var DEL_PER: String = ""
    var DORM: String = ""
    var DORM_CHECKOUT: String = ""
    var DORM_STATUS: String = ""
    var FCM_CHECK: String = ""
    var FCM_KEY: String = ""
    var FCM_KEY_P1: String = ""
    var FCM_KEY_P2: String = ""
    var FOOD_KEY: String = ""
    var FOOD_KEY_P1: String = ""
    var FOOD_KEY_P2: String = ""
    var FOOD_PAY_EVE: String = ""
    var FOOD_PAY_MOR: String = ""
    var FOOD_PAY_MOON: String = ""
    var INPUT_MONTH: String = ""
    var INPUT_YEAR: String = ""
    var MAC: String = ""
    var MB_CLASS: String = ""
    var MB_FILE: String = ""
    var MB_GRADE: String = ""
    var MB_NO: String = ""
    var MB_OUT_PLAN: String = ""
    var MB_PLAN_IN_DATE: String = ""
    var MB_PLAN_OUT_DATE: String = ""
    var MB_POINT: String = ""
    var MINUS_POINT: String = ""
    var NEIS_CODE: String = ""
    var NFIX_POINT: String = ""
    var P_PHONE_01: String = ""
    var P_PHONE_02: String = ""
    var PLUS_POINT: String = ""
    var SC_CODE: String = ""
    var SC_GRADE: String = ""
    var SC_GROUP: String = ""
    var SC_LOCATION: String = ""
    var SC_NAME: String = ""
    
    func SET_APP_PARENT_01(APP_PARENT_01: Any) { self.APP_PARENT_01 = APP_PARENT_01 as? String ?? "" }
    func SET_APP_ST(APP_ST: Any) { self.APP_ST = APP_ST as? String ?? "" }
    func SET_B_CODE(B_CODE: Any) { self.B_CODE = B_CODE as? String ?? "" }
    func SET_BG_NO(BG_NO: Any) { self.BG_NO = BG_NO as? String ?? "" }
    func SET_BK_DATETIME(BK_DATETIME: Any) { self.BK_DATETIME = BK_DATETIME as? String ?? "" }
    func SET_BK_HP(BK_HP: Any) { self.BK_HP = BK_HP as? String ?? "" }
    func SET_BK_MEMO(BK_MEMO: Any) { self.BK_MEMO = BK_MEMO as? String ?? "" }
    func SET_BK_NAME(BK_NAME: Any) { self.BK_NAME = BK_NAME as? String ?? "" }
    func SET_BK_NO(BK_NO: Any) { self.BK_NO = BK_NO as? String ?? "" }
    func SET_BOOK_YEAR(BOOK_YEAR: Any) { self.BOOK_YEAR = BOOK_YEAR as? String ?? "" }
    func SET_C_NUM(C_NUM: Any) { self.C_NUM = C_NUM as? String ?? "" }
    func SET_COIN_MAC(COIN_MAC: Any) { self.COIN_MAC = COIN_MAC as? String ?? "" }
    func SET_DEL_PER(DEL_PER: Any) { self.DEL_PER = DEL_PER as? String ?? "" }
    func SET_DORM(DORM: Any) { self.DORM = DORM as? String ?? "" }
    func SET_DORM_CHECKOUT(DORM_CHECKOUT: Any) { self.DORM_CHECKOUT = DORM_CHECKOUT as? String ?? "" }
    func SET_DORM_STATUS(DORM_STATUS: Any) { self.DORM_STATUS = DORM_STATUS as? String ?? "" }
    func SET_FCM_CHECK(FCM_CHECK: Any) { self.FCM_CHECK = FCM_CHECK as? String ?? "" }
    func SET_FCM_KEY(FCM_KEY: Any) { self.FCM_KEY = FCM_KEY as? String ?? "" }
    func SET_FCM_KEY_P1(FCM_KEY_P1: Any) { self.FCM_KEY_P1 = FCM_KEY_P1 as? String ?? "" }
    func SET_FCM_KEY_P2(FCM_KEY_P2: Any) { self.FCM_KEY_P2 = FCM_KEY_P2 as? String ?? "" }
    func SET_FOOD_KEY(FOOD_KEY: Any) { self.FOOD_KEY = FOOD_KEY as? String ?? "" }
    func SET_FOOD_KEY_P1(FOOD_KEY_P1: Any) { self.FOOD_KEY_P1 = FOOD_KEY_P1 as? String ?? "" }
    func SET_FOOD_KEY_P2(FOOD_KEY_P2: Any) { self.FOOD_KEY_P2 = FOOD_KEY_P2 as? String ?? "" }
    func SET_FOOD_PAY_EVE(FOOD_PAY_EVE: Any) { self.FOOD_PAY_EVE = FOOD_PAY_EVE as? String ?? "" }
    func SET_FOOD_PAY_MOR(FOOD_PAY_MOR: Any) { self.FOOD_PAY_MOR = FOOD_PAY_MOR as? String ?? "" }
    func SET_FOOD_PAY_MOON(FOOD_PAY_MOON: Any) { self.FOOD_PAY_MOON = FOOD_PAY_MOON as? String ?? "" }
    func SET_INPUT_MONTH(INPUT_MONTH: Any) { self.INPUT_MONTH = INPUT_MONTH as? String ?? "" }
    func SET_INPUT_YEAR(INPUT_YEAR: Any) { self.INPUT_YEAR = INPUT_YEAR as? String ?? "" }
    func SET_MAC(MAC: Any) { self.MAC = MAC as? String ?? "" }
    func SET_MB_CLASS(MB_CLASS: Any) { self.MB_CLASS = MB_CLASS as? String ?? "" }
    func SET_MB_FILE(MB_FILE: Any) { self.MB_FILE = MB_FILE as? String ?? "" }
    func SET_MB_GRADE(MB_GRADE: Any) { self.MB_GRADE = MB_GRADE as? String ?? "" }
    func SET_MB_NO(MB_NO: Any) { self.MB_NO = MB_NO as? String ?? "" }
    func SET_MB_OUT_PLAN(MB_OUT_PLAN: Any) { self.MB_OUT_PLAN = MB_OUT_PLAN as? String ?? "" }
    func SET_MB_PLAN_IN_DATE(MB_PLAN_IN_DATE: Any) { self.MB_PLAN_IN_DATE = MB_PLAN_IN_DATE as? String ?? "" }
    func SET_MB_PLAN_OUT_DATE(MB_PLAN_OUT_DATE: Any) { self.MB_PLAN_OUT_DATE = MB_PLAN_OUT_DATE as? String ?? "" }
    func SET_MB_POINT(MB_POINT: Any) { self.MB_POINT = MB_POINT as? String ?? "" }
    func SET_MINUS_POINT(MINUS_POINT: Any) { self.MINUS_POINT = MINUS_POINT as? String ?? "" }
    func SET_NEIS_CODE(NEIS_CODE: Any) { self.NEIS_CODE = NEIS_CODE as? String ?? "" }
    func SET_NFIX_POINT(NFIX_POINT: Any) { self.NFIX_POINT = NFIX_POINT as? String ?? "" }
    func SET_P_PHONE_01(P_PHONE_01: Any) { self.P_PHONE_01 = P_PHONE_01 as? String ?? "" }
    func SET_P_PHONE_02(P_PHONE_02: Any) { self.P_PHONE_02 = P_PHONE_02 as? String ?? "" }
    func SET_PLUS_POINT(PLUS_POINT: Any) { self.PLUS_POINT = PLUS_POINT as? String ?? "" }
    func SET_SC_CODE(SC_CODE: Any) { self.SC_CODE = SC_CODE as? String ?? "" }
    func SET_SC_GRADE(SC_GRADE: Any) { self.SC_GRADE = SC_GRADE as? String ?? "" }
    func SET_SC_GROUP(SC_GROUP: Any) { self.SC_GROUP = SC_GROUP as? String ?? "" }
    func SET_SC_LOCATION(SC_LOCATION: Any) { self.SC_LOCATION = SC_LOCATION as? String ?? "" }
    func SET_SC_NAME(SC_NAME: Any) { self.SC_NAME = SC_NAME as? String ?? "" }
}

// MARK: - 상.벌점
public class POINT_DATA {
    
    var PO_ID: String = ""
    var PO_DATETIME: String = ""
    var PO_CONTENT: String = ""
    var PO_POINT: String = ""
    var PO_USE_POINT: String = ""
    var PO_EXPIRED: String = ""
    var PO_EXPIRE_DATE: String = ""
    var PO_MB_POINT: String = ""
    var PO_REL_TABLE: String = ""
    var PO_REL_ID: String = ""
    var PO_REL_ACTION: String = ""
    var C_NUM: String = ""
    var BK_HP: String = ""
    var SC_CODE: String = ""
    var MB_GRADE: String = ""
    var MB_CLASS: String = ""
    var C_NAME: String = ""
    var CATE: String = ""
    var PO_CAT: String = ""
    var MB_NO: String = ""
    var TEACHER_NAME: String = ""
    var BK_NAME: String = ""
    var POINT_DEL: String = ""
    var MB_ID: String = ""
    var PO_SUM: String = ""
    var NEIS_CODE: String = ""
    var BG_NO: String = ""
    var YEAR: String = ""
    
    func SET_PO_ID(PO_ID: Any) { self.PO_ID = PO_ID as? String ?? "" }
    func SET_PO_DATETIME(PO_DATETIME: Any) { self.PO_DATETIME = PO_DATETIME as? String ?? "" }
    func SET_PO_CONTENT(PO_CONTENT: Any) { self.PO_CONTENT = PO_CONTENT as? String ?? "" }
    func SET_PO_POINT(PO_POINT: Any) { self.PO_POINT = PO_POINT as? String ?? "" }
    func SET_PO_USE_POINT(PO_USE_POINT: Any) { self.PO_USE_POINT = PO_USE_POINT as? String ?? "" }
    func SET_PO_EXPIRED(PO_EXPIRED: Any) { self.PO_EXPIRED = PO_EXPIRED as? String ?? "" }
    func SET_PO_EXPIRE_DATE(PO_EXPIRE_DATE: Any) { self.PO_EXPIRE_DATE = PO_EXPIRE_DATE as? String ?? "" }
    func SET_PO_MB_POINT(PO_MB_POINT: Any) { self.PO_MB_POINT = PO_MB_POINT as? String ?? "" }
    func SET_PO_REL_TABLE(PO_REL_TABLE: Any) { self.PO_REL_TABLE = PO_REL_TABLE as? String ?? "" }
    func SET_PO_REL_ID(PO_REL_ID: Any) { self.PO_REL_ID = PO_REL_ID as? String ?? "" }
    func SET_PO_REL_ACTION(PO_REL_ACTION: Any) { self.PO_REL_ACTION = PO_REL_ACTION as? String ?? "" }
    func SET_C_NUM(C_NUM: Any) { self.C_NUM = C_NUM as? String ?? "" }
    func SET_BK_HP(BK_HP: Any) { self.BK_HP = BK_HP as? String ?? "" }
    func SET_SC_CODE(SC_CODE: Any) { self.SC_CODE = SC_CODE as? String ?? "" }
    func SET_MB_GRADE(MB_GRADE: Any) { self.MB_GRADE = MB_GRADE as? String ?? "" }
    func SET_MB_CLASS(MB_CLASS: Any) { self.MB_CLASS = MB_CLASS as? String ?? "" }
    func SET_C_NAME(C_NAME: Any) { self.C_NAME = C_NAME as? String ?? "" }
    func SET_CATE(CATE: Any) { self.CATE = CATE as? String ?? "" }
    func SET_PO_CAT(PO_CAT: Any) { self.PO_CAT = PO_CAT as? String ?? "" }
    func SET_MB_NO(MB_NO: Any) { self.MB_NO = MB_NO as? String ?? "" }
    func SET_TEACHER_NAME(TEACHER_NAME: Any) { self.TEACHER_NAME = TEACHER_NAME as? String ?? "" }
    func SET_BK_NAME(BK_NAME: Any) { self.BK_NAME = BK_NAME as? String ?? "" }
    func SET_POINT_DEL(POINT_DEL: Any) { self.POINT_DEL = POINT_DEL as? String ?? "" }
    func SET_MB_ID(MB_ID: Any) { self.MB_ID = MB_ID as? String ?? "" }
    func SET_PO_SUM(PO_SUM: Any) { self.PO_SUM = PO_SUM as? String ?? "" }
    func SET_NEIS_CODE(NEIS_CODE: Any) { self.NEIS_CODE = NEIS_CODE as? String ?? "" }
    func SET_BG_NO(BG_NO: Any) { self.BG_NO = BG_NO as? String ?? "" }
    func SET_YEAR(YEAR: Any) { self.YEAR = YEAR as? String ?? "" }
}

public class SC_INFO_DATA {
    
    var AP_CHUL: String = ""
    var AP_GORM: String = ""
    var AP_FOOD: String = ""
    var AP_MILE: String = ""
    var BG_NO: String = ""
    var BOOK_UPPER_CODE: String = ""
    var COUNT_EDUBOOK: String = ""
    var COUNT_ST: String = ""
    var COUNT_TEACHER: String = ""
    var DATETIME: String = ""
    var DISPLAY: String = ""
    var KA_BILL: String = ""
    var KA_MESSAGE: String = ""
    var KA_POINT: String = ""
    var KA_POLL: String = ""
    var KA_SMS: String = ""
    var LAT: String = ""
    var LATE_POINT: String = ""
    var LNG: String = ""
    var LOGO_URL: String = ""
    var MI_CHECK: String = ""
    var REG_FILE: String = ""
    var S_IDX: String = ""
    var SC_ADDRESS: String = ""
    var SC_CODE: String = ""
    var SC_EMAIL: String = ""
    var SC_FAX: String = ""
    var SC_GRADE: String = ""
    var SC_GRADE_NAME: String = ""
    
    var SC_IN: String = ""
    var SC_IN_BTE: String = ""
    var SC_IN_BTS: String = ""
    var BEACON_DATA: [BEACON_DATA] = []
    
    func SET_SC_IN(SC_IN: Any) { self.SC_IN = SC_IN as? String ?? "" }
    func SET_SC_IN_BTE(SC_IN_BTE: Any) { self.SC_IN_BTE = SC_IN_BTE as? String ?? "" }
    func SET_SC_IN_BTS(SC_IN_BTS: Any) { self.SC_IN_BTS = SC_IN_BTS as? String ?? "" }
    func SET_BEACON_DATA(BEACON_DATA: [BEACON_DATA]) { self.BEACON_DATA = BEACON_DATA }
}

public class BEACON_DATA {
    
    var BEACON_MAC: String = ""
    var BEACON_MAJOR: String = ""
    var BEACON_MINOR: String = ""
    var BEACON_UUID: String = ""
    var CHECKER_BEACON: String = ""
    var DEVICE_TYPE: String = ""
    var IDX: String = ""
    var INSTALLED_AT: String = ""
    var PUBLIC_IP: String = ""
    var PASSWORD: String = ""
    var SC_CODE: String = ""
    var SC_NAME: String = ""
    var SSID: String = ""
    
    func SET_BEACON_MAC(BEACON_MAC: Any) { self.BEACON_MAC = BEACON_MAC as? String ?? "" }
    func SET_BEACON_MAJOR(BEACON_MAJOR: Any) { self.BEACON_MAJOR = BEACON_MAJOR as? String ?? "" }
    func SET_BEACON_MINOR(BEACON_MINOR: Any) { self.BEACON_MINOR = BEACON_MINOR as? String ?? "" }
    func SET_BEACON_UUID(BEACON_UUID: Any) { self.BEACON_UUID = BEACON_UUID as? String ?? "" }
    func SET_CHECKER_BEACON(CHECKER_BEACON: Any) { self.CHECKER_BEACON = CHECKER_BEACON as? String ?? "" }
    func SET_DEVICE_TYPE(DEVICE_TYPE: Any) { self.DEVICE_TYPE = DEVICE_TYPE as? String ?? "" }
    func SET_IDX(IDX: Any) { self.IDX = IDX as? String ?? "" }
    func SET_INSTALLED_AT(INSTALLED_AT: Any) { self.INSTALLED_AT = INSTALLED_AT as? String ?? "" }
    func SET_PUBLIC_IP(PUBLIC_IP: Any) { self.PUBLIC_IP = PUBLIC_IP as? String ?? "" }
    func SET_PASSWORD(PASSWORD: Any) { self.PASSWORD = PASSWORD as? String ?? "" }
    func SET_SC_CODE(SC_CODE: Any) { self.SC_CODE = SC_CODE as? String ?? "" }
    func SET_SC_NAME(SC_NAME: Any) { self.SC_NAME = SC_NAME as? String ?? "" }
    func SET_SSID(SSID: Any) { self.SSID = SSID as? String ?? "" }
}
