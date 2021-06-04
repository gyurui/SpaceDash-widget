//
//  LaunchesViewModel.swift
//  SpaceDash
//
//  Created by György Trum on 2021. 06. 03..
//  Copyright © 2021. Pushpinder Pal Singh. All rights reserved.
//

import Foundation
import Combine

class LaunchesViewModel: ObservableObject {
    
    let networkObject = NetworkManager(Constants.NetworkManager.rocketLaunchLiveAPI)
    @Published var launches: [ResultData] = []
    
    init() {
        getLaunches() 
    }
    
}

extension LaunchesViewModel {
    // Subscriber implementation
    func getLaunches() {
        networkObject.performRequest(key: "") { [weak self] (result: Result<NextLaunchData,Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let nextLaunch):
                DispatchQueue.main.async {
                    self.launches = nextLaunch.resultList
                }
                print(nextLaunch)
                break
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
