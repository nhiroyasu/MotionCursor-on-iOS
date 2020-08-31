import Foundation


struct MouseAction: Codable {
    let type: MouseActionType
    let action: MouseActionParamType
    let param: MouseActionParam? = nil
}

enum MouseActionType: Int, Codable {
    case LEFT_CLICK = 0
    case RIGHT_CLICK = 1
}

enum MouseActionParamType: String, Codable {
    case DOWN = "down"
    case UP = "up"
    case MOVE = "move"
}

struct MouseActionParam: Codable {
    let x: Int
    let y: Int
}

func encodeMouseAction(mouseAction: MouseAction) throws -> Data {
    let encoder = JSONEncoder()
    do {
        let encodedData = try encoder.encode(mouseAction)
        let encodedStrOpt = String(data: encodedData, encoding: .utf8)
        guard let encodedStr = encodedStrOpt else {
            throw NSError.init(domain: "encoding error on [MouseAction -> String]", code: -1, userInfo: nil)
        }
        
        let dataOpt = encodedStr.data(using: .utf8)
        guard let data = dataOpt else {
            throw NSError.init(domain: "string type error", code: -1, userInfo: nil)
        }
        return data
    } catch {
        print("encode error")
        throw NSError.init(domain: "encoding error on [MouseAction -> Data]", code: -1, userInfo: nil)
    }
}

func decodeMouseAction(data: Data) throws -> MouseAction {
    let decoder = JSONDecoder()
    do {
        let decodedObj = try decoder.decode(MouseAction.self, from: data)
        return decodedObj
    } catch {
        print("decode error")
        throw NSError.init(domain: "decoding error", code: -1, userInfo: nil)
    }
}
