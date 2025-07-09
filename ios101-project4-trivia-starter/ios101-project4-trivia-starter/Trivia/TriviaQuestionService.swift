//
//  TriviaQuestionService.swift
//  Trivia
//
//  Created by Kelvin Chen on 7/8/25.
//

import Foundation

struct TriviaResponse: Decodable {
    let results: [TriviaQuestion]
}

class TriviaQuestionService {
    static func fetchTriviaQuestion(completion: (([TriviaQuestion]) -> Void)? = nil) {

        let url = URL(string: "https://opentdb.com/api.php?amount=5")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                assertionFailure("Error \(error!.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                assertionFailure("Invalid response")
                return
            }
            
            guard let data = data, httpResponse.statusCode == 200 else {
                assertionFailure("Invalid response status code: \(httpResponse.statusCode)")
                return
            }
            
            let triviaQuestions = parse(data: data)
            DispatchQueue.main.async {
                completion?(triviaQuestions)
            }
        }
        task.resume()
    }
    
    private static func parse(data: Data) -> [TriviaQuestion] {
        do {
            let decoded = try JSONDecoder().decode(TriviaResponse.self, from: data)
            return decoded.results
        } catch {
            return []
        }
        
    }
}
