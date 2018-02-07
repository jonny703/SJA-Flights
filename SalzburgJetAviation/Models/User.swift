//
//  User.swift
//  SalzburgJetAviation
//
//  Created by John Nik on 2/7/18.
//  Copyright © 2018 johnik703. All rights reserved.
//

import Foundation

struct User: Encodable, Decodable {
    
    let userId: String
    let username: String
    let deviceId: String
}
