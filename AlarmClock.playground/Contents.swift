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
//    音が鳴っている時間
    var lengthOfSound = 5
//    音の種類
    var ringSound = "ピピピッ"
    enum Sound {
        case pipipi
        case beepbeep
        case wakeUp
    }
//    タイムゾーン
    var timeZone = "Asia/Tokyo"
    enum Zone {
        case tokyo
        case hawai
        case london
    }
    var timer: Timer?
//    アラームを鳴らす時刻
    var alermTime: String = ""
//    時刻表示のフォーマット
    var dateFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateStyle = .long
        df.timeZone = TimeZone(identifier: timeZone)
        df.locale = Locale(identifier: "ja-JP")
        df.dateFormat = "HH:mm:ss"
        return df
    }
//    時刻をセットしてアラームを起動します。
    func setAndStartAlarm(alermTime: String){
        self.alermTime = alermTime
        print("\(alermTime)にアラームがセットされました。")
        timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(compareTimes),
            userInfo: nil,
            repeats: true
        )
    }
//    セットされた時間と現在時刻を比較します。
    @objc func compareTimes() {
        let now = dateFormatter.string(from: Date())
        if now == self.alermTime {
            print("\(self.alermTime)になりました")
            timer?.invalidate()
            ringAlarm()
        }
    }
//    アラームを鳴らします。
    func ringAlarm(){
        timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(stopAlarm),
            userInfo: nil,
            repeats: true
        )
    }
//    指定した時間分アラームを鳴らしたらストップします。
    @objc func stopAlarm(){
        print("\(ringSound)")
        lengthOfSound -= 1
        if lengthOfSound == 0 {
            timer?.invalidate()
        }
    }
//    アラームが止まるまでの時間を設定
    func changeDistance(lengthOfSound: Int){
        self.lengthOfSound = lengthOfSound
    }
//    アラームの音を変更する
    func changeSound(sound: Sound){
        switch sound {
        case .pipipi:
            self.ringSound = "ピピピッ"
        case .beepbeep:
            self.ringSound = "ピー、ピー、"
        case .wakeUp:
            self.ringSound = "起きろー！"
        }
    }
//    タイムゾーンを変更する
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
//    現在時刻を表示する
    func whatTimeIsIt(){
        let now = dateFormatter.string(from: Date())
        print(now)
    }
//    アラームを止める
    func cancelAlarm(){
        timer?.invalidate()
        print("アラームを止めました。")
    }
}

let alarmClock = AlarmClock()
alarmClock.changeDistance(lengthOfSound: 10)
alarmClock.changeSound(sound: .wakeUp)
alarmClock.changeTimeZone(timeZone: .hawai)
alarmClock.whatTimeIsIt()
alarmClock.setAndStartAlarm(alermTime: "21:46:30")
alarmClock.cancelAlarm()
