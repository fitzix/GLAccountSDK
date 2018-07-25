//
//  GLModel.swift
//  GameleySDK
//
//  Created by fitz on 2018/7/24.
//  Copyright © 2018年 Fitz Leo. All rights reserved.
//

import Foundation
import ObjectMapper

class GLBaseResp: Mappable {
    
    var state: Int?
    var msg: String?
    var ok: Bool?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        state <- map["state"]
        msg <- map["msg"]
        ok <- map["ok"]
    }
}

@objcMembers public class GLUserInfo: NSObject, Mappable {
    
     public var uid: Int?
     public var account: String?
     public var area: String?
     public var city: String?
     public var dtLastLogin: String?
     public var dtReg: String?
     public var gBirth: String?
     public var gender: String?
     public var icon: String?
     public var nickname: String?
   
    
    required public init?(map: Map) {}
    
    @nonobjc public func mapping(map: Map) {
        uid <- map["uid"]
        nickname <- map["nickname"]
        icon <- map["icon"]
        account <- map["account"]
        area <- map["area"]
        city <- map["city"]
        dtLastLogin <- map["dtLastLogin"]
        dtReg <- map["dtReg"]
        gBirth <- map["gBirth"]
        gender <- map["gender"]
        
    }
    public override init() {}
}

class GLUserInfoResp: GLBaseResp {
    var info: GLUserInfo?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        info <- map["info"]
    }
}


// OAUTH
class GLOauthInfo: Mappable {
    var token: String?
    
    required init?(map: Map) {}
    func mapping(map: Map) {
        token <- map["token"]
    }
}

class GLOauthResp: GLBaseResp {
    var info: GLOauthInfo?
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        info <- map["info"]
    }
}
