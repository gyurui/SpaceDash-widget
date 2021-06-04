//
//  ContentView.swift
//  SpaceDash
//
//  Created by György Trum on 2021. 06. 03..
//  Copyright © 2021. Pushpinder Pal Singh. All rights reserved.
//

import SwiftUI
import UIKit

struct ContentView: View {
    
    @ObservedObject var viewModel = LaunchesViewModel()
    @State var selection: Int?
    
    var body: some View {
        VStack {
            LoadingView(isShowing: .constant(viewModel.launches.count == 0)) {
                NavigationView {
                    List(viewModel.launches) { launch in
                        NavigationLink(
                            destination: ResultLaunchMediumView(launch),
                            tag: launch.id,
                            selection: $selection,
                            label: {
                                ResultRow(launch: launch)
                            })
                    }
                    .navigationBarTitle("Rocket Launches")
                }.onOpenURL(perform: { (url) in
                    selection = viewModel.launches.first(where: { (result) -> Bool in
                        return URL(string: "\(result.id)") == url
                    })?.id
                })
            }
        }
       .background(Color.black)
       
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

