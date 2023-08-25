import SwiftUI

class TextInputViewModel: ObservableObject {
    
    struct SummaryRequestBody: Encodable {
        let text: String
    }
    
    struct SummaryResponseBody: Decodable {
        let summary: String
    }
    
    struct UrlRequestBody: Encodable {
        let url: String
    }
    
    struct TextResponseBody: Decodable {
        let text: String
    }
    
    func fetchText(from link: String) async -> String {
        //encoding url to JSON
//        guard let url = URL(string: link) else {
//            return "Provided link is invalid"
//        }
        
        let requestObject = UrlRequestBody(url: link)
        guard let encoded = try? JSONEncoder().encode(requestObject) else {
            return "Cant encode URL to JSON"
        }
        
        //prepping POST request
        guard let apiLink = URL(string: "http://example_API/extract_text") else {
            return "Invalid URL"
        }
        
        var request = URLRequest(url: apiLink)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //sending request and decoding response
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            guard let response = try? JSONDecoder().decode(TextResponseBody.self, from: data) else {
                return "Couldn't decode JSON"
            }
            
            return response.text
            
        } catch {
            return "No text could be extracted"
        }
    }
    
    func fetchSummary(of text: String) async -> String {
        //encoding text to JSON
        let requestObject = SummaryRequestBody(text: text)
        guard let encoded = try? JSONEncoder().encode(requestObject) else {
            return "Can't encode text to JSON"
        }
        
        //prepping POST request
        guard let url = URL(string: "http://example_API/summarize") else {
            return "Invalid URL"
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        //sending request and decoding response
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            guard let response = try? JSONDecoder().decode(SummaryResponseBody.self, from: data) else {
                return "Couldn't decode JSON"
            }
            
            return response.summary
            
        } catch {
            print(error.localizedDescription)
            return "No summary found"
        }
    }
}
