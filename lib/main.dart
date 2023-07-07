import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

const kColorPurple = Color(0xFF8337EC);
const kColorPink = Color(0xFFFF006F);
const kColorIndicatorBegin = kColorPink;
const kColorIndicatorEnd = kColorPurple;
const kColorTitle = Color(0xFF616161);
const kColorText = Color(0xFF9E9E9E);
const kElevation = 4.0;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.light().copyWith(
          primaryColor: Colors.white,
          primaryTextTheme: TextTheme(
            titleLarge: TextStyle(color: kColorTitle),
          ),
          scaffoldBackgroundColor: Colors.white),
      home: BatteryOptimizerPage(),
    );
  }
}

class BatteryOptimizerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Battery Optimizer'),
        centerTitle: false,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            OptimizerButtons(),
            BatteryLevelIndicator(),
            AppDrainage(),
            Optimizenow()
          ],
        ),
      ),
    );
  }
}

class _OptimizerButton extends StatelessWidget {
  final String text;

  const _OptimizerButton({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
      onPressed: () {},
      child: Text(
        text,
        style: TextStyle(color: kColorTitle, fontSize: 12),
      ),
    );
  }
}

class OptimizerButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            SizedBox(width: 16), //Button間の余白
            _OptimizerButton(text: 'Battery Optimizer'),
            SizedBox(width: 16),
            _OptimizerButton(text: 'Connection Optimizer'),
            SizedBox(width: 16),
            _OptimizerButton(text: 'Memory Optimizer'),
            SizedBox(width: 16),
            _OptimizerButton(text: 'Storage Optimizer'),
            SizedBox(width: 16)
          ],
        ),
      ),
    );
  }
}

class _BatteryLevelIndicatorPainter extends CustomPainter {
  final double percentage;
  final double textCircleRadius;

  _BatteryLevelIndicatorPainter(
      {required this.percentage, required this.textCircleRadius});

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 1; i < (360 * percentage); i += 5) {
      final per = i / 360.0;
      final color = ColorTween(
        begin: kColorIndicatorBegin,
        end: kColorIndicatorEnd,
      ).lerp(per)!;
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4;

      final spaceLen = 16;
      final lineLen = 24;
      final angle = (2 * pi * per) - (pi / 2);

      final offset0 = Offset(size.width * 0.5, size.height * 0.5);

      final offset1 = offset0.translate(
          (textCircleRadius + spaceLen) * cos(angle),
          (textCircleRadius + spaceLen) * sin(angle));

      final offset2 =
          offset1.translate(lineLen * cos(angle), lineLen * sin(angle));
      canvas.drawLine(offset1, offset2, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class BatteryLevelIndicator extends StatelessWidget {
  final percentage = 0.7;
  final size = 164.0;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _BatteryLevelIndicatorPainter(
          percentage: percentage, textCircleRadius: size * 0.5),
      child: Container(
        padding: const EdgeInsets.all(64),
        child: Material(
          color: Colors.white,
          elevation: kElevation,
          borderRadius: BorderRadius.circular(size * 0.5),
          child: Container(
            width: size,
            height: size,
            child: Center(
              child: Text(
                '${percentage * 100}%',
                style: TextStyle(color: kColorPink, fontSize: 48),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HorizontalBorder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      margin: EdgeInsets.symmetric(horizontal: 16),
      color: Colors.grey[200],
    );
  }
}

class _AppColumn extends StatelessWidget {
  final String name;
  final Icon icon;
  final String percentage;

  const _AppColumn({
    Key? key,
    required this.name,
    required this.icon,
    required this.percentage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon,
      title: Text(
        name,
        style: TextStyle(color: kColorText),
      ),
      trailing: Text(percentage, style: TextStyle(color: kColorText)),
    );
  }
}

class AppDrainage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: ClipOval(
            child: Container(
              color: kColorPurple,
              child: Icon(Icons.apps, color: Colors.white),
            ),
          ),
          title: Text(
            'Apps Drainage',
            style: TextStyle(color: kColorTitle),
          ),
          subtitle: Text(
            'Show the most draining energy application',
            style: TextStyle(color: kColorText),
          ),
        ),
        Material(
          color: Colors.white,
          elevation: kElevation,
          borderRadius: BorderRadius.circular(16),
          child: Column(
            children: [
              _AppColumn(
                  name: 'SMSApp',
                  icon: Icon(Icons.sms, color: Colors.indigo),
                  percentage: '75%'),
              _HorizontalBorder(),
              _AppColumn(
                  name: 'MovieApp',
                  icon: Icon(
                    Icons.live_tv,
                    color: Colors.red,
                  ),
                  percentage: '60%'),
              _HorizontalBorder(),
              _AppColumn(
                  name: 'MapApp',
                  icon: Icon(Icons.place, color: Colors.green),
                  percentage: '35%'),
              _HorizontalBorder(),
              _AppColumn(
                  name: 'ShoppingApp',
                  icon: Icon(Icons.local_grocery_store, color: Colors.orange),
                  percentage: '35%'),
              _HorizontalBorder(),
              _AppColumn(
                  name: 'TrainApp',
                  icon: Icon(Icons.train, color: Colors.black),
                  percentage: '15%'),
            ],
          ),
        )
      ],
    );
  }
}

class Optimizenow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: kColorPurple,
            padding: EdgeInsets.symmetric(horizontal: 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            )),
        onPressed: () {},
        child: Text(
          'Optimize   Now',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
