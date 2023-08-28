import SwiftUI

final class TextInputViewModel: ObservableObject {
    
    struct TextBody: Codable {
        let text: String
    }
    
    struct URLRequestBody: Encodable {
        let url: String
    }
    
    enum AnalysisModes {
        case summary
        case namedEntities
        case keyPhrases
    }
    
    @Published var analysisMode = AnalysisModes.summary
    
    //MARK: Intent(s)
    
    func selectAnalysisMode() {
        switch analysisMode {
        case .summary:
            analysisMode = .namedEntities
        case .namedEntities:
            analysisMode = .keyPhrases
        case .keyPhrases:
            analysisMode = .summary
        }
    }
    
    func fetchText(from link: String) async -> String {
        //encoding URL to JSON
        let requestObject = URLRequestBody(url: link)
        guard let encoded = try? JSONEncoder().encode(requestObject) else {
            return "Cant encode URL to JSON"
        }
        
        //prepping POST request
        guard let apiLink = URL(string: "http://127.0.0.1:5000/extract_text") else {
            return "Invalid URL"
        }
        
        var request = URLRequest(url: apiLink)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //sending request and decoding response
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            guard let response = try? JSONDecoder().decode(TextBody.self, from: data) else {
                return "Couldn't decode JSON"
            }
            
            return response.text
            
        } catch {
            return "No text could be extracted"
        }
    }
    
    func fetchSummary(of text: String) async -> String {
        //encoding text to JSON
        let requestObject = TextBody(text: text)
        guard let encoded = try? JSONEncoder().encode(requestObject) else {
            return "Can't encode text to JSON"
        }
        
        //prepping POST request
        guard let url = URL(string: "http://127.0.0.1:5000/summarize") else {
            return "Invalid URL"
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        //sending request and decoding response
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            guard let response = try? JSONDecoder().decode(TextBody.self, from: data) else {
                return "Couldn't decode JSON"
            }
            
            return response.text
            
        } catch {
            print(error.localizedDescription)
            return "No summary found"
        }
    }
    
    func fetchKeyPhrases(from text: String) async -> String {
        //encoding text to JSON
        let requestBody = TextBody(text: text)
        guard let encoded = try? JSONEncoder().encode(requestBody) else {
            return "Could not be encoded to JSON"
        }
        
        //prepping POST request
        guard let url = URL(string: "http://127.0.0.1:5000/extract_key_phrases") else {
            return "Could not access server"
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //sending request and decoding response
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            guard let response = try? JSONDecoder().decode(TextBody.self, from: data) else {
                return "Couldn't decode JSON"
            }
            
            return response.text
            
        } catch {
            print(error.localizedDescription)
            return "No keyphrases found"
        }
    }
    
    func fetchNamedeEntities(from text: String) async -> String {
        //encoding text to JSON
        let requestBody = TextBody(text: text)
        guard let encoded = try? JSONEncoder().encode(requestBody) else {
            return "Could not be encoded to JSON"
        }
        
        //prepping POST request
        guard let url = URL(string: "http://127.0.0.1:5000/named_entities") else {
            return "Could not access server"
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //sending request and decoding response
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            guard let response = try? JSONDecoder().decode(TextBody.self, from: data) else {
                return "Couldn't decode JSON"
            }
            
            return response.text
            
        } catch {
            print(error.localizedDescription)
            return "No named entities found"
        }
    }
}
