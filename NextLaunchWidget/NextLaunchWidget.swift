//
//  NextLaunchWidget.swift
//  NextLaunchWidget
//
//  Created by György Trum on 2021. 05. 13..
//  Copyright © 2021. Pushpinder Pal Singh. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), nextLaunch: ResultData.mock, relevance: nil)
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), nextLaunch: ResultData.mock, relevance: nil)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        NetworkManager(Constants.NetworkManager.rocketLaunchLiveAPI).performRequest(key: Constants.HomeView.nextLaunch) { (result: Result<NextLaunchData,Error>) in
            var upcomingLaunch = ResultData.mock
            switch result {
            case .success(let launchesResponse):
                upcomingLaunch = NextLaunchData.nextLaunchInResultList(results: launchesResponse.resultList)
            case .failure: return
            }
            
            let oneHour: TimeInterval = 20
            var currentDate = Date()
            var entries: [SimpleEntry] = []
            var score: Float = 0.0
            
            var relevance = TimelineEntryRelevance.init(score: score)
            var entry = SimpleEntry(date: currentDate, nextLaunch: upcomingLaunch, relevance: relevance)
            entries.append(entry)

            while currentDate < upcomingLaunch.normalDate {
                currentDate += oneHour
                
                score += 1
                relevance = TimelineEntryRelevance.init(score: score)
                
                entry = SimpleEntry(date: currentDate, nextLaunch: upcomingLaunch, relevance: relevance)
                entries.append(entry)
            }
            
            let timeline = Timeline(entries: entries, policy: .after(upcomingLaunch.normalDate))
            completion(timeline)
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let nextLaunch: ResultData
    let relevance: TimelineEntryRelevance?
}

struct PlaceholderView: View {
    var body: some View {
        NextLaunchWidgetEntryView(entry: SimpleEntry(date: Date(), nextLaunch: ResultData.mock, relevance: nil)).redacted(reason: .placeholder)
    }
}

struct NextLaunchWidgetEntryView : View {
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily) var family
    
    @ViewBuilder
    var body: some View {
        switch family {
        case .systemSmall:
            ResultLaunchWidgetView(entry.nextLaunch)
            .widgetURL(URL.init(string: "\(entry.nextLaunch.id)launch"))
        default:
            ResultLaunchMediumView(entry.nextLaunch)
            .widgetURL(URL.init(string: "\(entry.nextLaunch.id)launch"))
        }
    }
}

struct NextLaunchWidget: Widget {
    let kind: String = "NextLaunchWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            NextLaunchWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Next Launch Widget")
        .description("See when will the next SpaceX launch happen.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct NextLaunchWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NextLaunchWidgetEntryView(entry: SimpleEntry(date: Date(), nextLaunch: ResultData.mock, relevance: nil))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            
            PlaceholderView()
                .previewContext(WidgetPreviewContext(family: .systemMedium))
        }
    }
}
