//
//  FSBrowser.swift
//  Uninstaller
//
//  Created by Melvin Laplanche on 11/29/20.
//

import Foundation

enum FetcherStatus {
    case fetching
    case fetched
}

class Fetcher: ObservableObject {
    @Published var installedApp = [InstalledApp]()
    @Published var status = FetcherStatus.fetching
}

var AppFetcherCache = [InstalledApp]()

class AppFetcher: Fetcher {
    override init() {
        super.init()
        
        if AppFetcherCache.count > 0 {
            self.status = FetcherStatus.fetched
            self.installedApp = AppFetcherCache
        } else {
            fetch()
        }
    }
    
    func fetch() {
        self.status = FetcherStatus.fetching
        
        DispatchQueue.global(qos: .userInitiated).async {           
            var items: [InstalledApp] = []
            self.getInstalledApp { (installedApp) in
                items.append(installedApp)
            }
            
            DispatchQueue.main.async {
                self.status = FetcherStatus.fetched
                self.installedApp = items
                AppFetcherCache = items
            }
        }
    }
    
    func getInstalledApp(progress: (InstalledApp)->()) -> Void {
        let fm = FileManager.default
        let resourceKeys = Set<URLResourceKey>([.nameKey, .isDirectoryKey])
        
        let paths = [URL(fileURLWithPath: "/Applications"), fm.homeDirectoryForCurrentUser]
        
        for p in paths {
            let de = fm.enumerator(at: p, includingPropertiesForKeys: Array(resourceKeys))!
            for case let fileURL as URL in de {
                guard let resourceValues = try? fileURL.resourceValues(forKeys: resourceKeys),
                    let isDirectory = resourceValues.isDirectory,
                    let name = resourceValues.name
                    else {
                        continue
                    }
                
                let ext = ".app"
                if !isDirectory || !name.hasSuffix(ext) {
                    continue
                }
                
                de.skipDescendants()
                
                do {
                    let info = try self.getAppInfo(appPath: fileURL)
                    var iconFile = info.CFBundleIconFile
                    if !iconFile.hasSuffix(".icns") {
                        iconFile += ".icns"
                    }
                   
                    var name = String(name.dropLast(ext.count))
                    if let displayName = info.CFBundleDisplayName {
                        name = displayName
                    } else if let bundleName = info.CFBundleName {
                        name = bundleName
                    }
                    
                    progress(InstalledApp(
                        name: name,
                        path: fileURL,
                        // TODO(melvin): make sure the image exists on disk or default back to a default
                        // this would lead to a crash otherwise
                        iconPath: fileURL.appendingPathComponent("Contents/Resources/" + iconFile, isDirectory: false)
                    ))
                } catch {
                    print(error)
                }
            }
        }
    }
    
    func getAppInfo(appPath: URL) throws -> AppInfo {
        let infoPath = appPath.appendingPathComponent("Contents/info.plist", isDirectory: false)
        
        let data: Data
        do {
            data = try Data(contentsOf: infoPath)
        } catch {
            throw FSError.read(infoPath, error)
        }
        
        do {
            let decoder = PropertyListDecoder()
            return try decoder.decode(AppInfo.self, from: data)
        } catch {
            throw FSError.parse(infoPath, error)
        }
    }
}

enum FSError: Error {
    case read(URL, Error)
    case parse(URL, Error)
}


struct AppInfo: Decodable {
    var CFBundleDisplayName: String?
    var CFBundleName: String?
    var CFBundleIconFile: String
}
