//
//  LaunchWidget.swift
//  SpaceDash
//
//  Created by György Trum on 2021. 05. 13..
//  Copyright © 2021. Pushpinder Pal Singh. All rights reserved.
//

import SwiftUI
import WidgetKit

struct ActivityIndicatorView: UIViewRepresentable {
    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style
    
    func makeUIView(context: UIViewRepresentableContext<ActivityIndicatorView>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicatorView>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}

struct LoadingView<Content>: View where Content: View {
    @Binding var isShowing: Bool
    var content: () -> Content

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {

                self.content()
                    .disabled(self.isShowing)
                    .blur(radius: self.isShowing ? 3 : 0)

                VStack {
                    Text("Loading...")
                    ActivityIndicatorView(isAnimating: .constant(true), style: .large)
                }
                .frame(width: geometry.size.width / 2,
                       height: geometry.size.height / 5)
                .background(Color.secondary.colorInvert())
                .foregroundColor(Color.primary)
                .cornerRadius(20)
                .opacity(self.isShowing ? 1 : 0)

            }
        }
    }
}

struct ResultAvatar: View {
    var nextLaunchData: ResultData
    var vehicleSlug = Constants.Vehicles.starshipPrototype
    
    init(_ nextLaunchData: ResultData?) {
        self.nextLaunchData = nextLaunchData ?? ResultData.mock
        if let nextData = nextLaunchData, let vehicle = Constants.Vehicles(rawValue: nextData.vehicleSlug) {
            vehicleSlug = vehicle
        }
    }
    
    var body: some View {
        ZStack {
            Image(vehicleSlug.rawValue).resizable().scaledToFit()
        }
    }
}

struct ResultLaunchInfoView: View {
    let nextLaunchData: ResultData

    init(_ nextLaunchData: ResultData?) {
        self.nextLaunchData = nextLaunchData ?? ResultData.mock
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(nextLaunchData.providerName)
                .font(.title)
                .fontWeight(.bold)
                .minimumScaleFactor(0.25)
            Text(nextLaunchData.pad.location)
            Text("\(nextLaunchData.launchDesc)")
                .minimumScaleFactor(0.5)
        }
    }
}

struct ResultLaunchWidgetView: View {
    let nextLaunchData: ResultData

    init(_ nextLaunchData: ResultData?) {
        self.nextLaunchData = nextLaunchData ?? ResultData.mock
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(nextLaunchData.name)
                        Image(nextLaunchData.pad.countrySlug).resizable().scaledToFit()
                    }
                    .padding(.trailing)
                }
                Text("Launch Time")
                Text(nextLaunchData.normalDate, style: .timer)
                    .font(.system(.body, design: .monospaced))
            }
            ResultAvatar(nextLaunchData)
        }
        .padding()
    }
}

struct ResultLaunchMediumView: View {
    let nextLaunchData: ResultData

    init(_ nextLaunchData: ResultData?) {
        self.nextLaunchData = nextLaunchData ?? ResultData.mock
    }

    var body: some View {
        HStack {
            ResultLaunchWidgetView(nextLaunchData)
            VStack {
                ResultLaunchInfoView(nextLaunchData)
            }
            .padding([.top, .bottom, .trailing])
        }
    }
}

struct AvatarView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ResultLaunchMediumView(ResultData.mock)
                .previewLayout(.fixed(width: 360, height: 169))
        }
    }
}

struct ResultRow: View {
    
    let launch: ResultData
    
    init(launch: ResultData? = ResultData.mock) {
        self.launch = launch ?? ResultData.mock
    }
    
    var body: some View {
        HStack {
            ResultAvatar(launch).frame(maxWidth: 50, maxHeight: 50).scaledToFit()
            Image(launch.pad.countrySlug).resizable().scaledToFit().frame(maxWidth: 50, maxHeight: 50)
            Text(launch.name).font(.caption).foregroundColor(.blue).lineLimit(1)
            Text(launch.normalDate, style: .timer)
                .font(.system(.body, design: .monospaced))
        }
    }
}

struct AllLaunchesView: View {
    
    let launches: [ResultData]
    
    init(launches: [ResultData]? = [ResultData.mock, ResultData.mock]) {
        self.launches = launches ?? [ResultData.mock, ResultData.mock]
    }
    
    var body: some View {
        VStack(spacing: 20) {
            ForEach(
                launches.sorted { $0.date > $1.date }, id: \.self) { launch in
                Link(destination: URL.init(string: "\(launch.id)launch")!) {
                    ResultRow(launch: launch)
                }
            }
        }
    }
}

struct AllLaunchesView_Previews: PreviewProvider {
    static var previews: some View {
        AllLaunchesView()
    }
}

