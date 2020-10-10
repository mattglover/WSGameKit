import XCTest
@testable import WSGameKit

final class WSBoardTests: XCTestCase {
    
    var sut: WSBoard!
    
    func testBoardIsCreatedWithAllCellAreVacant() {
        sut = WSBoard.TestWSBoard()
        
        XCTAssertEqual("0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0", sut.boardNotation())
    }
    
    func testCanAddPlayer() {
        sut = WSBoard.TestWSBoard()
        let player = WSPlayer.TestPlayer()
        
        sut.add(player)
        XCTAssertEqual(sut.players.count, 1)
    }
    
    func testCannotAddExistingPlayer() {
        sut = WSBoard.TestWSBoard()
        let player = WSPlayer.TestPlayer()
        
        sut.add(player)
        sut.add(player)
        XCTAssertEqual(sut.players.count, 1)
    }
    
    func testCanAddMoreThanOnePlayer() {
        sut = WSBoard.TestWSBoard()
        let player = WSPlayer.TestPlayer()
        let player2 = WSPlayer.TestPlayer()
        sut.add(player)
        sut.add(player2)
        
        XCTAssertEqual(sut.players.count, 2)
    }
    
    func testCannotAddAnyMoreThan5Players() {
        sut = WSBoard.TestWSBoard()
        let player = WSPlayer.TestPlayer()
        let player2 = WSPlayer.TestPlayer()
        let player3 = WSPlayer.TestPlayer()
        let player4 = WSPlayer.TestPlayer()
        let player5 = WSPlayer.TestPlayer()
        let player6 = WSPlayer.TestPlayer()
        sut.add(player)
        sut.add(player2)
        sut.add(player3)
        sut.add(player4)
        sut.add(player5)
        sut.add(player6)
        
        XCTAssertEqual(sut.players.count, 5)
    }
    
    func testUnstartedGameWithMoreThan1PlayersCanBeStarted() {
        sut = WSBoard.TestWSBoard()
        let player = WSPlayer.TestPlayer()
        let player2 = WSPlayer.TestPlayer()
        sut.add(player)
        sut.add(player2)
        
        sut.start()
        
        XCTAssertTrue(sut.hasStarted)
    }
    
    func testFirstPlayerAddedIsAddedToCenter() {

        sut = WSBoard(boardSize: 5)

        let testPlayer = WSPlayer.TestPlayer()
        sut.add(testPlayer)

        XCTAssertEqual("0,0,0,0,0,0,0,0,0,0,0,0,\(testPlayer.playerId),0,0,0,0,0,0,0,0,0,0,0,0", sut.boardNotation())
    }
    
    func testSecondPlayerAddedIsAddedToTopLeft() {

        sut = WSBoard(boardSize: 5)

        let testPlayer = WSPlayer.TestPlayer()
        sut.add(testPlayer)
        let testPlayer2 = WSPlayer.TestPlayer()
        sut.add(testPlayer2)

        XCTAssertEqual("\(testPlayer2.playerId),0,0,0,0,0,0,0,0,0,0,0,\(testPlayer.playerId),0,0,0,0,0,0,0,0,0,0,0,0", sut.boardNotation())
    }
    
    func testThirdPlayerAddedIsAddedToBottomRight() {

        sut = WSBoard(boardSize: 5)

        let testPlayer = WSPlayer.TestPlayer()
        sut.add(testPlayer)
        let testPlayer2 = WSPlayer.TestPlayer()
        sut.add(testPlayer2)
        let testPlayer3 = WSPlayer.TestPlayer()
        sut.add(testPlayer3)

        XCTAssertEqual("\(testPlayer2.playerId),0,0,0,0,0,0,0,0,0,0,0,\(testPlayer.playerId),0,0,0,0,0,0,0,0,0,0,0,\(testPlayer3.playerId)", sut.boardNotation())
    }
    
