//
//  Constants.swift
//  SpaceDash
//
//  Created by Pushpinder Pal Singh on 26/07/20.
//  Copyright © 2020 Pushpinder Pal Singh. All rights reserved.
//

import Foundation

struct Constants {
    
    struct NetworkManager {
        static let spaceXAPI = "https://api.spacexdata.com/v3/"
        static let rocketLaunchLiveAPI = "https://fdo.rocketlaunch.live/json/launches/next/5"
        static let authorization = "Authorization"
        static let youtubeWatchURL = "https://www.youtube.com/watch?v="
    }
    struct  Colors {
        static let DashCream = "DashCream"
        static let DashBlack = "DashBlack"
    }
    struct SegueManager {
        static let detailViewSegue = "DetailView"
        
        struct SenderValues {
            static let rocket = "rockets"
            static let launchSite = "launchpads"
            static let landpads = "landpads"
            static let capsules = "capsules"
            static let ships = "ships"
            static let launches = "launches"
        }
    }
    
    struct DefaultArgs {
        static let launchSite = "Launch Site Not Declared"
        static let noData = "Not Available"
    }
    
    struct HomeView{
        static let tentativeDetail = "This is the tentative launch date and subjected to change"
        static let nextLaunch = "launches/next/5"
    }
    
    struct DetailsView {
        static let nibName = "DetailsTableViewCell"
        static let reuseId = "cell"
    }
    
    struct AboutView {
        static let licenseURLString = "https://github.com/pushpinderpalsingh/SpaceDash/blob/master/LICENSE"
        static let privacyURLString = "https://pushpinderpalsingh.github.io/SpaceDash/policy.html"
        static let alertMessage = "Unable to open due to some reasons please check back later"
        static let okButtonTitle = "Ok"
    }
    
    struct AppIcon {
        static let rocket = "SpaceDashIconRocket"
        static let shuttle = "SpaceDashIconShuttle"
        static let spaceShuttle = "SpaceDashIconSpaceShuttle"
    }
    
    enum Vehicles: String {
        case ariane5 = "ariane-5"
        case atlasv = "atlas-v"
        case electron
        case falcon9 = "falcon-9"
        case falconHeavy = "falcon-heavy"
        case launcherone
        case pslv
        case soyuz = "soyuz-2"
        case starshipPrototype = "starship-prototype"
        case starship
        case vega
    }
}
