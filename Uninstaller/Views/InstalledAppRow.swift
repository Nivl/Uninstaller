//
//  InstalledAppRow.swift
//  Uninstaller
//
//  Created by Melvin Laplanche on 11/29/20.
//

import SwiftUI
import Cocoa

struct InstalledAppRow: View {
    var installedApp: InstalledApp
    
    var body: some View {
        HStack{
            if let img = NSImage(contentsOfFile: installedApp.iconPath.path) {
                Image(nsImage: img)
                    .resizable()
                    .aspectRatio(1.0, contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .fixedSize(horizontal: true, vertical: false)
            } else {
                // TODO(melvin): use default image
                Text(installedApp.iconPath.path)
            }
            Text(installedApp.name)
        }
        .padding(.horizontal, 4)
    }
}

struct InstalledAppRow_Previews: PreviewProvider {
    static var previews: some View {
        InstalledAppRow(installedApp: installedAppData[0])
    }
}
