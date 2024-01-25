import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const _kDefaultSizeAndroid = 28.0;

class RbSpinner extends StatelessWidget {
  const RbSpinner({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return defaultTargetPlatform == TargetPlatform.iOS
        ? const CupertinoActivityIndicator()
        : const SizedBox.square(
            dimension: _kDefaultSizeAndroid,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}
