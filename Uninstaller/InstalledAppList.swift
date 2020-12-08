//
//  InstalledAppList.swift
//  Uninstaller
//
//  Created by Melvin Laplanche on 11/29/20.
//

import SwiftUI

struct InstalledAppList: View {
    @Binding var selectedApp: InstalledApp?
    
    // TODO(melvin): inject
    @ObservedObject var fs: Fetcher = AppFetcher();
    
    var body: some View {
        // TODO(melvin): build list async
        List(selection: $selectedApp) {
            ForEach(fs.installedApp, id: \.name) { installedApp in
                InstalledAppRow(installedApp: installedApp).tag(installedApp)
            }
        }
    }
}

struct InstalledAppList_Previews: PreviewProvider {
    static var previews: some View {
        InstalledAppList(selectedApp: .constant(installedAppData[0]))
    }
}
