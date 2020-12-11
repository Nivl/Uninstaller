//
//  IntalledApp.swift
//  Uninstaller
//
//  Created by Melvin Laplanche on 11/29/20.
//

import Foundation

struct InstalledApp: Hashable {    
    var name: String
    var path: URL
    var iconPath: URL
    var dataLocations: [PathInfo]
    var uninstallerPath: String?
}
