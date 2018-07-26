//
//  GLModel.swift
//  GameleySDK
//
//  Created by fitz on 2018/7/24.
//  Copyright © 2018年 Fitz Leo. All rights reserved.
//

import Foundation

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
     public var gender: Int?
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


// bind
class GLBnindInfo: Mappable {
    
    var phone: String?
    var wx: String?
    var qq: String?
    var wb: String?
    var email: String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        phone <- map["phone"]
        wx <- map["wx"]
        qq <- map["qq"]
        wb <- map["wb"]
        email <- map["email"]
    }
}

class GLBindsResp: GLBaseResp {
    var info: GLBnindInfo?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        info <- map["info"]
    }
}

// upload
class GLUploadInfo: Mappable {
    var url: String!
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        url <- map["url"]
    }
}

class GLUploadResp: GLBaseResp {
    var info: GLUploadInfo?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        info <- map["info"]
    }
}
