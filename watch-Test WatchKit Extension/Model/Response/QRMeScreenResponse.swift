//
//  QRMeScreenResponse.swift
//  watch-Test WatchKit Extension
//
//  Created by Ahmed Medhat on 26/10/2021.
//

import Foundation

struct QRMeScreenResponse: Codable {
    let id: String
    let accountId: String
    let medicalCaseName: String
    let fileUri: String
    let name: String
}
