//
//  ALPConstans.swift
//  Alpface
//
//  Created by swae on 2018/3/25.
//  Copyright © 2018年 alpface. All rights reserved.
//

import Foundation


// 存储登录用户信息的key，如果此key获取的value为nil则说明用户未登录
let ALPLoginUserInfoKey = "LoginUserInfoKey"
let ALPSiteURLString = "http://www.alpface.com:8889"
let ALPCsrfmiddlewaretokenKey = "csrfmiddlewaretoken"
let ALPCsrftokenKey = "csrftoken"


struct ALPConstans {
    static var animationDuration: Double {
        get {
            return 0.36
        }
    }
    
    
    struct HttpRequestURL {
        // 登录
        let login = "\(ALPSiteURLString)" + "/account/auth/login/"
        // 注册
        let register = "\(ALPSiteURLString)" + "/account/auth/register/"
        let getCsrfToken = "\(ALPSiteURLString)" + "/account/auth/csrf"
//        let queryUserInfoByUserID = "\(ALPSiteURLString)" + "/queryUserInfoByUserID"
//        // moment列表
//        let momentList = "\(ALPSiteURLString)" + "/momentList"
//        // 发送moment
//        let sendMoment = "\(ALPSiteURLString)" + "/sendMoment"
        
    }
    
}
