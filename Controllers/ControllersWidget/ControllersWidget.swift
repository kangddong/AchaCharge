//
//  ControllersWidget.swift
//  ControllersWidget
//
//  Created by 강동영 on 2023/06/07.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        if let info = GameControllerManager.shared.getBatteryInfo(), info.state != -1 {
            return SimpleEntry(date: Date(), batteryLevel: info.level)
        } else {
            let level = UserDefaults.shared.value(forKey: "batteryLevel") as? Float
            return SimpleEntry(date: Date(), batteryLevel: level ?? 0.0)
        }
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        if let info = GameControllerManager.shared.getBatteryInfo(), info.state != -1 {
            let entry = SimpleEntry(date: Date(), batteryLevel: info.level)
            completion(entry)
        } else {
            let level = UserDefaults.shared.value(forKey: "batteryLevel") as? Float
            let entry = SimpleEntry(date: Date(), batteryLevel: level ?? 0.0)
            completion(entry)
        }
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        print(#function)
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        if let info = GameControllerManager.shared.getBatteryInfo(), info.state != -1 {
            print("case if let called")
            let level = info.level
            
            if level < 20.0 {
                addScehdule(identifier: "batteryState", body: "현재 배터리는 \(Int((level) * 100))% 입니다.")
            }
            
            let currentDate = Date()
            for hourOffset in 0 ..< 5 {
                let entryDate = Calendar.current.date(byAdding: .minute, value: hourOffset, to: currentDate)!
                let entry = SimpleEntry(date: entryDate, batteryLevel: level)
                entries.append(entry)
            }
            
            let timeline = Timeline(entries: entries, policy: .never)
            completion(timeline)
        } else {
            print("case else called")
            let level = (UserDefaults.shared.value(forKey: "batteryLevel") as? Float) ?? 0
            
            if level < 20.0 {
                addScehdule(identifier: "batteryState", body: "현재 배터리는 \(Int((level) * 100))% 입니다.")
            }
            
            
            let currentDate = Date()
            for hourOffset in 0 ..< 5 {
                let entryDate = Calendar.current.date(byAdding: .minute, value: hourOffset, to: currentDate)!
                let entry = SimpleEntry(date: entryDate, batteryLevel: level)
                entries.append(entry)
            }
            
            let timeline = Timeline(entries: entries, policy: .never)
            completion(timeline)
        }
        
        func addScehdule(identifier: String, body: String) {
            print(#function, "called")
            let center = UNUserNotificationCenter.current()
            let content = UNMutableNotificationContent()
            content.title = "아차 충전!"
            content.body = body
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            center.add(request)
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let batteryLevel: Float
}

struct ControllersWidgetEntryView : View {
    var entry: Provider.Entry
    let size: CGFloat = 100.0
    
    @State var progressValue: Float = 0.8
    
    var body: some View {
        ZStack {
            VStack {
                Image(systemName: "gamecontroller.fill")
                Text("\(Int(entry.batteryLevel * 100))%")
            }
            
            VStack {
                ProgressBar(progress: self.$progressValue)
                    .frame(width: size, height: size)
                    .padding(40.0)
                
                Spacer()
            }
            .onAppear {
                print("progressValue = entry.batteryLevel: \(entry.batteryLevel)")
                progressValue = entry.batteryLevel
            }
        }
    }
}

struct ControllersWidget: Widget {
    let kind: String = "ControllersWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            ControllersWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("아차 충전!")
        .description("배경화면에서 배터리 상태를 확인하세요 !")
    }
}

struct ControllersWidget_Previews: PreviewProvider {
    static var previews: some View {
        ControllersWidgetEntryView(entry: SimpleEntry(date: Date(), batteryLevel: 0))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
