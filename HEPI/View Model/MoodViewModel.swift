//
//  MoodViewModel.swift
//  HEPI
//
//  Created by Mikhael Adiputra on 04/10/22.
//

import Foundation
import RxSwift
import RxCocoa

class MoodViewModel {
    
    //MARK: - Object Declaration
    private var moodArray = BehaviorRelay<[Mood]>(value: [])
    
    //MARK: - Object Observation Declaration
    var moodArrayObservable: Observable<[Mood]> {
        return moodArray.asObservable()
    }
    
    //MARK: - Observe Journal Array
    /// Returns boolean true or false
    /// from the given components.
    func fetchMoodData() {
        var imMoodArray : [Mood] = []
        imMoodArray.append(Mood(moodDesc: "Very Happy", moodImage: UIImage(named: "veryHappy")!.pngData()))
        imMoodArray.append(Mood(moodDesc: "Happy", moodImage: UIImage(named: "happy")!.pngData()))
        imMoodArray.append(Mood(moodDesc: "Neutral", moodImage: UIImage(named: "neutral")!.pngData()))
        imMoodArray.append(Mood(moodDesc: "Sad", moodImage: UIImage(named: "sad")!.pngData()))
        imMoodArray.append(Mood(moodDesc: "Very Sad", moodImage: UIImage(named: "verySad")!.pngData()))
        moodArray.accept(imMoodArray)
    }
}
