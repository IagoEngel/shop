import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/auth.dart';
// import '../screens/products_screen.dart';
import '../utils/app_routes.dart';
// import '../utils/custom_route.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            centerTitle: true,
            automaticallyImplyLeading: false,
            title: const Text('Bem-vindo Usuário!'),
          ),
          ListTile(
            leading: const Icon(Icons.shop),
            title: const Text('Loja'),
            onTap: () => Navigator.of(context).pushReplacementNamed(
              AppRoutes.authOrHome,
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('Pedidos'),
            onTap: () => Navigator.of(context).pushReplacementNamed(
              AppRoutes.orders,
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Gerenciar Produtos'),
            onTap: () => Navigator.of(context).pushReplacementNamed(
              AppRoutes.products,
            ),
            // Animação para rotas especificas
            // onTap: () => Navigator.of(context).pushReplacement(
            //   CustomRoute(
            //     builder: (_) => const ProductsScreen(),
            //   ),
            // ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Sair'),
            onTap: () {
              Provider.of<Auth>(context, listen: false).logout();

              Navigator.of(context).pushReplacementNamed(
                AppRoutes.authOrHome,
              );
            },
          ),
        ],
      ),
    );
  }
}
