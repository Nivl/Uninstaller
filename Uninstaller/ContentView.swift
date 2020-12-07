//
//  ContentView.swift
//  Uninstaller
//
//  Created by Melvin Laplanche on 11/29/20.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedApp: InstalledApp?

    var body: some View {
        HStack {
            // TODO(melvin): Make sure ScrollView works
            // when the list has items with long name
            VStack{
                InstalledAppList(selectedApp: $selectedApp)
                    .listStyle(SidebarListStyle())
            }
            .frame(width: 300)
            
            if selectedApp != nil {
                InstalledAppDetail(installedApp: selectedApp!)
                    .frame(minWidth: 700, idealWidth: 900, maxWidth: .infinity, maxHeight: .infinity)
            } else {
                EmptyDetailView()
                    .frame(minWidth: 700, idealWidth: 900, maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .frame(minWidth: 1000, idealWidth: 1200, minHeight: 500, idealHeight: 600)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
