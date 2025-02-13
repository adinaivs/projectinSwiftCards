//
//  Extensions.swift
//  snackstore1
//
//  Created by marzhan on 26/11/24.
//

import Foundation

extension Encodable {
    func asDictionary() -> [String:Any]{
        guard let data = try? JSONEncoder().encode(self) else {
            return [:]
        }
        
        do{
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            return json ?? [:]
        }catch{
            return [:]
        }
    }
}
