//
//  ContentView.swift
//  Cactus Connect
//
//  Created by Smit Devrukhkar on 4/18/25.
//

import SwiftUI

// No explicit import needed as EventItem.swift is in the same module

struct ContentView: View {
    @State private var searchText = ""

    let eventItems = [
        EventItem(
            title: "Desert Botanical Garden Tour",
            subtitle: "Explore the beauty of desert plants",
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 10))!,
            eventType: "Tour",
            location: "Phoenix"
        ),
        EventItem(
            title: "Cactus Cultivation Workshop",
            subtitle: "Learn how to grow and care for cacti",
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 15))!,
            eventType: "Workshop",
            location: "Scottsdale"
        ),
        EventItem(
            title: "Succulent Swap Meet",
            subtitle: "Trade plants with fellow enthusiasts",
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 22))!,
            eventType: "Community",
            location: "Tempe"
        ),
        EventItem(
            title: "Desert Conservation Talk",
            subtitle: "Learn about protecting native species",
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 6, day: 5))!,
            eventType: "Lecture",
            location: "Mesa"
        ),
        EventItem(
            title: "Cactus Photography Class",
            subtitle: "Capture the beauty of desert plants",
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 6, day: 12))!,
            eventType: "Class",
            location: "Phoenix"
        )
    ]

    var filteredEvents: [EventItem] {
        if searchText.isEmpty {
            return eventItems
        } else {
            return eventItems.filter { event in
                event.title.localizedCaseInsensitiveContains(searchText) ||
                event.subtitle.localizedCaseInsensitiveContains(searchText) ||
                event.eventType.localizedCaseInsensitiveContains(searchText) ||
                event.location.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        NavigationStack {
            List(filteredEvents, id: \.ID) { event in
                EventItemView(event: event)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear) 
            }
            .listStyle(.plain) // Use plain list style
            .navigationTitle("Cactus Events")
            // Apply the searchable modifier
            .searchable(text: $searchText, prompt: "Search events")
        }
    }
}

#Preview {
    ContentView()
}
