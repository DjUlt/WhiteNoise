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
  
  var points: [[CGRect]] = []
  var colors: [CGColor] = []
  
  var colorIndexes: [[Int]] = []
  var indexModa = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    generateColors()
    let date = Date()
    uiImageView.animationImages = createStaticAnimation(compress: true, frame: uiImageView.frame)
    print(date.timeIntervalSinceNow)
    uiImageView.startAnimating()
  }
  
  private func createStaticAnimation(compress: Bool, frame: CGRect) -> [UIImage] {
    var imageArray: [UIImage] = []
    generatePoints(compress: compress, frame: uiImageView.frame)// affects performance significantly
    
    if let image = generateImage(compress: compress, frame: frame) {// affects performance significantly
      imageArray.append(image)
      imageArray += splitImageAndGenerateNew(image: image, width: Int(frame.width), height: Int(frame.height))
    }
    return imageArray
  }

//  func createBitmapContext(pixelsWide: Int, _ pixelsHigh: Int) -> CGContext? {
//    let bytesPerPixel = 4
//    let bytesPerRow = bytesPerPixel * pixelsWide
//    let bitsPerComponent = 8
//
//    let byteCount = (bytesPerRow * pixelsHigh)
//    guard let cgColorSpace = CGColorSpace(name: CGColorSpace.sRGB) else { return nil }
//    let data = UnsafeMutableRawPointer(bitPattern: byteCount)
//    let bitmapInfo = CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue
//
//    let context = CGContext(data: data, width: pixelsWide, height: pixelsHigh, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: cgColorSpace, bitmapInfo: bitmapInfo)
//
//    return context
//  }
  
  private func generateImage(compress: Bool, frame: CGRect) -> UIImage? {
    var width = Int(frame.width + 1)
    var height = Int(frame.height + 1)
    let size = CGSize(width: width, height: height)
    
    width = Int(frame.width / 2 + 1)
    height = Int(frame.height / 2 + 1)
    let midSize = CGSize(width: width, height: height)
    
    if compress {
      width = Int(frame.width / 4 + 1)
      height = Int(frame.height / 4 + 1)
      let minSize = CGSize(width: width, height: height)
      UIGraphicsBeginImageContextWithOptions(minSize, false, 1.0)
    } else {
      UIGraphicsBeginImageContextWithOptions(midSize, false, 1.0)
    }
    
    guard let graphicsContext = UIGraphicsGetCurrentContext() else { return nil }
    graphicsContext.setFillColor(colors[indexModa])
    graphicsContext.fill(CGRect(origin: CGPoint(x: 0, y: 0), size: size))
    for i in 0 ... width {
      for j in 0 ... height {
//        let colorIndex = Int.random(in: 0 ... 2)
        if colorIndexes[i][j] != indexModa {
          graphicsContext.setFillColor(colors[colorIndexes[i][j]])
          graphicsContext.fill(points[i][j])
        } else {
          continue
        }
      }
    }
    let colorImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    if let image = colorImage {
      var ssize: CGSize
      if compress {
        height = height + 1
        ssize = midSize
      } else {
        ssize = size
      }
      if let finImage = reGenerateImage(startImage: image, width: width, height: height, size: ssize) {
        if compress {
          return reGenerateImage(startImage: finImage, width: width * 2, height: height * 2, size: size)
        }
        return finImage
      }
    }
    return nil
  }
  
  private func reGenerateImage(startImage: UIImage, width: Int, height: Int, size: CGSize) -> UIImage? {
    let rects = generateRects(width: Double(width), height: Double(height))
    var images = splitImageAndGenerateNew(image: startImage, width: width, height: height)
    images.append(startImage)
    UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
    images[0].draw(in: rects[0])
    images[1].draw(in: rects[1])
    images[2].draw(in: rects[2])
    images[3].draw(in: rects[3])
    if let finalImage = UIGraphicsGetImageFromCurrentImageContext() {
      UIGraphicsEndImageContext()
      return finalImage
    }
    return nil
  }
  
  private func splitImageAndGenerateNew(image: UIImage, width: Int, height: Int) -> [UIImage] {
    guard let cgImage = image.cgImage else { return [] }
    var imageArray: [UIImage] = []
    
    let size = CGSize(width: width, height: height)
    
    let rects = generateRects(width: Double(width / 2 + 1), height: Double(height / 2 + 1))
    
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
    
    UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
    images[0].draw(in: rects[1])
    images[1].draw(in: rects[2])
    images[2].draw(in: rects[3])
    images[3].draw(in: rects[0])
    if let finImage = UIGraphicsGetImageFromCurrentImageContext() {
      imageArray.append(finImage)
    }
    UIGraphicsEndImageContext()
    
    UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
    images[0].draw(in: rects[2])
    images[1].draw(in: rects[3])
    images[2].draw(in: rects[0])
    images[3].draw(in: rects[1])
    if let finImage = UIGraphicsGetImageFromCurrentImageContext() {
      imageArray.append(finImage)
    }
    UIGraphicsEndImageContext()
    
    UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
    images[0].draw(in: rects[3])
    images[1].draw(in: rects[0])
    images[2].draw(in: rects[1])
    images[3].draw(in: rects[2])
    if let finImage = UIGraphicsGetImageFromCurrentImageContext() {
      imageArray.append(finImage)
    }
    UIGraphicsEndImageContext()
    
    return imageArray
  }
  
  private func generateRects(width: Double, height: Double) -> [CGRect] {
    return [ CGRect(x: 0, y: 0, width: width, height: height),
             CGRect(x: width, y: 0, width: width, height: height),
             CGRect(x: 0, y: height, width: width, height: height),
             CGRect(x: width, y: height, width: width, height: height) ]
  }
  
  private func generateColors() {
    for i in 1 ... 3 {//5
      //let random = (CGFloat(i - 1) * 20 + CGFloat.random(in: 0 ... 20)) / 100
      let random = (CGFloat(i - 1) * 33 + CGFloat.random(in: 0 ... 33)) / 100
      let color = UIColor(red: random,
                          green: random,
                          blue: random,
                          alpha: 1.0)
      colors.append(color.cgColor)
    }
  }
  
  private func generatePoints(compress: Bool, frame: CGRect) {
    let pointSize = CGSize(width: 1, height: 1)
    points = []
    colorIndexes = []
    var white = 0
    var grey = 0
    var black = 0
    
    var width = Int(frame.width / 2 + 1)
    var height = Int(frame.height / 2 + 1)
    if compress {
      width = Int(frame.width / 4 + 1)
      height = Int(frame.height / 4 + 1)
    }
    
    for i in 0 ... width {
      var indexArr: [Int] = []
      var arr: [CGRect] = []
      for j in 0 ... height {
        arr.append(CGRect(origin: CGPoint(x: i, y: j), size: pointSize))
        indexArr.append(Int.random(in: 0 ... 2))
        switch indexArr[j] {
        case 0:
          white += 1
        case 1:
          grey += 1
        case 2:
          black += 1
        default:
          donothing()
        }
      }
      points.append(arr)
      colorIndexes.append(indexArr)
    }
    
    switch max(white, grey, black) {
    case white:
      indexModa = 0
    case grey:
      indexModa = 1
    case black:
      indexModa = 2
    default:
      donothing()
    }
  }
  
  func donothing() {}
  
  @IBAction func test(_ sender: UIButton) {
    let date = Date()
    uiImageView.animationImages = createStaticAnimation(compress: true, frame: uiImageView.frame)
    print(date.timeIntervalSinceNow)
    uiImageView.startAnimating()
  }
  @IBAction func testt(_ sender: UIButton) {
    let date = Date()
    uiImageView.animationImages = createStaticAnimation(compress: false, frame: uiImageView.frame)
    print(date.timeIntervalSinceNow)
    uiImageView.startAnimating()
  }
}
//extension UIColor {
//    static var random: UIColor {
//      let random = CGFloat.random(in: 0...1)
//        return UIColor(red: random,
//                       green: random,
//                       blue: random,
//                       alpha: 1.0)
//    }
//}
