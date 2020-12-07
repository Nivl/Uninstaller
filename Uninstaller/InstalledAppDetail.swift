//
//  InstalledAppDetail.swift
//  Uninstaller
//
//  Created by Melvin Laplanche on 12/6/20.
//

import SwiftUI

struct InstalledAppDetail: View {
    var installedApp: InstalledApp
    
    var body: some View {
        ScrollView{
            Text("Content of \(installedApp.name)")
        }
    }
}

struct InstalledAppDetail_Previews: PreviewProvider {
    static var previews: some View {
        InstalledAppDetail(installedApp: installedAppData[0])
    }
}
