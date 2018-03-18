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
                                   "lat":"25.308337","lon":"101.544880"]

        let networkService = NetworkService(for: .location, with: json)
        networkService.fetchData(completion: { [weak self] (success, error) in
            print("Success")
    })

}
}

