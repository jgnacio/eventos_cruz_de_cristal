import 'package:flutter/material.dart';
import 'dart:math';

class MotivationCardWidget extends StatefulWidget {
  const MotivationCardWidget({super.key});

  @override
  State<MotivationCardWidget> createState() => _MotivationCardWidgetState();
}

class _MotivationCardWidgetState extends State<MotivationCardWidget> {
  late String _currentMessage;
  late String _currentTitle;
  late IconData _currentIcon;
  late Color _currentColor;

  final List<Map<String, dynamic>> _motivationalMessages = [
    {
      'title': 'Mateo 6:16-18',
      'message': '"Cuando ayunen, no pongan cara triste como hacen los hipócritas... Pero tú, cuando ayunes, perfúmate la cabeza y lávate la cara, para que tu ayuno sea visto no por los hombres, sino por tu Padre que está en lo secreto; y tu Padre, que ve en lo secreto, te recompensará."',
      'icon': Icons.menu_book,
      'color': Colors.deepPurple,
    },
    {
      'title': 'Joel 2:12',
      'message': '"Ahora pues, dice Jehová, convertíos a mí con todo vuestro corazón, con ayuno y lloro y lamento. Rasgad vuestro corazón, y no vuestros vestidos, y convertíos a Jehová vuestro Dios."',
      'icon': Icons.favorite,
      'color': Colors.red,
    },
    {
      'title': 'Mateo 4:4',
      'message': '"No sólo de pan vivirá el hombre, sino de toda palabra que sale de la boca de Dios."',
      'icon': Icons.restaurant,
      'color': Colors.orange,
    },
    {
      'title': 'Isaías 58:6',
      'message': '"¿No es más bien el ayuno que yo escogí, desatar las ligaduras de impiedad, soltar las cargas de opresión, y dejar ir libres a los quebrantados, y que rompáis todo yugo?"',
      'icon': Icons.healing,
      'color': Colors.green,
    },
    {
      'title': '1 Corintios 7:5',
      'message': '"No os neguéis el uno al otro, a no ser por algún tiempo de mutuo consentimiento, para ocuparos sosegadamente en la oración; y volved a juntaros en uno, para que no os tiente Satanás."',
      'icon': Icons.groups,
      'color': Colors.blue,
    },
    {
      'title': 'Daniel 10:3',
      'message': '"No comí manjar delicado, ni entró en mi boca carne ni vino, ni me ungí con ungüento, hasta que se cumplieron las tres semanas."',
      'icon': Icons.self_improvement,
      'color': Colors.indigo,
    },
    {
      'title': 'Mateo 17:21',
      'message': '"Pero este género no sale sino con oración y ayuno."',
      'icon': Icons.church,
      'color': Colors.purple,
    },
    {
      'title': 'Nehemías 1:4',
      'message': '"Cuando oí estas palabras me senté y lloré, e hice duelo por algunos días, y ayuné y oré delante del Dios de los cielos."',
      'icon': Icons.policy,
      'color': Colors.teal,
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectRandomMessage();
  }

  void _selectRandomMessage() {
    final random = Random();
    final selectedMessage = _motivationalMessages[random.nextInt(_motivationalMessages.length)];
    
    setState(() {
      _currentTitle = selectedMessage['title'];
      _currentMessage = selectedMessage['message'];
      _currentIcon = selectedMessage['icon'];
      _currentColor = selectedMessage['color'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      child: InkWell(
        onTap: _selectRandomMessage,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                _currentColor.withValues(alpha: 0.1),
                _currentColor.withValues(alpha: 0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _currentColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _currentIcon,
                        color: _currentColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _currentTitle,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: _currentColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Versículo bíblico',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _currentColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        Icons.refresh,
                        color: _currentColor,
                        size: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  _currentMessage,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(
                      Icons.touch_app,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Toca para ver otro versículo',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 