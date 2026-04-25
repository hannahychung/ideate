//
//  SessionUser.swift
//  ideate
//
//  Created by Hannah Chung on 4/25/26.
//

import Foundation

class SessionUser {
    static let shared = SessionUser()
        
        var currentUser: IdeateUser?
        
        private init() {}
}
