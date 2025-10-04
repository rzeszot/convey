import XCTest

@MainActor final class ExampleUITests: XCTestCase {
    override func setUp() {
        launch()
    }

    override func tearDown() {
        terminate()
    }

    func test_1() {
        screenshot(name: "List View")

        XCTAssertEqual(app.navigationBars.element.identifier, "green")
    }

    // MARK: -

    private var app: XCUIApplication!

    private func launch() {
        app = XCUIApplication()
        app.launchArguments = ["--ui-tests"]
        app.launch()
    }

    private func terminate() {
        app.terminate()
        app = nil
    }

    private func screenshot(name: String) {
        let screenshot = app.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
