# Bambora Checkout SDK for iOS
The Checkout SDK for iOS provides the tools necessary for integrating Bambora Checkout with your iOS application. The SDK helps with displaying the Checkout session, and sending out events during the payment flow.

## Installation
The Bambora SDK is available via [CocoaPods](https://cocoapods.org/), [Swift Package Manager](https://github.com/apple/swift-package-manager) or [Carthage](https://github.com/Carthage/Carthage).

### CocoaPods
Add the Bambora SDK as a pod to your project by adding the following to your `Podfile`:

```
$ pod 'BamboraSDK'
```

Afterwards, run the following command:

```
$ pod install
```

### Swift Package Manager
Add the Bambora SDK with Swift Package Manager with the following steps:

1. Go to your project's settings and click the 'Package Dependencies' tab.
2. Click the '+' to add a new Swift Package dependency.
3. Enter the Github URL in the search bar: `https://github.com/bambora/checkout-sdk-ios`
4. Additionally, you can set a version when including the package. The default option is to select the latest, which is the recommended option to ensure that you are up to date and have the latest (security) patches.
5. Click 'Add package'

When the package has successfully been added, it will automatically be added as a dependency to your targets as well.

### Carthage
Add the Bambora SDK with Carthage, by adding the following to your `Cartfile`:

```
$ github "bambora/checkout-sdk-ios"
```

Afterwards, run the following command:

```
$ carthage update --use-xcframeworks
```

Navigate to the `Carthage/Build` directory, which was created in the same directory as where the `.xcodeproj` or `.xcworkspace` is. Inside this directory the `.xcframework` bundle is stored. Drag the `.xcframework` into the "Framework, Libraries and Embedded Content" section of the desired target. Make sure that it is set to "Embed & Sign". 

### Allow redirects to wallet apps
Your customers might want to complete their payments via a wallet method, such as MobilePay and Vipps. Ideally, they will be redirected to the corresponding wallet app and complete the payment there. To allow redirection to these apps, it is required to set up which apps can be redirected to in your project.
Below are the steps to allow redirecting to other apps:

1. Go to your project's target and click the 'Info' tab.
2. Add the key 'Queried URL Schemes'.
3. For each URL Scheme that should be supported, add an item to 'Queried URL Schemes' 'by clicking the '+'.
4. Add a value to the item. This should be a scheme, e.g. "mobilepayonline".

It should look similar to this:
![An example of what the 'Queried URL Schemes' should look like.](/Assets/Queried_Url_Schemes_Example.png)

### Available URLs
The SDK currently supports MobilePay, Vipps and Swish. For these wallet products, you can define the following URLs.
| Wallet product     | Production app     | Test app                |
| ------------------ | ------------------ | ----------------------- |
| MobilePay          | mobilepay<br/>mobilepayonline          | mobilepay-test<br/>mobilepayonline-test          |
| Vipps              | vipps              | vippsmt                 |
| Swish              | swish              | swish                   |                         

### <a name="urlScheme"></a>Configure a URL Scheme
In order to allow your customers to be redirected to your app after completing a payment via a wallet method, it is mandatory to set up a URL Scheme in your project.
The steps below show how to set up the scheme properly:

1. Go to your project's target and click the 'Info' tab.
2. Expand the 'URL Types' category.
3. Enter your desired URL Scheme in the 'URL Schemes' text field.

It should look similar to this:
![An example of what the 'URL Scheme' should look like.](/Assets/Url_Scheme_Example.png)

## Usage
Processing a payment through the Bambora Checkout SDK requires only a couple of easy steps:
- Initializing the SDK
- Showing the payment screen to your customer
- Listen for events and process the payment result

### Creating a Checkout Session
To initialize the SDK, you need a session token that can be obtained by creating a Checkout session. For details on how to create a Checkout session have a look at the [Bambora Development Documentation](https://developer.bambora.com/europe/checkout/getting-started/create-payment).

### Initializing the SDK
Initialize the SDK like so:
```
var checkout = Bambora.checkout(sessionToken: sessionToken, customUrl: customUrl)
```
Parameters:
- `sessionToken` - Token that you received in the previous step, when creating a session
- (Optional) `customUrl`: An option to override the default URL to which the SDK will connect

### Displaying the checkout
After having initialized the SDK, the Bambora Checkout UI can be displayed to your customer. To show the payment screen, simply call:
```
checkout.show()
```
The SDK will render the Bambora Checkout UI in a pop up over the current screen. If the customer selects to pay with their wallet payment application, the SDK will make sure to open the corresponding app. The SDK will also handle the redirect back to the configured URL scheme.

### Subscribing to events
The SDK is event-driven. This means that it will sent out events when something notable occurs during the payment flow. To be able to receive these events, you'll have to subscribe to them.
- Subscribe to **all events**\
    Get notified when any event occurs:
  ```
  checkout.subscribeOnAllEvents()
  ```

- Subscribe to **some events**\
  Get notified when specific events occur. Replace the events in the example below with the ones you need. The possible options are listed [here](#eventsOverview).
  ```
  checkout.on(events: [EventType.authorize, EventType.cardTypeResolve])
  ```
  Use the snippet below to subscribe to a single event.
   ```
  checkout.on(event: EventType.authorize)
  ```

- Unsubscribe from **some events**\
  Use the example below to unsubscribe from certain events. Replace the event types with the ones you no longer need to receive.
  ```
  checkout.off(events: [EventType.authorize, EventType.cardTypeResolve])
  ```
  Use the snippet below to unsubscribe from a specific event.
  ```
  checkout.off(event: EventType.authorize)
  ```

### Receiving events
To intercept the events that you have subscribed to, implement the `CheckoutDelegate` protocol. This protocol has a function called `onEventDispatched(event:Event)` which you can implement like this:
```
func onEventDispatched(event: Event) {
    switch event {
    case is AuthorizeEvent:
        // do something when an Authorize event was intercepted
    default:
        // do something when any other event was intercepted
    }
}
```

### <a name="eventsOverview"></a>Events overview
| Event                  | Trigger                                                                                                       | Data description |
| ---------------------- | ------------------------------------------------------------------------------------------------------------- | ----------------------------                                                 |
| Authorize              | Sent when a payment has been authorized                                                                       | Contains payment data, such as `txnid` and `orderid`                         |
| CheckoutViewClose      | Sent when the payment screen has been closed                                                                  | Contains no data                                                             |
| PaymentTypeSelection   | Sent when a payment type has been selected                                                                    | Contains the payment type, such as `paymentcard` or `mobilepay`              |
| CardTypeResolve        | Sent whenever enough digits of the payment card number have been entered to determine the payment card type   | Contains payment card type data, such as `id` and `fee`                      |
| Error                  | Sent when an error occurs                                                                                     | Contains an Error type, such as `LoadSessionError` or `GenericMessageError`  |

More information about the different types of Events and their data, can be found at the [Bambora Development Documentation](https://developer.bambora.com/europe/sdk/web-sdk/advanced-usage). 

### Closing the SDK
The Checkout SDK is closed automatically when a payment was authorized and therefore completed. In all other scenarios, the SDK can be closed by calling `Bambora.close()`. This is required before the SDK can be reinitialized for a new payment.

Note that, if the user is still completing a payment, closing the SDK during the process may cause the payment to fail.

When the SDK is closed, a few things happen:
- The View Controller showing the Bambora Checkout view is dismissed immediately
- Resources of the SDK, such as Checkout, are cleaned up
- A new payment session can now be instantiated


## Demo App
The Demo App shows how you can use the Bambora Checkout SDK in your own app. It shows how to implement the following features:
- Initialize a session with Bambora's default production URL
- See the details of a payment after it was completed
- Listen and respond to events
- Configure a deeplink URL
