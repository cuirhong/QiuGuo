//
//  NSString-Extension.swift
//  QiuGuo
//
//  Created by cuirhong on 2017/2/28.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import UIKit


extension String{
  
    static func localPath(_ localFileName:String) -> String {
      
        if  let path = Bundle.main.path(forResource: localFileName, ofType: nil)  {
            return path;
        }
            return ""
        
    }
    
    
    func md5String(str:String) -> String{
        let cStr = str.cString(using: String.Encoding.utf8);
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
        
        CC_MD5(cStr!,(CC_LONG)(strlen(cStr!)), buffer)
        let md5String = NSMutableString();
        for i in 0 ..< 16{
            md5String.appendFormat("%02x", buffer[i])
        }
        free(buffer)
        return md5String as String
    }
    
    
    func cacheStr()->String{
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
        let filePath = (path as NSString).appendingPathComponent(self)
        return filePath
    }
    func docStr()->String{
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentationDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
        let filePath = (path as NSString).appendingPathComponent(self)
        return filePath
    }
    func tmpStr()->String{
        let path = NSTemporaryDirectory()
        let filePath = (path as NSString).appendingPathComponent(self)
        return filePath
    }


}












