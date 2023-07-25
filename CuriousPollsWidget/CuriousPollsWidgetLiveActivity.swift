//
//  CuriousPollsWidgetLiveActivity.swift
//  CuriousPollsWidget
//
//  Created by Rosa Jeon on 2023-07-20.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct CuriousPollsWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: CuriousPollsWidgetAttributes.self) { context in
            VStack {
                HStack {
                    Text(context.state.name)
                    Spacer()
                    Image(systemName: "chart.bar.xaxis")
                    Text(String(context.state.totalCount))
                    
                    if let updatedAt = context.state.updatedAt {
                        Image(systemName: "clock.fill")
                        Text(updatedAt, style: .time)
                    }
                }
                .frame(maxWidth: .infinity)
                .lineLimit(1)
                .padding(.bottom, 4)
                
                PollChartView(options: context.state.options)
            }
            .padding()
            .activitySystemActionForegroundColor(Color.black)
            
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Text(context.state.name).lineLimit(1)
                        .padding(.leading, 1.5)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    HStack(alignment: .top) {
                        Image(systemName: "chart.bar.xaxis")
                        Text(String(context.state.totalCount))
                    }
                    .lineLimit(1)
                    .padding(.trailing, 1.5)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    PollChartView(options: context.state.options)
                        .padding([.leading, .trailing], 4)
                }
            } compactLeading: {
                Text(context.state.lastUpdatedOption?.name ?? "-")
            } compactTrailing: {
                HStack {
                    Image(systemName: "chart.bar.xaxis")
                    Text(String(context.state.lastUpdatedOption?.count ?? 0))
                }.lineLimit(1)
            } minimal: {
                HStack {
                    Image(systemName: "chart.bar.xaxis")
                }.lineLimit(1)
            }
        }
    }
}

extension CuriousPollsWidgetAttributes {
    fileprivate static var preview: CuriousPollsWidgetAttributes {
        CuriousPollsWidgetAttributes(pollId: "console")
    }
}

extension CuriousPollsWidgetAttributes.ContentState {
    
    fileprivate static var first: CuriousPollsWidgetAttributes.ContentState {
        CuriousPollsWidgetAttributes.ContentState(updatedAt: Date(), name: "Favorite Console", totalCount: 100, options: [Option(count: 20, name: "XBOX S|X"), Option(id: "ps5", count: 80, name: "PS5")], lastUpdatedOptionId: "ps5")
    }
    
    fileprivate static var second: CuriousPollsWidgetAttributes.ContentState {
        CuriousPollsWidgetAttributes.ContentState(updatedAt: Date().addingTimeInterval(3600), name: "Best Artist", totalCount: 15, options: [Option(count: 3, name: "Van Gogh"), Option(id: "37E36047-01CD-8981-7A75A25ED637", count: 4, name: "Salvadore Dali"), Option(id: "C0EBA534-B2F2-4DB5-92D3-391D3CB08069", count: 6, name: "Picasso"), Option(id: "40F2CB0B-0DCF-4311-9909-85D54E2BDFAF", count: 2, name: "Claude Monet")], lastUpdatedOptionId: "37E36047-01CD-8981-7A75A25ED637")
    }
    
}


#Preview("Notification", as: .content, using: CuriousPollsWidgetAttributes.preview) {
    CuriousPollsWidgetLiveActivity()
} contentStates: {
    CuriousPollsWidgetAttributes.ContentState.first
    CuriousPollsWidgetAttributes.ContentState.second
}

