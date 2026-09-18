import Vapor

struct GoldAPIController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        routes.get("market", "price", use: getGoldPrice)
    }

    func getGoldPrice(req: Request) async throws -> [String: Double] {
        // guard let apiKey = Environment.get("GOLD_API_KEY") else {
        //     throw Abort(.internalServerError, reason: "GOLD_API_KEY is missing")
        // }

        // let response = try await req.client.get(
        //     "https://www.goldapi.io/api/price/XAU/IDR"
        // ) { request in
        //     request.headers.add(name: "x-access-token", value: apiKey)
        // }.content.decode(GoldAPIResponse.self)

        // let silverResponse = try await req.client.get(
        //     "https://www.goldapi.io/api/price/XAG/IDR"
        // ) { request in
        //     request.headers.add(name: "x-access-token", value: apiKey)
        // }.content.decode(GoldAPIResponse.self)

        // return [
        //     "goldPricePerGram": response.pricePerUnit.gram,
        //     "goldPriceChange": response.change,
        //     "goldPriceChangePercent": response.changePercent,
        //     "silverPricePerGram": silverResponse.pricePerUnit.gram,
        //     "silverPriceChange": silverResponse.change,
        //     "silverPriceChangePercent": silverResponse.changePercent
        // ]

        return [
            "goldPricePerGram": 2435213.234,
            "goldPriceChange": 354678.2736,
            "goldPriceChangePercent": 0.45233,
            "silverPricePerGram": 36199.739,
            "silverPriceChange": -4567.89,
            "silverPriceChangePercent": -0.2134
        ]
    }
}

struct GoldAPIResponse: Content {
    let pricePerUnit: PricePerUnit
    let change : Double
    let changePercent : Double

    enum CodingKeys: String, CodingKey {
        case pricePerUnit = "price_per_unit"
        case change = "change"
        case changePercent = "change_percent"
    }
}

struct PricePerUnit: Content {
    let gram: Double
}