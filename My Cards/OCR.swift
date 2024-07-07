//
//  OCR.swift
//  LableScanner
//
//  Created by Tim Coder on 6/30/24.
//

import SwiftUI
import Vision

func ocrText(uiImage: UIImage, completion: @escaping (String)->()) {
    guard let cgImage = uiImage.cgImage else {
        print("Could not make cgImage")
        return
    }
    
    let handler = VNImageRequestHandler(cgImage: cgImage)
    let request = VNRecognizeTextRequest { request, error in
        if let error {
            print(error.localizedDescription)
            return
        }
        guard let results = request.results as? [VNRecognizedTextObservation] else {
            return
        }
        
        let recogArr = results.compactMap { result in
            result.topCandidates(1).first?.string
        }
        completion(recogArr.joined(separator: "\n"))
    }
    request.recognitionLevel = .accurate
    
    do {
        try handler.perform([request])
    } catch {
        fatalError(error.localizedDescription)
    }
}
