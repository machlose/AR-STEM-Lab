//
//  readDataFromFile.swift
//  STEAM Lab
//
//  Created by uczen on 23/03/2025.
//

import Foundation

func readDataFromFile<T: Decodable>(from file: String) -> [T]{
    guard let fileURL = Bundle.main.url(forResource: file, withExtension: "json")
    else{
        print("Nie znaleziono pliku: \(file)")
        return []
    }
    do{
        let data = try Data(contentsOf: fileURL)
        let decoder = JSONDecoder();
        return try decoder.decode([T].self, from: data)
    } catch{
        print("Nie można odczytać danych z pliku: \(file)")
        return []
    }
}