    func testFourthPlayerAddedIsAddedToTopRight() {

        sut = WSBoard(boardSize: 5)

        let testPlayer = WSPlayer.TestPlayer()
        sut.add(testPlayer)
        let testPlayer2 = WSPlayer.TestPlayer()
        sut.add(testPlayer2)
        let testPlayer3 = WSPlayer.TestPlayer()
        sut.add(testPlayer3)
        let testPlayer4 = WSPlayer.TestPlayer()
        sut.add(testPlayer4)

        XCTAssertEqual("\(testPlayer2.playerId),0,0,0,\(testPlayer4.playerId),0,0,0,0,0,0,0,\(testPlayer.playerId),0,0,0,0,0,0,0,0,0,0,0,\(testPlayer3.playerId)", sut.boardNotation())
    }
    
    func testFifthPlayerAddedIsAddedToBottomLeft() {

        sut = WSBoard.WSBoardWith5Players(boardSize: 5)
        
        let playerIds = sut.playerIds
        XCTAssertEqual("\(playerIds[1]),0,0,0,\(playerIds[3]),0,0,0,0,0,0,0,\(playerIds[0]),0,0,0,0,0,0,0,\(playerIds[4]),0,0,0,\(playerIds[2])", sut.boardNotation())
    }
    
    func testPlayerWith8VacantCellSurroundingCanMoveInAllDirections() {
        sut = WSBoard.WSBoardWith2Players(boardSize: 5) // only 2 players
        
        let playerOneId = sut.players[sut.playerIds.first!]!.playerId
        let playerIds = sut.playerIds
        
        sut.move(playerId: playerOneId, direction: .up)
        XCTAssertEqual("\(playerIds[1]),0,0,0,0,0,0,\(playerOneId),0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0", sut.boardNotation())
        
        sut.move(playerId: playerOneId, direction: .down)
        XCTAssertEqual("\(playerIds[1]),0,0,0,0,0,0,0,0,0,0,0,\(playerOneId),0,0,0,0,0,0,0,0,0,0,0,0", sut.boardNotation())
        
        sut.move(playerId: playerOneId, direction: .left)
        XCTAssertEqual("\(playerIds[1]),0,0,0,0,0,0,0,0,0,0,\(playerOneId),0,0,0,0,0,0,0,0,0,0,0,0,0", sut.boardNotation())
        sut.move(playerId: playerOneId, direction: .right)
        XCTAssertEqual("\(playerIds[1]),0,0,0,0,0,0,0,0,0,0,0,\(playerOneId),0,0,0,0,0,0,0,0,0,0,0,0", sut.boardNotation())
        
        sut.move(playerId: playerOneId, direction: .upRight)
        XCTAssertEqual("\(playerIds[1]),0,0,0,0,0,0,0,\(playerOneId),0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0", sut.boardNotation())
        sut.move(playerId: playerOneId, direction: .downLeft)
        XCTAssertEqual("\(playerIds[1]),0,0,0,0,0,0,0,0,0,0,0,\(playerOneId),0,0,0,0,0,0,0,0,0,0,0,0", sut.boardNotation())
        
        sut.move(playerId: playerOneId, direction: .downRight)
        XCTAssertEqual("\(playerIds[1]),0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,\(playerOneId),0,0,0,0,0,0", sut.boardNotation())
        sut.move(playerId: playerOneId, direction: .upLeft)
        XCTAssertEqual("\(playerIds[1]),0,0,0,0,0,0,0,0,0,0,0,\(playerOneId),0,0,0,0,0,0,0,0,0,0,0,0", sut.boardNotation())
    }
    
