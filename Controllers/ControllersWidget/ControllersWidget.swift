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
        if let info = GameControllerManager.shared.getBatteryInfo() {
            if info.state != -1{
                return SimpleEntry(date: Date(), batteryLevel: info.level)
            }
        }
        
        return SimpleEntry(date: Date(), batteryLevel: 0)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        if let info = GameControllerManager.shared.getBatteryInfo() {
            if info.state != -1{
                let entry = SimpleEntry(date: Date(), batteryLevel: info.level)
                completion(entry)
            }
        }
        let entry = SimpleEntry(date: Date(), batteryLevel: 0)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        var level: Float = 0.0
        
        if let info = GameControllerManager.shared.getBatteryInfo() {
            if info.state != -1{
                level = info.level
            }
        }
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, batteryLevel: level)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let batteryLevel: Float
}

struct ControllersWidgetEntryView : View {
    var entry: Provider.Entry
    let size: CGFloat = 100.0
    
    @State var progressValue: Float = 0.0
    
    var body: some View {
        ZStack {
            VStack {
                Image(systemName: "gamecontroller.fill")
                Text("\(Int(entry.batteryLevel))%")
            }
            
            VStack {
                ProgressBar(progress: self.$progressValue)
                    .frame(width: size, height: size)
                    .padding(40.0)
                
                Spacer()
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
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct ControllersWidget_Previews: PreviewProvider {
    static var previews: some View {
        ControllersWidgetEntryView(entry: SimpleEntry(date: Date(), batteryLevel: 0))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
