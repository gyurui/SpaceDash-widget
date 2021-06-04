//
//  NextLaunch.swift
//  SpaceDash
//
//  Created by Pushpinder Pal Singh on 01/12/20.
//  Copyright © 2020 Pushpinder Pal Singh. All rights reserved.
//

import Foundation

struct NextLaunchData: Identifiable {
    let id : Int
    let isAuth : Bool
    let date: String
    let normalDate: Date
    let name : String
    let providerName : String
    let providerSlug : String
    let vehicleId : Int
    let vehicleName : String
    let vehicleSlug : String
    let launchSite : String
    let countrySlug : String
    let missions : String
    let launchDesc : String
    let tags : [String]
    let weatherIconCode : String?
    let mediaId : Int?
    let youtubeLink : URL?
    let launchDayMedia : Bool?
    let featured : Bool?
    let resultList: [ResultData]
}

extension NextLaunchData : Decodable {
    
    enum CodingKeys : String, CodingKey {
        case result
        case isAuth = "valid_auth"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let results = try container.decode([ResultData].self, forKey: .result)
        resultList = results
        
        // search the next launch
        let result = NextLaunchData.nextLaunchInResultList(results: results)
                
        isAuth = try container.decode(Bool.self, forKey: .isAuth)

        // Following is copying data decoded from result into the current object. If you have a better way to do this, let me know
        
        id = result.id
        date = result.date
        normalDate = result.normalDate
        name = result.name
        providerName = result.providerName
        providerSlug = result.providerSlug
        vehicleId = result.vehicleId
        vehicleName = result.vehicleName
        vehicleSlug = result.vehicleSlug
        launchSite = result.pad.location
        countrySlug = result.pad.countrySlug
        missions = result.missions
        launchDesc = result.launchDesc
        tags = result.tags
        weatherIconCode = result.weatherIconCode
        mediaId = result.mediaId
        youtubeLink = result.youtubeLink
        launchDayMedia = result.launchDayMedia
        featured = result.featured
    }
}

extension NextLaunchData {
    static func nextLaunchInResultList(results: [ResultData]) -> ResultData {
        var result = results[0]
        for next in results {
            let differenceBetweenNow = Double(result.date) ?? 0.0 - Double(Date().timeIntervalSinceNow)
            let differenceBetweenNext = Double(next.date) ?? 0.0 - Double(Date().timeIntervalSinceNow)
            if differenceBetweenNow > 0 && differenceBetweenNext < differenceBetweenNow {
                result = next
            }
        }
        return result
    }
}

extension NextLaunchData {
    static let mock =  NextLaunchData.init(id: 1, isAuth: false, date: "May 15, 2021 at 2:02 AM", normalDate: Date(timeIntervalSinceNow: 448442.370277778), name: "KiNET-X", providerName: "NASA", providerSlug: "nasa", vehicleId: 118, vehicleName: "Black Brant XII", vehicleSlug: "black-brant-xii", launchSite: "Launch Pad, Wallops Flight Facility", countrySlug: "fUnited States", missions: "KiNET-X (Suborbital)", launchDesc: "A NASA Black Brant XII rocket will launch the KiNET-X (Suborbital) mission", tags: ["Suborbital"], weatherIconCode: nil, mediaId: nil, youtubeLink: nil, launchDayMedia: nil, featured: nil, resultList: [])
}
