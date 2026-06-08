import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class CustomContainer extends StatefulWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const CustomContainer({super.key, required this.title, required this.icon, this.child = const SizedBox()});

  @override
  State<CustomContainer> createState() => _CustomContainerState();
}

class _CustomContainerState extends State<CustomContainer> {
  bool isClicked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(left: 15, right: 15, top: 5),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  widget.icon,
                  size: 20,
                  color: AppColors.blackColor,
                ),
                const SizedBox(width: 8),
                Text(
                  widget.title,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: AppColors.blackColor),
                ),
                Spacer(),
                IconButton(
                  icon: Icon(isClicked ? Icons.keyboard_arrow_down :Icons.arrow_forward_ios, size: 20, color: AppColors.blackColor),
                  onPressed: () {
                    isClicked = !isClicked;
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
            AnimatedSize(
              duration: const Duration(milliseconds: 500),
              child:isClicked ? Container(
                padding: const EdgeInsets.all(12),
                width: double.infinity,
                child: widget.child,
              ): SizedBox()
            )
        ],
      ),
    );
  }
}
