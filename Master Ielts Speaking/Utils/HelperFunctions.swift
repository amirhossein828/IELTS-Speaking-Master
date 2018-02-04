//
//  HelperFunctions.swift
//  Master Ielts Speaking
//
//  Created by seyedamirhossein hashemi on 2017-12-15.
//  Copyright © 2017 seyedamirhossein hashemi. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import WebKit
import CoreVideo

/**
 A set of helpful functions and extensions
 */

/// Gives the array of defenition for specific word in json object format.
///
/// - Parameters:
///   - word: the word
///   - viewController: the viewController
///   - arrayOfDefObject: the array Of Definition Object get invoked when success
///   - arrayOfExampleObject: the array Of Example Object get invoked when success
///   - failur: the failur get invoked if error happens
func getDefinitionsAndPhotos(withWord word : String,viewController : UIViewController , arrayOfDefObject : @escaping ([JSON]) -> Void ,arrayOfExampleObject : @escaping ([JSON]) -> Void , failur : @escaping (_ massege : String) -> Void) {
    WordsApiService.getDefinitionOfWords(word: word) { (response) in
        // create array of string (the definition of word)
        switch response.result {
        case .success(let value):
            let json = JSON(value)
            guard let arrayOfDefObjects = json["definitions"].array else {
                viewController.showAlert("Enter a valid word", "There is no meaning for this word")
                return
            }
            arrayOfDefObject(arrayOfDefObjects)
        case .failure(let error):
            failur(error.localizedDescription)
            print(error.localizedDescription)
        }
    }
    WordsApiService.getExampleOfWords(word: word) { (response) in
        // create array of string (the definition of word)
        switch response.result {
        case .success(let value):
            let json = JSON(value)
            guard let arrayOfExamObjects = json["examples"].array else {
                viewController.showAlert("Enter a valid word", "There is no meaning for this word")
                return
            }
            arrayOfExampleObject(arrayOfExamObjects)
        case .failure(let error):
            print(error)
        }
    }
    
}

/// Get images from json files
///
/// - Parameters:
///   - path: the path of photo
///   - viewController: the viewController
///   - completion: the completion invoke when success ( bring Json photo)
func getImageAssets(path : String, completion :  (JSON) -> Void){
    do {
        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        print(data)
        let json = try JSON(data : data)
        completion(json)
        
    } catch {
        print("error")
    }
}

/// load my Page
///
/// - Parameters:
///   - webSite: the webSite
///   - webView: the webView
///   - viewController: the viewController
///   - activityIndicator: the activityIndicator
func loadWebPage(webSite : String, webView : WKWebView , viewController : WKNavigationDelegate, activityIndicator : UIActivityIndicatorView?) {
    // create url
    let url = URL(string: webSite)
    // create request
    let request = URLRequest(url: url!)
    // load the page by the request
    webView.load(request)
    webView.navigationDelegate = viewController
    if let activityIndicator = activityIndicator {
        webView.addSubview(activityIndicator)
    }
}

/**
 * Class to check connectivity to Internet
 *
 * - author: Amir
 *
 */
class Connectivity {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

struct ImageProcessor {
    static func pixelBuffer (forImage image:CGImage) -> CVPixelBuffer? {
        
        
        let frameSize = CGSize(width: image.width, height: image.height)
        
        var pixelBuffer:CVPixelBuffer? = nil
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(frameSize.width), Int(frameSize.height), kCVPixelFormatType_32BGRA , nil, &pixelBuffer)
        
        if status != kCVReturnSuccess {
            return nil
            
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags.init(rawValue: 0))
        let data = CVPixelBufferGetBaseAddress(pixelBuffer!)
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.premultipliedFirst.rawValue)
        let context = CGContext(data: data, width: Int(frameSize.width), height: Int(frameSize.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: bitmapInfo.rawValue)
        
        
        context?.draw(image, in: CGRect(x: 0, y: 0, width: image.width, height: image.height))
        
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        return pixelBuffer
        
    }
    
}


func ResizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
    let size = image.size
    
    let widthRatio  = targetSize.width  / image.size.width
    let heightRatio = targetSize.height / image.size.height
    
    // Figure out what our orientation is, and use that to form the rectangle
    var newSize: CGSize
    if(widthRatio > heightRatio) {
        
        newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
    } else {
        newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        
    }
    
    // This is the rect that we've calculated out and this is what is actually used below
    
    let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
    
    // Actually do the resizing to the rect using the ImageContext stuff
    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    image.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage!
}
