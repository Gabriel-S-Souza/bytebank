import 'package:flutter/material.dart';

class CustomLoading extends StatelessWidget {
  const CustomLoading({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          CircularProgressIndicator(),
          Text("Loading")
        ],
      ),
    );
  }
}