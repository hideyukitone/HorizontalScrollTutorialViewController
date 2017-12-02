//
//  HorizontalScrollTutorialItem.swift
//  HorizontalScrollTutorialViewController
//
//  Created by 大國嗣元 on 2017/09/11.
//  Copyright © 2017年 hideyuki okuni. All rights reserved.
//

import UIKit
import ImageIO

public enum HorizontalScrollTutorialItem {
    case image(UIImage)
    case images([UIImage])
    case gif(String)

    var images: [UIImage] {
        switch self {
        case .image(let image):
            return [image]
        case .images(let images):
            return images
        case .gif(let fileName):
            guard let gifFile = Bundle.main.path(forResource: fileName, ofType: "gif"),
                let data = NSData(contentsOfFile: gifFile),
                let cgImageSource = CGImageSourceCreateWithData(data, nil) else {
                    return []
            }

            return (0...CGImageSourceGetCount(cgImageSource)).flatMap{ CGImageSourceCreateImageAtIndex(cgImageSource, $0, nil) }.map{ UIImage(cgImage: $0) }
        }
    }

    func getImagesInBackground(completion: @escaping ([UIImage]) -> Void) {
        DispatchQueue.global().async {
            completion(self.images)
        }
    }
}
