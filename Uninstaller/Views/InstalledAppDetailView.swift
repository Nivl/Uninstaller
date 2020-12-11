//
//  InstalledAppDetail.swift
//  Uninstaller
//
//  Created by Melvin Laplanche on 12/6/20.
//

import SwiftUI

struct InstalledAppDetailView: View {
    var installedApp: InstalledApp
    
    var body: some View {
        PathInfoList(pathInfos: installedApp.dataLocations)
    }
}

struct InstalledAppDetail_Previews: PreviewProvider {
    static var previews: some View {
        InstalledAppDetailView(installedApp: installedAppData[0])
    }
}
