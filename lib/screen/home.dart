import 'package:flutter/material.dart';
import 'package:spectrum/screen/checklist.dart';
import 'package:spectrum/screen/profile.dart';
import 'package:spectrum/screen/spectrums.dart';
import 'package:spectrum/theme.dart' as app_theme;
import 'package:spectrum/widget/bottom_nav_btn.dart';
import 'package:spectrum/service/stream_service.dart' as source;
import 'package:spectrum/widget/info_text_btn.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String?>(
        stream: source.screenEmitter,
        builder: (context, snapshot) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text('Spectrum'),
              leading: InfoTextBtn(onPressed: () {}),
              actions: [
                IconButton(
                  padding: const EdgeInsets.only(top: 5),
                  iconSize: 20,
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () {},
                ),
                IconButton(
                  padding: const EdgeInsets.only(top: 7, right: 5),
                  iconSize: 20,
                  icon: const Icon(Icons.search_outlined),
                  onPressed: () {},
                ),
              ],
            ),
            body: _buildAppBody(snapshot.data ?? 'checklist'),
            bottomNavigationBar: SizedBox(
              height: 68.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 3.0,
                    decoration: const BoxDecoration(
                      color: app_theme.appBarColour,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 5.0),
                    child: Divider(
                      height: 1.0,
                      color: Colors.black38,
                      thickness: 1.0,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const <Widget>[
                      BottomNavBtn(
                        icon: Icons.grid_view_outlined,
                        label: 'Spectrums',
                      ),
                      BottomNavBtn(
                        icon: Icons.library_add_outlined,
                        label: 'Create',
                      ),
                      BottomNavBtn(
                        icon: Icons.check_circle,
                        iconSize: 52,
                        label: null,
                        unselectedColor: Colors.green,
                        selectedColor: Colors.green,
                      ),
                      BottomNavBtn(
                        icon: Icons.scatter_plot_outlined,
                        label: 'Insights',
                      ),
                      BottomNavBtn(
                        icon: Icons.person_outlined,
                        label: 'Profile',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}

Widget _buildAppBody(String? screen) {
  print(screen);
  switch (screen) {
    // TODO: write all the components
    case 'Spectrums':
      return const Spectrums();
    // case 'Create':
    //   return const Activities();
    // case 'Insights':
    //   return const Insights();
    case 'Profile':
      return const Profile();
    default:
      return const Checklist();
  }
}
