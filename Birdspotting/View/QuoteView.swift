import SwiftUI

struct QuoteView: View {
    @Environment(QuoteController.self) private var quoteController
    
    var body: some View {
        TabView {
            VStack {
                if let quote = quoteController.quote {
                    Text("\"\(quote.quote)\"")
                        .font(.title)
                        .italic()
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    Text("- \(quote.author)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.top, 8)
                }
            }
            .onAppear {
                Task {
                    await quoteController.fetchNewQuote()
                }
            }
        }
    }
}



#Preview {
    QuoteView().environment(QuoteController())
}
