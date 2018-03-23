//
//  ViewController.swift
//  MyBackEnd
//
//  Created by Suman Chatterjee on 3/18/18.
//  Copyright © 2018 Suman Chatterjee. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var connectButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func onConnect(_ sender: Any) {

        let json: [String: Any] = ["address": "123 Fake Street",
            "lat": 25.308337, "lon": 10.345]

        let networkService = NetworkService(for: .location, with: json)

        networkService.fetchData(completion: { [weak self] (success, data, error) in
            // Parse data
            if success {
                guard let data = data, let fetchResult: Location = ParseJson.parse(data: data) else {
                    return
                }
                print("message " + fetchResult.message)
            } else {
                print(error ?? "")
            }

        })
    }
}

