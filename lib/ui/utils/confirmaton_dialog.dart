import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/ui/utils/styles.dart';

/// Displays a confirmation dialog before actions like Log Out, Note deletion
Future<bool?> showConfirmationDialog(String type) {
  return Get.dialog<bool>(Dialog(
    child: Container(
      padding: EdgeInsets.only(top: 14),
      width: 350,
      height: 175,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: colorScheme.surfaceContainer,
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 4, left: 20, right: 20),
            child: Column(children: [
              Text(
                type,
                style: Styles.titleStyle(fontSize: 26.0),
              ),
              SizedBox(
                height: 8.0,
              ),
              Text(
                type == 'Delete Notes'
                    ? 'Are you sure you want to delete these notes?'
                    : 'Are you sure you want to delete this note?',
                textAlign: TextAlign.center,
                style: Styles.subtitleStyle(fontSize: 16.0),
              ),
            ]),
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: colorScheme.outline, width: 1.0),
                    ),
                  ),
                  child: TextButton(
                    onPressed: () {
                      Get.back(result: false);
                    },
                    child: Text(
                      'Cancel',
                      style: Styles.w600texts(
                          color: colorScheme.onSurface, fontSize: 16.0),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.error,
                    borderRadius:
                        BorderRadius.only(bottomRight: Radius.circular(12.0)),
                    border: Border(
                      top: BorderSide(color: colorScheme.outline, width: 1.0),
                    ),
                  ),
                  child: TextButton(
                    onPressed: () {
                      Get.back(result: true);
                    },
                    child: Text('Delete',
                        style: Styles.w600texts(
                            color: colorScheme.onError, fontSize: 16.0)),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    ),
  ));
}
