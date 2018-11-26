import Foundation

struct SliderValue {
    
    let values: [Int]
    
    /**
     表示する値を決定する
     WARNING: 座標を元に値を決定しているので、端末サイズに依存して実際に扱われる値が異なる
     TODO: 値が多すぎるとパフォーマンスに大きく影響してしまう
     */
    init(values: [Int] = []) {
        self.values = values
    }
    
    var minValue: Int {
        return values.first ?? 0
    }
    
    var maxValue: Int {
        return values.last ?? Int.max
    }
    
    func isExists(value: Int) -> Bool {
        return values.contains(value)
    }
    
    /** 中間値2つを返す */
    var intermediateValue: (left: Int, right: Int)? {
        let leftIndex = values.count / 3
        let rightIndex = (values.count * 2) / 3
        guard rightIndex < values.count - 1 else { return nil }
        return (left: values[leftIndex], right: values[rightIndex])
    }
    
    /** 値に応じたデータのインデックスを返す。値が存在しない場合はnilを返す */
    func indexFromValue(value: Int) -> Int? {
        for (index, element) in values.enumerated() where element == value {
            return index
        }
        return nil
    }
    
    /** valuesに存在しない値をもとにしてvaluesのどのレンジに属するかを返す。存在する場合はnilを返す */
    func rangeFromNotExistValue(value: Int) -> (left: Int, right: Int)? {
        if isExists(value: value) {
            return nil
        }
        
        var left = 0
        for element in values.reversed() where value > element {
            left = element
            break
        }
        
        var right = Int.max
        for element in values where value < element {
            right = element
            break
        }
        
        return (left: left, right: right)
    }
}
