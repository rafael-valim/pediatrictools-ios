import XCTest
@testable import PediatricTools

final class AppDelegateTests: XCTestCase {
    private var delegate: AppDelegate!

    override func setUp() {
        super.setUp()
        delegate = AppDelegate()
        AppDelegate.orientationLock = .allButUpsideDown
    }

    func testDefaultOrientationIsAllButUpsideDown() {
        XCTAssertEqual(AppDelegate.orientationLock, .allButUpsideDown)
    }

    func testOrientationLockPortrait() {
        AppDelegate.orientationLock = .portrait
        let result = delegate.application(UIApplication.shared, supportedInterfaceOrientationsFor: nil)
        XCTAssertEqual(result, .portrait)
    }

    func testOrientationLockRestore() {
        AppDelegate.orientationLock = .portrait
        AppDelegate.orientationLock = .allButUpsideDown
        let result = delegate.application(UIApplication.shared, supportedInterfaceOrientationsFor: nil)
        XCTAssertEqual(result, .allButUpsideDown)
    }
}
