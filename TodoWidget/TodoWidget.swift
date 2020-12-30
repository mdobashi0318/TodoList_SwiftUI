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
        let entry = SimpleEntry(date: Date(), configuration: configuration, todomodel: ToDoModel(id: "", toDoName: "次のTodoタイトル", todoDate: "2021/01/01 00:00", toDo: "Todoの詳細", createTime: nil))
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        var todo: ToDoModel? {
            return ToDoModel.allFindRealm()?.first(where: {
                Format().dateFromString(string: $0.todoDate)! > Format().dateFormat()
            })
        }


        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .minute, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration, todomodel: todo)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    var todomodel: ToDoModel?
}

struct TodoWidgetEntryView : View {
    var entry: Provider.Entry
    
    private static let deeplinkURL: URL = URL(string: "widget-deeplink-todolist://")!
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("次の予定")
                .font(.caption)
            Text(entry.todomodel?.toDoName ?? "No Todo")
            Text(entry.todomodel?.todoDate ?? "")
        }
        .widgetURL(Self.deeplinkURL)
        .padding()
    }
}

@main
struct TodoWidget: Widget {
    let kind: String = "TodoWidget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            TodoWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemSmall])
    }
}

struct TodoWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TodoWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), todomodel: testModel[0]))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            
            TodoWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), todomodel: nil))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
        }
    }
}
