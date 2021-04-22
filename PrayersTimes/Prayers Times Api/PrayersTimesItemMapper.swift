//
//  PrayersTimesItemMapper.swift
//  PrayersTimes
//
//  Created by Salah Amassi on 21/04/2021.
//

import Foundation

final class PrayersTimesItemMapper {
    
    private struct Root: Decodable {
        
        let code: Int
        let status: String
        let data: [RemotePrayersTimes]
    }
    
    static var OK_200: Int { return 200 }
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [RemotePrayersTimes] {
        guard response.statusCode == OK_200,
              let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw RemotePrayersTimesLoader.Error.invalidData
        }
        
        return root.data
    }
}

