import 'package:flutter/material.dart';
import 'package:notetakingapp1/logic/utils/utils.dart';
import 'package:notetakingapp1/ui/theme/styles.dart';

class FoldersBody extends StatelessWidget {
  final List<Map<String, dynamic>> folders;
  const FoldersBody({super.key, required this.folders});

  @override
  Widget build(BuildContext context) {
    return folders.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.create_new_folder_outlined,
                  size: 50.0,
                ),
                const SizedBox(
                  height: 4.0,
                ),
                Text('No folders yet!\nCreate one.',
                    textAlign: TextAlign.center,
                    style: Styles.universalFont(fontSize: 20.0)),
              ],
            ),
          )
        : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: EdgeInsets.only(top: 12.0, left: 16.0, bottom: 8.0),
              child: Text(
                'Folders',
                style: Styles.noteSectionTitle(),
              ),
            ),
            SizedBox(height: 6,),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isDesktop(context)
                      ? 6
                      : isTablet(context)
                          ? 4
                          : 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 150/100,
                ),
                itemCount: folders.length,
                itemBuilder: (context, index) {
                  final folder = folders[index];
                  return GestureDetector(
                    onTap: () {
                      // TODO : Handle folder tap
                    },
                    child: Container(
                   
                      decoration: BoxDecoration(
                        color: Color(0xFFf4e8c2),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.folder,
                              size: 24.0, color: Color(0xFFA67B5B)),
                          const SizedBox(height: 8.0),
                          Text(
                            folder['name'] ?? 'Unnamed Folder',
                            textAlign: TextAlign.center,
                            style: Styles.w600texts(fontSize: 16.0),
                          ),
                          Text('${folder['itemsCount']} items',
                          textAlign: TextAlign.center,
                          style: Styles.subtitleStyle(fontSize: 10.0),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ]);
  }
}
