import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Artboard? _artboard;
  StateMachineController? _stateMachineController;

  SMIInput<bool>? _flyInput;
  SMIInput<bool>? _waveInput;
  SMIInput<bool>? _winkInput;

  @override
  void initState() {
    super.initState();

    _initRive();
  }

  @override
  void dispose() {
    _stateMachineController?.dispose();
    _stateMachineController = null;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_artboard != null) ...[
            SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.width / 2,
              child: const RiveAnimation.asset(
                'assets/animations/dash.riv',
                fit: BoxFit.cover,
                animations: ['Fly'],
              ),
            ),
            const Divider(
              color: Colors.white,
            ),
            AspectRatio(
              aspectRatio: 1,
              child: Rive(
                fit: BoxFit.cover,
                artboard: _artboard!,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _resetToIdle();
                    setState(() {
                      _flyInput?.value = !(_flyInput?.value ?? false);
                    });
                  },
                  child: const Text('Fly'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _resetToIdle();
                    setState(() {
                      _waveInput?.value = !(_waveInput?.value ?? false);
                    });
                  },
                  child: const Text('Wave'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _resetToIdle();
                    setState(() {
                      _winkInput?.value = !(_winkInput?.value ?? false);
                    });
                  },
                  child: const Text('Wink'),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () => _resetToIdle(),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade300),
              child: const Text('Reset to Idle'),
            ),
          ] else ...[
            const Text(
              'Loading...',
              style: TextStyle(
                color: Colors.white,
              ),
            )
          ]
        ],
      ),
    );
  }

  void _initRive() {
    rootBundle.load('assets/animations/dash.riv').then(
      (data) async {
        final file = RiveFile.import(data);

        final artboard = file.mainArtboard;
        final controller = StateMachineController.fromArtboard(artboard, 'State Machine 1');

        if (controller != null) {
          artboard.addController(controller);
          _flyInput = controller.findInput('isFlying');
          _waveInput = controller.findInput('isWaving');
          _winkInput = controller.findInput('isWinking');
        }

        _stateMachineController = controller;
        _artboard = artboard;
        setState(() {});
      },
    );
  }

  void _resetToIdle() {
    _flyInput?.value = false;
    _waveInput?.value = false;
    _winkInput?.value = false;
    setState(() {});
  }
}
