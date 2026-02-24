//
//  ActivityDataSource.swift
//  HeatMap
//
//  Created by Damir Aushenov on 24/2/26.
//

import Foundation


final class UserDefaultsActivityDataSource {
    private let key = "activity_events_v1"

    func load() -> [ActivityEvent] {
        guard let data = UserDefaults.standard.data(forKey: key) else { return [] }
        return (try? JSONDecoder().decode([ActivityEvent].self, from: data)) ?? []
    }

    func save(_ events: [ActivityEvent]) {
        let data = try? JSONEncoder().encode(events)
        UserDefaults.standard.set(data, forKey: key)
    }
}

final class ActivityRepositoryImpl: ActivityRepository {
    private let ds: UserDefaultsActivityDataSource
    init(ds: UserDefaultsActivityDataSource) { self.ds = ds }

    func loadEvents() -> [ActivityEvent] { ds.load() }
    func saveEvents(_ events: [ActivityEvent]) { ds.save(events) }
}
