// import 'package:flutter/material.dart';
// import '../Widgets/init_state.dart';           // For signInAndSetRole & UserRole
// import 'storescreen.dart';                    // For StoreScreen
// import 'itemdetilscreen.dart';                // For ItemDetailScreen (or fix name)

// class role_screen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               child: Text("I'm a Parent"),
//               onPressed: () async {
//                 final user = await signInAndSetRole(UserRole.parent);
//                 Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => StoreScreen()));
//               },
//             ),
//             ElevatedButton(
//               child: Text("I'm a Kid"),
//               onPressed: () async {
//                 final user = await signInAndSetRole(UserRole.kid);
//                 Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ItemDetailScreen()));
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
