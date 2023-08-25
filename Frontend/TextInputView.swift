import SwiftUI

struct TextInputView: View {
    
    @State var showScanner = false
    @State var url = ""
    @State var scannedText = "No Text Provided"
    @ObservedObject var viewModel: TextInputViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("TextScan NLP Tool")
                .font(.largeTitle)
                .fontWeight(.bold)
            HStack {
                scanButton
                imgButton
            }
            urlInput
            textOutput
                .padding(.bottom)
            summarizeButton
        }
        .padding()
        .sheet(isPresented: $showScanner) {
            DocScanner(recognizedText: $scannedText)
        }
    }

    var submitURLButton: some View {
        Button {
            Task {
                scannedText = await viewModel.fetchText(from: url)
            }
        } label: {
            Text("Submit")
                .padding()
                .foregroundColor(.white)
                .fontWeight(.bold)
                .frame(width: 100, height: 50)
                .background(.green)
                .cornerRadius(10)
        }
    }
    
    var imgButton: some View {
        Button {
            
        } label: {
            Image(systemName: "photo")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundColor(.white)
                .frame(width: 175, height: 50)
                .background(.green)
                .cornerRadius(10)
        }
    }
    
    var scanButton: some View {
        Button {
//            showScanner = true
        } label: {
            Image(systemName: "camera")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundColor(.white)
                .frame(width: 175, height: 50)
                .background(.green)
                .cornerRadius(10)
                
        }
    }
    
    var summarizeButton: some View {
        Button {
            Task {
                scannedText = await viewModel.fetchSummary(of: scannedText)
            }
        } label: {
            Text("Summarize")
                .padding()
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 55)
                .background(.green)
                .cornerRadius(20)
        }
    }
    
    var urlInput: some View {
        HStack {
            TextField("Insert URL here", text: $url)
                .padding()
                .foregroundColor(.black)
                .background(.white)
                .cornerRadius(10)
                .shadow(color: .gray, radius: DrawingConstants.shadowRadius, x: DrawingConstants.shadowX, y: DrawingConstants.shadowY)
            submitURLButton
        }
    }
    
    var textOutput: some View {
        TextEditor(text: $scannedText)
            .padding()
            .foregroundColor(.black)
            .background(.white)
            .cornerRadius(10)
            .shadow(color: .gray, radius: 4, x: 2, y: 2)
    }
    
    private struct DrawingConstants {
        static let submitButtonHeight: CGFloat = 50
        static let submitButtonWidth: CGFloat = 100
        static let imgButtonSymHeight: CGFloat = 50
        static let imgButtonSymWidth: CGFloat = 50
        static let imgButtonWidth: CGFloat = 175
        static let imgButtonHeight: CGFloat = 50
        static let summarizeButtonHeight: CGFloat = 55
        static let summarizeButtonCornerRadius: CGFloat = 20
        static let shadowRadius: CGFloat = 4
        static let shadowX: CGFloat = 2
        static let shadowY: CGFloat = 2
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TextInputView(viewModel: TextInputViewModel())
    }
}
