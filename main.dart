import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_internet_speed_test/flutter_internet_speed_test.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();

  }
class _MyAppState extends State<MyApp> {
  final internetSpeedTest = FlutterInternetSpeedTest()..enableLog();

  bool _testInProgress = false;
  double _downloadRate = 0;
  double _uploadRate = 0;
  String _downloadProgress = '0';
  String _uploadProgress = '0';
  int _downloadCompletionTime = 0;
  int _uploadCompletionTime = 0;
  bool _isServerSelectionInProgress = false;
  String? _ip;
  String? _asn;
  String? _isp;
  double a = 0.0;
  String _unitText = 'Mbps';
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {

    });
  }
  @override
  Widget build(BuildContext context) {
    List<double> points = [_uploadRate, _downloadRate];
    List<String> labels = [
      "upload speed",
      "download speed",
    ];
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors. black87,
          title: const Text('"Internet Speed Test"'),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Your internet speed',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('upload Rate: ${_uploadRate} $_unitText'),
                  Text('Download Rate: ${_downloadRate} $_unitText'),
                  Text('average Rate: ${(_downloadRate+_uploadRate)/2}')


                ],
              ),
              const SizedBox(
                height: 32.0,
              ),

              const SizedBox(
                height: 32.0,
              ),
              if (!_testInProgress) ...{
                ElevatedButton(
                  child: const Text('Start Testing'),
                  onPressed: () async {
                     reset();
                    await internetSpeedTest.startTesting(onStarted: () {
                      setState(() => _testInProgress = true);
                    }, onCompleted: (TestResult download, TestResult upload) {
                      if (kDebugMode) {
                        print(
                            'the transfer rate ${download.transferRate}, ${upload.transferRate}');
                      }
                      setState(() {
                        _downloadRate = download.transferRate;
                        _unitText =
                        download.unit == SpeedUnit.kbps ? 'Kbps' : 'Mbps';
                        _downloadProgress = '100';
                        _downloadCompletionTime = download.durationInMillis;
                      });
                      setState(() {
                        _uploadRate = upload.transferRate;
                        _unitText =
                        upload.unit == SpeedUnit.kbps ? 'Kbps' : 'Mbps';
                        _uploadProgress = '100';
                        _uploadCompletionTime = upload.durationInMillis;
                        _testInProgress = false;
                      });
                    }, onProgress: (double percent, TestResult data) {
                      if (kDebugMode) {
                        print(
                            'the transfer rate $data.transferRate, the percent $percent');
                      }
                      setState(() {
                        _unitText =
                        data.unit == SpeedUnit.kbps ? 'Kbps' : 'Mbps';
                        if (data.type == TestType.download) {
                          _downloadRate = data.transferRate;
                          _downloadProgress = percent.toStringAsFixed(2);
                        } else {
                          _uploadRate = data.transferRate;
                          _uploadProgress = percent.toStringAsFixed(2);
                        }
                      });
                    }, onError: (String errorMessage, String speedTestError) {
                      if (kDebugMode) {
                        print(
                            'the errorMessage $errorMessage, the speedTestError $speedTestError');
                      }
                      reset();
                    }, onDefaultServerSelectionInProgress: () {
                      setState(() {
                        _isServerSelectionInProgress = true;
                      });
                    }, onDefaultServerSelectionDone: (Client? client) {
                      setState(() {
                        _isServerSelectionInProgress = false;
                        _ip = client?.ip;
                        _asn = client?.asn;
                        _isp = client?.isp;
                      });
                    }, onDownloadComplete: (TestResult data) {
                      setState(() {
                        _downloadRate = data.transferRate;
                        _unitText =
                        data.unit == SpeedUnit.kbps ? 'Kbps' : 'Mbps';
                        _downloadCompletionTime = data.durationInMillis;
                      });
                    }, onUploadComplete: (TestResult data) {
                      setState(() {
                        _uploadRate = data.transferRate;
                        _unitText =
                        data.unit == SpeedUnit.kbps ? 'Kbps' : 'Mbps';
                        _uploadCompletionTime = data.durationInMillis;
                      });
                    }, onCancel: () {
                      reset();
                    });
                  },
                )
              } else ...{
                const CircularProgressIndicator(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton.icon(
                    onPressed: () => internetSpeedTest.cancelTest(),
                    icon: const Icon(Icons.cancel_rounded),
                    label: const Text('Cancel'),
                  ),
                )
              },
            ],
          ),
        ),
      ),
    );
  }
  void reset() {
    setState(() {
      {
        _testInProgress = false;
        _downloadRate = 0;
        _uploadRate = 0;
        _downloadProgress = '0';
        _uploadProgress = '0';
        _unitText = 'Mbps';
        _downloadCompletionTime = 0;
        _uploadCompletionTime = 0;

        _ip = null;
        _asn = null;
        _isp = null;
      }
    });
  }
}
