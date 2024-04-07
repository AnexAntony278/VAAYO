import 'package:flutter/material.dart';

class ForgetPassButtonWidget extends StatelessWidget {
  const ForgetPassButtonWidget({
    required this.btnIcon,
    required this.title,
    required this.subTitle1,
    required this.onTap,
    super.key,
  });
  final IconData btnIcon;
  final String title,subTitle1;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.grey.shade200,
        ),
        child: Row(
          children: [
             Icon(btnIcon,size:60.0),
           const SizedBox(width: 10.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.bodySmall),
                Text(subTitle1,style: Theme.of(context).textTheme.bodySmall),
      
              ],
            )
          ],
        ),
      ),
    );
  }
}