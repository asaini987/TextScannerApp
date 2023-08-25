import SwiftUI

@main
struct TextScanApp: App {
    var body: some Scene {
        WindowGroup {
            TextInputView(viewModel: TextInputViewModel())
        }
    }
}
