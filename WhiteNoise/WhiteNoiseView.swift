//
//  WhiteNoiseView.swift
//  WhiteNoise
//
//  Created by user on 18.12.2019.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class WhiteNoiseView: UIImageView {

  private var points: [[CGRect]] = []
  private var colors: [CGColor] = []
  
  private var colorIndexes: [[Int]] = []
  private var indexModa = 0
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    self.animationImages = createAnimationFrames(compress: true, frame: frame)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.animationImages = createAnimationFrames(compress: true, frame: frame)
  }
  
  func generateFrames() -> [UIImage] {
    return createAnimationFrames(compress: true, frame: frame)
  }
  
  private func createAnimationFrames(compress: Bool, frame: CGRect) -> [UIImage] {
    var imageArray: [UIImage] = []
    generatePoints(compress: compress, frame: frame)// affects performance significantly
    generateColors()
    if let image = generateImage(compress: compress, frame: frame) {// affects performance significantly
      imageArray.append(image)
      imageArray += splitImageAndGenerateNew(image: image, width: Int(frame.width), height: Int(frame.height))
    }
    return imageArray
  }
  
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
    for i in 1 ... 3 {
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
    var white = 0
    var gray = 0
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
          gray += 1
        case 2:
          black += 1
        default:
          donothing()
        }
      }
      points.append(arr)
      colorIndexes.append(indexArr)
    }
    
    switch max(white, gray, black) {
    case white:
      indexModa = 0
    case gray:
      indexModa = 1
    case black:
      indexModa = 2
    default:
      donothing()
    }
  }
  
  private func donothing() {}
  
}
