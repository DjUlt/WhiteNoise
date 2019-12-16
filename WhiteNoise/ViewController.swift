//
//  ViewController.swift
//  WhiteNoise
//
//  Created by user on 13.12.2019.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  @IBOutlet weak var uiImageView: UIImageView!
  
  var points: [[CGPoint]] = []
  var colors: [CGColor] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    generatePoints()
    generateColors()
    initial()
  }
  
  private func initial() {
    let startDate = Date()
    
    var imageArray: [UIImage] = []
    if let image = generateImage() {
      imageArray.append(image)
      imageArray += splitImageAndGenerateNew(image: image)
    }
    uiImageView.animationImages = imageArray
    uiImageView.startAnimating()
    
    print(startDate.timeIntervalSinceNow)
  }

  private func generateImage() -> UIImage? {
    let width = Int(uiImageView.frame.width)
    let height = Int(uiImageView.frame.height)
    let size = CGSize(width: width, height: height)
    let pointSize = CGSize(width: 1, height: 1)
    let startDate = Date()
    
    UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
    let sysColor = UIColor.systemBlue.cgColor
    for i in 0 ... width {
      for j in 0 ... height {
        UIGraphicsGetCurrentContext()!.setFillColor(colors[Int.random(in: 0 ... 4)])
        UIGraphicsGetCurrentContext()!.fill(CGRect(origin: points[i][j], size: pointSize))
      }
    }
    let colorImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    print(startDate.timeIntervalSinceNow)
    return colorImage
  }
  
  private func splitImageAndGenerateNew(image: UIImage) -> [UIImage] {
    guard let cgImage = image.cgImage else { return [] }
    var imageArray: [UIImage] = []
    
    let width = Int(uiImageView.frame.width)
    let height = Int(uiImageView.frame.height)
    let size = CGSize(width: width, height: height)
    
    let rects = [ CGRect(x: 0, y: 0, width: width/2, height: height/2),
                  CGRect(x: width/2, y: 0, width: width/2, height: height/2),
                  CGRect(x: 0, y: height/2, width: width/2, height: height/2),
                  CGRect(x: width/2, y: height/2, width: width/2, height: height/2) ]
    
    guard let cgImage1 = cgImage.cropping(to: rects[0]),
          let cgImage2 = cgImage.cropping(to: rects[1]),
          let cgImage3 = cgImage.cropping(to: rects[2]),
          let cgImage4 = cgImage.cropping(to: rects[3]) else { return [] }
    
    let cgImages = [ cgImage1,
                     cgImage2,
                     cgImage3,
                     cgImage4 ]
    
      let images = [ UIImage(cgImage: cgImages[0]),
                     UIImage(cgImage: cgImages[1]),
                     UIImage(cgImage: cgImages[2]),
                     UIImage(cgImage: cgImages[3]) ]
    
    var startDate = Date()
    UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
    images[0].draw(in: rects[1])
    images[1].draw(in: rects[2])
    images[2].draw(in: rects[3])
    images[3].draw(in: rects[0])
    if let finImage = UIGraphicsGetImageFromCurrentImageContext() {
      imageArray.append(finImage)
    }
    UIGraphicsEndImageContext()
    print(startDate.timeIntervalSinceNow)
    
    startDate = Date()
    UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
    images[0].draw(in: rects[2])
    images[1].draw(in: rects[3])
    images[2].draw(in: rects[0])
    images[3].draw(in: rects[1])
    if let finImage = UIGraphicsGetImageFromCurrentImageContext() {
      imageArray.append(finImage)
    }
    UIGraphicsEndImageContext()
    print(startDate.timeIntervalSinceNow)
    
    startDate = Date()
    UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
    images[0].draw(in: rects[3])
    images[1].draw(in: rects[0])
    images[2].draw(in: rects[1])
    images[3].draw(in: rects[2])
    if let finImage = UIGraphicsGetImageFromCurrentImageContext() {
      imageArray.append(finImage)
    }
    UIGraphicsEndImageContext()
    print(startDate.timeIntervalSinceNow)
    
    return imageArray
  }
  
  private func generateColors() {
    for i in 1 ... 5 {
//      let random = (CGFloat(i - 1) * 10 + CGFloat.random(in: 0 ... 10)) / 100
      let random = (CGFloat(i - 1) * 20 + CGFloat.random(in: 0 ... 20)) / 100
      let color = UIColor(red: random,
                          green: random,
                          blue: random,
                          alpha: 1.0)
      colors.append(color.cgColor)
    }
  }
  
  private func generatePoints() {
    let width = Int(uiImageView.frame.width)
    let height = Int(uiImageView.frame.height)
    
    for i in 0 ... width {
      var arr: [CGPoint] = []
      for j in 0 ... height {
        arr.append(CGPoint(x: i, y: j))
      }
      points.append(arr)
    }
  }
  
  @IBAction func test(_ sender: UIButton) {
    initial()
  }
}
extension UIColor {
    static var random: UIColor {
      let random = CGFloat.random(in: 0...1)
        return UIColor(red: random,
                       green: random,
                       blue: random,
                       alpha: 1.0)
    }
}
