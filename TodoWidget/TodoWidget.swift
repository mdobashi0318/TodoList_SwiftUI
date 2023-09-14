//
//  TodoWidget.swift
//  TodoWidget
//
//  Created by 土橋正晴 on 2020/12/01.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import WidgetKit
import SwiftUI

// MARK: - Provider

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(),
                                todomodel: ToDoModel(id: "",
                                                     toDoName: NSLocalizedString("TodoTitle", tableName: "Label", comment: ""),
                                                     todoDate: "2021/01/01 00:00",
                                                     toDo: NSLocalizedString("TodoDetail", tableName: "Label", comment: ""),
                                                     createTime: nil,
                                                     tag_id: nil)
        )
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        var entries: [SimpleEntry] = []
        var todo: ToDoModel? {
            return ToDoModel.allFindTodo().first(where: {
                Format.dateFromString(string: $0.todoDate)! > Format.dateFormat() &&
                $0.completionFlag != CompletionFlag.completion.rawValue
            })
        }
        
        
        let currentDate = Date()
        let entryDate = Calendar.current.date(byAdding: .minute, value: 30, to: currentDate)!
        let entry = SimpleEntry(date: entryDate, todomodel: todo)
        entries.append(entry)
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}


// MARK: - SimpleEntry

struct SimpleEntry: TimelineEntry {
    let date: Date
    var todomodel: ToDoModel?
}


// MARK: - TodoWidgetEntryView

struct TodoWidgetEntryView : View {
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily) private var family: WidgetFamily
    
    private static let deeplinkURL: URL = URL(string: "widget-deeplink-todolist://")!
    
    @ViewBuilder
    var body: some View {
        switch family {
        case .systemSmall, .accessoryRectangular:
            VStack(alignment: .leading) {
                Text(NSLocalizedString("NextTodo", tableName: "Label", comment: ""))
                    .font(.caption)
                Text(entry.todomodel?.toDoName ?? NSLocalizedString("NoTodo", tableName: "Label", comment: ""))
                Text(entry.todomodel?.todoDate ?? "")
            }
            .widgetURL(Self.deeplinkURL)
        case .systemMedium:
            VStack(alignment: .leading) {
                Text(NSLocalizedString("NextTodo", tableName: "Label", comment: ""))
                    .font(.caption)
                HStack {
                    VStack(alignment: .leading) {
                        Text(entry.todomodel?.toDoName ?? NSLocalizedString("NoTodo", tableName: "Label", comment: ""))
                        Text(entry.todomodel?.todoDate ?? "")
                    }
                    Text(entry.todomodel?.toDo ?? "")
                }
            }
            .padding()
            .widgetURL(Self.deeplinkURL)
        default:
            Text("")
        }
    }
}


// MARK: - TodoWidget

@main
struct TodoWidget: Widget {
    let kind: String = "TodoWidget"
    
    let widgetFamilys: [WidgetFamily] = {
        if #available(iOS 16.0, *) {
            return [.systemSmall, .systemMedium, .accessoryRectangular]
        } else {
            return [.systemSmall, .systemMedium]
        }
    }()
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            TodoWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Todo Widget")
        .description("This is an example widget.")
        .supportedFamilies(widgetFamilys)
    }
}


// MARK: - Previews

struct TodoWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TodoWidgetEntryView(entry: SimpleEntry(date: Date(), todomodel: testModel[0]))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            
            TodoWidgetEntryView(entry: SimpleEntry(date: Date(), todomodel: nil))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
        }
    }
}
