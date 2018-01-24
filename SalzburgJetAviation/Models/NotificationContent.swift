//
//  NotificationContent.swift
//  SalzburgJetAviation
//
//  Created by John Nik on 12/15/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import Foundation

struct NotificationContent: Encodable {
    
    var app_id: String
    var included_segments: [String]
    var contents: [String: String]?
    var headings: [String: String]?
    var ios_badgeType: String?
    var ios_badgeCount: Int?
    
}
