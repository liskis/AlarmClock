//現在の時刻を表示
//アラームが鳴る時刻を24時間表記で設定する
//指定時間になるとアラームが鳴る
//アラームの音を変更できるデフォルトは"ピピピッ"
//アラームが止まるまでの時間を設定できる。デフォルトは5秒
//世界時計に対応。デフォルトは"Asia/Tokyo”
//アラームを途中で止めることができる

import Foundation
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

class AlarmClock {
    
    var ringDistance = 5
    var ringSount = "ピピピッ"
    enum Sound {
        case pipipi
        case beepbeep
        case wakeUp
    }
    var timeZone = "Asia/Tokyo"
    enum Zone {
        case tokyo
        case hawai
        case london
    }
    var timer: Timer?
    var setTime: String = ""
    var dateFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateStyle = .long
        df.timeZone = TimeZone(identifier: timeZone)
        df.locale = Locale(identifier: "ja-JP")
        df.dateFormat = "HH:mm:ss"
        return df
    }
    
    func setAlarm(setTime: String){
        self.setTime = setTime
        print("\(setTime)にアラームがセットされました。")
        timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(checkTime),
            userInfo: nil,
            repeats: true
        )
    }
    @objc func checkTime() {
        let now = dateFormatter.string(from: Date())
        if now == self.setTime {
            print("\(self.setTime)になりました")
            timer?.invalidate()
            ringAlarm()
        }
    }
    @objc func ringAlarm(){
        timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(stopAlarm),
            userInfo: nil,
            repeats: true
        )
    }
    @objc func stopAlarm(){
        print("\(ringSount)")
        ringDistance -= 1
        if ringDistance == 0 {
            timer?.invalidate()
        }
    }
    
    func changeDistance(ringDistance: Int){
        self.ringDistance = ringDistance
    }
    func changeSound(sound: Sound){
        switch sound {
        case .pipipi:
            self.ringSount = "ピピピッ"
        case .beepbeep:
            self.ringSount = "ピー、ピー、"
        case .wakeUp:
            self.ringSount = "起きろー！"
        }
    }
    func changeTimeZone(timeZone: Zone){
        switch timeZone {
        case .tokyo:
            self.timeZone = "Asia/Tokyo"
        case .hawai:
            self.timeZone = "America/Adak"
        case .london:
            self.timeZone = "Europe/London"
        }
    }
    func whatTimeIsIt(){
        let now = dateFormatter.string(from: Date())
        print(now)
    }
    func cancelAlarm(){
        timer?.invalidate()
        print("アラームを止めました。")
    }
}

let alarmClock = AlarmClock()
alarmClock.changeDistance(ringDistance: 10)
alarmClock.changeSound(sound: .wakeUp)
alarmClock.changeTimeZone(timeZone: .hawai)
alarmClock.whatTimeIsIt()
alarmClock.setAlarm(setTime: "15:50:00")
alarmClock.cancelAlarm()