    func testPlayerInTopLeftCanOnlyGo_Right_DownRight_Down() {
        sut = WSBoard.WSBoardWith2Players(boardSize: 5) // 2 players
        
        let playerOneId = sut.players[sut.playerIds.first!]!.playerId
        let playerTwoId = sut.players[sut.playerIds[1]]!.playerId
        
        sut.move(playerId: playerTwoId, direction: .down)
        XCTAssertEqual("0,0,0,0,0,\(playerTwoId),0,0,0,0,0,0,\(playerOneId),0,0,0,0,0,0,0,0,0,0,0,0", sut.boardNotation())
        sut.move(playerId: playerTwoId, direction: .up) // RESET
        
        
        sut.move(playerId: playerTwoId, direction: .right)
        XCTAssertEqual("0,\(playerTwoId),0,0,0,0,0,0,0,0,0,0,\(playerOneId),0,0,0,0,0,0,0,0,0,0,0,0", sut.boardNotation())
        sut.move(playerId: playerTwoId, direction: .left) // RESET
        
        
        sut.move(playerId: playerTwoId, direction: .downRight)
        XCTAssertEqual("0,0,0,0,0,0,\(playerTwoId),0,0,0,0,0,\(playerOneId),0,0,0,0,0,0,0,0,0,0,0,0", sut.boardNotation())
        sut.move(playerId: playerTwoId, direction: .upLeft) // RESET
        
        
        // These Should Not Move
        sut.move(playerId: playerTwoId, direction: .up)
        XCTAssertEqual("\(playerTwoId),0,0,0,0,0,0,0,0,0,0,0,\(playerOneId),0,0,0,0,0,0,0,0,0,0,0,0", sut.boardNotation())
        sut.move(playerId: playerTwoId, direction: .left)
        XCTAssertEqual("\(playerTwoId),0,0,0,0,0,0,0,0,0,0,0,\(playerOneId),0,0,0,0,0,0,0,0,0,0,0,0", sut.boardNotation())
        sut.move(playerId: playerTwoId, direction: .upRight)
        XCTAssertEqual("\(playerTwoId),0,0,0,0,0,0,0,0,0,0,0,\(playerOneId),0,0,0,0,0,0,0,0,0,0,0,0", sut.boardNotation())
        sut.move(playerId: playerTwoId, direction: .downLeft)
        XCTAssertEqual("\(playerTwoId),0,0,0,0,0,0,0,0,0,0,0,\(playerOneId),0,0,0,0,0,0,0,0,0,0,0,0", sut.boardNotation())
        sut.move(playerId: playerTwoId, direction: .upLeft)
        XCTAssertEqual("\(playerTwoId),0,0,0,0,0,0,0,0,0,0,0,\(playerOneId),0,0,0,0,0,0,0,0,0,0,0,0", sut.boardNotation())
    }
    
