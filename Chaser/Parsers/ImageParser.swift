//
//  ImageParser.swift
//  Chaser
//
//  Created by Andrew Whipple on 3/16/25.
//

import Vision
import UIKit

func recognizeText(from image: UIImage, completion: @escaping (String?) -> Void) {
    guard let cgImage = image.cgImage else {
        completion(nil)
        return
    }
    
    let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
    let request = VNRecognizeTextRequest { request, error in
        guard let results = request.results as? [VNRecognizedTextObservation] else {
            completion(nil)
            return
        }
        
        let recognizedText = results.compactMap { $0.topCandidates(1).first?.string }.joined(separator: "\n")
        completion(recognizedText)
    }
    
    do {
        try requestHandler.perform([request])
    } catch {
        print("Error performing OCR: \(error)")
        completion(nil)
    }
}

