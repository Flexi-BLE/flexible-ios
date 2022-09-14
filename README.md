# FlexiBLE iOS Application

## Demo
[![Demo YouTube Video](https://img.youtube.com/vi/g7ES4XcpsuU/0.jpg)](https://www.youtube.com/watch?v=g7ES4XcpsuU)

## Getting Started
Currently, the application is released for external testing via TestFlight by **invite only**. [Please reach out](https://blainerothrock.com) for a invitation via email. The application can be built locally by opening in XCode and updating the Signing and Capibilities. 

**Note** this repository relies on the [FlexiBLE Swift Package](https://github.com/Flexi-BLE/flexible-swift), which is set as a dependency on the main branch. To edit locally, first clone the Swift Package Library, then add the package as a local dependency.

## Testing the Zephyr nrf5340 Sample Code
To collect data and interact with the firmware from our [Zephyr nrf5340 development kit sample code], first either build or download the application. Not, BLE only works on physical devices. In the applicaiton home screen, click `Select` and enter the url `https://pastebin.com/raw/hBw3K1MH`, which is a example specification file for the example code. The nRF5340 should connect automatically when turned on, edit the Data Stream parameters to collect data. Data can be exported via the Settings Tab.
