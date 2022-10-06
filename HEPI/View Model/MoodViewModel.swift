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
    
    private var moodArray = BehaviorRelay<[Mood]>(value: [])
    var moodArrayObservable: Observable<[Mood]> {
        return moodArray.asObservable()
    }
    
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