    func testPlayerInTopRightCanOnlyGo_Left_DownLeft_Down() {
        sut = WSBoard.WSBoardWith4Players(boardSize: 5) // 4 players
        
        let playerOneId = sut.players[sut.playerIds.first!]!.playerId
        let playerTwoId = sut.players[sut.playerIds[1]]!.playerId
        let playerThreeId = sut.players[sut.playerIds[2]]!.playerId
        let playerFourId = sut.players[sut.playerIds[3]]!.playerId
        
        sut.move(playerId: playerFourId, direction: .down)
        XCTAssertEqual("\(playerTwoId),0,0,0,0,0,0,0,0,\(playerFourId),0,0,\(playerOneId),0,0,0,0,0,0,0,0,0,0,0,\(playerThreeId)", sut.boardNotation())
        sut.move(playerId: playerFourId, direction: .up) // RESET
        
        
        sut.move(playerId: playerFourId, direction: .left)
        XCTAssertEqual("\(playerTwoId),0,0,\(playerFourId),0,0,0,0,0,0,0,0,\(playerOneId),0,0,0,0,0,0,0,0,0,0,0,\(playerThreeId)", sut.boardNotation())
        sut.move(playerId: playerFourId, direction: .right) // RESET
        
        
        sut.move(playerId: playerFourId, direction: .downLeft)
        XCTAssertEqual("\(playerTwoId),0,0,0,0,0,0,0,\(playerFourId),0,0,0,\(playerOneId),0,0,0,0,0,0,0,0,0,0,0,\(playerThreeId)", sut.boardNotation())
        sut.move(playerId: playerFourId, direction: .upRight) // RESET
        
        
        // These Should Not Move
        sut.move(playerId: playerFourId, direction: .up)
        XCTAssertEqual("\(playerTwoId),0,0,0,\(playerFourId),0,0,0,0,0,0,0,\(playerOneId),0,0,0,0,0,0,0,0,0,0,0,\(playerThreeId)", sut.boardNotation())
        sut.move(playerId: playerFourId, direction: .right)
        XCTAssertEqual("\(playerTwoId),0,0,0,\(playerFourId),0,0,0,0,0,0,0,\(playerOneId),0,0,0,0,0,0,0,0,0,0,0,\(playerThreeId)", sut.boardNotation())
        sut.move(playerId: playerFourId, direction: .upRight)
        XCTAssertEqual("\(playerTwoId),0,0,0,\(playerFourId),0,0,0,0,0,0,0,\(playerOneId),0,0,0,0,0,0,0,0,0,0,0,\(playerThreeId)", sut.boardNotation())
        sut.move(playerId: playerFourId, direction: .downRight)
        XCTAssertEqual("\(playerTwoId),0,0,0,\(playerFourId),0,0,0,0,0,0,0,\(playerOneId),0,0,0,0,0,0,0,0,0,0,0,\(playerThreeId)", sut.boardNotation())
        sut.move(playerId: playerFourId, direction: .upLeft)
        XCTAssertEqual("\(playerTwoId),0,0,0,\(playerFourId),0,0,0,0,0,0,0,\(playerOneId),0,0,0,0,0,0,0,0,0,0,0,\(playerThreeId)", sut.boardNotation())
    }
    
    func testPlayerInBottomRightCanOnlyGo_Left_UpLeft_Up() {
        sut = WSBoard.WSBoardWith4Players(boardSize: 5) // 4 players
        
        let playerOneId = sut.players[sut.playerIds.first!]!.playerId
        let playerTwoId = sut.players[sut.playerIds[1]]!.playerId
        let playerThreeId = sut.players[sut.playerIds[2]]!.playerId
        let playerFourId = sut.players[sut.playerIds[3]]!.playerId
        
        sut.move(playerId: playerThreeId, direction: .up)
        XCTAssertEqual("\(playerTwoId),0,0,0,\(playerFourId),0,0,0,0,0,0,0,\(playerOneId),0,0,0,0,0,0,\(playerThreeId),0,0,0,0,0", sut.boardNotation())
        sut.move(playerId: playerThreeId, direction: .down) // RESET
        
        
        sut.move(playerId: playerThreeId, direction: .left)
        XCTAssertEqual("\(playerTwoId),0,0,0,\(playerFourId),0,0,0,0,0,0,0,\(playerOneId),0,0,0,0,0,0,0,0,0,0,\(playerThreeId),0", sut.boardNotation())
        sut.move(playerId: playerThreeId, direction: .right) // RESET
        
        
        sut.move(playerId: playerThreeId, direction: .upLeft)
        XCTAssertEqual("\(playerTwoId),0,0,0,\(playerFourId),0,0,0,0,0,0,0,\(playerOneId),0,0,0,0,0,\(playerThreeId),0,0,0,0,0,0", sut.boardNotation())
        sut.move(playerId: playerThreeId, direction: .downRight) // RESET
        
        
        // These Should Not Move
        sut.move(playerId: playerThreeId, direction: .down)
        XCTAssertEqual("\(playerTwoId),0,0,0,\(playerFourId),0,0,0,0,0,0,0,\(playerOneId),0,0,0,0,0,0,0,0,0,0,0,\(playerThreeId)", sut.boardNotation())
        sut.move(playerId: playerThreeId, direction: .right)
        XCTAssertEqual("\(playerTwoId),0,0,0,\(playerFourId),0,0,0,0,0,0,0,\(playerOneId),0,0,0,0,0,0,0,0,0,0,0,\(playerThreeId)", sut.boardNotation())
        sut.move(playerId: playerThreeId, direction: .upRight)
        XCTAssertEqual("\(playerTwoId),0,0,0,\(playerFourId),0,0,0,0,0,0,0,\(playerOneId),0,0,0,0,0,0,0,0,0,0,0,\(playerThreeId)", sut.boardNotation())
        sut.move(playerId: playerThreeId, direction: .downRight)
        XCTAssertEqual("\(playerTwoId),0,0,0,\(playerFourId),0,0,0,0,0,0,0,\(playerOneId),0,0,0,0,0,0,0,0,0,0,0,\(playerThreeId)", sut.boardNotation())
        sut.move(playerId: playerThreeId, direction: .downLeft)
        XCTAssertEqual("\(playerTwoId),0,0,0,\(playerFourId),0,0,0,0,0,0,0,\(playerOneId),0,0,0,0,0,0,0,0,0,0,0,\(playerThreeId)", sut.boardNotation())
    }
    
