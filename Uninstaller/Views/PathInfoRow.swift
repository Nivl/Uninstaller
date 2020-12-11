//
//  InstalledAppDetailsRow.swift
//  Uninstaller
//
//  Created by Melvin Laplanche on 12/10/20.
//

import SwiftUI

struct PathInfoRow: View {
    let pathInfo: PathInfo
    
    var body: some View {
        Text(pathInfo.location.path)
    }
}

struct InstalledAppDetailsRow_Previews: PreviewProvider {
    static var previews: some View {
        PathInfoRow(pathInfo: installedAppData[0].dataLocations[0])
    }
}
