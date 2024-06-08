import 'package:flutter/material.dart';

class FullScreenLoader extends StatelessWidget {
  const FullScreenLoader({super.key});

  static const messages = <String>[
    'Cargando pelis...',
    'Comprando palomitas',
    'Llamando a mi novi@',
    'Cargando Populares...',
    'Esto ya tomo demasiado :-('
  ];

  Stream<String> getLoadingMessages() {
    return Stream.periodic(
      const Duration(milliseconds: 1200),
      (step) {
        return messages[step];
      },
    ).take(messages.length);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Espere por favor',
            style: TextStyle(fontSize: 23),
          ),
          const SizedBox(height: 20),
          CircularProgressIndicator(
            strokeWidth: 4,
          ),
          const SizedBox(height: 20),
          StreamBuilder(
            stream: getLoadingMessages(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const Text('Cargando...');
              return Text(
                snapshot.data!,
                style: const TextStyle(fontSize: 15),
              );
            },
          )
        ],
      ),
    );
  }
}
