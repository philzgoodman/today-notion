import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  WebViewController? _wvc;
  String get url => 'https://www.notion.so/TODAY-758bfe52c0e54d308867a113c0366ce6';


  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return WillPopScope(
      onWillPop: () async {
        _wvc?.goBack();
        return false;
      },
      child:  Scaffold(
        backgroundColor: Colors.black,
        body: WebView(
          userAgent: 'Mozilla/5.0 (Linux; Android 7.0; SM-G930V Build/NRD90M) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.125 Mobile Safari/537.36',

          javascriptMode: JavascriptMode.unrestricted, //  <---  this is the key

          javascriptChannels: {
                  JavascriptChannel(
                      name: 'Print',
                      onMessageReceived: (JavascriptMessage message) {

                      }),

                },

          onWebViewCreated: (WebViewController webViewController) {
            _wvc = webViewController;

            _wvc?.loadUrl(
                'https://www.notion.so/TODAY-758bfe52c0e54d308867a113c0366ce6');
          },

          onPageFinished: (String url) async {
            String overrideCSS =
                await CSSInjectionString(context, 'assets/custom.css');


            _wvc?.runJavascript(overrideCSS);


/*
            String overrideJS =
            await JSInjectionString(context, 'assets/custom.js');


            _wvc?.runJavascript(overrideJS); */

            },
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () {
                _wvc?.loadUrl(
                    'https://www.notion.so/TODAY-758bfe52c0e54d308867a113c0366ce6');
              },
              tooltip: 'Reload',
              child: const Icon(Icons.refresh),
            ),
            const SizedBox(
              height: 10,
            ),
            FloatingActionButton(
              onPressed: () {
                _wvc?.goBack();
              },
              tooltip: 'Back',
              child: const Icon(Icons.arrow_back),
            ),
            const SizedBox(
              height: 10,
            ),
            FloatingActionButton(
              onPressed: () {
                _wvc?.goForward();
              },
              tooltip: 'Forward',
              child: const Icon(Icons.arrow_forward),
            ),
            const SizedBox(
              height: 10,
            ),
            FloatingActionButton(
              onPressed: () async {

                await undo(context);
                }
                                       ,


              tooltip: 'Forward',
              child: const Icon(Icons.undo),
            ),
          ],

        ),
        // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }

  Future<void> undo(BuildContext context) async {
      String overrideJS ="document.execCommand('undo', false, null);console.log('undo');var keyboardEvent = document.createEvent('KeyboardEvent'); var initMethod = typeof keyboardEvent.initKeyboardEvent !== 'undefined' ? 'initKeyboardEvent' : 'initKeyEvent'; keyboardEvent[initMethod]( 'keydown', true, true, window, true, false, false, false, 90, 0, ); document.dispatchEvent(keyboardEvent);var ctrlEvent = new KeyboardEvent('keydown', {bubbles : true, cancelable : true, keyCode : 17, char : 17, shiftKey : true}); var aEvent = new KeyboardEvent('keydown', {bubbles : true, cancelable : true, keyCode : 90, char : 90, shiftKey : true}); document.dispatchEvent(ctrlEvent); document.dispatchEvent(aEvent);";












    _wvc?.runJavascript(overrideJS);
  }
  Future<String> CSSInjectionString(BuildContext context, String s) async {
    String cssOverride = await loadStringAsset(context, s);
    return "var cssOverrideStyle = document.createElement('style');"
        "cssOverrideStyle.textContent = `$cssOverride`;"
        "document.head.append(cssOverrideStyle);";
  }
  Future<String> JSInjectionString(BuildContext context, String s) async {
    String cssOverride = await loadStringAsset(context, s);
    return "var JSOverrideStyle = document.createElement('script');"
        "JSOverrideStyle.textContent = `$cssOverride`;"
        "document.head.append(JSOverrideStyle);";
  }





  Future<String> loadStringAsset(BuildContext context, String asset) async {
    return await DefaultAssetBundle.of(context).loadString(asset);
  }
}
