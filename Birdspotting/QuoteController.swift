import Foundation

@Observable
class QuoteController {
    var quote: Quote?
    var lastId: Int?

    init() {
        Task {
            await fetchNewQuote()
        }
    }
    
    func fetchNewQuote() async {
        guard let randomQuote = URL(string: "https://dummyjson.com/quotes/random") else { return }
        await fetchQuote(from: randomQuote)
    }
    
    func fetchQuote(from url: URL) async {
        guard let rawQuoteData = await NetworkService.getData(from: url) else { return }
        let decoder = JSONDecoder()
        do {
            let jsonResult = try decoder.decode(Quote.self, from: rawQuoteData)
            
            let lastID = UserDefaults.standard.integer(forKey: "lastId")
            if lastID == jsonResult.id {
                await fetchQuote(from: url)
                return
            }
            
            Task { @MainActor in
                self.quote = jsonResult
                UserDefaults.standard.set(jsonResult.id, forKey: "lastId")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
