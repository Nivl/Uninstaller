//
//  IntalledApp.swift
//  Uninstaller
//
//  Created by Melvin Laplanche on 11/29/20.
//

import Foundation
import AppKit

struct InstalledApp: Decodable, Hashable {   
    var name: String
    var path: URL
    var iconPath: URL
}
