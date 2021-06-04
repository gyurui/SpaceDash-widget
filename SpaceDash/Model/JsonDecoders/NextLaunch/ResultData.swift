//
//  Result.swift
//  SpaceDash
//
//  Created by Pushpinder Pal Singh on 01/12/20.
//  Copyright © 2020 Pushpinder Pal Singh. All rights reserved.
//

import Foundation

struct ResultData: Identifiable {

    let id : Int
    let date : String
    let normalDate: Date
    
    let name : String
    let providerName : String
    let providerSlug : String
    let vehicleId : Int
    let vehicleName : String
    let vehicleSlug : String
    let pad : PadData
    let missions : String
    let launchDesc : String
    let tags : [String]
    let weatherIconCode : String?
    let mediaId : Int?
    let youtubeLink : URL?
    let launchDayMedia : Bool?
    let featured : Bool?
}

extension ResultData : Decodable {
    enum CodingKeys : String, CodingKey {
        case id
        case name
        case providerName
        case providerSlug
        case vehicleId
        case vehicleName
        case vehicleSlug
        case pad
        case missions
        case tags
        
        case provider
        case vehicle
        
        case media
        case mediaId
        case youtubeLink
        case launchDayMedia
        case featured
        
        case date = "sort_date"
        case launchDesc = "launch_description"
        case weatherIcon = "weather_icon"
        
        enum ProviderKeys : String, CodingKey {
            case name
            case slug
        }
        
        enum VehicleKeys : String, CodingKey {
            case id
            case name
            case slug
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        pad = try container.decode(PadData.self, forKey: .pad)
        let resultDate: String = try container.decode(String.self, forKey: .date)
        date = Double(resultDate)?.getDate() ?? Constants.DefaultArgs.noData
        normalDate = Date(timeIntervalSince1970: Double(resultDate) ?? 0)
        
        launchDesc = try container.decode(String.self, forKey: .launchDesc)
        weatherIconCode = try container.decode(String?.self, forKey: .weatherIcon)

        let providerKeys = try container.nestedContainer(keyedBy: CodingKeys.ProviderKeys.self, forKey: .provider)
        providerName = try providerKeys.decode(String.self, forKey: .name)
        providerSlug = try providerKeys.decode(String.self, forKey: .slug)

        let vehicleKeys = try container.nestedContainer(keyedBy: CodingKeys.VehicleKeys.self, forKey: .vehicle)
        vehicleId = try vehicleKeys.decode(Int.self, forKey: .id)
        vehicleName = try vehicleKeys.decode(String.self, forKey: .name)
        vehicleSlug = try vehicleKeys.decode(String.self, forKey: .slug)

        let missionData = try container.decode([MissionData].self, forKey: .missions)
        var missionString = String()
        
        if missionData.count > 1 {
            for mission in missionData {
                missionString = missionString + ", " + mission.name
            }
            missions = missionString
        }
        else {
            missions = missionData[0].name
        }
                
        let tagData = try container.decode([TagsData].self, forKey: .tags)
        var tag = [String]()

        for tags in tagData {
            tag.append(tags.text)
        }

        tags = tag
        
        let mediaArray = try container.decode([MediaData].self, forKey: .media)
        if (!mediaArray.isEmpty){
            let mediaData = mediaArray[0]
            mediaId = mediaData.id
            featured = mediaData.featured
            launchDayMedia = mediaData.ldfeatured
            youtubeLink = URL(string:"\(Constants.NetworkManager.youtubeWatchURL + mediaData.youtube_vidid)")
        } else {
            mediaId = nil
            featured = nil
            launchDayMedia = nil
            youtubeLink = nil
        }
    }
}

extension ResultData: Hashable {
    static func == (lhs: ResultData, rhs: ResultData) -> Bool {
        return lhs.id == rhs.id
    }
}

extension ResultData {
    static let mock = ResultData.init(id: 1, date: "May 15, 2021 at 2:02 AM", normalDate: Date(timeIntervalSinceNow: 60), name: "Puli-X", providerName: "MNB", providerSlug: "nasa", vehicleId: 118, vehicleName: "Black Brant XII",  vehicleSlug: "black-brant-xii", pad: PadData(name: "us", location: "Launch Pad, Wallops Flight Facility", locationSlug: "US", countrySlug: "fHungary"), missions: "KiNET-X (Suborbital)", launchDesc: "A MNB Puli rocket will launch the next mission", tags: ["Suborbital"], weatherIconCode: nil, mediaId: nil, youtubeLink: nil, launchDayMedia: nil, featured: nil)
}
