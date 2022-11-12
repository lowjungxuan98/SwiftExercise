//
//  ViewModel.swift
//  SwiftExercise
//
//  Created by Low Jung Xuan on 12/11/2022.
//

import Foundation
class ViewModel: ObservableObject {
    @Published var items = [StudentModel]()
    let prefixUrl = "http://localhost:3000/api/student"
    init() {
        findAll()
    }

    // MARK: - retrieve data

    func findAll() {
        guard let url = URL(string: "\(prefixUrl)") else {
            print("Not found url")
            return
        }
        URLSession.shared.dataTask(with: url) { data, _, error in
            if error != nil {
                print("Error", error?.localizedDescription ?? "")
                return
            }
            do {
                if let data = data {
                    let result = try JSONDecoder().decode([StudentModel].self, from: data)
//                    show json without model
//                    let result = try JSONSerialization.jsonObject(with: data, options: [.json5Allowed])
                    DispatchQueue.main.async {
                        self.items = result
//                        print(result)
                    }
                } else {
                    print("No Data")
                }
            } catch let JsonError {
                print("fetch json error:", JsonError.localizedDescription)
            }
        }.resume()
    }

    // MARK: - create data

    func create(parameters: [String: Any]) {
        guard let url = URL(string: "\(prefixUrl)") else {
            print("Not found url")
            return
        }

        let data = try! JSONSerialization.data(withJSONObject: parameters)

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = data
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, _, error in
            if error != nil {
                print("Error", error?.localizedDescription ?? "")
                return
            }

            do {
                if let data = data {
                    let result = try JSONDecoder().decode(StudentModel.self, from: data)
                    DispatchQueue.main.async {
                        print(result)
                    }
                } else {
                    print("No Data")
                }
            } catch let JsonError {
                print("fetch json error:", JsonError.localizedDescription)
            }
        }.resume()
    }
}
