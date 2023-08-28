import SwiftUI
import VisionKit
import Vision

struct DocScanner: UIViewControllerRepresentable {
    
    @Binding var recognizedText: String
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, recognizedText: $recognizedText)
    }
    
    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let documentViewController = VNDocumentCameraViewController()
        documentViewController.delegate = context.coordinator
        return documentViewController
    }
    
    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {
        
    }
    
    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        var parent: DocScanner
        var recognizedText: Binding<String>
        
        init(_ parent: DocScanner, recognizedText: Binding<String>) {
            self.parent = parent
            self.recognizedText = recognizedText
        }
        
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            //processing images as CGImages and appending to list
            var extractedImages = [CGImage]()
            
            for i in 0..<scan.pageCount {
                if let img = scan.imageOfPage(at: i).cgImage {
                    extractedImages.append(img)
                } else {
                    continue
                }
            }
            
            //processing recognized text
            var extractedText = [String]()
            
            for i in extractedImages.indices { //going through each image
                let requestHandler = VNImageRequestHandler(cgImage: extractedImages[i])
                
                let request = VNRecognizeTextRequest { request, error in
                    guard let observations = request.results as? [VNRecognizedTextObservation] else {
                        fatalError("Unable to get observations")
                    }
                    
                    for observation in observations { //going through each observation
                        guard let topCandidate = observation.topCandidates(1).first else {
                            print("No candidate found")
                            continue
                        }
                        extractedText.append(topCandidate.string) //appending each string from each observation to a list
                    }
                    
                }
                
                do {
                    try requestHandler.perform([request])
                } catch {
                    print(error.localizedDescription)
                }
                
            }
            
            self.recognizedText.wrappedValue = extractedText.joined(separator: " ")
        }
        
        
    }
    
}
