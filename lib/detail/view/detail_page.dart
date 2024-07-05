import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/detail/cubit/detail_cubit.dart';
import 'package:my_app/l10n/l10n.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DetailCubit(),
      child: const DetailView(),
    );
  }
}

class DetailView extends StatelessWidget {
  const DetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.detailAppBarTitle)),
      backgroundColor: Colors.black38,
      body: Container(
        margin: const EdgeInsets.only(top: 20),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Stack(
              children: [
                Image.asset(
                  'assets/images/background-image.png',
                  width: 360,
                  height: 400,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  left: 50,
                  top: 50,
                  child: Text('11'),
                ),
              ],
            ),
            SizedBox(
              height: 150,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.restart_alt,
                        color: Colors.white70, size: 42),
                    onPressed: () {},
                  ),
                  ElevatedButton(
                    child: Icon(Icons.add, color: Colors.black54, size: 42),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.download,
                        color: Colors.white70, size: 42),
                    onPressed: () {},
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
