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
    let url: URL?
    let ID = UUID()
}

struct EventItemView: View {
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
        HStack(alignment: .center, spacing: 12) {
            
            // Date box
            VStack(spacing: 4) {
                Text(EventItemView.monthFormatter.string(from: event.date))
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.white)
                Text(EventItemView.dayFormatter.string(from: event.date))
                    .font(.title3)
                    .bold()
                    .foregroundColor(.white)
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.green)
                    .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0)
            )
            
            // Event details
            VStack(alignment: .leading, spacing: 4) {
                Text(event.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                HStack{
                    Image(systemName: "mappin.and.ellipse")
                        .foregroundColor(.gray)
                    Text(event.location)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Text(event.subtitle)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
            
           
        }
        // Apply the searchable modifier
        .padding(.all, 2)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(UIColor.systemBackground))
 
        )
    }
}

#Preview {
    let event = EventItem(
        title: "Test Event",
        subtitle: "Subtitle",
        date: Date(),
        eventType: "Test Type",
        location: "Tempe",
        url: URL(string: "https://www.google.com")
    )
    EventItemView(event: event)
}
