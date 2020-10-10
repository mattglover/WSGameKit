import XCTest
@testable import WSGameKit

final class WSGameTests: XCTestCase {
    
    var sut: WSGame!
        
    func testCanCreateNewGame() {
        let hostPlayer = WSPlayer.TestPlayer()
        sut = WSGame(hostPlayer: hostPlayer, boardSize: 11)
        
        XCTAssertNotNil(sut)
        XCTAssertNotNil(sut.hostPlayer)
    }
    
    func testPlayerCanJoinGame() {
        sut = WSGame.HostedGame()
        
        let joiningPlayer = WSPlayer.TestPlayer()
        sut.joinGame(player: joiningPlayer)
        
        XCTAssertNotNil(sut.hostPlayer)
        XCTAssertEqual(sut.guestPlayers.count, 1)
        XCTAssertEqual(sut.guestPlayers.first!.playerId, joiningPlayer.playerId)
    }
    
    func testManyPlayersCanJoinGame() {
        sut = WSGame.HostedGame()
        
        let joiningPlayer = WSPlayer.TestPlayer()
        sut.joinGame(player: joiningPlayer)
        XCTAssertEqual(sut.guestPlayers.count, 1)
        
        let joiningPlayer2 = WSPlayer.TestPlayer()
        sut.joinGame(player: joiningPlayer2)
        XCTAssertEqual(sut.guestPlayers.count, 2)
        
        let joiningPlayer3 = WSPlayer.TestPlayer()
        sut.joinGame(player: joiningPlayer3)
        XCTAssertEqual(sut.guestPlayers.count, 3)
    }
    
    func testAlreadyJoinedPlayerCannotJoinGame() {
        sut = WSGame.HostedGame()
        
        let joiningPlayer = WSPlayer.TestPlayer()
        sut.joinGame(player: joiningPlayer)
        sut.joinGame(player: joiningPlayer)
        XCTAssertEqual(sut.guestPlayers.count, 1)
    }
    
    func testGuestPlayerCanLeaveGame() {
        sut = WSGame.HostedGame()
        
        let joiningPlayer = WSPlayer.TestPlayer()
        sut.joinGame(player: joiningPlayer)
        XCTAssertEqual(sut.guestPlayers.count, 1)
        sut.leaveGame(player: joiningPlayer)
        XCTAssertEqual(sut.guestPlayers.count, 0)
        XCTAssertNil(joiningPlayer.currentGame)
        XCTAssertNotNil(sut.hostPlayer)
    }
    
    func testHostCanLeaveGame() {
        let hostPlayer = WSPlayer()
        sut = WSGame(hostPlayer: hostPlayer, boardSize: 5)
        
        sut.leaveGame(player: hostPlayer)
        XCTAssertNil(sut.hostPlayer)
    }
    
    func testFirstGuestPlayerIsPromotedToHostWhenHostLeaves() {
        let hostPlayer = WSPlayer()
        sut = WSGame(hostPlayer: hostPlayer, boardSize: 5)

        let guestPlayer = WSPlayer()
        sut.joinGame(player: guestPlayer)
        let guestPlayer2 = WSPlayer()
        sut.joinGame(player: guestPlayer2)

        sut.leaveGame(player: hostPlayer)

        XCTAssertEqual(sut.hostPlayer?.playerId, guestPlayer.playerId)
        XCTAssertEqual(sut.guestPlayers.count, 1)
    }
    
    func testGameWithHostOrAnyGuestsBecomeAnOrphenedGame() {
        let hostPlayer = WSPlayer()
        sut = WSGame(hostPlayer: hostPlayer, boardSize: 5)
        
        let guestPlayer = WSPlayer()
        sut.joinGame(player: guestPlayer)
        
        sut.leaveGame(player: hostPlayer) // note: guest player has now become host
        sut.leaveGame(player: guestPlayer)
        
        XCTAssertTrue(sut.isOrphenedGame)
    }
    
    func testGameWithOnlyHostCannotBeStarted() {
        sut = WSGame.HostedGame()
       
        XCTAssertFalse(sut.canStart)
    }
    
    func testGameCanBeStartedIsTrueIfAtleastTwoPlayersInGame() {
        sut = WSGame.HostedGame()
        sut.joinGame(player: WSPlayer())
        
        XCTAssertTrue(sut.canStart)
    }
    
    func testNewGameAddsHostPlayerToBoard() {
        let hostPlayer = WSPlayer.TestPlayer()
        let mockBoardSpy = MockBoard(boardSize: 11, delegate: nil)
        sut = WSGame(hostPlayer: hostPlayer, boardSize: 11, gameBoard: mockBoardSpy)
        
        XCTAssertEqual(mockBoardSpy?.addPlayerCalledCount, 1)
    }
    
    func testJoinGameAddsHostPlayerToBoard() {
        let hostPlayer = WSPlayer.TestPlayer()
        let mockBoardSpy = MockBoard(boardSize: 11, delegate: nil)
        sut = WSGame(hostPlayer: hostPlayer, boardSize: 11, gameBoard: mockBoardSpy)
        
        let joiningPlayer = WSPlayer.TestPlayer()
        sut.joinGame(player: joiningPlayer)
        
        XCTAssertEqual(mockBoardSpy?.addPlayerCalledCount, 2)
    }

//    static var allTests = [
//        ("testExample", testExample),
//    ]
}

extension WSGame {
    static func HostedGame() -> WSGame {
        let host = WSPlayer.TestPlayer()
        return WSGame(hostPlayer: host, boardSize: 5)
    }
}

extension WSPlayer {
    static func TestPlayer() -> WSPlayer {
        return WSPlayer()
    }
}

class MockBoard: WSBoard {
    var addPlayerCalledCount = 0
    override func add(_ player: WSPlayer) {
        addPlayerCalledCount += 1
    }
}
