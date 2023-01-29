//
//  ToDOListWidget.swift
//  ToDOListWidget
//
//  Created by IKAKOOO on 28.01.23.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct ToDOListWidgetEntryView : View {
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily) var widgetFaminly
    
    var fontStyle: Font {
        if widgetFaminly == .systemSmall {
            return .system(.footnote, design: .rounded)
        } else {
            return .system(.headline, design: .rounded)
        }
    }
    
    var body: some View {
        // Text(entry.date, style: .time)
        
        GeometryReader { geometry in
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.pink, Color.black]), startPoint: .topLeading, endPoint: .bottomTrailing)
                
                Image("rocket-small")
                    .resizable()
                    .scaledToFit()
                
                Image("logo")
                    .resizable()
                    .frame(width: widgetFaminly != .systemSmall ? 56 : 36,
                           height: widgetFaminly != .systemSmall ? 56 : 36)
                    .offset(
                        x: (geometry.size.width / 2 ) - 20,
                        y: (geometry.size.height / -2 ) + 20
                    )
                    .padding(.top, widgetFaminly != .systemSmall ? 32 : 12)
                    .padding(.trailing, widgetFaminly != .systemSmall ? 32 : 12)
                
                HStack {
                    Text("Just Do It")
                        .foregroundColor(.white)
                        .font(fontStyle)
                        .fontWeight(.bold)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(Color(red: 0 , green: 0, blue: 0, opacity: 0.5).blendMode(.overlay))
                        .clipShape(Capsule())
                        
                        
                    
                    if widgetFaminly != .systemSmall {
                        Spacer()
                    }
                }
                .padding()
                .offset(
                    y: (geometry.size.height / 2 ) - 40
                )
                //.clipShape(Capsule())
            }
        }
    }
}

struct ToDOListWidget: Widget {
    let kind: String = "ToDOListWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            ToDOListWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Just Do It Launcher")
        .description("This is an example widget for launching to do lists tasks app")
    }
}

struct ToDOListWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ToDOListWidgetEntryView(entry: SimpleEntry(date: Date()))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            
            ToDOListWidgetEntryView(entry: SimpleEntry(date: Date()))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            
            ToDOListWidgetEntryView(entry: SimpleEntry(date: Date()))
                .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
    }
}
