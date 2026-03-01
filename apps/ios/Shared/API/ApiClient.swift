import Foundation

enum ApiError: Error, LocalizedError {
    case invalidURL
    case noData
    case httpStatus(Int, Data?)
    case decoding(Error)
    case unauthorized

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Неверный URL"
        case .noData:
            return "Нет ответа от сервера"
        case .httpStatus(let code, let data):
            if let data = data,
               let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let message = json["message"] as? String ?? json["error"] as? String {
                return message
            }
            return "Ошибка сервера (\(code))"
        case .decoding(let error):
            return "Ошибка данных: \(error.localizedDescription)"
        case .unauthorized:
            return "Требуется авторизация"
        }
    }
}

final class ApiClient {
    private let baseURL: URL
    private let tokenStorage: ITokenStorage
    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    var onUnauthorized: (() async throws -> Void)?

    init(baseURL: URL = ApiConfig.baseURL, tokenStorage: ITokenStorage) {
        self.baseURL = baseURL
        self.tokenStorage = tokenStorage
        self.session = URLSession.shared
        self.decoder = JSONDecoder()
        self.decoder.dateDecodingStrategy = .custom { decoder in
            let c = try decoder.singleValueContainer()
            let s = try c.decode(String.self)
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            if let d = formatter.date(from: s) { return d }
            formatter.formatOptions = [.withInternetDateTime]
            guard let d = formatter.date(from: s) else {
                throw DecodingError.dataCorruptedError(in: c, debugDescription: "Invalid date: \(s)")
            }
            return d
        }
        self.encoder = JSONEncoder()
    }

    func request<T: Decodable>(
        path: String,
        method: String = "GET",
        query: [String: String] = [:],
        body: (any Encodable)? = nil,
        requiresAuth: Bool = true
    ) async throws -> T {
        var url = URL(string: path, relativeTo: baseURL)!.absoluteURL
        if !query.isEmpty {
            var comp = URLComponents(url: url, resolvingAgainstBaseURL: false)!
            comp.queryItems = query.map { kv in URLQueryItem(name: kv.key, value: kv.value) }
            url = comp.url!
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        if requiresAuth, let token = tokenStorage.accessToken {
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        if let b = body {
            urlRequest.httpBody = try encoder.encode(AnyEncodable(value: b))
        }
        let (data, response) = try await session.data(for: urlRequest)
        guard let http = response as? HTTPURLResponse else { throw ApiError.noData }
        if http.statusCode == 401 && requiresAuth, let refresh = onUnauthorized {
            try await refresh()
            return try await self.request(path: path, method: method, query: query, body: body, requiresAuth: requiresAuth)
        }
        guard (200...299).contains(http.statusCode) else {
            throw ApiError.httpStatus(http.statusCode, data)
        }
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw ApiError.decoding(error)
        }
    }

    func requestVoid(
        path: String,
        method: String = "GET",
        query: [String: String] = [:],
        body: (any Encodable)? = nil,
        requiresAuth: Bool = true
    ) async throws {
        var url = URL(string: path, relativeTo: baseURL)!.absoluteURL
        if !query.isEmpty {
            var comp = URLComponents(url: url, resolvingAgainstBaseURL: false)!
            comp.queryItems = query.map { kv in URLQueryItem(name: kv.key, value: kv.value) }
            url = comp.url!
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        if requiresAuth, let token = tokenStorage.accessToken {
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        if let b = body {
            urlRequest.httpBody = try encoder.encode(AnyEncodable(value: b))
        }
        let (data, response) = try await session.data(for: urlRequest)
        guard let http = response as? HTTPURLResponse else { throw ApiError.noData }
        if http.statusCode == 401 && requiresAuth, let refresh = onUnauthorized {
            try await refresh()
            try await self.requestVoid(path: path, method: method, query: query, body: body, requiresAuth: requiresAuth)
            return
        }
        guard (200...299).contains(http.statusCode) else {
            throw ApiError.httpStatus(http.statusCode, data)
        }
    }
}

private struct AnyEncodable: Encodable {
    let value: any Encodable
    func encode(to encoder: Encoder) throws {
        try value.encode(to: encoder)
    }
}
