//
//  ViewController.swift
//  WhiteNoise
//
//  Created by user on 13.12.2019.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  @IBOutlet weak var uiImageView: WhiteNoiseView!
  @IBOutlet weak var imagee: WhiteNoiseView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let date = Date()
    if lol.flag {
      uiImageView.generateFrames()
    } else {
      imagee.generateFrames()
    }
    print(date.timeIntervalSinceNow)
    if lol.flag {
      uiImageView.startAnimating()
      lol.flag = !lol.flag
    } else {
      imagee.startAnimating()
    }
  }
}

class lol {
  static var flag = true
}
