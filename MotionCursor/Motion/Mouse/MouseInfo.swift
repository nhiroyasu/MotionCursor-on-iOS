import Foundation

struct MouseInfo: Codable {
    let type: String
    let acc: AccParam?
    let atti: AttiParam?
}

struct AccParam: Codable {
    let x: Double
    let y: Double
    let z: Double
}

struct AttiParam: Codable {
    let pitch: Double
    let yaw: Double
    let roll: Double
}

enum MOUSE_TYPE: String {
    case NORMAL = "normal"
    case ThreeD = "3d"
    case ThreeD_GAME = "3d_game"
}

func encodeMouseInfo(mouseInfo: MouseInfo) throws -> Data {
    let encoder = JSONEncoder()
    do {
        let encodedData = try encoder.encode(mouseInfo)
        let encodedStrOpt = String(data: encodedData, encoding: .utf8)
        guard let encodedStr = encodedStrOpt else {
            throw NSError.init(domain: "encoding error on [MouseInfo -> String]", code: -1, userInfo: nil)
        }
        
        let dataOpt = encodedStr.data(using: .utf8)
        guard let data = dataOpt else {
            throw NSError.init(domain: "string type error", code: -1, userInfo: nil)
        }
        return data
    } catch {
        print("encode error")
        throw NSError.init(domain: "encoding error on [MouseInfo -> Data]", code: -1, userInfo: nil)
    }
}

func decodeMouseInfo(data: Data) throws -> MouseInfo {
    let decoder = JSONDecoder()
    do {
        let decodedObj = try decoder.decode(MouseInfo.self, from: data)
        return decodedObj
    } catch {
        print("decode error")
        throw NSError.init(domain: "decoding error", code: -1, userInfo: nil)
    }
}
