//
//  EventItem.swift
//  Cactus Connect
//
//  Created by Smit Devrukhkar on 4/24/25.
//

import SwiftUI

struct EventItem {
    let title: String
    let subtitle: String
    let date: Date
    let eventType: String
    let location: String
    let ID = UUID()
}

struct EventItemView : View {
    let event: EventItem
    private static let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        return formatter
    }()
    
    private static let monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        return formatter
    }()
    
    var body: some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerSize: CGSize(width: 5.0, height: 5.0))
                    .fill(Color.green)
                    .frame(width: 50, height: 50)
                
                VStack(alignment: .center, spacing: 2) {
                    Text(EventItemView.monthFormatter.string(from: event.date))
                        .bold()
                        .foregroundStyle(.white)
                    Text(EventItemView.dayFormatter.string(from: event.date))
                        .foregroundStyle(.white)
                }
                .padding(.all, 2)
            }
            VStack(alignment: .leading) {
                Text(event.title)
                    .font(.headline)
                Text(event.subtitle)
                    .font(.caption)
            }
        }
    }
}

#Preview {
    let event = EventItem(title: "Test Event", subtitle: "Subtitle", date: Date(), eventType: "Test Type", location: "Tempe")
    EventItemView(event: event)
}
