//
//  EventDetails.swift
//  Cactus Connect
//
//  Created by Smit Devrukhkar on 4/29/25.
//

import SwiftUI
import UIKit

struct EventDetails: View {
    let event: EventItem
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .short
        return formatter
    }()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header image or colored banner
                Rectangle()
                    .fill(Color.green)
                    .frame(height: 200)
                    .overlay(
                        Text(event.title)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                    )
                
                VStack(alignment: .leading, spacing: 16) {
                    // Date and location
                    Group {
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundColor(.green)
                                .frame(width: 24)
                            
                            Text(Self.dateFormatter.string(from: event.date))
                                .font(.headline)
                        }
                        
                        HStack {
                            Image(systemName: "mappin.and.ellipse")
                                .foregroundColor(.green)
                                .frame(width: 24)
                            
                            Text(event.location)
                                .font(.headline)
                        }
                        
                        HStack {
                            Image(systemName: "tag")
                                .foregroundColor(.green)
                                .frame(width: 24)
                            
                            Text(event.eventType)
                                .font(.headline)
                        }
                    }
                    .padding(.horizontal)
                    
                    Divider()
                    
                    // Description
                    VStack(alignment: .leading, spacing: 12) {
                        Text("About This Event")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text(event.subtitle)
                            .font(.body)
                        
                        // Placeholder for more detailed description
                        Text("This event will feature experts in the field and provide hands-on experience for all attendees. Don't miss this opportunity to learn more about desert plants and connect with fellow enthusiasts!")
                            .font(.body)
                            .padding(.top, 8)
                    }
                    .padding(.horizontal)
                    
                    Spacer(minLength: 30)
                    
                    // Register button
                    Button(action: {
                        if let url = event.url, UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        Text(event.url != nil ? "Register for Event" : "Registration Unavailable")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(event.url != nil ? Color.green : Color.gray)
                            .cornerRadius(10)
                    }
                    .disabled(event.url == nil)
                    .padding(.horizontal)
                }
                .padding(.bottom, 30)
            }
        }
        .navigationTitle("Event Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        EventDetails(
            event: EventItem(
                title: "Desert Botanical Garden Tour",
                subtitle: "Explore the beauty of desert plants",
                date: Date(),
                eventType: "Tour",
                location: "Phoenix",
                url: URL(string: "https://google.com")
            )
        )
    }
}
