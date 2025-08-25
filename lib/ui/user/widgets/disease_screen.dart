// import 'package:flutter/material.dart';
// import 'package:tcc/ui/core/button_primary_component.dart';
//
// import '../../../utils/custom_text_style.dart';
// import '../../core/input_component.dart';
//
// class DiseaseScreen extends StatelessWidget {
//   const DiseaseScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<RegisterUserViewModel>(context);
//     return Scaffold(
//       appBar: AppBar(),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           spacing: 32,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "Criar uma nova conta",
//                   style: customTextTitle(),
//                 ),
//                 Text(
//                   "Crie sua conta para organizar seus medicamentos e cuidar melhor da sua saúde.",
//                   style: customTextLabel(),
//                 ),
//               ],
//             ),
//             Form(
//               key: provider.formKey,
//               child: Column(
//                 spacing: 22,
//                 children: [
//                   InputComponent(
//                     controller: provider.nameController,
//                     label: "Nome completo",
//                     hint: "Digite seu nome",
//                     prefixIcon: Icons.account_circle_outlined,
//                     obscureText: false,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return "Digite seu nome";
//                       }
//                       return null;
//                     },
//                   ),
//                 ],
//               ),
//             ),
//             ButtonPrimaryComponent(
//               onPressed: () {},
//               isLoading: provider.isLoading,
//               text: "Concluir",
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
