//
//  InstalledAppList.swift
//  Uninstaller
//
//  Created by Melvin Laplanche on 11/29/20.
//

import SwiftUI

struct InstalledAppList: View {
    @Binding var selectedApp: InstalledApp?
    
    @ObservedObject var fetcher: Fetcher = AppFetcher();
    
    var body: some View {
        switch fetcher.status {
        case FetcherStatus.fetched:
            List(selection: $selectedApp) {
                ForEach(fetcher.installedApp, id: \.name) { installedApp in
                    InstalledAppRow(installedApp: installedApp).tag(installedApp)
                }
            }
        case FetcherStatus.fetching:
            Text("fetching apps...")
        }
    }
}

struct InstalledAppList_Previews: PreviewProvider {
    static var previews: some View {
        InstalledAppList(selectedApp: .constant(installedAppData[0]), fetcher: AppFetcherPreview())
        
        InstalledAppList(selectedApp: .constant(installedAppData[0]), fetcher: AppFetcherPreview(status: FetcherStatus.fetching))
    }
}
