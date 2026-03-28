import 'package:e_commerce_refactor/theme/AppTheme.dart';
import 'package:e_commerce_refactor/theme/constants.dart';
import 'package:e_commerce_refactor/providers/UserProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {

  final void Function(int index) onNavigate;
  const ProfileScreen({super.key, required this.onNavigate});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final userProvider = Provider.of<UserProvider>(context, listen:true);
    return Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      ClipPath(
                        clipper: HeaderClipper(),
                        child: Container(
                          height: 330,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF283593), Color(0xFF7986CB)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: SafeArea(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                              child: Column(
                                children: [
                                  // top bar
                                  Text('My Profile', style: TextStyle(color: Colors.white, fontSize: AppTextSizes.mainHeadings, fontWeight: FontWeight.bold)),
                                  SizedBox(height: 12),

                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 48,
                                        backgroundColor: Color(0xFF7986CB),
                                        child: Text(userProvider.username[0], style: TextStyle(fontSize: AppTextSizes.subHeadings, color: Colors.white)),
                                      ),
                                      SizedBox(width: 20),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(userProvider.username, style: TextStyle(color: Colors.white, fontSize: AppTextSizes.subHeadings, fontWeight: FontWeight.bold)),
                                          Text(userProvider.email, style: TextStyle(color: Colors.white70, fontSize: AppTextSizes.smallText)),
                                          Text("+91 ${userProvider.phoneNo}", style: TextStyle(color: Colors.white70, fontSize: AppTextSizes.smallText)),
                                          SizedBox(height: 2),
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 1),
                                            decoration: BoxDecoration(
                                              color: Colors.white24,
                                              borderRadius: BorderRadius.circular(20),
                                              border: Border.all(color: Colors.white38),
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(Icons.verified,color: colors.success, size:16,),
                                                Text('Verified Student', style: TextStyle(color: Colors.black, fontSize: AppTextSizes.verySmallText)),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      Positioned(
                        bottom: 0,
                        left: 15,
                        right: 15,
                        child: Container(
                          padding: EdgeInsets.all(18.0),
                          decoration: BoxDecoration(
                            color: colors.primary,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(color: colors.onPrimary.withValues(), blurRadius: 10, offset: const Offset(0,0))
                            ]
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _statItem(value: userProvider.products.length.toString(), field: "Listings",colors: colors ),
                              _statItem(value: userProvider.bids.length.toString(), field: "Bids",colors: colors),
                              _statItem(value: userProvider.rating.toString(), field: "Rating",colors: colors)
                            ],
                          ),
                        )
                      )
                    ],
                  ),
                  const SizedBox(height: 60,),
                  _buildCard(icon: Icons.book, title: "Listings",subtitle: "Shows Your Item Listings", onTap: () => { widget.onNavigate(2)}, colors: colors, text: text),
                  _buildCard(icon: Icons.money, title: "Bids",subtitle: "Shows Your Item Bids", onTap: () => { widget.onNavigate(1)}, colors: colors, text: text),
                  _buildCard(icon: Icons.logout, title: "Logout", onTap: userProvider.logout,colors: colors, text: text)
                  
                ],
              ),
            ),
          );
  }

  Widget _buildCard({required IconData icon, required String title, String? subtitle, required VoidCallback onTap, ColorScheme ?colors, TextTheme ?text}){

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colors?.primary,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: colors!.onPrimary.withValues(), blurRadius: 5, offset: const Offset(-1,1))
        ]
      ),
      child: ListTile(
        leading: Icon(icon, color: colors.primary,size: 28,),
        title: Text(title, style: context.buttonText),
        subtitle: subtitle != null ? Text(subtitle, style: TextStyle(
          fontSize: AppTextSizes.verySmallText,
          color: Colors.black
        ),) : null,
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black,),
        onTap: onTap,
      ),
    );
  }

  Widget _statItem({required String value, required String field, ColorScheme ?colors}){

    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Text(value, style: TextStyle(
                fontSize: AppTextSizes.smallText,
                color: Colors.black,
                fontWeight: FontWeight.w700
              ),),
              field == "Rating" ? Icon(Icons.star, color: Colors.amber,) : const SizedBox.shrink()
            ],
          ),
          SizedBox(height: 5,),
          Text(field, style: TextStyle(
                fontSize: AppTextSizes.smallText,
                color: Colors.black,
                fontWeight: FontWeight.w700
              ),)
        ],
      );
  }
}

class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 40);  // go down left side

    // curve across the bottom
    path.quadraticBezierTo(
      size.width / 2, size.height + 40,  // control point (pulls curve down)
      size.width, size.height - 40,       // end point right side
    );

    path.lineTo(size.width, 0);  // up right side
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> old) => false;
}