    func testPlayerInBottomLeftCanOnlyGo_Right_UpRight_Up() {
        sut = WSBoard.WSBoardWith5Players(boardSize: 5)
        
        let playerOneId = sut.players[sut.playerIds.first!]!.playerId
        let playerTwoId = sut.players[sut.playerIds[1]]!.playerId
        let playerThreeId = sut.players[sut.playerIds[2]]!.playerId
        let playerFourId = sut.players[sut.playerIds[3]]!.playerId
        let playerFiveId = sut.players[sut.playerIds[4]]!.playerId
        
        sut.move(playerId: playerFiveId, direction: .up)
        XCTAssertEqual("\(playerTwoId),0,0,0,\(playerFourId),0,0,0,0,0,0,0,\(playerOneId),0,0,\(playerFiveId),0,0,0,0,0,0,0,0,\(playerThreeId)", sut.boardNotation())
        sut.move(playerId: playerFiveId, direction: .down) // RESET
        
        
        sut.move(playerId: playerFiveId, direction: .right)
        XCTAssertEqual("\(playerTwoId),0,0,0,\(playerFourId),0,0,0,0,0,0,0,\(playerOneId),0,0,0,0,0,0,0,0,\(playerFiveId),0,0,\(playerThreeId)", sut.boardNotation())
        sut.move(playerId: playerFiveId, direction: .left) // RESET
        
        
        sut.move(playerId: playerFiveId, direction: .upRight)
        XCTAssertEqual("\(playerTwoId),0,0,0,\(playerFourId),0,0,0,0,0,0,0,\(playerOneId),0,0,0,\(playerFiveId),0,0,0,0,0,0,0,\(playerThreeId)", sut.boardNotation())
        sut.move(playerId: playerFiveId, direction: .downLeft) // RESET
        
        
        // These Should Not Move
        sut.move(playerId: playerFiveId, direction: .down)
        XCTAssertEqual("\(playerTwoId),0,0,0,\(playerFourId),0,0,0,0,0,0,0,\(playerOneId),0,0,0,0,0,0,0,\(playerFiveId),0,0,0,\(playerThreeId)", sut.boardNotation())
        sut.move(playerId: playerFiveId, direction: .left)
        XCTAssertEqual("\(playerTwoId),0,0,0,\(playerFourId),0,0,0,0,0,0,0,\(playerOneId),0,0,0,0,0,0,0,\(playerFiveId),0,0,0,\(playerThreeId)", sut.boardNotation())
        sut.move(playerId: playerFiveId, direction: .upLeft)
        XCTAssertEqual("\(playerTwoId),0,0,0,\(playerFourId),0,0,0,0,0,0,0,\(playerOneId),0,0,0,0,0,0,0,\(playerFiveId),0,0,0,\(playerThreeId)", sut.boardNotation())
        sut.move(playerId: playerFiveId, direction: .downRight)
        XCTAssertEqual("\(playerTwoId),0,0,0,\(playerFourId),0,0,0,0,0,0,0,\(playerOneId),0,0,0,0,0,0,0,\(playerFiveId),0,0,0,\(playerThreeId)", sut.boardNotation())
        sut.move(playerId: playerFiveId, direction: .downLeft)
        XCTAssertEqual("\(playerTwoId),0,0,0,\(playerFourId),0,0,0,0,0,0,0,\(playerOneId),0,0,0,0,0,0,0,\(playerFiveId),0,0,0,\(playerThreeId)", sut.boardNotation())
    }
    
