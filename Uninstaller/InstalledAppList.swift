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
    var fs: FSManager = DefaultFSManager();
    
    var body: some View {
        // TODO(melvin): build list async
        List(selection: $selectedApp) {
            ForEach(self.fetchInstalledAppData(), id: \.name) { installedApp in
                InstalledAppRow(installedApp: installedApp).tag(installedApp)
            }
        }
    }

    func fetchInstalledAppData() -> [InstalledApp] {
        var items: [InstalledApp] = []
        fs.getInstalledApp { (installedApp) in
            items.append(installedApp)
        }
        return items
    }
}

struct InstalledAppList_Previews: PreviewProvider {
    static var previews: some View {
        InstalledAppList(selectedApp: .constant(installedAppData[0]))
    }
}
