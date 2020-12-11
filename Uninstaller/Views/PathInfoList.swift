//
//  PathInfoList.swift
//  Uninstaller
//
//  Created by Melvin Laplanche on 12/10/20.
//

import SwiftUI

struct PathInfoList: View {
    let pathInfos: [PathInfo]
    
    var body: some View {
        List(pathInfos, id: \.location) { path in
            PathInfoRow(pathInfo: path).tag(path)
        }
    }
}

struct PathInfoList_Previews: PreviewProvider {
    static var previews: some View {
        PathInfoList(pathInfos: installedAppData[0].dataLocations)
    }
}
