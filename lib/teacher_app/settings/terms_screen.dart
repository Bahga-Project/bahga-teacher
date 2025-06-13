import 'package:flutter/material.dart';

import '../../Refactoration/Colors.dart';
import '../../../Refactoration/common_widgets.dart';

class TermsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Terms & Condition",
        backgroundColor: AppColors.appBarColor,
        showBackButton: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus feugiat eget est leo, id tincidunt velit sodales vel. Sed eget orci felis. Suspendisse luctus tellus et nisl efficitur, sit amet mollis ex luctus. Nunc sem neque, condimentum at urna ut, viverra vulputate quam. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla tempor nunc sed elementum mattis. Sed sit amet cursus lorem. Aliquam aliquam elit non ligula pretium, vel volutpat tortor ullamcorper. Nulla rutrum tortor id libero mollis ullamcorper. In ut rhoncus dui. Ut interdum sem porttitor, eleifend justo nec, egestas est. Phasellus id venenatis lectus. Suspendisse pulvinar odio ac pellentesque fermentum, nibh erat commodo tortor, in sagittis enim lorem vitae velit.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16.0),
          ),
        ),
      ),
    );
  }
}