//
//  JsonDecoder.swift
//  AssignmentOne
//
//  Created by Jahan on 27/02/2019.
//  Copyright © 2019 Jahan. All rights reserved.
//

import Foundation

struct techReport: Decodable {
    let year: String
    let id: String
    let owner: String?
    let email: String?
    let authors: String
    let title: String
    var abstract: String? // Changed to var as I remove any HTML tags from the text
    let pdf: URL?
    let comment: String?
    let lastModified: String
}

struct technicalReports: Decodable {
    let techreports2: [techReport]
}
