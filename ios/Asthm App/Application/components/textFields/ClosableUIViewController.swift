//
//  ClosableUIViewController.swift
//  Asthm App
//
//  Created by Den Matiash on 16.01.2021.
//  Copyright © 2021 xorum.io. All rights reserved.
//

import Foundation
import UIKit

class ClosableUIViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "ic_chevron_left")?.withRenderingMode(.alwaysTemplate),
            style: .plain,
            target: self,
            action: #selector(closeTapped)
        ).apply {
            $0.tintColor = Palette.ebonyClay
        }
    }

    @objc func closeTapped() {
        dismiss(animated: true)
    }
}
