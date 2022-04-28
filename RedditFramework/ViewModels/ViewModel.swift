//
//  ViewControllerViewModel.swift
//  RedditChallenge
//
//  Created by Christian Quicano on 3/31/22.
//

import Foundation
import Combine

public protocol ViewModelProtocol {
    var totalRows: Int { get }
    var publisherStories: Published<[Story]>.Publisher { get }
    var publisherCache: Published<[Int: Data]>.Publisher { get }
    func getStories()
    func getTitle(by row: Int) -> String?
    func loadMoreStories()
    func forceUpdate()
    func getImageData(by row: Int) -> Data?
}

public class ViewModel: ViewModelProtocol {
    
    public var totalRows: Int { stories.count }
    public var publisherStories: Published<[Story]>.Publisher { $stories }
    public var publisherCache: Published<[Int: Data]>.Publisher { $cache }
    
    private let repository: RepositoryProtocol
    private var subscribers = Set<AnyCancellable>()
    @Published private(set) var stories = [Story]()
    @Published private(set) var error: NetworkError?
    private var afterKey = ""
    private var isLoading = false
    @Published private var cache: [Int: Data] = [:]
    
    public init(repository: RepositoryProtocol) {
        self.repository = repository
    }
    
    public func getStories() {
        // 1. review the current data on the disk
        let stories = repository.getStories()
        if stories.isEmpty {
            getStories(from: createURL(), forceUpdate: true)
        } else {
            self.stories = stories
        }
    }
    
    public func loadMoreStories() {
        let newURL = createURL(afterKey)
        getStories(from: newURL)
    }
    
    public func forceUpdate() {
        stories = []
        cache = [:]
        repository.removeAllStories()
        getStories()
    }
    
    private func createURL(_ afterKey: String? = nil) -> String {
        guard let afterKey = afterKey else {
            return NetworkURLs.urlBase
        }
        return "\(NetworkURLs.urlBase)?after=\(afterKey)"
    }
    
    private func getStories(from url: String, forceUpdate: Bool = false) {
        guard !isLoading else { return }
        isLoading = true

        // 2. get data from API
        repository.getStories(from: url) { [weak self] result in
            switch result {
            case .success(let tuple):
                self?.afterKey = tuple.1
                if forceUpdate {
                    self?.stories = tuple.0
                    self?.repository.removeAllStories()
                } else {
                    self?.stories.append(contentsOf: tuple.0)
                }
                // 3. save on disk new stories
                self?.repository.saveStories(tuple.0)
                self?.isLoading = false
            case .failure(let error):
                self?.error = error
                print(error.localizedDescription)
            }
        }
    }
    
    public func getImageData(by row: Int) -> Data? {
        return cache[row]
    }
    
    public func getTitle(by row: Int) -> String? {
        guard row < stories.count else { return nil }
        let story = stories[row]
        return story.title
    }
    
}
