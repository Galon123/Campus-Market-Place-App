import 'package:e_commerce_refactor/constants.dart';
import 'package:e_commerce_refactor/providers/UserProvider.dart';
import 'package:e_commerce_refactor/screens/mainNavigationHub.dart';
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
                          height: 300,
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
                                  SizedBox(height: 24),

                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 36,
                                        backgroundColor: Color(0xFF7986CB),
                                        child: Text(userProvider.username[0], style: TextStyle(fontSize: AppTextSizes.subHeadings, color: Colors.white)),
                                      ),
                                      SizedBox(width: 24),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(userProvider.username, style: TextStyle(color: Colors.white, fontSize: AppTextSizes.subHeadings, fontWeight: FontWeight.bold)),
                                          Text(userProvider.email, style: TextStyle(color: Colors.white70, fontSize: AppTextSizes.mediumText)),
                                          Text("+91 ${userProvider.phoneNo}", style: TextStyle(color: Colors.white70, fontSize: AppTextSizes.mediumText)),
                                          SizedBox(height: 6),
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                            decoration: BoxDecoration(
                                              color: Colors.white24,
                                              borderRadius: BorderRadius.circular(20),
                                              border: Border.all(color: Colors.white38),
                                            ),
                                            child: Text('✔ Verified Student', style: TextStyle(color: AppColors.textColorDefault, fontSize: 10)),
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
                        bottom: -30,
                        left: 20,
                        right: 20,
                        child: Container(
                          padding: EdgeInsets.all(15.0),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [AppColors.primaryColor, AppColors.secondaryColor],
                              begin: AlignmentGeometry.topCenter,
                              end: AlignmentGeometry.bottomCenter
                            ),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withValues(), blurRadius: 12, offset: const Offset(0,2))
                            ]
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _statItem(value: userProvider.products.length.toString(), field: "Listings"),
                              _statItem(value: "1", field: "Bids"),
                              _statItem(value: userProvider.rating.toString(), field: "Rating")
                            ],
                          ),
                        )
                      )
                    ],
                  ),
                  const SizedBox(height: 60,),
                  _buildCard(icon: Icons.book, title: "Listings",subtitle: "Shows Your Item Listings", onTap: () => { widget.onNavigate(2) },),
                  _buildCard(icon: Icons.money, title: "Bids",subtitle: "Shows Your Item Bids", onTap: () => { widget.onNavigate(1) }),
                  _buildCard(icon: Icons.logout, title: "Logout", onTap: userProvider.logout)
                  
                ],
              ),
            ),
          );
  }

  Widget _buildCard({required IconData icon, required String title, String? subtitle, required VoidCallback onTap}){

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryColor, AppColors.secondaryColor],
          begin: AlignmentGeometry.topCenter,
          end: AlignmentGeometry.bottomCenter
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(), blurRadius: 10, offset: const Offset(0,2))
        ]
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.textColorDefault,size: 36,),
        title: Text(title, style: TextStyle(
          fontWeight: FontWeight.w600,
          color: AppColors.textColorDefault
        ),),
        subtitle: subtitle != null ? Text(subtitle, style: TextStyle(
          fontSize: AppTextSizes.smallText,
          color: AppColors.textColorDefault
        ),) : null,
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textColorDefault,),
        onTap: onTap,
      ),
    );
  }

  Widget _statItem({required String value, required String field}){

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Text(value, style: TextStyle(
                fontSize: AppTextSizes.mediumText,
                color: AppColors.textColorDefault,
                fontWeight: FontWeight.w700
              ),),
              field == "Rating" ? Icon(Icons.star, color: Colors.amber,) : const SizedBox.shrink()
            ],
          ),
          SizedBox(height: 5,),
          Text(field, style: TextStyle(
                fontSize: AppTextSizes.mediumText,
                color: AppColors.textColorDefault,
                fontWeight: FontWeight.w700
              ),)
        ],
      ),
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