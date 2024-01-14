//
//  File.swift
//  
//
//  Created by Serhii Londar on 12.06.2022.
//

import Foundation
import SwiftUI
import FairApp

@available(macOS 12.0, iOS 15.0, *)
@MainActor public final class OpenSourceAppsInventory: ObservableObject, AppInventory {
    static var `default` = OpenSourceAppsInventory()
    
    typealias InventoryItem = JSONApplication
    
    
    /// The current catalog of apps
    @Published var catalog: [AppCatalogItem] = []
    var catalogUpdated: Date?
    
    func appInstalled(item: JSONApplication) -> String? {
        return nil
    }
    
    func appUpdated(item: JSONApplication) -> Bool {
        return true
    }
    
    func installedPath(for item: JSONApplication) throws -> URL? {
        return nil
    }
    
    func launch(item: JSONApplication) async throws {
        
    }
    
    func reveal(item: JSONApplication) async throws {
        
    }
    
    func delete(item: JSONApplication, verbose: Bool) async throws {
        
    }
    
    func badgeCount(for item: SidebarItem) -> Text? {
        return Text("No Badge")
    }
    
    /// The items arranged for the given category with the specifed sort order and search text
    func arrangedItems(sidebarSelection: SidebarSelection?, sortOrder: [KeyPathComparator<AppInfo>], searchText: String) -> [AppInfo] {
        return catalog.map({ AppInfo(catalogMetadata: $0) })
            .sorted(using: sortOrder + categorySortOrder(category: sidebarSelection?.item))
    }
    
    func categorySortOrder(category: SidebarItem?) -> [KeyPathComparator<AppInfo>] {
        switch category {
        case .none:
            return []
        case .top:
            return [KeyPathComparator(\AppInfo.catalogMetadata.downloadCount, order: .reverse)]
        case .recent:
            return [KeyPathComparator(\AppInfo.catalogMetadata.versionDate, order: .reverse)]
        case .updated:
            return [KeyPathComparator(\AppInfo.catalogMetadata.versionDate, order: .reverse)]
        case .installed:
            return [KeyPathComparator(\AppInfo.catalogMetadata.name, order: .forward)]
        case .category:
            return [KeyPathComparator(\AppInfo.catalogMetadata.starCount, order: .reverse), KeyPathComparator(\AppInfo.catalogMetadata.downloadCount, order: .reverse)]
        }
    }
}

struct JSONApplication: Codable, Equatable {
    var title: String
    var iconURL: String
    var repoURL: String
    var shortDescription: String
    var languages: [String]
    var screenshots: [String]
    var categories: [String]
    var officialSite: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case iconURL = "icon_url"
        case repoURL = "repo_url"
        case shortDescription = "short_description"
        case languages
        case screenshots
        case categories
        case officialSite = "official_site"
    }
    
    init(title: String, iconURL: String, repoURL: String, shortDescription: String, languages: [String], screenshots: [String], categories: [String], officialSite: String) {
        self.title = title
        self.iconURL = iconURL
        self.repoURL = repoURL
        self.shortDescription = shortDescription
        self.languages = languages
        self.screenshots = screenshots
        self.categories = categories
        self.officialSite = officialSite
    }
}

class Categories: Codable {
    let categories: [Category]
    
    init(categories: [Category]) {
        self.categories = categories
    }
    
    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        categories = try values.decodeIfPresent([Category].self, forKey: .categories) ?? []
    }
}

class Category: Codable {
    let title, id, description: String
    let parent: String?
    
    init(title: String, id: String, description: String, parent: String?) {
        self.title = title
        self.id = id
        self.description = description
        self.parent = parent
    }
}
