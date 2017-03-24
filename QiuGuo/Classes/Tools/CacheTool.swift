//
//  CacheTool.swift
//  QiuGuo
//
//  Created by apple on 17/3/5.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import UIKit
import WebKit

class CacheTool: NSObject {
    // 计算缓存大小
    static var cacheSize: String{
        get{
            let basePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
            let fileManager = FileManager.default
            
            func caculateCache() -> Float{
                var total: Float = 0
                if fileManager.fileExists(atPath: basePath!){
                    let childrenPath = fileManager.subpaths(atPath: basePath!)
                    if childrenPath != nil{
                        for path in childrenPath!{
                            let childPaht = basePath!+"/"+path
                            do{
                                let attr = try fileManager.attributesOfItem(atPath: childPaht)
                               
                                let fileSize = attr[FileAttributeKey.size] as! Float
                                total += fileSize
                                
                            }catch _{
                                
                            }
                        }
                    }
                }
                
                return total
            }
            let totalCache = caculateCache()
            return NSString(format: "%.2f MB", totalCache / 1024.0 / 1024.0 ) as String
        }
    }
    
    // 清除缓存
    class func clearCache() -> Bool{
        var result = true
        let basePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: basePath!){
            let childrenPath = fileManager.subpaths(atPath: basePath!)
            for childPath in childrenPath!{
                let cachePath = (basePath)! + "/" + childPath

                do{
                    try fileManager.removeItem(atPath: cachePath)
                }catch _{
                    result = false
                }
            }
        }
        
        result = CacheTool.clearWKWebViewCache()
        return result
    }
    
    
    //MARK:- 清除wkWebview的缓存
    class func clearWKWebViewCache()->Bool{
        let websiteDataTypes = WKWebsiteDataStore.allWebsiteDataTypes()
        let dateForm = Date.init(timeIntervalSince1970: 0)
       WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes, modifiedSince: dateForm) {
            
        }
        return true
    }
    
}
