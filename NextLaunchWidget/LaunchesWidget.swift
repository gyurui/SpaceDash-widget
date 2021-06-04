//
//  LaunchesWidget.swift
//  SpaceDash
//
//  Created by György Trum on 2021. 06. 04..
//  Copyright © 2021. Pushpinder Pal Singh. All rights reserved.
//

import WidgetKit
import SwiftUI

struct LaunchesProvider: TimelineProvider {
    
    public typealias Entry = LaunchesEntry
    
    func placeholder(in context: Context) -> LaunchesEntry {
        return LaunchesEntry(date: Date(), launches: [ResultData.mock, ResultData.mock])
    }
    
    func getSnapshot(in context: Context, completion: @escaping (LaunchesEntry) -> Void) {
        let entry = LaunchesEntry(date: Date(), launches: [ResultData.mock, ResultData.mock])
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<LaunchesEntry>) -> Void) {
        NetworkManager(Constants.NetworkManager.rocketLaunchLiveAPI).performRequest(key: "")  { (result: Result<NextLaunchData,Error>) in
            var upcomingLaunch = NextLaunchData.mock
            switch result {
            case .success(let launchesResponse):
                upcomingLaunch = launchesResponse
            case .failure: return
            }
            
            let oneHour: TimeInterval = 60*60
            var currentDate = Date()
            var entries: [LaunchesEntry] = []
            
            var entry = LaunchesEntry(date: currentDate, launches: upcomingLaunch.resultList)
            entries.append(entry)

            while currentDate < upcomingLaunch.normalDate {
                currentDate += oneHour
                entry = LaunchesEntry(date: currentDate, launches: upcomingLaunch.resultList)
                entries.append(entry)
            }
            
            let timeline = Timeline(entries: entries, policy: .after(upcomingLaunch.normalDate))
            completion(timeline)
        }
    }
}

struct LaunchesEntry: TimelineEntry {
    public let date: Date
    var launches: [ResultData]?
}

struct LaunchesPlaceholderView: View {
    var body: some View {
        LaunchesWidgetEntryView(entry: LaunchesEntry(date: Date(), launches: [ResultData.mock, ResultData.mock]))
    }
}

struct LaunchesWidgetEntryView: View {
    var entry: LaunchesProvider.Entry

    var body: some View {
        AllLaunchesView(launches: entry.launches)
    }
}

struct LaunchesWidget: Widget {
    private let kind: String = "LaunchesWidget"

    public var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: LaunchesProvider()) { entry in
            LaunchesWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Launches")
        .description("What's Coming Next")
        .supportedFamilies([.systemLarge])
    }
}

struct LaunchesWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LaunchesWidgetEntryView(entry: LaunchesEntry(date: Date(), launches: [ResultData.mock, ResultData.mock]))
                .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
    }
}

@main
struct LaunchesBundle: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        NextLaunchWidget()
        LaunchesWidget()
    }
}
