import Foundation
import StoreKit

@objc(RateApp)
class RateApp: NSObject {

  private let noActiveSceneError = "no_active_scene"
  private let unsupportedPlatformError = "unsupported_platform"

  @objc
  static func requiresMainQueueSetup() -> Bool {
    return false
  }

  @objc
  func requestReview(_ resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
      var sceneExists = false

      Task { @MainActor in
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            sceneExists = true
              if #available(iOS 16.0, *) {
                  AppStore.requestReview(in: scene)
              } else if #available(iOS 14.0, *) {
                  SKStoreReviewController.requestReview(in: scene)
              } else {
                  SKStoreReviewController.requestReview()
              }
        }
      }

      if (sceneExists) {
          resolve(true)
      } else {
          reject(noActiveSceneError, "No active scene found", nil)
      }
  }

  @objc
  func requestReviewAppGallery(_ resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
    reject(unsupportedPlatformError, "App Gallery reviews are not supported on iOS", nil)
  }

  @objc
  func requestReviewGalaxyStore(_ packageName: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
    reject(unsupportedPlatformError, "Galaxy Store reviews are not supported on iOS", nil)
  }
}
