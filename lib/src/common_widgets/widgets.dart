import 'package:flutter/material.dart';

class TextDataBox extends StatelessWidget {
  const TextDataBox({
    required this.text,
    required this.data,
    required this.noOfBox,
    super.key,
  });

  final String text;
  final String data;
  final double noOfBox;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
          ),
          Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.circular(5),
            ),
            width:
                (MediaQuery.of(context).size.width - 90 - (noOfBox - 1) * 20) /
                    noOfBox,
            height: 40,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(data),
            ),
          ),
        ],
      ),
    );
  }
}

class CarCard extends StatelessWidget {
  const CarCard({super.key, required this.carNo});
  final String carNo;
  @override
  Widget build(BuildContext context) {
    return Placeholder(
      child: Text(carNo),
    );
  }
}