    func testOnSuccessfulMove_delegateInformedWith_didChangeState() {
        let delegate = MockDelegate()
        sut = WSBoard.WSBoardWith2Players(boardSize: 5, delegate: delegate)
        
        let playerOneId = sut.players[sut.playerIds.first!]!.playerId
        sut.move(playerId: playerOneId, direction: .up)
        
        XCTAssertTrue(delegate.boardDidChangeStateCalled)
    }
    
    func testOnFailedMove_delegateNotInformed() {
        let delegate = MockDelegate()
        sut = WSBoard.WSBoardWith5Players(boardSize: 5, delegate: delegate)
        
        delegate.boardDidChangeStateCalled = false // resetting delegate after players added calls boardDidChangeState(_:)
        
        let playerTwoId = sut.playerIds[1]
        sut.move(playerId: playerTwoId, direction: .up)
        
        XCTAssertFalse(delegate.boardDidChangeStateCalled)
    }
    
    #warning("TODO: notify of capture")
    func testOnCollision_delegateInformed() {
        
    }

//    static var allTests = [
//        ("testExample", testExample),
//    ]
}

extension WSBoard {
    static func TestWSBoard() -> WSBoard {
        return WSBoard.TestFixture(numberOfPlayers: 0, boardSize: 11, delegate: nil)
    }
    
    static func WSBoardWith5Players(boardSize: Int, delegate: WSBoardDelegate? = nil) -> WSBoard {
        return WSBoard.TestFixture(numberOfPlayers: 5, boardSize: boardSize, delegate: delegate)
    }
    
    static func WSBoardWith4Players(boardSize: Int, delegate: WSBoardDelegate? = nil) -> WSBoard {
        return WSBoard.TestFixture(numberOfPlayers: 4, boardSize: boardSize, delegate: delegate)
    }
    
    static func WSBoardWith2Players(boardSize: Int, delegate: WSBoardDelegate? = nil) -> WSBoard {
        return WSBoard.TestFixture(numberOfPlayers: 2, boardSize: boardSize, delegate: delegate)
    }
    
    static func TestFixture(numberOfPlayers: Int, boardSize: Int, delegate: WSBoardDelegate? = nil) -> WSBoard {
        let board = WSBoard(boardSize: boardSize, delegate: delegate)!
        guard numberOfPlayers > 0 else {
            return board
        }
        
        for _ in 1...numberOfPlayers {
            board.add(WSPlayer.TestPlayer())
        }
        
        return board
    }
}

class MockDelegate: WSBoardDelegate {
    
    var boardDidChangeStateCalled = false
    var didCollideWithPlayerIdCalled = false
    var didCollideWithPlayerId: String? = nil
    
    func boardDidChangeState(_ board: WSBoard?) {
        self.boardDidChangeStateCalled = true
    }
    
    func board(_ board: WSBoard?, didCollideWithPlayerId: String) {
        self.didCollideWithPlayerIdCalled = true
        self.didCollideWithPlayerId = didCollideWithPlayerId
    }
}

