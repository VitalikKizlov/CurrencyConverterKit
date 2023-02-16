//
//  File.swift
//  
//
//  Created by Vitalii Kizlov on 15.02.2023.
//

import Foundation
import Combine

public final class SearchViewModel {

    // MARK: - Dependencies

    @Injected(\.countriesStoreService) private var countriesStoreService: CountriesStoreProtocol

    // MARK: - Input

    @Published private(set) var searchText = ""
    let viewInputEventSubject = PassthroughSubject<ViewInputEvent, Never>()
    private lazy var viewInputEventPublisher = viewInputEventSubject.eraseToAnyPublisher()

    // MARK: - Properties

    @Published private(set) var state: LoadingState = .idle
    private var context: Context
    private var subscriptions: Set<AnyCancellable> = []

    // MARK: - Lifecycle

    public init(_ context: Context) {
        self.context = context
        setupBindings()
        configureInitialState()
    }

    // MARK: - Private

    private func configureInitialState() {
        switch context {
        case .sender:
            let viewModels = countriesStoreService.countriesForSender().map { country in
                return SearchItemViewModel(title: country.name, subtitle: country.currency.title, image: country.image)
            }
            state = .loaded(viewModels)
        case .receiver:
            let viewModels = countriesStoreService.countriesForReceiver().map { country in
                return SearchItemViewModel(title: country.name, subtitle: country.currency.title, image: country.image)
            }
            state = .loaded(viewModels)
        }
    }

    private func setupBindings() {
        $searchText
            .debounce(for: 0.2, scheduler: DispatchQueue.main)
            .removeDuplicates()
            .filter { value in
                return value.count > 1
            }
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.search()
            }
            .store(in: &subscriptions)

        viewInputEventPublisher
            .sink { [weak self] viewInputEvent in
                guard let self = self else { return }
                self.proceedViewInputEvent(viewInputEvent)
            }
            .store(in: &subscriptions)
    }

    private func proceedViewInputEvent(_ event: ViewInputEvent) {
        switch event {
        case .textDidChange(let text):
            searchText = text

            if searchText.isEmpty {
                self.state = .loaded([])
            }
        case .cancelButtonClicked:
            state = .loaded([])
        }
    }

    private func search() {
        state = .loading
    }
}

extension SearchViewModel {
    enum LoadingState: Equatable {
        case idle
        case loading
        case loaded([SearchItemViewModel])
        case failed(Error)

        static func == (lhs: SearchViewModel.LoadingState, rhs: SearchViewModel.LoadingState) -> Bool {
            switch (lhs, rhs) {
            case (.idle, .idle):
                return true
            case (.loading, .loading):
                return true
            case (.loaded, .loaded):
                return true
            case (.failed, .failed):
                return true
            default:
                return false
            }
        }
    }
}

extension SearchViewModel {
    enum ViewInputEvent {
        case textDidChange(String)
        case cancelButtonClicked
    }
}

extension SearchViewModel {
    public enum Context {
        case sender
        case receiver
    }
}
