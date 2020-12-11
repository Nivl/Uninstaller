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
    
    // fetch browse the disk on another queue to find information
    // about what app are installed, and where did they write data
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
        
        // By default we look in the "system" app folder and in the current user's
        let paths = [
            URL(fileURLWithPath: "/Applications"),
            fm.homeDirectoryForCurrentUser.appendingPathComponent("Applications")
        ]
        
        for p in paths {
            let de = fm.enumerator(at: p, includingPropertiesForKeys: Array(resourceKeys))!
            // TODO(melvin): can we run each iteration concurently?
            for case let fileURL as URL in de {
                guard let resourceValues = try? fileURL.resourceValues(forKeys: resourceKeys),
                    let isDirectory = resourceValues.isDirectory,
                    let name = resourceValues.name
                    else {
                        // In case of issues we just skip whatever that was
                        // and go to the next item
                        de.skipDescendants()
                        continue
                    }

                // if the current item is not a directory or
                // is a directory but not an app, then we skip it
                // Note that if the item IS a directory, we will
                // browse it.
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
                    
                    var dataLocations = getAppDataLocations(info: info)
                    dataLocations.insert(PathInfo(location: fileURL), at: 0)

                    progress(InstalledApp(
                        name: name,
                        path: fileURL,
                        // TODO(melvin): make sure the image exists on disk or default back to a default
                        // this would lead to a crash otherwise
                        iconPath: fileURL.appendingPathComponent("Contents/Resources/" + iconFile, isDirectory: false),
                        dataLocations: dataLocations
                    ))
                } catch {
                    print(error)
                }
            }
        }
    }
    
    // getAppDataLocations browses the disk to find data stored by this app
    // TODO(melvin): Also get the size of each path
    func getAppDataLocations(info: AppInfo) -> [PathInfo] {
        var results = [PathInfo]()
        let fm = FileManager.default
        // List of common directories where apps tend to store data
        let commonDirectories = [
            fm.homeDirectoryForCurrentUser.appendingPathComponent("Library/Application Support"),
            fm.homeDirectoryForCurrentUser.appendingPathComponent("Library/Caches"),
            fm.homeDirectoryForCurrentUser.appendingPathComponent("Library/Logs"),
            fm.homeDirectoryForCurrentUser.appendingPathComponent("Library/Preferences"),
            fm.homeDirectoryForCurrentUser.appendingPathComponent("Library/Containers"),
            fm.homeDirectoryForCurrentUser.appendingPathComponent("Library/Cookies"),
        ]
        // List of potential directory names that might contain data for our app
        let potentialDirs = [info.CrProductDirName, info.CFBundleIdentifier, info.CFBundleName, info.CFBundleDisplayName]
        
        // Let's browse everything!
        for rootDir in commonDirectories {
            for potentialDir in potentialDirs {
                // we're dealing with a list of optional
                guard let subdir = potentialDir else {
                    continue
                }
                let dir = rootDir.appendingPathComponent(subdir)
                if !fm.fileExists(atPath: dir.path, isDirectory: nil) {
                    continue
                }
                results.append(PathInfo(location: dir))
                break
            }
        }
        
        return results
    }
    
    // getAppInfo parses the app's Info.plist and return the important information
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
    var CFBundleIdentifier: String
    var CrProductDirName: String? // Chrome-based browser only
}

struct PathInfo: Hashable {
    var location: URL
}
