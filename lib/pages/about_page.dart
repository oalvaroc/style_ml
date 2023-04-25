import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Image.asset("assets/flutter.png"),
                ),
                Expanded(
                  child: Image.asset("assets/tensorflow.png"),
                ),
              ],
            ),
            SelectableText.rich(
              TextSpan(
                style: const TextStyle(fontSize: 20),
                children: [
                  const TextSpan(
                    text:
                        "StyleML é um projeto desenvolvido para a disciplina SI700 - Programação para Dispositivos Móveis.",
                  ),
                  const TextSpan(
                    text:
                        "\n\nSe trata de um aplicativo que realiza transferência artística de estilo de uma imagem de estilo para uma foto capturada pela câmera do dispositivo. A imagem de estilo é escolhida pelo usuário dentre um conjunto pré-definido.",
                  ),
                  const TextSpan(
                    text:
                        "\n\nA transferência de estilo é realizada utilizando",
                  ),
                  makeLink(
                    context,
                    " TensorFlow Lite,",
                    "https://tensorflow.org/lite",
                  ),
                  const TextSpan(
                    text: " com o modelo descrito por",
                  ),
                  makeLink(
                    context,
                    " Ghiasi et al. (2017)",
                    "https://arxiv.org/abs/1705.06830",
                  ),
                  const TextSpan(
                    text: " e disponível, pré-treinado, no",
                  ),
                  makeLink(
                    context,
                    " TensorFlow Hub",
                    "https://tfhub.dev/google/magenta/arbitrary-image-stylization-v1-256/2",
                  )
                ],
              ),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }

  TextSpan makeLink(BuildContext context, String text, String uri) {
    return TextSpan(
        text: text,
        style: TextStyle(color: Theme.of(context).primaryColor),
        recognizer: TapGestureRecognizer()
          ..onTap = () async {
            final url = Uri.parse(uri);
            if (await canLaunchUrl(url)) {
              await launchUrl(url, mode: LaunchMode.externalApplication);
            }
          });
  }
}
