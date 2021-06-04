//
//  MySwiftUIHostingViewController.swift
//  SpaceDash
//
//  Created by György Trum on 2021. 06. 03..
//  Copyright © 2021. Pushpinder Pal Singh. All rights reserved.
//

import UIKit
import SwiftUI

class MySwiftUIHostingViewController: UIHostingController<ContentView> {

    required init?(coder: NSCoder) {
        super.init(coder: coder, rootView: ContentView())
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
    }
}
