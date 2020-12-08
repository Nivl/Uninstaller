//
//  Data.swift
//  Uninstaller
//
//  Created by Melvin Laplanche on 11/29/20.
//

import SwiftUI

let installedAppData: [InstalledApp] = [
    InstalledApp(name: "Safari", path: URL(fileURLWithPath: "/Applications/Safari.app"), iconPath: URL(fileURLWithPath: "/Applications/Safari.app/Contents/Resources/AppIcon.icns")),
    InstalledApp(name: "Xcode", path: URL(fileURLWithPath: "/Applications/Xcode.app"), iconPath: URL(fileURLWithPath: "/Applications/Xcode.app/Contents/Resources/Xcode.icns")),
]

class AppFetcherPreview: Fetcher {
    override init() {
        super.init()
        self.installedApp = installedAppData
    }
}
