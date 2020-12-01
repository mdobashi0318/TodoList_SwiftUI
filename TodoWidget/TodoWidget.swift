//
//  TodoWidget.swift
//  TodoWidget
//
//  Created by 土橋正晴 on 2020/12/01.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct TodoWidgetEntryView : View {
    var entry: Provider.Entry
    
    var todomodel: ToDoModel?

    var body: some View {
        VStack {
            Text("Next Todo")
            Text(todomodel?.toDoName ?? "No Todo")
        }
    }
}

@main
struct TodoWidget: Widget {
    let kind: String = "TodoWidget"

    var todo: ToDoModel? {
        return ToDoModel.allFindRealm()?.first(where: {
            Format().dateFromString(string: $0.todoDate)! > Format().dateFormat()
        })
    }
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            TodoWidgetEntryView(entry: entry, todomodel: todo)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct TodoWidget_Previews: PreviewProvider {
    static var previews: some View {
        TodoWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()), todomodel: todomodel[0])
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
